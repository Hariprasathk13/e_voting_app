import 'package:flutter/material.dart';

class StaffScreen extends StatelessWidget {
  StaffScreen({super.key});

  Future getStaffDetails() async {
    final List staffs = [
      {
        "name": "Mrs. S .Selvarani",
        "job": "Head of the Department",
        "education": "M.C.A.,M.Phil.,NET,SET,(Ph.D.)",
        "img": "assets/staffs/staff1.jpg"
      },
      {
        "name": "Ms.J.Arockia Jackuline Joni",
        "job": "Assistant Professor",
        "education": "MSc.,M.Phil.,(Ph.D.)",
        "img": "assets/staffs/staff2.jpg"
      },
      {
        "name": "Mrs. K.P. Maheswari",
        "job": "Assistant Professor",
        "education": "MCA,M.Phil.,NET,(Ph.D.)",
        "img": "assets/staffs/staff5.jpg"
      },
      {
        "name": "Ms. P. Renganayagi",
        "job": "Assistant Professor",
        "education": "MCA.,M.Phil.,NET.",
        "img": "assets/staffs/staff3.jpg"
      },
      {
        "name": "Mrs. S. Nirmala Devi",
        "job": "Assistant Professor",
        "education": "M.Sc.,M.Phil.,NET,(Ph.D.)",
        "img": "assets/candidates/8.jpg"
      },
    ];

    await Future.delayed(Duration(seconds: 2));
    return staffs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Details'),
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: FutureBuilder(
        future: getStaffDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No staff details available."));
          }

          final staffDetails = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: staffDetails.length,
            itemBuilder: (context, index) {
              final staff = staffDetails[index];
              return _buildStaffCard(
                  name: staff['name'] ?? 'N/A',
                  job: staff['job'] ?? 'N/A',
                  education: staff['education'] ?? 'N/A',
                  imgurl: staff['img']);
            },
          );
        },
      ),
    );
  }

  Widget _buildStaffCard({
    required String name,
    required String job,
    required String education,
    required String imgurl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Job: $job',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Education: $education',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
