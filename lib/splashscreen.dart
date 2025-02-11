import 'package:e_voting_app/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFECF0F1), Color(0xFFD5DBDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/staffs/logo2.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 24),

              // Title
              Text(
                'ElectoHub BCA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E50),
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 8),

              // Subtitle
              Text(
                'Empowering Your Voice in Voting',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7F8C8D),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),

              // Divider
              Divider(
                color: Color(0xFFBDC3C7),
                thickness: 1.2,
                indent: 50,
                endIndent: 50,
              ),
              SizedBox(height: 24),

              // Information Sections
              _buildInfoSection(
                  'Developed By', 'A Pon Divya Dharshini\nIII BCA'),
              SizedBox(height: 16),
              _buildInfoSection('Under the Guidance of',
                  'Ms. J. Arockia Jackuline Joni\nAssistant Professor'),
              SizedBox(height: 12),
              _buildInfoSection(
                  '', 'Mrs. S. Selvarani\nHead & Assistant Professor'),

              SizedBox(height: 40),

              // Loading Indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C3E50)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String details) {
    return Column(
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        SizedBox(height: 4),
        Text(
          details,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }
}
