import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/crisis_card/presentation/pages/crisis_card.dart';
import '../features/offline_toolkit/presentation/pages/daily_journal_screen.dart';
import 'slidea.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false); // ✅ mark as finished
    Navigator.of(context).pushReplacementNamed('/firstpage');
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      rawPages: [

        Onboarding1(),
        Onboarding2(),
        Onboarding3(),





      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: getDotDecoration(),
      globalBackgroundColor: const Color(0xFF092B47),
    );
  }

  PageDecoration getPageDecoration() => const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyTextStyle: TextStyle(fontSize: 16, color: Colors.white70),
    // descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Color(0xFF092B47),
  );

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Colors.white38,
    activeColor: Colors.white,
    size: const Size(10, 10),
    activeSize: const Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}
