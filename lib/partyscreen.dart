import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_voting_app/candidatelist.dart';
import 'package:e_voting_app/firestore.dart';
import 'package:flutter/material.dart';

class PartyScreen extends StatelessWidget {
  final Function(String partyName, String phoneNumber, Function callback)
      callback;
  final Function votedCallback;
  final String phoneNumber; // User's phone number to track voting.
  final bool voted;
  const PartyScreen({
    super.key,
    // required this.callback,
    // required this.votedCallback,
    required this.phoneNumber,
    required this.callback,
    required this.votedCallback,
    required this.voted,
    // required this.voted, required String position
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties'),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // _buildPartyCard(context: context, partyName: "President", phoneNumber: , voted: voted)
              _buildPartyCard(context: context, Position: "President"),
              _buildPartyCard(context: context, Position: "Vice President"),
              _buildPartyCard(context: context, Position: "Treasurer"),
              _buildPartyCard(context: context, Position: "Coordinator"),
            ],
          )),
    );
  }

  Widget _buildPartyCard({
    required BuildContext context,
    required String Position,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Position,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // if (voted) {
                      //   _showAlreadyVotedAlert(context);
                      // } else {
                      //   _showVoteConfirmationDialog(
                      //     context,
                      //     partyName,
                      //     phoneNumber,
                      //   );
                      // }

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Candidatelist(
                              callback: callback,
                              votedCallback: votedCallback,
                              phoneNumber: phoneNumber,
                              voted: voted)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Vote Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVoteConfirmationDialog(
    BuildContext context,
    String partyName,
    String phoneNumber,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Vote'),
          content: Text('Are you sure you want to vote for $partyName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // callback(partyName, phoneNumber,);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showAlreadyVotedAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Already Voted'),
          content: const Text('You have already voted for this party.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert box
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
