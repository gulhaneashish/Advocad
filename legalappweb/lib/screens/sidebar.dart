import 'package:flutter/material.dart';
import 'package:legalappweb/screens/lawyer_verification.dart';
import 'package:legalappweb/screens/manage_ads.dart';
import 'package:legalappweb/screens/upload_blogs.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      color: Colors.black87,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Admin Panel",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          SidebarTile(icon: Icons.dashboard, label: "Dashboard", onTap: () {}),
          SidebarTile(icon: Icons.verified_user, label: "Lawyer Verification", onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LawyerVerificationScreen()));
          }),
          SidebarTile(icon: Icons.post_add, label: "Upload Blogs", onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UploadBlogScreen()));
          }),
          SidebarTile(icon: Icons.campaign, label: "Manage Ads", onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ManageAdsScreen()));
          }),
        ],
      ),
    );
  }
}

class SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SidebarTile({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
