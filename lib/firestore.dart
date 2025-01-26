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

Future<List<Map<String, dynamic>>> getParties() async {
  try {
    final collRef = FirebaseFirestore.instance.collection('Parties');
    final querySnapshot = await collRef.get();
    print(querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList());
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error fetching parties: $e');
    return [];
  }
}

Future<void> incrementVotes(
    String partyName, String position, String phoneNumber) async {
  final db = FirebaseFirestore.instance;

  // Get the party document reference based on the party name
  final partyDocRef = await db
      .collection('Parties')
      .where('Name', isEqualTo: partyName)
      .limit(1)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs[0].reference;
  });

  // Get the user document reference based on the phone number
  final userDocRef = await db
      .collection('Users')
      .where('PhoneNumber', isEqualTo: phoneNumber)
      .limit(1)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs[0].reference;
  });

  await db.runTransaction((transaction) async {
    // Append the position to the party's votedpositions array
    transaction.update(partyDocRef, {
      "votedpositions": FieldValue.arrayUnion([position]),
    });

    // Record the user's vote in their document
    transaction.update(userDocRef, {
      "VotedPositions": FieldValue.arrayUnion([position]),
    });
  });
}

Future<Map<String, dynamic>> fetchUsers() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    // Reference to the Users collection
    CollectionReference usersRef = _firestore.collection('Users');

    // Fetch all users
    QuerySnapshot usersSnapshot = await usersRef.get();

    // Separate users into voted and not voted based on VotedPositions array
    List<Map<String, dynamic>> votedUsers = [];
    List<Map<String, dynamic>> notVotedUsers = [];

    for (var doc in usersSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final List<dynamic> votedPositions = data['VotedPositions'] ?? [];

      if (votedPositions.isNotEmpty) {
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

    // Return counts and user lists
    return {
      'votedCount': votedUsers.length,
      'notVotedCount': notVotedUsers.length,
      'votedUsers': votedUsers,
      'notVotedUsers': notVotedUsers,
    };
  } catch (e) {
    print('Error fetching users: $e');
    return {
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
    // Fetch all party documents
    final partiesSnapshot = await db.collection('Parties').get();

    // Map to store the max votes for each position
    Map<String, Map<String, int>> positionVotes =
        {}; // { "Coordinator": { "Party A": 3, "Party B": 2 }, ... }

    for (var partyDoc in partiesSnapshot.docs) {
      final partyData = partyDoc.data();
      final String partyName = partyData['Name'];
      final List<dynamic> votedPositions = partyData['votedpositions'];

      // Count occurrences of each position for the current party
      Map<String, int> voteCount = {};
      for (String position in votedPositions) {
        voteCount[position] = (voteCount[position] ?? 0) + 1;
      }

      // Add this party's vote count to the overall positionVotes map
      for (var position in voteCount.keys) {
        if (!positionVotes.containsKey(position)) {
          positionVotes[position] = {};
        }
        positionVotes[position]![partyName] = voteCount[position]!;
      }
    }

    // Determine the party with the max votes for each position

    // { "Coordinator": "Party A", "Principal": "Party B" }
    int maxVotes = 0;
    List winners = [];
    for (var position in positionVotes.keys) {
      String maxParty = "";
      maxVotes = 0;

      positionVotes[position]!.forEach((party, votes) {
        if (votes > maxVotes) {
          maxVotes = votes;
          maxParty = party;
        }
      });
      Map<String, String> maxVotesPerPosition = {};
      maxVotesPerPosition['position'] = position;
      maxVotesPerPosition['winner'] = maxParty;
      maxVotesPerPosition['votes'] = maxVotes.toString();
      winners.add(maxVotesPerPosition);
    }

    // Print the results
    // maxVotesPerPosition.forEach((
    //   position,
    //   party,
    // ) {
    //   // print("Position: $position, winner: $party,votes: $maxVotes");
    // });
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
