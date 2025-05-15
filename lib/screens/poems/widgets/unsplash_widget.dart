import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class UnsplashImagePicker extends StatefulWidget {
  final Function(String url) onImageSelected;

  const UnsplashImagePicker({super.key, required this.onImageSelected});

  @override
  State<UnsplashImagePicker> createState() => _UnsplashImagePickerState();
}

class _UnsplashImagePickerState extends State<UnsplashImagePicker> {
  final String accessKey = 'muE4e8WRTaw1wWdADHlOGyJXUyTxHM4hIKv5ZKgRpoI';
  String searchQuery = "nature";
  List<dynamic> photos = [];
  bool isLoading = false;

  void _search() async {
  if (!mounted) return; // Add this check
  setState(() => isLoading = true);

  final response = await http.get(
    Uri.parse('https://api.unsplash.com/search/photos?page=1&per_page=30&query=$searchQuery&client_id=$accessKey'),
  );

  if (!mounted) return; // Check again after async call
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    setState(() {
      photos = data['results'];
      isLoading = false;
    });
  } else {
    setState(() => isLoading = false);
    // Optionally handle error
  }
}


  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Search Unsplash...'),
          onSubmitted: (value) {
            searchQuery = value;
            _search();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final photo = photos[index];
                final thumbUrl = photo['urls']['thumb'];
                final regularUrl = photo['urls']['regular'];
                return GestureDetector(
                  onTap: () {
                    widget.onImageSelected(regularUrl);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: thumbUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[300]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
