import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildFAQTile(
              question: '1. Who can use the app?',
              answer: 'The app is exclusively for students, faculty, and administrators of the department.',
            ),

            _buildFAQTile(
              question: '2. Who can vote in this election?',
              answer: 'Only registered students of the college can vote.',
            ),
            _buildFAQTile(
              question: '3. How do I vote?',
              answer:
                  'Login with your student ID, select a party, and cast your vote.',
            ),
            _buildFAQTile(
              question: '4. Is my vote anonymous?',
              answer:
                  'Yes, your vote is completely confidential and secure.',
            ),
            _buildFAQTile(
              question: '5. Can I vote more than once?',
              answer:
                  'No, the app ensures one vote per user for each election.',
            ),


           _buildFAQTile(
              question: '6. Can I change my vote?',
              answer: 'No, once you have voted, you cannot change your vote.',
            ),
            _buildFAQTile(
              question: '7. When does the voting start and end?',
              answer:
                  'Voting starts on the specified date and ends at midnight.',
            ),
            _buildFAQTile(
              question: '8. What if I miss the voting deadline?',
              answer:
                  'Unfortunately, you cannot vote after the deadline. Make sure to check the election schedule.',
            ),
            _buildFAQTile(
              question: '9. How can I check the results?',
              answer:
                  'You can view the results after the voting period ends in the Results section.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E40AF),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}