import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legalapp/screens/blog_details_screen.dart';
import 'package:legalapp/screens/hireing_form.dart';
import 'package:legalapp/screens/summary_screen.dart';
import 'package:legalapp/summary_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final SummaryStore _summaryStore = SummaryStore();

  XFile? _selectedFile;
  List<String> slideImages = [];
  List<Map<String, dynamic>> lawyers = [];
  List<Map<String, dynamic>> blogs = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSlides();
    fetchBlogs();
    fetchLawyers();
  }

  /// Fetch Slides
  Future<void> fetchSlides() async {
    try {
      final response = await supabase.from('slides').select('image_url');
      setState(() {
        slideImages = response.map<String>((row) => row['image_url'] as String).toList();
      });
    } catch (e) {
      print('Error fetching slides: $e');
    }
  }

  /// Fetch Lawyers
  Future<void> fetchLawyers() async {
    try {
      final response = await supabase
          .from('lawyer')
          .select('id, name, image_url, category').eq('verified', true)
          .order('id', ascending: false)
          .limit(4);

      setState(() {
        lawyers = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching lawyers: $e');
    }
  }

  /// Fetch Blogs
  Future<void> fetchBlogs() async {
    try {
      final response = await supabase.from('blog').select('id, title, image_url, content');
      setState(() {
        blogs = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching blogs: $e');
    }
  }

  /// Document Upload
  Future<void> _pickDocument(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: source);

    if (file != null) {
      setState(() {
        _selectedFile = file;
        isLoading = true;
      });

      await _summaryStore.summarizeDocument(file);

      setState(() => isLoading = false);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SummaryScreen(
              summary: _summaryStore.summary ?? "No summary available.",
              imagePath: file.path,
            ),
          ),
        );
      }
    }
  }

  /// Build Method
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
        body:Center(child: Image.asset('assets/loader.gif')),
      );
    }else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          setState(() {
            fetchSlides();
            fetchBlogs();
            fetchLawyers();
          });
        },
          child: Icon(Icons.refresh),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (slideImages.isNotEmpty) _buildCarousel(),

              const SizedBox(height: 20),
              Divider(
                color: Colors.teal.shade700,
              ),
              _buildDocumentUpload(),
              Divider(
                color: Colors.teal.shade700,
              ),
              const SizedBox(height: 20),
              _buildLawyerSection(),

              const SizedBox(height: 20),
              _buildBlogSection(),
            ],
          ),
        ),
      );
    }
  }

  /// Carousel Section
  Widget _buildCarousel() {
    return Column(
      children: [
        const Text(
          "Featured",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.95,
          ),
          items: slideImages.map((imageUrl) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Document Upload Section
  Widget _buildDocumentUpload() {
    return Column(
      children: [
        const Text(
          "Upload Document for Summarization",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _selectedFile != null
            ? Image.file(File(_selectedFile!.path), width: 200, height: 200, fit: BoxFit.cover)
            : const Icon(Icons.insert_drive_file, size: 80, color: Colors.teal),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildUploadButton("Gallery", Icons.image, () => _pickDocument(ImageSource.gallery)),
            _buildUploadButton("Camera", Icons.camera_alt, () => _pickDocument(ImageSource.camera)),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(minimumSize: const Size(150, 50)),
    );
  }

  /// Lawyers Section
  Widget _buildLawyerSection() {
    return Column(
      children: [
        const Text(
          "Top Lawyers",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        lawyers.isEmpty
            ? const CircularProgressIndicator()
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.90,
          ),
          itemCount: lawyers.length,
          itemBuilder: (context, index) {
            final lawyer = lawyers[index];
            return GestureDetector(
              onTap: (){
                  showDialog(
                    context: context,
                    builder: (context) => HireLawyerForm(lawyerId: lawyer['email'], lawyerName: lawyer['name']),
                  );
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        lawyer['image_url'],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lawyer['name'],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lawyer['category'],
                            style: const TextStyle(fontSize: 14, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Blog Section
  Widget _buildBlogSection() {
    return Column(
      children: [
        const Text(
          "Latest Blogs",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        blogs.isEmpty
            ? const CircularProgressIndicator()
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.9,
          ),
          itemCount: blogs.length,
          itemBuilder: (context, index) {
            final blog = blogs[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BlogDetailScreen(blog: blog)),
              ),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(blog['image_url'], height: 120, fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        blog['title'],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
