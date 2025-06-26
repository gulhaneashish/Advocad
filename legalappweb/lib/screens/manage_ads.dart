import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ManageAdsScreen extends StatefulWidget {
  const ManageAdsScreen({super.key});

  @override
  State<ManageAdsScreen> createState() => _ManageAdsScreenState();
}

class _ManageAdsScreenState extends State<ManageAdsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _imageUrlController = TextEditingController();
  List<Map<String, dynamic>> _ads = [];

  @override
  void initState() {
    super.initState();
    fetchAds();
  }

  // Fetch images from the slides table
  Future<void> fetchAds() async {
    try {
      final response = await supabase.from('slides').select('id, image_url');
      setState(() {
        _ads = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching ads: $e')),
      );
    }
  }

  // Add image URL to the slides table
  Future<void> addAd() async {
    if (_imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid image URL')),
      );
      return;
    }
    try {
      await supabase.from('slides').insert({
        'image_url': _imageUrlController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image added successfully')),
      );
      _imageUrlController.clear();
      fetchAds();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding image: $e')),
      );
    }
  }

  // Delete image from the slides table
  Future<void> deleteAd(int id) async {
    try {
      await supabase.from('slides').delete().match({'id': id});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image deleted successfully')),
      );
      fetchAds();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Ads')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input for adding image URL
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addAd,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Add Image URL'),
            ),
            const SizedBox(height: 20),

            // Display ads from slides table
            Expanded(
              child: _ads.isEmpty
                  ? const Center(child: Text('No ads available'))
                  : ListView.builder(
                itemCount: _ads.length,
                itemBuilder: (context, index) {
                  final ad = _ads[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        ad['image_url'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                      ),
                      title: Text('Ad ID: ${ad['id']}'),
                      subtitle: Text(ad['image_url']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteAd(ad['id']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
