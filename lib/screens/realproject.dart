import 'package:flutter/material.dart';
import 'package:flutterxlearn/screens/app_bar.dart';

class HelloHome extends StatelessWidget {
  const HelloHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(),
      // 1. Fixed: Body properly accepts the widget tree
      body: SizedBox(
        height: 200,
        // 2. Fixed: Column is now the nested child of SizedBox
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white10,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: "Search Here", // 3. Fixed: Typo corrected
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
                      "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtNTMzLWljb24tMjlfMS5wbmc.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(
                      "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L3JtNTMzLWljb24tMjlfMS5wbmc.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
