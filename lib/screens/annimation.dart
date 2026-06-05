import 'package:flutter/material.dart';
import 'package:flutterxlearn/screens/main_navigation_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedFirebaseText extends StatefulWidget {
  const AnimatedFirebaseText({super.key});

  @override
  State<AnimatedFirebaseText> createState() => _AnimatedFirebaseTextState();
}

class _AnimatedFirebaseTextState extends State<AnimatedFirebaseText>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  bool showButton = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          showButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          // CENTER ANIMATION TEXT
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedLine(
                  text: "Powered By Artificial",
                  controller: controller,
                  startDelay: 0.0,
                ),
                const SizedBox(height: 10),
                AnimatedLine(
                  text: "Intelligence",
                  controller: controller,
                  startDelay: 0.6,
                ),
              ],
            ),
          ),

          // BOTTOM RIGHT BUTTON
          Positioned(
            bottom: 30,
            right: 20,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 800),
              opacity: showButton ? 1 : 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 800),
                offset: showButton ? Offset.zero : const Offset(0, 0.3),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainNavigationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedLine extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final double startDelay;

  const AnimatedLine({
    super.key,
    required this.text,
    required this.controller,
    this.startDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final chars = text.split('');

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = (screenWidth * 0.075).clamp(18.0, 40.0);

    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(chars.length, (index) {
        final start = startDelay + (index / chars.length) * 0.4;
        final end = (start + 0.15).clamp(0.0, 1.0);

        final animation = CurvedAnimation(
          parent: controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        );

        return AnimatedBuilder(
          animation: animation,
          child: Text(
            chars[index],
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -40 * (1 - animation.value)),
              child: Opacity(opacity: animation.value, child: child),
            );
          },
        );
      }),
    );
  }
}
