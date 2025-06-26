import 'package:flutter/material.dart';
import 'package:legalapp/screens/hireing_form.dart';
import 'package:legalapp/screens/join_form.dart';
import 'package:legalapp/screens/pdfviewer.dart';
import 'package:legalapp/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> lawyers = [];
  List<String> selectedCategories = [];
  bool isLoading = true;
  final String userId = SessionManager.userId.toString();

  final List<String> lawyerCategories = [
    "Civil Lawyer", "Criminal Lawyer", "Corporate Lawyer",
    "Family Lawyer", "Property Lawyer", "Tax Lawyer"
  ];

  @override
  void initState() {
    super.initState();
    fetchLawyers();
  }

  Future<void> fetchLawyers() async {
    try {
      final response = await supabase.from('lawyer').select('*').eq('verified', true);
      setState(() {
        lawyers = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      showError("Error fetching data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredLawyers {
    if (selectedCategories.isEmpty) {
      return lawyers;
    }
    return lawyers.where((lawyer) {
      return selectedCategories.any((category) => lawyer['category']?.contains(category) ?? false);
    }).toList();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void openJoinForm() {
    showDialog(context: context, builder: (context) => const JoinForm());
  }

  void openHireForm(String lawyerId, String lawyerName) {
    showDialog(
      context: context,
      builder: (context) => HireLawyerForm(lawyerId: lawyerId, lawyerName: lawyerName),
    );
  }

  void toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register as a lawyer -->",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              onPressed: openJoinForm,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Join',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Buttons
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lawyerCategories.length,
              itemBuilder: (context, index) {
                final category = lawyerCategories[index];
                final isSelected = selectedCategories.contains(category);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => toggleCategory(category),
                    selectedColor: Colors.blueAccent,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.teal.shade200,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Display Lawyers
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredLawyers.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/no_lawyers.png", height: 200),
                  const SizedBox(height: 10),
                  const Text(
                    "No lawyers available",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredLawyers.length,
              itemBuilder: (context, index) {
                final lawyer = filteredLawyers[index];
                return LawyerCard(
                  lawyer: lawyer,
                  onViewResume: () {
                    String pdfUrl = lawyer['resume_url'];
                    String googleDocsUrl = "https://docs.google.com/viewer?url=$pdfUrl";
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PDFViewer(pdfUrl: googleDocsUrl)),
                    );
                  },
                  onHire: () => openHireForm(lawyer['user_id'], lawyer['name']),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LawyerCard extends StatelessWidget {
  final Map<String, dynamic> lawyer;
  final VoidCallback onViewResume;
  final VoidCallback onHire;

  const LawyerCard({
    super.key,
    required this.lawyer,
    required this.onViewResume,
    required this.onHire,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: lawyer['image_url'] != null
                      ? NetworkImage(lawyer['image_url'])
                      : const AssetImage("assets/default_avatar.png") as ImageProvider,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lawyer['name'] ?? "Unknown",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        lawyer['category'] ?? "N/A",
                        style: const TextStyle(fontSize: 14, color: Colors.teal),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.currency_rupee, size: 14, color: Colors.teal),
                          Text(
                            lawyer['fees']?.toString() ?? "fees not provided",
                            style: const TextStyle(fontSize: 14, color: Colors.teal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: onViewResume,
                  icon: const Icon(Icons.description, size: 18),
                  label: const Text("Certificate"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onHire,
                  icon: const Icon(Icons.person_add_alt_1, size: 18),
                  label: const Text("Hire"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
