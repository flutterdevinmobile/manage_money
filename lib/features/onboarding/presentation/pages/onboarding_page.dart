import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<Map<String, String>> data = [
    {
      'title': 'Welcome to Manage My Money',
      'desc': 'Track expenses, manage loans, and plan your budget easily.',
      'image': 'assets/images/finance1.png',
    },
    {
      'title': 'Visual Analytics',
      'desc': 'Get insights with smart charts and budget goals.',
      'image': 'assets/images/analytics.png',
    },
    {
      'title': 'Secure & Cloud-based',
      'desc': 'All your data backed up securely with Firebase.',
      'image': 'assets/images/secure.png',
    },
  ];

  Future<void> _completeOnboarding() async {
    final box = await Hive.openBox('app');
    box.put('seenOnboarding', true);
    context.go('/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: data.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (ctx, i) => OnboardingContent(
          title: data[i]['title']!,
          description: data[i]['desc']!,
          image: data[i]['image']!,
          isLast: i == data.length - 1,
          onContinue: _completeOnboarding,
        ),
      ),
    );
  }
}
