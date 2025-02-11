import 'package:cloud_firestore/cloud_firestore.dart';

void addCoordinators() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List of coordinators
  List<Map<String, String>> coordinators = [
    {"name": "Kaviya G", "id": "2024BC21"},
    {"name": "Keerthana Devi R", "id": "2024BC22"},
    {"name": "Lasili O", "id": "2024BC23"},
    {"name": "Lohithha A", "id": "2024BC24"},
    {"name": "Maragatha Valli R", "id": "2024BC25"},
    {"name": "Mathi M", "id": "2024BC26"}
  ];

  // Reference to the Coordinator subcollection
  // CollectionReference coordinatorRef = firestore.collection('Positions').doc('Coordinator');
  DocumentReference positionRef =
      firestore.collection('Positions').doc('Coordinator');

  // Add each coordinator inside the "Members" subcollection
  for (var coordinator in coordinators) {
    await positionRef.collection('Members').doc(coordinator['id']).set(
        {'name': coordinator['name'], 'id': coordinator['id'], 'votes': 0});
  }
  print("Coordinators added successfully!");
}
