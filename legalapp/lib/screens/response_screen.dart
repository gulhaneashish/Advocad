import 'package:flutter/material.dart';
import 'package:legalapp/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ResponsePage extends StatefulWidget {
  @override
  _ResponsePageState createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> userJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserJobs();
  }

  // Fetch jobs where the logged-in user is the one who posted the request
  Future<void> fetchUserJobs() async {
    try {
      final response = await supabase
          .from('hiring')
          .select('*')
          .eq('user_id', SessionManager.userId.toString()) // Fetch jobs where user_id == logged-in user
          .order('created_at', ascending: false);

      setState(() {
        userJobs = response;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching user jobs: $error");
      setState(() => isLoading = false);
    }
  }

  // Function to make a phone call
  void makeCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      print("Could not launch call: $phoneNumber");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Hired Lawyers')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userJobs.isEmpty
          ? Center(child: Text("No hiring records found"))
          : ListView.builder(
        itemCount: userJobs.length,
        itemBuilder: (context, index) {
          final job = userJobs[index];
          bool isAccepted = job['status'] == 'Accepted';

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Case Details: ${job['case_details']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lawyer Email: ${job['lawyer_id']}"),
                  Text("Status: ${job['status']}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: job['status'] == 'Accepted'
                              ? Colors.green
                              : job['status'] == 'Rejected'
                              ? Colors.red
                              : Colors.orange)),
                ],
              ),
              trailing: isAccepted && job['lawyer_phone'] != null
                  ? ElevatedButton(
                onPressed: () => makeCall(job['lawyer_phone']),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                child: Text("Call Lawyer"),
              )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
