import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_voting_app/firestore.dart';
import 'package:flutter/material.dart';

class Candidatelist extends StatefulWidget {
  final String position;
  final String phoneNumber; // User's phone number to track voting.
  final bool voted; // Initial voted status
  final Function callback;

  const Candidatelist({
    super.key,
    required this.phoneNumber,
    required this.voted,
    required this.position,
    required this.callback,
  });

  @override
  State<Candidatelist> createState() => _CandidatelistState();
}

class _CandidatelistState extends State<Candidatelist> {
  final List imgurls = [
    'lib/images/staff1.jpg',
    'lib/images/staff2.jpg',
    'lib/images/staff3.jpg',
    'lib/images/staff4.jpg',
    'lib/images/staff5.jpg',
  ];

  bool? votedStatus;

  @override
  void initState() {
    super.initState();
    // Initialize the voted status when the widget is first created
    votedStatus = widget.voted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates'),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Parties').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No parties available.'));
            }

            final parties = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final party = parties[index];
                final imgurl = imgurls[index];
                return _buildPartyCard(
                  context: context,
                  partyName: party['Name'],
                  phoneNumber: widget.phoneNumber,
                  voted:
                      votedStatus ?? widget.voted, // Use votedStatus from state
                  imgurl: imgurl,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPartyCard({
    required BuildContext context,
    required String partyName,
    required String phoneNumber,
    required bool voted,
    required String imgurl,
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
              Image.asset(
                imgurl,
                width: 100,
                height: 100,
              ),
              Text(
                partyName,
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
                  Text(
                    'Phone: $phoneNumber',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (voted) {
                        _showAlreadyVotedAlert(context);
                      } else {
                        _showVoteConfirmationDialog(
                          context,
                          partyName,
                          phoneNumber,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          voted ? Colors.grey[400] : const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(voted ? 'Already Voted' : 'Vote'),
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
      BuildContext context, String partyName, String phoneNumber) {
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
              onPressed: () async {
                // Call the function to increment votes
                await incrementVotes(partyName, widget.position, phoneNumber);

                Navigator.pop(context); // Close the dialog

                // ✅ Update the UI of the main widget
                setState(() {
                  votedStatus = true;
                });

                // Notify the parent widget about the vote
                widget.callback();
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
