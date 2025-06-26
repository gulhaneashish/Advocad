import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legalapp/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HireLawyerForm extends StatefulWidget {
  final String lawyerId;
  final String lawyerName;

  const HireLawyerForm({super.key, required this.lawyerId, required this.lawyerName});

  @override
  _HireLawyerFormState createState() => _HireLawyerFormState();
}

class _HireLawyerFormState extends State<HireLawyerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  File? selectedImage;
  final SupabaseClient supabase = Supabase.instance.client;
  bool isSubmitting = false;

  void submitHiringRequest()async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);
   final response = await Supabase.instance.client.from('hiring').insert({
      'case_details': detailsController.text,
        'contact_number':contactController.text,
        'user_id':SessionManager.userId.toString(),
        'lawyer_id':widget.lawyerId,
        'document_url':uploadedImageUrl,
     'status':'Pending',
   }
    );

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isSubmitting = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hiring request sent to ${widget.lawyerName}.")));
    });
  }
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
      await uploadImageToSupabase();
    }
  }
  String? uploadedImageUrl;
  Future<void> uploadImageToSupabase() async {
    if (selectedImage == null) return;
    final String imagePath = "lawyers/${DateTime.now().millisecondsSinceEpoch}.jpg";

    try {
      await supabase.storage.from('document').upload(imagePath, selectedImage!);
      final imageUrl = supabase.storage.from('document').getPublicUrl(imagePath);

      setState(() => uploadedImageUrl = imageUrl);
    } catch (e) {
      _showMessage("Image upload failed: $e", Colors.red);
    }
  }
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Hire ${widget.lawyerName}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextFormField(
                controller: detailsController,
                decoration: const InputDecoration(labelText: "Case Details"),
                validator: (value) => value!.isEmpty ? "Please enter case details" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Contact Number"),
                validator: (value) => value!.isEmpty ? "Please enter Contact Details" : null,
              ),

              const SizedBox(height: 15),
              ElevatedButton(onPressed: (){
                pickImage();
              },
                  style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal
                  ),
                  child: Text('Upload Document',style: TextStyle(color: Colors.white),)),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: submitHiringRequest,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
