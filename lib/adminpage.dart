import 'package:e_voting_app/votedstudents.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'firestore.dart'; // Ensure this file contains your Firestore helper functions

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late bool isPollStarted;
  late bool isshowresults;
  @override
  void initState() {
    super.initState();
    getIsPoll().then((status) {
      setState(() {
        isPollStarted = status as bool;
      });
    });
    getShowResults().then((status) {
      setState(() {
        isshowresults = status as bool;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: FutureBuilder(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text(
                'Error fetching data. Please try again.',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          final List votedUsers = snapshot.data!['votedUsers'];
          final List notVotedUsers = snapshot.data!['notVotedUsers'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      updateIsPoll(!isPollStarted);
                      getIsPoll().then((value) {
                        setState(() {
                          print(value);
                          isPollStarted = value!;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPollStarted
                          ? Colors.red
                          : Colors
                              .green, // Green when started, red when stopped
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text(isPollStarted ? 'Stop Poll' : 'Start Poll'),
                  ),
                  const SizedBox(height: 20),

                  // Stylish "Display Results" button, only enabled when the poll is started
                  TextButton(
                    onPressed: () {
                      getShowResults().then((value) {
                        setState(() {
                          updateShowResults(!value!);
                          isshowresults = !value;
                        });
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          isshowresults ? Colors.blue : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text('Display Results'),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildDashboardCard(
                        context,
                        title: "Voted Students",
                        count: votedUsers.length,
                        color: Colors.green,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VotedStudents(
                              votedStudents: votedUsers,
                            ),
                          ));
                        },
                      ),
                      _buildDashboardCard(
                        context,
                        title: "Not Voted Students",
                        count: notVotedUsers.length,
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NotVotedStudents(
                              notVotedStudents: notVotedUsers,
                            ),
                          ));
                        },
                      ),
                    ],
                  ),
                  const Text(
                    'Live Voting Data',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Chart(), // Replace with your Chart widget implementation
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required int count,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Chart extends StatefulWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getParties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        final List<Map<String, dynamic>> parties = snapshot.data!;

        // Step 1: Count votes per position for each party
        Map<String, Map<String, int>> positionVotes =
            {}; // { "Coordinator": { "Party A": 3, "Party B": 2 }, ... }
        for (var party in parties) {
          final partyName = party['Name'];
          final votedPositions = party['votedpositions'];

          Map<String, int> voteCount = {}; // Count occurrences of each position
          for (String position in votedPositions) {
            voteCount[position] = (voteCount[position] ?? 0) + 1;
          }

          // Add this party's vote counts to the overall positionVotes map
          voteCount.forEach((position, votesCount) {
            if (!positionVotes.containsKey(position)) {
              positionVotes[position] = {};
            }
            positionVotes[position]![partyName] = votesCount;
          });
        }

        // Step 2: Prepare the top two parties for each position
        Map<String, List<Map<String, dynamic>>> topPartiesForPositions = {};

        positionVotes.forEach((position, partyVotes) {
          // Sort by votes and get top two parties
          var sortedParties = partyVotes.entries.toList()
            ..sort((a, b) => b.value
                .compareTo(a.value)); // Sort in descending order by votes
          topPartiesForPositions[position] = sortedParties.take(2).map((entry) {
            return {
              'party': entry.key,
              'votes': entry.value,
            };
          }).toList();
        });

        return Card(
          elevation: 0,
          color: Colors.blue[100],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Votes by Position',
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Step 3: Render BarChart for each position
                ...topPartiesForPositions.entries.map((entry) {
                  final position = entry.key;
                  final topParties = entry.value;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          position,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 200, // Bar chart height
                          child: BarChart(
                            BarChartData(
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: topParties.map((partyData) {
                                return BarChartGroupData(
                                  x: topParties.indexOf(partyData),
                                  barRods: [
                                    BarChartRodData(
                                      toY:
                                          partyData['votes']?.toDouble() ?? 0.0,
                                      color: topParties.indexOf(partyData) == 0
                                          ? Colors.blue
                                          : Colors
                                              .orange, // Different color for 1st and 2nd positions
                                      width: 20,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(show: false),
                            ),
                          ),
                        ),
                        // Step 4: Display Party Names and Votes
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: topParties.map((partyData) {
                            return Row(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 10,
                                      backgroundColor:
                                          topParties.indexOf(partyData) == 0
                                              ? Colors.blue
                                              : Colors.orange,
                                    ),
                                    Text(
                                      "\t " + partyData['party'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Text(
                                  "\t " + '${partyData['votes']} votes',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
