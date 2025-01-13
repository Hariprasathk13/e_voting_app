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
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Live Voting Data',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Chart(), // Replace with your Chart widget implementation
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
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
                ),
              ],
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
  int touchedIndex = -1;

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
        final List<int> votes =
            parties.map((party) => party['Votes'] as int).toList();
        final int totalVotes =
            votes.isNotEmpty ? votes.reduce((a, b) => a + b) : 0;
        final List<double> votesPercent = totalVotes > 0
            ? votes.map((e) => (e / totalVotes) * 100).toList()
            : List.filled(votes.length, 0.0);
        final List<Color> sectionColors = [
          const Color(0xff0293ee),
          const Color(0xfff8b250),
          const Color(0xff845bef),
          const Color(0xff13d38e),
          const Color(0xfff5387a),
        ];

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
                  'Votes',
                  style: TextStyle(
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 80,
                      sections:
                          showingSections(votes, votesPercent, sectionColors),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: parties.asMap().entries.map((entry) {
                    final index = entry.key;
                    final party = entry.value;
                    return Indicator(
                      color: sectionColors[index % sectionColors.length],
                      text: party['Name'],
                      isSquare: true,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(
    List<int> votes,
    List<double> votesPercent,
    List<Color> sectionColors,
  ) {
    if (votes.isEmpty) {
      return [];
    }
    return List.generate(votes.length, (index) {
      final isTouched = index == touchedIndex;
      final double radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: sectionColors[index % sectionColors.length],
        value: votesPercent[index],
        title: votesPercent[index] > 0
            ? '${votesPercent[index].toStringAsFixed(1)}%'
            : '',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
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
