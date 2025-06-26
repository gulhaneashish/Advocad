import 'package:flutter/material.dart';
import 'package:legalapp/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewJobsForYouPage extends StatefulWidget {
  @override
  _ViewJobsForYouPageState createState() => _ViewJobsForYouPageState();
}

class _ViewJobsForYouPageState extends State<ViewJobsForYouPage>
    with SingleTickerProviderStateMixin {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> pendingJobs = [];
  List<dynamic> activeJobs = [];
  List<dynamic> expiredJobs = [];
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      final response = await supabase
          .from('hiring')
          .select('*')
          .eq('lawyer_id', SessionManager.userId.toString())
          .order('created_at', ascending: false);

      setState(() {
        pendingJobs = response.where((job) => job['status'] == 'Pending').toList();
        activeJobs = response.where((job) => job['status'] == 'Accepted').toList();
        expiredJobs = response.where((job) => job['status'] == 'Expired').toList();
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching jobs: $error");
      setState(() => isLoading = false);
    }
  }

  Future<void> acceptJob(String jobId) async {
    try {
      final response = await supabase
          .from('users')
          .select('phone')
          .eq('email', SessionManager.userId.toString())
          .single();

      final lawyerPhone = response['phone'];

      await supabase
          .from('hiring')
          .update({'status': 'Accepted', 'lawyer_phone': lawyerPhone})
          .eq('id', jobId);

      fetchJobs();
    } catch (error) {
      print("Error accepting job: $error");
    }
  }

  Future<void> rejectJob(String jobId) async {
    try {
      await supabase
          .from('hiring')
          .update({'status': 'Expired'}) // Changed 'Rejected' to 'Expired'
          .eq('id', jobId);

      fetchJobs();
    } catch (error) {
      print("Error rejecting job: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cases for You', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.yellowAccent,
          tabs: [
            Tab(icon: Icon(Icons.pending_actions), text: "Pending"),
            Tab(icon: Icon(Icons.work), text: "Active"),
            Tab(icon: Icon(Icons.history), text: "Expired"),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          buildJobList(pendingJobs, true),
          buildJobList(activeJobs, false),
          buildJobList(expiredJobs, false),
        ],
      ),
    );
  }

  Widget buildJobList(List<dynamic> jobs, bool showActions) {
    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.teal[400]),
            SizedBox(height: 10),
            Text("No jobs found", style: TextStyle(fontSize: 18, color: Colors.teal)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Case Details:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(job['case_details'], style: TextStyle(fontSize: 14)),

                SizedBox(height: 10),
                Text(
                  "Documents",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
Image.network(job['document_url']),
                SizedBox(height: 10),
                

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Client: ${job['user_id']}",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: job['status'] == 'Accepted'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        job['status'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: job['status'] == 'Accepted' ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5),
                Text("Contact: ${job['contact_number']}", style: TextStyle(fontSize: 14)),
                if(job['status'] == 'Accepted')
                  ElevatedButton(onPressed: ()async{
                     await supabase.from('hiring').update({'status':'Expired'}).eq('id',job['id']);
                  },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Expired',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)),
                if (showActions) ...[
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => acceptJob(job['id']),
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text("Accept"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => rejectJob(job['id']),
                        icon: Icon(Icons.close, color: Colors.white),
                        label: Text("Reject"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
