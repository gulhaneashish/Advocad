import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LawyerVerificationScreen extends StatefulWidget {
  const LawyerVerificationScreen({super.key});

  @override
  State<LawyerVerificationScreen> createState() => _LawyerVerificationScreenState();
}

class _LawyerVerificationScreenState extends State<LawyerVerificationScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> lawyers = [];

  @override
  void initState() {
    super.initState();
    fetchLawyers();
  }

  Future<void> fetchLawyers() async {
    try {
      final response = await supabase
          .from('lawyer')
          .select()
          .eq('verified', false);
      setState(() {
        lawyers = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching lawyers: $e')));
    }
  }

  Future<void> verifyLawyer(String lawyerId) async {
    try {
      await supabase
          .from('lawyer')
          .update({'verified': true})
          .eq('id', lawyerId);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Lawyer verified successfully')));
        setState(() {
          fetchLawyers();
        });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error verifying lawyer: $e')));
    }
  }

  void showLawyerDetails(Map<String, dynamic> lawyer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lawyer Details - ${lawyer['name']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${lawyer['name']}'),
              Text('Phone: ${lawyer['phone']}'),
              Text('Specialization: ${lawyer['category']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              verifyLawyer(lawyer['id']);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Accept & Verify'),
          ),
        ],
      ),
    );
  }

  Future<void> openCertificate(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open certificate')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lawyer Verification')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: lawyers.isEmpty
            ? const Center(child: Text('No lawyers pending verification.'))
            : ListView.builder(
          itemCount: lawyers.length,
          itemBuilder: (context, index) {
            final lawyer = lawyers[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(lawyer['image_url']),
                ),
                title: Text(lawyer['name']),
                subtitle: Text('Category: ${lawyer['category']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => showLawyerDetails(lawyer),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Review'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => openCertificate(lawyer['resume_url']),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text('View Certificate'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
