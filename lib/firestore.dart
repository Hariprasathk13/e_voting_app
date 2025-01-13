import 'package:cloud_firestore/cloud_firestore.dart';

Future addUser(name, phoneNumber, password) async {
  final dbCollection = FirebaseFirestore.instance.collection('Users');
  await dbCollection.doc(phoneNumber).set({
    'FullName': name,
    'PhoneNumber': phoneNumber,
    'password': password,
    'Voted': false
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

Future incrementVotes(
    String partyName, String phoneNumber, Function callback) async {
  final db = FirebaseFirestore.instance;
  final partyDocRef = await db
      .collection('Parties')
      .where('Name', isEqualTo: partyName)
      .limit(1)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs[0].reference;
  });
  final userDocRef = await db
      .collection('Users')
      .where('PhoneNumber', isEqualTo: phoneNumber)
      .limit(1)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs[0].reference;
  });

  await db.runTransaction((transaction) async {
    transaction.update(partyDocRef, {
      // Pass the DocumentReference here ^^
      "Votes": FieldValue.increment(1),
    });
    transaction.update(userDocRef, {
      // Pass the DocumentReference here ^^
      "Voted": true,
    });
  }).then((value) => callback());
}

Stream<List<Map<String, dynamic>>> getLiveVotingData() {
  return FirebaseFirestore.instance
      .collection('votes')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  });
}

Future<void> saveVotingPeriod(DateTime startTime, DateTime endTime) async {
  try {
    // Reference to the Firestore document
    final DocumentReference votingPeriodDoc = FirebaseFirestore.instance
        .collection('VotingSettings')
        .doc('votingPeriod');

    // Update or set the voting period
    await votingPeriodDoc.set({
      'startTime': startTime,
      'endTime': endTime,
    });

    print('Voting period saved successfully!');
  } catch (e) {
    print('Error saving voting period: $e');
    throw Exception('Failed to save voting period');
  }
}

Future fetchUsers() async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    // Reference to the Users collection
    CollectionReference usersRef = _firestore.collection('Users');

    // Query users who have voted
    QuerySnapshot votedSnapshot =
        await usersRef.where('Voted', isEqualTo: true).get();

    // Query users who have not voted
    QuerySnapshot notVotedSnapshot =
        await usersRef.where('Voted', isEqualTo: false).get();

    // Extract details
    List<Map<String, dynamic>> votedUsers = votedSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        "REG_ID": doc['PhoneNumber'],
        'FullName': doc['FullName'],
        'voted': doc['Voted']
      };
    }).toList();

    List<Map<String, dynamic>> notVotedUsers = notVotedSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        "REG_ID": doc['PhoneNumber'],
        'FullName': doc['FullName'],
        'voted': doc['Voted']
      };

      return {'id': doc.id, 'FullName': doc['FullName'], 'voted': doc['Voted']};

      return {'id': doc.id, 'name': doc['name'], 'voted': doc['voted']};
    }).toList();

    return {
      'votedCount': votedUsers.length,
      'notVotedCount': notVotedUsers.length,
      'votedUsers': votedUsers,
      'notVotedUsers': notVotedUsers,
    };
  } catch (e) {
    print('Error fetching users: $e');
    return {};
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
