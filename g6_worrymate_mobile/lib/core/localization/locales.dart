import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale('en', LocalData.EN),
  MapLocale('am', LocalData.AM),
];

mixin LocalData {
  // settings
  static const String settingsTitle = 'settings_title';
  static const String appearance = 'appearance';
  static const String darkMode = 'dark_mode';
  static const String language = 'language';
  static const String fontSize = 'font_size';
  static const String aboutTitle = 'about_title';
  static const String aboutDescription = 'about_description';
  static const String versionLabel = 'version_label';
  static const String privacyTitle = 'privacy_title';
  static const String saveChat = 'save_chat';
  static const String deleteChatHistory = 'delete_chat_history';
  static const String privacyPointLocal = 'privacy_point_local';
  static const String privacyPointNoServer = 'privacy_point_no_server';
  static const String backToChat = 'back_to_chat';

  // journal
  static const String dailyJournalTitle = 'daily_journal_title';
  static const String journalPromptsHeading = 'journal_prompts_heading';
  static const String journalPromptFeelingNow = 'journal_prompt_feeling_now';
  static const String journalPromptSmileToday = 'journal_prompt_smile_today';
  static const String journalPromptGrateful = 'journal_prompt_grateful';
  static const String journalPromptChallengeOvercome = 'journal_prompt_challenge_overcome';
  static const String journalPromptHopeTomorrow = 'journal_prompt_hope_tomorrow';
  static const String journalYourThoughtsLabel = 'journal_your_thoughts_label';
  static const String journalInputHint = 'journal_input_hint';
  static const String journalEntriesHeading = 'journal_entries_heading';
  static const String journalEntriesPrivacyNote = 'journal_entries_privacy_note';

  // home page / dashboard
  static const String appBrandPart1 = 'app_brand_part1';
  static const String appBrandPart2 = 'app_brand_part2';

  static const String homeGreetingMorning = 'home_greeting_morning';
  static const String homeGreetingAfternoon = 'home_greeting_afternoon';
  static const String homeGreetingEvening = 'home_greeting_evening';

  static const String homeStubJournal = 'home_stub_journal';
  static const String homeStubWins = 'home_stub_wins';
  static const String homeStubProfile = 'home_stub_profile';

  static const String homeStatStreak = 'home_stat_streak';
  static const String homeStatThisWeek = 'home_stat_this_week';
  static const String homeStatToday = 'home_stat_today';

  static const String homeQuickJournal = 'home_quick_journal';
  static const String homeQuickMood = 'home_quick_mood';
  static const String homeQuickBreathing = 'home_quick_breathing';
  static const String homeQuickChatAI = 'home_quick_chat_ai';

  static const String homeAffirmation1 = 'home_affirmation_1';
  static const String homeAffirmation2 = 'home_affirmation_2';
  static const String homeAffirmation3 = 'home_affirmation_3';
  static const String homeAffirmation4 = 'home_affirmation_4';

  static const String homeAskSupportTitle = 'home_ask_support_title';
  static const String homePromptFeelingAnxious = 'home_prompt_feeling_anxious';
  static const String homePromptImproveSleep = 'home_prompt_improve_sleep';
  static const String homePromptLowMotivation = 'home_prompt_low_motivation';
  static const String homePromptOverthinking = 'home_prompt_overthinking';
  static const String homePromptHint = 'home_prompt_hint';
  static const String homePromptSent = 'home_prompt_sent';

  static const String homeSafetyBannerText = 'home_safety_banner_text';

  static const String homeMoodCheckInTitle = 'home_mood_checkin_title';
  static const String homeMoodLow = 'home_mood_low';
  static const String homeMoodMeh = 'home_mood_meh';
  static const String homeMoodOkay = 'home_mood_okay';
  static const String homeMoodGood = 'home_mood_good';
  static const String homeMoodGreat = 'home_mood_great';
  static const String homeMoodLoggedTemplate = 'home_mood_logged_template';

  static const String homeActivityTitle = 'home_activity_title';
  static const String homeRingToday = 'home_ring_today';
  static const String homeRing7Days = 'home_ring_7days';
  static const String homeRingStreak = 'home_ring_streak';
  static const String homeStreakBarTemplate = 'home_streak_bar_template';

  // (Optional legacy keys)
  static const String title = 'title';
  static const String body = 'body';

  static const Map<String, dynamic> EN = {
    // settings
    settingsTitle: 'Settings',
    appearance: 'Appearance',
    darkMode: 'Dark Mode',
    language: 'Language',
    fontSize: 'Font Size',
    aboutTitle: 'About WorryMate',
    aboutDescription: 'WorryMate is your AI-powered worry buddy designed specifically for Africa.',
    versionLabel: 'Version 1.0 Demo',
    privacyTitle: 'Privacy & Safety',
    saveChat: 'Save chat',
    deleteChatHistory: 'Delete chat history',
    privacyPointLocal: '• Your conversations are stored locally only',
    privacyPointNoServer: '• No personal data is sent to servers',
    backToChat: 'Back to Chat',

    // journal
    dailyJournalTitle: 'Daily Journal',
    journalPromptsHeading: 'Journal Prompts:',
    journalPromptFeelingNow: 'How am I feeling right now?',
    journalPromptSmileToday: 'What made me smile today?',
    journalPromptGrateful: 'What is one thing I\'m grateful for?',
    journalPromptChallengeOvercome: 'What challenge did I overcome recently?',
    journalPromptHopeTomorrow: 'What do I hope for tomorrow?',
    journalYourThoughtsLabel: 'Your thoughts:',
    journalInputHint: 'Write about your day, feelings, or anything on your mind...',
    journalEntriesHeading: 'Your Journal Entries:',
    journalEntriesPrivacyNote: 'Your journal entries are saved locally and private to you.',

    // home
    appBrandPart1: 'Worry',
    appBrandPart2: 'Mate',
    homeGreetingMorning: 'Good morning',
    homeGreetingAfternoon: 'Good afternoon',
    homeGreetingEvening: 'Good evening',
    homeStubJournal: 'Journal (TODO)',
    homeStubWins: 'Wins (TODO)',
    homeStubProfile: 'Profile (TODO)',
    homeStatStreak: 'Streak',
    homeStatThisWeek: 'This Week',
    homeStatToday: 'Today',
    homeQuickJournal: 'Journal',
    homeQuickMood: 'Mood',
    homeQuickBreathing: 'Breathing',
    homeQuickChatAI: 'Chat AI',
    homeAffirmation1: 'You are making progress, one small step at a time.',
    homeAffirmation2: 'Your feelings are valid.',
    homeAffirmation3: 'Breathing space creates thinking space.',
    homeAffirmation4: 'You deserve kindness—from yourself too.',
    homeAskSupportTitle: 'Ask for support',
    homePromptFeelingAnxious: 'Feeling anxious',
    homePromptImproveSleep: 'Improve sleep',
    homePromptLowMotivation: 'Low motivation',
    homePromptOverthinking: 'Overthinking',
    homePromptHint: 'Describe how you feel or ask a question...',
    homePromptSent: 'Prompt sent',
    homeSafetyBannerText: 'Safety resources\nQuick help if needed',
    homeMoodCheckInTitle: 'Mood check-in',
    homeMoodLow: 'Low',
    homeMoodMeh: 'Meh',
    homeMoodOkay: 'Okay',
    homeMoodGood: 'Good',
    homeMoodGreat: 'Great',
    homeMoodLoggedTemplate: 'Logged mood: {}',
    homeActivityTitle: 'Your activity',
    homeRingToday: 'Today',
    homeRing7Days: '7 Days',
    homeRingStreak: 'Streak',
    homeStreakBarTemplate: 'Streak: {}',

    // Legacy
    title: 'Settings',
    body: 'Manage your preferences'
  };

  static const Map<String, dynamic> AM = {
    // settings
    settingsTitle: 'ቅንብሮች',
    appearance: 'መልክ',
    darkMode: 'ጨለማ ሁነታ',
    language: 'ቋንቋ',
    fontSize: 'የፊደል መጠን',
    aboutTitle: 'ስለ WorryMate',
    aboutDescription: 'WorryMate ለአፍሪካ በተሰራ በAI የተነዳ የውርይ ጓደኛዎ ነው።',
    versionLabel: 'እትም 1.0 ማሳያ',
    privacyTitle: 'ግላዊነት እና ደህንነት',
    saveChat: 'ውይይት አስቀምጥ',
    deleteChatHistory: 'የውይይት ታሪክ ሰርዝ',
    privacyPointLocal: '• ውይይቶችዎ በመሣሪያዎ ብቻ ይቀመጣሉ',
    privacyPointNoServer: '• የግል ውሂብ ወደ አገልጋዮች አይልክም',
    backToChat: 'ወደ ውይይት ተመለስ',

    // journal
    dailyJournalTitle: 'ዕለታዊ መዝገብ',
    journalPromptsHeading: 'የመዝገብ መነሻ ጥያቄዎች:',
    journalPromptFeelingNow: 'አሁን እንዴት እሰማለሁ?',
    journalPromptSmileToday: 'ዛሬ ምን ነገር አሳበሰኝ?',
    journalPromptGrateful: 'ምን ነገር ላይ እመሰግናለሁ?',
    journalPromptChallengeOvercome: 'በቅርቡ ያሸንፍኳት የትኛው ፈተና ነበር?',
    journalPromptHopeTomorrow: 'ለነገ ምን ተስፋ አደርጋለሁ?',
    journalYourThoughtsLabel: 'ሐሳቦችህ:',
    journalInputHint: 'ስለ ቀንህ፣ ስሜቶችህ ወይም በአእምሮህ ላይ ያለውን ነገር ጻፍ...',
    journalEntriesHeading: 'የመዝገብ ግቤቶችህ:',
    journalEntriesPrivacyNote: 'የመዝገብ ግቤቶችህ በመሣሪያው ላይ ብቻ ይቀመጣሉ እና ግል ናቸው።',

    // home
    appBrandPart1: 'Worry',
    appBrandPart2: 'Mate',
    homeGreetingMorning: 'ጥሩ ጠዋት',
    homeGreetingAfternoon: 'ጥሩ ቀን',
    homeGreetingEvening: 'ጥሩ ማታ',
    homeStubJournal: 'መዝገብ (በመካከል)',
    homeStubWins: 'ስኬቶች (በመካከል)',
    homeStubProfile: 'መገለጫ (በመካከል)',
    homeStatStreak: 'ቀጥታ',
    homeStatThisWeek: 'ይህ ሳምንት',
    homeStatToday: 'ዛሬ',
    homeQuickJournal: 'መዝገብ',
    homeQuickMood: 'ስሜት',
    homeQuickBreathing: 'መተንፈሻ',
    homeQuickChatAI: 'AI ውይይት',
    homeAffirmation1: 'በትንሽ ደረጃ በየቀኑ እየተመጣጠንህ ነህ።',
    homeAffirmation2: 'ስሜቶችህ ትክክለኛ ናቸው።',
    homeAffirmation3: 'የመተንፈስ እረፍት የሐሳብ ቦታ ይፈጥራል።',
    homeAffirmation4: 'ቸርነት ያስፈልግሃል—ከራስህ ዘንድም እንኳ።',
    homeAskSupportTitle: 'ድጋፍ ጠይቅ',
    homePromptFeelingAnxious: 'ጭንቀት እሰማለሁ',
    homePromptImproveSleep: 'እንቅልፍ ማሻሻል',
    homePromptLowMotivation: 'ፍጥረት ተቀና',
    homePromptOverthinking: 'ብዙ አስበዋለሁ',
    homePromptHint: 'እንዴት እንደምትሰማ ወይም ጥያቄ ጻፍ...',
    homePromptSent: 'ጥያቄ ተልኳል',
    homeSafetyBannerText: 'የደህንነት ምንጮች\nፈጣን እገዛ ከሚፈልጉት ጊዜ',
    homeMoodCheckInTitle: 'ስሜት መመዝገቢያ',
    homeMoodLow: 'ዝቅተኛ',
    homeMoodMeh: 'መካከለኛ',
    homeMoodOkay: 'እሺ',
    homeMoodGood: 'ጥሩ',
    homeMoodGreat: 'በጣም ጥሩ',
    homeMoodLoggedTemplate: 'የተመዘገበ ስሜት: {}',
    homeActivityTitle: 'እንቅስቃሴህ',
    homeRingToday: 'ዛሬ',
    homeRing7Days: '7 ቀን',
    homeRingStreak: 'ቀጥታ',
    homeStreakBarTemplate: 'ቀጥታ: {}',

    // Legacy
    title: 'ቅንብሮች',
    body: 'ምርጫዎችን ያቀናብሩ'
  };
}