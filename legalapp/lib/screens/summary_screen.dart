import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SummaryScreen extends StatelessWidget {
  final String summary;
  final String imagePath;

  const SummaryScreen({super.key, required this.summary, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Summary Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath), width: 200, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Expanded(
              child: Markdown(
                data: summary,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  strong: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
