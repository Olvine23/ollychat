import 'dart:convert';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

 
class GeminiService {
  final GenerativeModel model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: 'AIzaSyApGwZlbEZFK5G0LG1gygYbqZdApMJLu1Y');

  Future<String> generatePromptFromImage(File image , String title) async {
    // final bytes = await image.readAsBytes();
    final imageParts = [
        DataPart('image/jpeg', await image.readAsBytes()),
      ];
    final prompt = TextPart("Generate an interesting spoken word piece based on the image which has the title, $title ");

    // final base64Image = base64Encode(bytes);
    // final content = Content.multi([prompt, DataPart(base64Image, bytes)]);

    final response = await model.generateContent([Content.multi([prompt, ...imageParts])]);
    print(response.text);
    return response.text!;
  }
}
