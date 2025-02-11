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
      body: StreamBuilder(
        stream: fetchUsers(),
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
                ElevatedButton(onPressed: (){
                  resetVotes();
                }, child: Text("Reset votes")),
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
                  if (votedUsers.length > 0) ...[
                    Chart(
                      postion: "President",
                    ),
                    Chart(
                      postion: "Secretary",
                    ),
                    Chart(
                      postion: "Vice president",
                    ),
                    Chart(
                      postion: "Treasurer",
                    ),
                    Chart(
                      postion: "Join Secretary",
                    ),
                    Chart(
                      postion: "Coordinator",
                    )

                    // ListView.builder(itemBuilder: (context, index) => ch,)
                  ], // Replace with your Chart widget implementation
                  if (votedUsers.length == 0)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                        color:
                            Colors.red[100], // Light red background for error
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
                                  "No Vote right now !\n ask your students to vote soon !",
                                  style: TextStyle(
                                    color:
                                        Colors.red[800], // Dark red text color
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
  final postion;
  Chart({
    Key? key,
    required this.postion,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: getCandidates(widget.postion),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        final List<Map<String, dynamic>> parties = snapshot.data!;
        num totalvotecount = 0;
        for (dynamic party in parties) {
          totalvotecount += party['votes'];
        }

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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.postion,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (totalvotecount < 1) Text("No votes Polled"),
                      if (totalvotecount > 0)
                        SizedBox(
                          height: 250, // Adjust for the donut chart size
                          child: PieChart(
                            PieChartData(
                              sections: parties.map((entry) {
                                final partyName = entry['name'];
                                final voteCount = entry['votes'];

                                return PieChartSectionData(
                                  value: voteCount.toDouble(),
                                  title: '$partyName\n($voteCount)',
                                  color: _getPartyColor(
                                      partyName), // Dynamic colors
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                              centerSpaceRadius:
                                  40, // Creates the "donut" effect
                              sectionsSpace: 2,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      // Step 3: Display Legend
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: parties.map((party) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  maxRadius: 8,
                                  backgroundColor:
                                      _getPartyColor(party['name']),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  party['name'],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getPartyColor(String partyName) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.yellow
    ];
    return colors[
        partyName.hashCode % colors.length]; // Assign colors dynamically
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
