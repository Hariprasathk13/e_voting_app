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
