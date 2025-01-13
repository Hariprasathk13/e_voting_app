import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_voting_app/adminpage.dart';
import 'package:flutter/material.dart';

class VotingResultPage extends StatefulWidget {
  @override
  _VotingResultPageState createState() => _VotingResultPageState();
}

class _VotingResultPageState extends State<VotingResultPage> {
  late Future<Map<String, dynamic>> votingResult;

  @override
  void initState() {
    super.initState();
    votingResult = getVotingResults();
  }

  Future<Map<String, dynamic>> getVotingResults() async {
    try {
      // Fetch votes from the 'votes' collection
      final votesSnapshot =
          await FirebaseFirestore.instance.collection('votes').get();

      if (votesSnapshot.docs.isEmpty) {
        throw Exception("No votes have been recorded yet.");
      }

      // Find the party with the highest votes
      final partyVotes = votesSnapshot.docs.map((doc) {
        return {
          "partyName": doc.id,
          "votes": doc['votes'] as int,
        };
      }).toList();

      // partyVotes.sort((a, b) => b['votes'].compareTo(a['votes'])); // Sort descending by votes

      final winner = partyVotes.isNotEmpty ? partyVotes.first : null;

      return {
        "winner": winner,
        "votingClosed": false, // Always open
      };
    } catch (e) {
      return {
        "error": e.toString(),
        "votingClosed": false,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voting Live'),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Chart()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
