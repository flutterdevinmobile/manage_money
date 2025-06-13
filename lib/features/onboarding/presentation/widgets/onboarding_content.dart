import 'package:flutter/material.dart';

class OnboardingContent extends StatelessWidget {
  final String title, description, image;
  final bool isLast;
  final VoidCallback onContinue;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.isLast,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          const SizedBox(height: 32),
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(description, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onContinue,
            child: Text(isLast ? 'Get Started' : 'Continue'),
          )
        ],
      ),
    );
  }
}
