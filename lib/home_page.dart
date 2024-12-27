import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'auth.dart';
import 'firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.phoneNumber, super.key});
  final String phoneNumber;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String title = 'Home';

  void votedCallback() {
    setState(() {
      selectedIndex = 0;
      title = 'Home';
    });
  }

  Widget getWidget(data) {
    switch (selectedIndex) {
      case 0:
        return Column(
          children: [
            Card(
              elevation: 0,
              color: Colors.blue[100],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Welcome,\n${data["FullName"]}',
                      style: TextStyle(
                          fontSize: 30,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: () {
                if (data["Voted"]) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'You have successfully cast your vote!',
                            style: TextStyle(
                                color: Colors.green[600], fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Colors.yellow[50],
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning,
                            color: Colors.yellow[700],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'You have not cast your vote!\nCast your vote by navigating to the Vote tab',
                            style: TextStyle(
                                color: Colors.yellow[700], fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }(),
            ),
            Column(
              children: const [
                SizedBox(
                  height: 10,
                ),
                Chart(),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        );
      default:
        return Column(
          children: [
            Text(
              'Vote for Your Desired Party',
              style: TextStyle(
                  fontSize: 28,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: getParties(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!
                        .map<Widget>(
                          (party) => Party(
                            partyName: party["Name"],
                            voted: data['Voted'],
                            phoneNumber: widget.phoneNumber,
                            callback: incrementVotes,
                            votedCallback: votedCallback,
                          ),
                        )
                        .toList(),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => signOut(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: FutureBuilder(
        future: getUser(widget.phoneNumber),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: getWidget(
                    snapshot.data,
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.blue[50],
        unselectedItemColor: Colors.black38,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote_rounded),
            label: 'Vote',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              setState(() => title = 'Home');
              break;
            default:
              setState(() => title = 'Vote');
              break;
          }
          setState(() => selectedIndex = index);
        },
      ),
    );
  }
}

class Party extends StatelessWidget {
  const Party({
    required this.partyName,
    required this.phoneNumber,
    required this.voted,
    required this.callback,
    required this.votedCallback,
    Key? key,
  }) : super(key: key);

  final String partyName;
  final String phoneNumber;
  final bool voted;
  final Function(String partyName, String phoneNumber, Function callback)
      callback;
  final Function votedCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.blue[100],
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                partyName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              ElevatedButton(
                  onPressed: voted
                      ? null
                      : () async {
                          callback(partyName, phoneNumber, votedCallback);
                        },
                  child: Text(voted ? 'Already voted' : 'Vote'))
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
