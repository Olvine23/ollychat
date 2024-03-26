import 'package:flutter/material.dart';

class NoConnectivityScreen extends StatelessWidget {
  const NoConnectivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.signal_wifi_off, size: 100),
              const SizedBox(height: 20),
              const Text(
                'No internet connection',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}