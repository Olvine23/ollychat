import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyApGwZlbEZFK5G0LG1gygYbqZdApMJLu1Y',
  );

  Future<String> generatePromptFromText(
      String title, String mood, String genre) async {
    final prompt = TextPart('''
Write a heartfelt article or spoken word piece based on the title: "$title".
Let the writing reflect the mood of "$mood" and align it with the theme of "$genre".
Avoid stage directions or theatrical scenes. Instead, make it deeply personal and reflective — something the reader can connect with, feel, and ponder long after reading.
It should feel like someone's honest thoughts spilled onto a page.
''');

    final response = await model.generateContent([Content.text(prompt.text)]);
    return response.text ?? '';
  }

  Future<String> summarizeToQuote(String article) async {
    final prompt = TextPart(
      '''
Summarize the following article into a short, emotionally impactful quote under 25 words. The quote should feel raw, personal, and thought-provoking.

"$article"
''',
    );

    final response = await model.generateContent([Content.text(prompt.text)]);
    return response.text?.replaceAll('"', '').trim() ?? '';
  }
}
