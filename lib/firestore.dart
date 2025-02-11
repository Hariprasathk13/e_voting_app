import 'package:cloud_firestore/cloud_firestore.dart';

Future addUser(name, phoneNumber, password) async {
  final dbCollection = FirebaseFirestore.instance.collection('Users');
  await dbCollection.doc(phoneNumber).set({
    'FullName': name,
    'PhoneNumber': phoneNumber,
    'password': password,
    "VotedPositions": []
  });
}

Future getUser(phoneNumber) async {
  final docRef =
      FirebaseFirestore.instance.collection('Users').doc(phoneNumber);

  Map<String, dynamic>? data;
  await docRef.get().then(
    (DocumentSnapshot doc) {
      if (!doc.exists) return null;
      data = doc.data() as Map<String, dynamic>;
    },
    onError: (e) => print('Error: $e'),
  );
  return data;
}

Future getvotedposition(phonenumber) async {
  final db = FirebaseFirestore.instance;
  final userQuery = await db
      .collection('Users')
      .where('PhoneNumber', isEqualTo: phonenumber)
      .limit(1)
      .get();
  return userQuery;
}
// Stream<List<Map<String, dynamic>>> getParties() {
//   final collRef = FirebaseFirestore.instance.collection('Parties');
//   return collRef.snapshots().map((querySnapshot) {
//     return querySnapshot.docs
//         .map((doc) => doc.data() as Map<String, dynamic>)
//         .toList();
//   });
// }

Stream<List<Map<String, dynamic>>> getCandidates(String position) {
  final collRef = FirebaseFirestore.instance
          .collection('Positions') // Collection for positions
          .doc(position) // Specific position (e.g., Coordinator)
          .collection('Members') // Members collection under that position
      // The 'list' document containing the candidates
      ; // Collection for candidates

  return collRef.snapshots().map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  });
}

Future<void> incrementVotes(
    String partyName, String position, String phoneNumber) async {
  final db = FirebaseFirestore.instance;
  print(partyName);
  print(position);
  print(phoneNumber);
  try {
    // Get the specific member document based on the position, member ID, and party name
    final positionDocRef = db
        .collection('Positions') // Collection for positions (e.g., Coordinator)
        .doc(position) // Position document (e.g., Coordinator)
        .collection('Members') // Collection for party members
        .doc(partyName); // Specific member document (e.g., 2024BC21)

    // Get the user document reference based on the phone number
    final userQuery = await db
        .collection('Users')
        .where('PhoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) {
      throw Exception("User not found");
    }
    final userDocRef = userQuery.docs[0].reference;

    // Use transaction to safely update both documents
    await db.runTransaction((transaction) async {
      final positionSnapshot = await transaction.get(positionDocRef);
      final userSnapshot = await transaction.get(userDocRef);

      if (!positionSnapshot.exists || !userSnapshot.exists) {
        throw Exception("Document not found");
      }

      // Manually append the position to the user's votedpositions array (allowing duplicates)
      List<dynamic> userVotes =
          List.from(userSnapshot.data()?['VotedPositions'] ?? []);
      userVotes.add(position); // Allows duplicates

      // Increment the vote count for the specific party under the position
      final partyVotes = positionSnapshot.data()?['votes'] ?? 0;
      final newVoteCount = partyVotes + 1;

      // Update both documents
      transaction.update(positionDocRef, {"votes": newVoteCount});
      transaction.update(userDocRef, {"VotedPositions": userVotes});
    });

    print("Vote successfully recorded!");
  } catch (e, stacktrace) {
    print("Error incrementing votes: $e");
    print("Stack trace: $stacktrace");
  }
}

// Future<void> incrementVotes(
//     String partyName, String position, String phoneNumber) async {
//   final db = FirebaseFirestore.instance;

//   try {
//     // Get the party document reference based on the party name
//     final partyQuery = await db
//         .collection('Parties')
//         .where('Name', isEqualTo: partyName)
//         .limit(1)
//         .get();

//     if (partyQuery.docs.isEmpty) {
//       throw Exception("Party not found");
//     }
//     final partyDocRef = partyQuery.docs[0].reference;

//     // Get the user document reference based on the phone number
//     final userQuery = await db
//         .collection('Users')
//         .where('PhoneNumber', isEqualTo: phoneNumber)
//         .limit(1)
//         .get();

//     if (userQuery.docs.isEmpty) {
//       throw Exception("User not found");
//     }
//     final userDocRef = userQuery.docs[0].reference;

//     // Use transaction to safely update both documents
//     await db.runTransaction((transaction) async {
//       final partySnapshot = await transaction.get(partyDocRef);
//       final userSnapshot = await transaction.get(userDocRef);

//       if (!partySnapshot.exists || !userSnapshot.exists) {
//         throw Exception("Document not found");
//       }

//       // Manually append the position to the party's votedpositions array (allowing duplicates)
//       List<dynamic> partyVotes =
//           List.from(partySnapshot.data()?['votedpositions'] ?? []);
//       partyVotes.add(position); // Allows duplicates

//       // Manually append the position to the user's votedpositions array (allowing duplicates)
//       List<dynamic> userVotes =
//           List.from(userSnapshot.data()?['VotedPositions'] ?? []);
//       userVotes.add(position); // Allows duplicates

//       // Update both documents
//       transaction.update(partyDocRef, {"votedpositions": partyVotes});
//       transaction.update(userDocRef, {"VotedPositions": userVotes});
//     });

//     print("Vote successfully recorded!");
//   } catch (e) {
//     print("Error incrementing votes: $e");
//   }
// }

Stream<Map<String, dynamic>> fetchUsers() async* {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    // Reference to the Users collection
    CollectionReference usersRef = _firestore.collection('Users');

    // Listen to the users collection (real-time data)
    await for (var snapshot in usersRef.snapshots()) {
      // Separate users into voted and not voted based on VotedPositions array
      List<Map<String, dynamic>> votedUsers = [];
      List<Map<String, dynamic>> notVotedUsers = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final List<dynamic> votedPositions = data['VotedPositions'] ?? [];

        if (votedPositions.isNotEmpty && votedPositions.length > 5) {
          // User has voted
          votedUsers.add({
            'id': doc.id,
            "REG_ID": data['PhoneNumber'],
            'FullName': data['FullName'],
            'votedPositions': votedPositions,
          });
        } else {
          // User has not voted
          notVotedUsers.add({
            'id': doc.id,
            "REG_ID": data['PhoneNumber'],
            'FullName': data['FullName'],
            'votedPositions': votedPositions,
          });
        }
      }

      // Yield the data as a stream
      yield {
        'votedCount': votedUsers.length,
        'notVotedCount': notVotedUsers.length,
        'votedUsers': votedUsers,
        'notVotedUsers': notVotedUsers,
      };
    }
  } catch (e) {
    print('Error fetching users: $e');
    yield {
      'votedCount': 0,
      'notVotedCount': 0,
      'votedUsers': [],
      'notVotedUsers': [],
    };
  }
}

Future<List> calculateMaxVotes() async {
  final db = FirebaseFirestore.instance;

  try {
    // Fetch all positions
    final positionsSnapshot = await db.collection('Positions').get();

    List<Map<String, String>> winners = [];

    for (var positionDoc in positionsSnapshot.docs) {
      final String position =
          positionDoc.id; // Position name (e.g., "Coordinator")
      final collRef = await db
          .collection('Positions')
          .doc(position)
          .collection('Members')
          .get();

      // Map to store vote count for each party for this position
      Map<String, int> partyVotes = {};

      for (var memberDoc in collRef.docs) {
        final memberData = memberDoc.data();
        final String partyName =
            memberData['id']; // Assuming 'name' is the party name
        final int votes = memberData['votes']; // Number of votes

        // Accumulate votes for the party in this position
        partyVotes[partyName] = (partyVotes[partyName] ?? 0) + votes;
      }

      // Find the party with the max votes for this position
      String maxParty = "";
      int maxVotes = 0;

      partyVotes.forEach((party, votes) {
        if (votes > maxVotes) {
          maxVotes = votes;
          maxParty = party;
        }
      });

      // Prepare result for this position
      winners.add({
        'position': position,
        'winner': maxParty,
        'votes': maxVotes.toString(),
      });
    }
    print(winners);
    return winners;
  } catch (e) {
    print("Error: $e");
  }

  return [];
}

Future<bool?> getIsPoll() async {
  final db = FirebaseFirestore.instance;

  try {
    // Fetch the `ispoll` value from the settings document
    final doc = await db.collection('Settings').doc('setting').get();
    if (doc.exists) {
      return doc.data()?['ispoll']; // Return the ispoll value
    } else {
      print("Settings document does not exist.");
      return null;
    }
  } catch (e) {
    print("Error fetching ispoll: $e");
    return null;
  }
}

Future<void> updateIsPoll(bool ispoll) async {
  final db = FirebaseFirestore.instance;

  try {
    // Update the `ispoll` value in the settings document
    await db.collection('Settings').doc('setting').update({
      'ispoll': ispoll,
    });
    print("ispoll updated successfully.");
  } catch (e) {
    print("Error updating ispoll: $e");
  }
}

Future<bool?> getShowResults() async {
  final db = FirebaseFirestore.instance;

  try {
    // Fetch the `showresults` value from the settings document
    final doc = await db.collection('Settings').doc('setting').get();
    if (doc.exists) {
      return doc.data()?['showresults']; // Return the showresults value
    } else {
      print("Settings document does not exist.");
      return null;
    }
  } catch (e) {
    print("Error fetching showresults: $e");
    return null;
  }
}

Future<void> updateShowResults(bool showresults) async {
  final db = FirebaseFirestore.instance;

  try {
    // Update the `showresults` value in the settings document
    await db.collection('Settings').doc('setting').update({
      'showresults': showresults,
    });
    print("showresults updated successfully.");
  } catch (e) {
    print("Error updating showresults: $e");
  }
}

Future<void> resetVotes() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference positionsRef = firestore.collection("Positions");

  // Get all positions
  QuerySnapshot positionsSnapshot = await positionsRef.get();

  for (var positionDoc in positionsSnapshot.docs) {
    String positionName = positionDoc.id;

    // Reference to Members inside each position
    CollectionReference membersRef =
        positionsRef.doc(positionName).collection("Members");

    // Get all members
    QuerySnapshot membersSnapshot = await membersRef.get();

    for (var memberDoc in membersSnapshot.docs) {
      // Reset vote count to 0
      await membersRef.doc(memberDoc.id).update({"votes": 0});
    }
  }
  await resetVotedPositions();
  print("All votes reset successfully.");
}

Future<void> resetVotedPositions() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference usersRef = firestore.collection('Users');

  try {
    // Get all users
    QuerySnapshot usersSnapshot = await usersRef.get();

    WriteBatch batch = firestore.batch(); // Use batch for efficiency

    for (var doc in usersSnapshot.docs) {
      batch.update(doc.reference, {'VotedPositions': []});
    }

    // Commit the batch update
    await batch.commit();

    print("All users' voted_position arrays have been reset.");
  } catch (e) {
    print("Error resetting voted_position: $e");
  }
}
/// Fetches all staff details from the `staff` collection in Firestore.
// Future<List<Map<String, dynamic>>> getStaffDetails() async {
//   try {
//     // Reference to the Firestore `staff` collection
//     final collectionRef = FirebaseFirestore.instance.collection('staff');

//     // Fetch documents from the collection
//     final querySnapshot = await collectionRef.get();

//     // Map the documents to a list of staff details
//     final staffList = querySnapshot.docs.map((doc) {
//       return {
//         "id": doc.id, // Document ID
//         ...doc.data() as Map<String, dynamic>, // Document fields
//       };
//     }).toList();

//     return staffList;
//   } catch (e) {
//     print("Error fetching staff details: $e");
//     throw Exception("Failed to fetch staff details.");
//   }
// }
