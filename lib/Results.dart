import 'package:e_voting_app/candidates.dart';
import 'package:e_voting_app/firestore.dart';
import 'package:flutter/material.dart';

class VotingResultPage extends StatefulWidget {
  @override
  _VotingResultPageState createState() => _VotingResultPageState();
}

class _VotingResultPageState extends State<VotingResultPage> {
  late Future<List> pollResults;
  bool isshowresults = false;
  @override
  void initState() {
    super.initState();
    pollResults = calculateMaxVotes();
    getShowResults().then((value) {
      setState(() {
        isshowresults = value!;
      });
    });
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
        child: isshowresults
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder(
                  future: calculateMaxVotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    if (snapshot.hasData) {
                      final pollresults = snapshot.data;

                      return ListView(
                        children: pollresults!.map<Widget>((winner) {
                          final position = winner['position'];
                          final rollno = winner['winner'];
                          final votes = winner['votes'];

                          // Safe way to find the staff member
                          // final staff = candidates.firstWhere(
                          //     (staff) => staff['name'] == candidate.toString(),
                          //     orElse: () => {
                          //           'img': 'assets/candidates/default.png',
                          //           'Rollno': 'N/A'
                          //         });
                          final staff = getcandiadates(rollno);
                          final img = staff['img'];
                          final name = staff['name'];

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    position.toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        img!,
                                        width: 120,
                                        height: 120,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Winner: $name',
                                              style: const TextStyle(
                                                overflow: TextOverflow.clip,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Roll NO: $rollno",
                                              style: const TextStyle(
                                                overflow: TextOverflow.clip,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Text("No data available");
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  color: Colors.red[100], // Light red background for error
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red, // Red icon for error
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "No Poll has started yet!",
                            style: TextStyle(
                              color: Colors.red[800], // Dark red text color
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
