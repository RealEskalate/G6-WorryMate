class AppServiceImage {
  String url;
  String title;

  AppServiceImage(this.url, this.title);
}

class AppService {
  String title;
  AppServiceImage coverImage;
  AppService(this.title, this.coverImage);
}


List<AppService> offlineTools = [
  AppService(
    'Breathing Timer',
    AppServiceImage(
      'assets/images/breathing.png',
        ''),
  ),
  AppService(
    'Grounding 5-4-3-2-1',
    AppServiceImage(
        'assets/images/meditation.png',
        ''),
  ),
  AppService(
    'Win Tracker',
    AppServiceImage(
        'assets/images/progress.png',
        ''),
  ),
  AppService(
    'Journal',
    AppServiceImage(
        'assets/images/journal.png',
        ''),
  ),
];

List<AppService> featuredAppServices = [
  AppService(
    'Chat with your AI Companion',
    AppServiceImage(
      'assets/images/Chat bot.png',
      '',
    ),
  ),
  AppService(
    'Daily Mood Check-In',
    AppServiceImage(
      'assets/images/progress.png',
      '',
    ),
  ),
  AppService(
    'Celebrate Small Wins',
    AppServiceImage(
      'assets/images/journal.png',
      '',
    ),
  ),
  AppService(
    'Guided Breathing Session',
    AppServiceImage(
      'assets/images/breathing.png',
      '',
    ),
  ),
  AppService(
    'Ground & Refocus (5-4-3-2-1)',
    AppServiceImage(
      'assets/images/meditation.png',
      '',
    ),
  ),
  // Optional sixth slide:
  // AppService(
  //   'Safety & Support Resources',
  //   AppServiceImage(
  //     'assets/images/safety_resources.gif',
  //     '',
  //   ),
  // ),
];