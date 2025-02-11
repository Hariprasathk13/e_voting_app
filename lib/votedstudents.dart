import 'package:flutter/material.dart';

class VotedStudents extends StatelessWidget {
  VotedStudents({super.key, required this.votedStudents});
  final List votedStudents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voted Students"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Voted: ${votedStudents.length}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: votedStudents.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          votedStudents[index]['REG_ID'][0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        votedStudents[index]['FullName'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text("Reg ID: ${votedStudents[index]['REG_ID']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotVotedStudents extends StatelessWidget {
  NotVotedStudents({super.key, required this.notVotedStudents});
  final List notVotedStudents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Voted Students"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Not Voted: ${notVotedStudents.length}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: notVotedStudents.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation:
                        8, // Increased elevation for a better floating effect
                    margin: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Info Section
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.blueAccent, // Subtle background color
                              child: Text(
                                notVotedStudents[index]['REG_ID'][0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              notVotedStudents[index]['FullName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87, // More muted title color
                              ),
                            ),
                            subtitle: Text(
                              "Reg ID: ${notVotedStudents[index]['REG_ID']}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Voted Positions Heading
                          const Text(
                            "Voted Positions:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Voted Positions List
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            // alignment: WrapAlignment.center,
                            children: [
                              ...notVotedStudents[index]['votedPositions']
                                  .map(
                                    (position) => Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Chip(
                                        label: Text(
                                          position,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: Colors.blueAccent,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget text(String positon) => Text(positon + " ,");
}
