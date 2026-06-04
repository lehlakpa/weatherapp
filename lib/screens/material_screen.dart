import 'package:flutter/material.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  Widget buildCard({
    required String title,
    required String description,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Icon(icon ?? Icons.book, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Flutter Materials",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Flutter Basics",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Learn MaterialApp and Scaffold with clean explanations.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              buildCard(
                icon: Icons.apps,
                title: "What is MaterialApp?",
                description:
                    "MaterialApp is a convenience widget that acts as the root of your Flutter application. It provides navigation, themes, routes, and other material design configurations.",
              ),

              buildCard(
                icon: Icons.dashboard_customize,
                title: "What is Scaffold?",
                description:
                    "Scaffold provides the basic visual layout structure for a material design app. It includes AppBar, Body, FloatingActionButton, Drawer, BottomNavigationBar, and more.",
              ),

              buildCard(
                icon: Icons.compare_arrows,
                title: "MaterialApp vs Scaffold",
                description:
                    "MaterialApp is the root widget of your application, while Scaffold is used inside screens to create the visual page structure and UI layout.",
              ),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Basic Implementation",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "MaterialApp(\n"
                      "  title: 'Flutter Material',\n"
                      "  theme: ThemeData(\n"
                      "    primarySwatch: Colors.blue,\n"
                      "  ),\n"
                      "  home: Scaffold(\n"
                      "    appBar: AppBar(\n"
                      "      title: Text('Home'),\n"
                      "    ),\n"
                      "    body: Center(\n"
                      "      child: Text('Material & Scaffold'),\n"
                      "    ),\n"
                      "  ),\n"
                      ")",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.7,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ```

// ## Improvements Made

// * Modern card-based UI
// * Better spacing and padding
// * Professional typography
// * Soft background color
// * Scrollable content
// * Cleaner code structure using reusable widgets
// * Added icons for visual learning
// * Better readability for educational apps
// * Styled code section like documentation apps
