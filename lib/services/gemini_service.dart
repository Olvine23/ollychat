import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: 'AIzaSyApGwZlbEZFK5G0LG1gygYbqZdApMJLu1Y',
  );

  Future<String> generatePromptFromText(
      String title, String mood, String genre) async {
    final prompt = TextPart('''
Write a heartfelt spoken word piece based on the title: "$title".
Let the writing reflect the mood of "$mood" and align it with the theme of "$genre".
Avoid stage directions or theatrical scenes. Instead, make it deeply personal and reflective — something the reader can connect with, feel, and ponder long after reading.
It should feel like someone's honest thoughts spilled onto a page. Dont make it too long, just enough to reflect upon. 
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
