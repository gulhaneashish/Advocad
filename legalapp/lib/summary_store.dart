import 'dart:developer';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:mobx/mobx.dart';

part "summary_store.g.dart";

class SummaryStore = _SummaryStore with _$SummaryStore;

abstract class _SummaryStore with Store {
  @observable
  String? summary;

  @observable
  String? errorMessage;

  final model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: 'AIzaSyDH68HMO2562f-K-wdXgGqIoNNMdnd6fUo', // Ensure this is correct
  );

  @action
  Future<void> summarizeDocument(XFile document) async {
    try {
      final mimeType = lookupMimeType(document.path);
      if (mimeType == null || !mimeType.startsWith('image/')) {
        errorMessage = "Invalid document type.";
        return;
      }

      final bytes = await document.readAsBytes();

      // Corrected usage: Text prompt + DataPart for file
      final response = await model.generateContent([
        Content.multi([
          TextPart(
              "Summarize the content of this document in simple words. Highlight key points in **bold** using markdown. and check weather is it related to law or any legal aspect if not show it is not a legal document in bold and dont give summary"
          ),
          DataPart(mimeType, bytes), // Corrected usage
        ])
      ]);

      summary = response.text ?? "No summary generated.";
    } catch (e, stack) {
      log("Error: $e\n$stack");
      errorMessage = "An error occurred.";
    }
  }
}
