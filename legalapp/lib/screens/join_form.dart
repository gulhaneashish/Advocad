import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legalapp/session_manager/session.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart'as http;
import 'package:pinput/pinput.dart';


class JoinForm extends StatefulWidget {
  const JoinForm({super.key});

  @override
  _JoinFormState createState() => _JoinFormState();
}

class _JoinFormState extends State<JoinForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController feesController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  File? selectedImage;
  String? uploadedImageUrl;
  File? selectedResume;
  String? uploadedResumeUrl;
  bool isSubmitting = false;
  bool isOtpSent = false;
  bool isOtpVerified = false;
  String? generatedOtp;

  final SupabaseClient supabase = Supabase.instance.client;

  final List<String> lawyerCategories = [
    "Civil Lawyer", "Criminal Lawyer", "Corporate Lawyer",
    "Family Lawyer", "Property Lawyer", "Tax Lawyer"
  ];
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails(); // Fetch existing details if user exists
  }
  // Generate OTP
  String generateOtp() {
    final Random random = Random();
    return (1000 + random.nextInt(9000)).toString(); // 4-digit OTP
  }

  Future<void> sendOtp(String phone) async {
    generatedOtp = generateOtp();
    String apiUrl = "https://www.fast2sms.com/dev/bulkV2?authorization=SOtq7kywLeozgV1dhTibYUKJGuxvDspjfH5IX9lNrMWcPR8A64X7vzFlDMWhEQxrCLdym3ie65TuK2Zj";

    final Uri url = Uri.parse("$apiUrl&route=q&message=$generatedOtp&flash=0&numbers=$phone&schedule_time=");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() => isOtpSent = true);
        _showMessage("OTP sent successfully!", Colors.green);
      } else {
        _showMessage("Failed to send OTP. Try again.", Colors.red);
      }
    } catch (e) {
      _showMessage("Error sending OTP: $e", Colors.red);
    }
  }

  // Verify OTP
  void verifyOtp() {
    if (otpController.text == generatedOtp) {
      setState(() => isOtpVerified = true);
      _showMessage("OTP Verified Successfully!", Colors.green);
    } else {
      _showMessage("Invalid OTP. Please try again.", Colors.red);
    }
  }

  // Show Messages
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
    ));
  }

  // Fetch Existing Data if User Exists
  Future<void> _fetchUserDetails() async {
    final response = await supabase
        .from('lawyer')
        .select()
        .eq('user_id', SessionManager.userId.toString())
        .maybeSingle();

    if (response != null) {
      setState(() {
        nameController.text = response['name'] ?? '';
        feesController.text = response['fees']?.toString() ?? '';
        uploadedImageUrl = response['image_url'];
        phoneController.text=response['phone'];
        uploadedResumeUrl = response['resume_url'];
        selectedCategories = (response['category'] as String?)?.split(',') ?? [];
      });
    }
  }

  // Pick Image
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
      await uploadImageToSupabase();
    }
  }

  // Upload Image to Supabase
  Future<void> uploadImageToSupabase() async {
    if (selectedImage == null) return;
    final String imagePath = "lawyers/${DateTime.now().millisecondsSinceEpoch}.jpg";

    try {
      await supabase.storage.from('profile').upload(imagePath, selectedImage!);
      final imageUrl = supabase.storage.from('profile').getPublicUrl(imagePath);

      setState(() => uploadedImageUrl = imageUrl);
    } catch (e) {
      _showMessage("Image upload failed: $e", Colors.red);
    }
  }

  // Pick Resume (PDF)
  Future<void> pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => selectedResume = File(result.files.single.path!));
      await uploadResumeToSupabase();
    }
  }

  // Upload Resume to Supabase
  Future<void> uploadResumeToSupabase() async {
    if (selectedResume == null) return;
    final String resumePath = "resumes/${DateTime.now().millisecondsSinceEpoch}.pdf";

    try {
      await supabase.storage.from('profile').upload(resumePath, selectedResume!);
      final resumeUrl = supabase.storage.from('profile').getPublicUrl(resumePath);

      setState(() => uploadedResumeUrl = resumeUrl);
    } catch (e) {
      _showMessage("Resume upload failed: $e", Colors.red);
    }
  }

  // Submit or Update Form
  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate() || uploadedImageUrl == null || uploadedResumeUrl == null || selectedCategories.isEmpty) {
      _showMessage("Please complete all fields before submission.", Colors.red);
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final existingUser = await supabase
          .from('lawyer')
          .select('user_id')
          .eq('user_id', SessionManager.userId.toString())
          .maybeSingle();

      final data = {
        'user_id': SessionManager.userId.toString(),
        'name': nameController.text.trim(),
        'fees': int.parse(feesController.text.trim()),
        'image_url': uploadedImageUrl,
        'phone':phoneController.text,
        'resume_url': uploadedResumeUrl,
        'category': selectedCategories.join(','),
      };

      if (existingUser == null) {
        await supabase.from('lawyer').insert(data);
        _showMessage("Application submitted successfully!", Colors.green);
      } else {
        await supabase.from('lawyer').update(data).eq('user_id', SessionManager.userId.toString());
        _showMessage("Details updated successfully!", Colors.green);
      }

      Navigator.pop(context);
    } catch (e) {
      _showMessage("Error: $e", Colors.red);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Join as a Lawyer", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter your name" : null,
                ),
                const SizedBox(height: 10),

                // Approx Fees Field
                TextFormField(
                  controller: feesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Approx Fees",
                    prefixIcon: const Icon(Icons.money),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter approx fees" : null,
                ),
                const SizedBox(height: 10),

                // Multi-Select Category
                MultiSelectDialogField(
                  items: lawyerCategories.map((c) => MultiSelectItem<String>(c, c)).toList(),
                  title: const Text("Select Categories"),
                  selectedColor: Colors.blue,
                  initialValue: selectedCategories,
                  onConfirm: (values) => setState(() => selectedCategories = values),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  buttonText: const Text("Choose Categories"),
                ),
                const SizedBox(height: 10),

                // Upload Image Button
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Upload Image"),
                ),

                // Show Uploaded Image Preview
                if (uploadedImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.network(uploadedImageUrl!, height: 100),
                  ),

                // Upload Resume Button
                ElevatedButton.icon(
                  onPressed: pickResume,
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Upload Certificate (PDF)"),
                ),

                if (uploadedResumeUrl != null)
                  Text("Resume uploaded successfully!", style: TextStyle(color: Colors.green)),

                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Contact Number",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (value) =>
                  (value!.length != 10) ? "Enter a valid number" : null,
                ),
                const SizedBox(height: 10),

                // Send OTP Button
                ElevatedButton(
                  onPressed: () => sendOtp(phoneController.text),
                  child: const Text("Send OTP"),
                ),

                // OTP Verification Field
                if (isOtpSent) ...[
                  const SizedBox(height: 10),
                  Pinput(
                    controller: otpController,
                    length: 4,
                    defaultPinTheme: PinTheme(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onCompleted: (value) => verifyOtp(),
                  ),
                ],

                if (isOtpVerified)
                  const Text(
                    "OTP Verified!",
                    style: TextStyle(color: Colors.green),
                  ),

                const SizedBox(height: 10),

                // Submit Button
                ElevatedButton(
                  onPressed: isOtpVerified ? () {
                    submitForm();
                  } : null,
                  child: const Text("Submit"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isOtpVerified ? Colors.green : Colors.teal),
                ),

                if (isSubmitting) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
