import 'package:ease_my_deal/utils/api_helper.dart';
import 'package:ease_my_deal/views/dynamic_ui.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiHelper.loadConfig(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          debugPrint("Error loading config: ${snapshot.error}");
          return Scaffold(
            body: Center(
              child: Text(
                "Error loading config: ${snapshot.error}",
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(
              child: Text("Config file is empty or missing."),
            ),
          );
        }
        return DynamicUI(config: snapshot.data!);
      },
    );
  }
}
