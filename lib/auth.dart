import 'package:e_voting_app/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// For hashing (optional)

import 'login_page.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

void signIn(BuildContext context, String phone, String password) async {
  try {
    // Hash the password for matching (if stored as hash in Firestore)

    // Query Firestore for user with matching email and password
    QuerySnapshot userSnapshot = await firestore
        .collection('Users')
        .where('PhoneNumber', isEqualTo: phone)
        .where('password', isEqualTo: password)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      // User exists, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomePage(phoneNumber: phone)), // Replace with your home page
      );
    } else {
      // Show error if no matching user found
      _showErrorDialog(context, 'Invalid email or password.');
    }
  } catch (e) {
    _showErrorDialog(context, 'An error occurred: $e');
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void signOut(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
