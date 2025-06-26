import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PDFViewer extends StatefulWidget {
  final String pdfUrl;
  const PDFViewer({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.pdfUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Certificate Viewer")),
      body: WebViewWidget(controller: controller),
    );
  }
}
