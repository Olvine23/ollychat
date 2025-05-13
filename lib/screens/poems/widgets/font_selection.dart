import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontSelectionBottomSheet extends StatelessWidget {
  final Function(String) onFontSelected;

  FontSelectionBottomSheet({required this.onFontSelected});

  final List<String> fontList = [
    'Roboto',
    'Lora',
    'Playfair Display',
    'Merriweather',
    'Dancing Script',
    'Schoolbell',
    // Add more fonts here
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // Adjust height for the bottom sheet
      child: Column(
        children: [
           // Scroll handle
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: EdgeInsets.only(bottom: 10), // Margin for spacing
            ),
          SizedBox(height: 8), // Space at the top
          Text("Select a Font", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: fontList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Sample text in ${fontList[index]}',
                    style: GoogleFonts.getFont(fontList[index]),  // Show sample text
                  ),
                  onTap: () {
                    onFontSelected(fontList[index]);  // Notify parent widget of font selection
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}