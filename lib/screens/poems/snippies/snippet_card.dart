import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnippetCard extends StatelessWidget {
  final String text;
  SnippetCard(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1080,
      height: 1920,
      padding: EdgeInsets.all(64),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Center(
        child: Text(
          text.isEmpty ? 'Your snippet will appear here' : text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
