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
              question: '1. Who can vote in this election?',
              answer: 'Only registered students of the college can vote.',
            ),
            _buildFAQTile(
              question: '2. How do I vote?',
              answer:
                  'Login with your student ID, select a party, and cast your vote.',
            ),
            _buildFAQTile(
              question: '3. Can I change my vote?',
              answer: 'No, once you have voted, you cannot change your vote.',
            ),
            _buildFAQTile(
              question: '4. When does the voting start and end?',
              answer:
                  'Voting starts on the specified date and ends at midnight.',
            ),
            _buildFAQTile(
              question: '5. How can I check the results?',
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
