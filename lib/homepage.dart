import 'package:e_voting_app/Results.dart';
import 'package:e_voting_app/faqpage.dart';
import 'package:e_voting_app/firestore.dart';
import 'package:e_voting_app/partyscreen.dart';
import 'package:e_voting_app/registration_page.dart';
import 'package:e_voting_app/staffscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String phonenumber;

  HomePage({super.key, required this.phonenumber});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegistrationPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.power_settings_new_rounded,
                color: Colors.white,
              ))
        ],
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getUser(widget.phonenumber),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset("assets/staffs/images (19).png"),
                const SizedBox(height: 50),
                Text(
                  snapshot.hasData && snapshot.data!['FullName'] != null
                      ? "Welcome " + snapshot.data!['FullName']
                      : 'Welcome User', // Default text if data is not available
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E40AF),
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildGridTile(
                        icon: Icons.group,
                        title: "Vote Now",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PartyScreen(
                                      phoneNumber: widget.phonenumber,
                                    )),
                          );
                        },
                      ),
                      _buildGridTile(
                        icon: Icons.person,
                        title: "View Staffs",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StaffScreen()),
                          );
                        },
                      ),
                      _buildGridTile(
                        icon: Icons.info,
                        title: "Voting FAQs",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FAQPage()),
                          );
                        },
                      ),
                      _buildGridTile(
                        icon: Icons.poll,
                        title: "Result",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VotingResultPage()),
                          );
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

  Widget _buildGridTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF1E40AF)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
