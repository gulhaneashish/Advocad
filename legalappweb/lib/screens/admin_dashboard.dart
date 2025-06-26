import 'package:flutter/material.dart';
import 'package:legalappweb/screens/dashboard_button.dart';
import 'package:legalappweb/screens/dashboard_card.dart';
import 'package:legalappweb/screens/lawyer_verification.dart';
import 'package:legalappweb/screens/manage_ads.dart';
import 'package:legalappweb/screens/sidebar.dart';
import 'package:legalappweb/screens/upload_blogs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final SupabaseClient supabase = Supabase.instance.client;
  int usersCount = 0;
  int lawyersCount = 0;
  int hiringCount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final users = await supabase.from('users').select();
      final lawyers = await supabase.from('lawyer').select();
      final hiring = await supabase.from('hiring').select();

      setState(() {
        usersCount = users.length;
        lawyersCount = lawyers.length;
        hiringCount = hiring.length;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Dashboard", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // Dashboard Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DashboardCard(label: "Total Users", count: usersCount, color: Colors.blue),
                        SizedBox(width: 4,),
                        DashboardCard(label: "Total Lawyers", count: lawyersCount, color: Colors.green),
                        SizedBox(width: 4,),
                        DashboardCard(label: "Total Hirings", count: hiringCount, color: Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        DashboardButton(
                          title: "Lawyer Verification",
                          icon: Icons.verified_user,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LawyerVerificationScreen())),
                        ),
                        DashboardButton(
                          title: "Upload Blogs",
                          icon: Icons.post_add,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadBlogScreen())),
                        ),
                        DashboardButton(
                          title: "Manage Ads",
                          icon: Icons.campaign,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageAdsScreen())),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
