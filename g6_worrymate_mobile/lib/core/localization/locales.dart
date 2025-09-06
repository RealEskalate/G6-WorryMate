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
  static const String homeQuickTrackWins = 'home_quick_wins';

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
  static const String homeActivityLoggedTemplate = 'home_activity_logged_template'; 

    // box breathing (offline toolkit)
    static const String boxBreathingTitle = 'box_breathing_title';
    static const String boxBreathingExerciseTitle = 'box_breathing_exercise_title';
    static const String boxBreathingStepIn = 'box_breathing_step_in';
    static const String boxBreathingStepHold = 'box_breathing_step_hold';
    static const String boxBreathingStepOut = 'box_breathing_step_out';
    static const String boxBreathingInstruction = 'box_breathing_instruction';
    static const String boxBreathingStart = 'box_breathing_start';
    static const String boxBreathingReset = 'box_breathing_reset';
    static const String boxBreathingDescription = 'box_breathing_description';
  
  // five-four grounding (offline toolkit)
  static const String fiveFourTitle = 'five_four_title';
  static const String fiveFourExerciseTitle = 'five_four_exercise_title';
  static const String fiveFourStep1 = 'five_four_step_1';
  static const String fiveFourStep2 = 'five_four_step_2';
  static const String fiveFourStep3 = 'five_four_step_3';
  static const String fiveFourStep4 = 'five_four_step_4';
  static const String fiveFourStep5 = 'five_four_step_5';
  static const String fiveFourPrevious = 'five_four_previous';
  static const String fiveFourNext = 'five_four_next';
  static const String fiveFourReset = 'five_four_reset';
  static const String fiveFourDescription = 'five_four_description';

  // offline toolkit screen general
  static const String offlineToolkitTitle = 'offline_toolkit_title';
  static const String offlineToolkitSubtitle = 'offline_toolkit_subtitle';
  static const String offlineToolkitWorksOffline = 'offline_toolkit_works_offline';

  // daily journal description (card)
  static const String dailyJournalDescription = 'daily_journal_description';

  // win tracker
  static const String winTrackerTitle = 'win_tracker_title';
  static const String winTrackerDescription = 'win_tracker_description';
  static const String winTrackerAddLabel = 'win_tracker_add_label';
  static const String winTrackerHint = 'win_tracker_hint';
  static const String winTrackerAddButton = 'win_tracker_add_button';
  static const String winTrackerYourWins = 'win_tracker_your_wins';
  static const String winTrackerEmptyState = 'win_tracker_empty_state';

  // chat screen
  static const String chatTagline = 'chat_tagline';
  static const String chatTryAsking = 'chat_try_asking';
  static const String chatExampleStressedExams = 'chat_example_stressed_exams';
  static const String chatExampleLostJob = 'chat_example_lost_job';
  static const String chatExampleFamilyFighting = 'chat_example_family_fighting';
  static const String chatInputHint = 'chat_input_hint';

  // action card screen
  static const String actionCardPanicSteps = 'action_card_panic_steps';
  static const String actionCardIfWorse = 'action_card_if_worse';
  static const String actionCardDisclaimerLabel = 'action_card_disclaimer_label';
  static const String actionCardTools = 'action_card_tools';
  static const String actionCardLaunchError = 'action_card_launch_error';

  static const String homeActivityTitle = 'home_activity_title';
  static const String homeRingToday = 'home_ring_today';
  static const String homeRing7Days = 'home_ring_7days';
  static const String homeRingStreak = 'home_ring_streak';
  static const String homeStreakBarTemplate = 'home_streak_bar_template';

  // +++ Reminder +++
  static const String reminderTitle = 'reminder_title';
  static const String reminderDescription = 'reminder_description';
  static const String reminderEnableLabel = 'reminder_enable_label';
  static const String reminderTimeLabel = 'reminder_time_label';
  static const String reminderPickTime = 'reminder_pick_time';
  static const String reminderSet = 'reminder_set';
  static const String reminderCancel = 'reminder_cancel';
  static const String reminderSaved = 'reminder_saved';
  static const String reminderDisabled = 'reminder_disabled';
  static const String reminderError = 'reminder_error';

  //preferences
  static const String preferencesTitle = 'preferences_title';
  static const String preferencesSubtitle = 'preferences_subtitle';
  static const String preferencesContinue = 'preferences_continue';
  static const String preferencesSaved = 'preferences_saved';

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
    homeQuickTrackWins: 'Wins',
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
    homeMoodLoggedTemplate: 'Logged mood: %a',
    homeActivityTitle: 'Your activity',
    homeRingToday: 'Today',
    homeRing7Days: '7 Days',
    homeRingStreak: 'Streak',
    homeStreakBarTemplate: 'Streak: %a',
    homeActivityLoggedTemplate: 'Activity logged: %a',
    // box breathing
    boxBreathingTitle: 'Box Breathing',
    boxBreathingExerciseTitle: 'Box Breathing Exercise',
    boxBreathingStepIn: 'Breathe In',
    boxBreathingStepHold: 'Hold',
    boxBreathingStepOut: 'Breathe Out',
    boxBreathingInstruction: 'Breathe in for 4 seconds, hold for 4, exhale for 4, hold for 4',
    boxBreathingStart: 'Start Breathing',
    boxBreathingReset: 'Reset',
    boxBreathingDescription: '4-4-4-4 breathing pattern to calm your mind',
  // five-four grounding
  fiveFourTitle: '5-4-3-2-1 Grounding',
  fiveFourExerciseTitle: '5-4-3-2-1 Grounding Exercise',
  fiveFourStep1: 'Look around and name 5 things you can see',
  fiveFourStep2: 'Listen carefully and name 4 things you can hear',
  fiveFourStep3: 'Touch and name 3 things you can feel',
  fiveFourStep4: 'Think of 2 things you can smell',
  fiveFourStep5: 'Name 1 thing you can taste',
  fiveFourPrevious: 'Previous',
  fiveFourNext: 'Next',
  fiveFourReset: 'Reset',
  fiveFourDescription: 'Focus on your senses to stay present',
  // offline toolkit screen
  offlineToolkitTitle: 'Offline Toolkit',
  offlineToolkitSubtitle: 'Wellness tools that work without internet',
  offlineToolkitWorksOffline: 'Works Offline',
  // daily journal description
  dailyJournalDescription: 'Reflect on your thoughts and feelings',
  // win tracker
  winTrackerTitle: 'Win Tracker',
  winTrackerDescription: 'Celebrate small victories and progress',
  winTrackerAddLabel: 'Add a new win:',
  winTrackerHint: 'I completed my assignment...',
  winTrackerAddButton: 'Add',
  winTrackerYourWins: 'Your Wins:',
  winTrackerEmptyState: 'Start tracking your wins, no matter how small!',
  // chat screen
  chatTagline: 'Your AI worry buddy',
  chatTryAsking: 'Try asking about:',
  chatExampleStressedExams: "I'm really stressed about my exams",
  chatExampleLostJob: "I lost my job and i'm worried about money.",
  chatExampleFamilyFighting: 'My family and i keep fighting.',
  chatInputHint: 'Type your message...',
  // action card
  actionCardPanicSteps: 'Panic Steps:',
  actionCardIfWorse: 'If Worse:',
  actionCardDisclaimerLabel: 'Disclaimer',
  actionCardTools: 'Tools:',
  actionCardLaunchError: 'Could not launch URL',

      // Reminder (EN)
    reminderTitle: 'Daily Reminder',
    reminderDescription: 'Get a gentle nudge each day to reflect or check in.',
    reminderEnableLabel: 'Enable reminder',
    reminderTimeLabel: 'Scheduled time',
    reminderPickTime: 'Pick time',
    reminderSet: 'Save',
    reminderCancel: 'Cancel',
    reminderSaved: 'Reminder saved',
    reminderDisabled: 'Reminder disabled',
    reminderError: 'Could not schedule reminder',


    //preferences
    preferencesTitle: 'Set your preferences',
    preferencesSubtitle: 'Adjust theme, language and how chats are stored.',
    preferencesContinue: 'Continue',
    preferencesSaved: 'Preferences saved',

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
    homeQuickTrackWins: 'ድሎች',
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
    homeMoodLoggedTemplate: 'የተመዘገበ ስሜት: %a',
    homeActivityTitle: 'እንቅስቃሴህ',
    homeRingToday: 'ዛሬ',
    homeRing7Days: '7 ቀን',
    homeRingStreak: 'ቀጥታ',
    homeStreakBarTemplate: 'ቀጥታ: %a',
    homeActivityLoggedTemplate: 'እንቅስቃሴ ተመዝግቧል: %a',
    // box breathing
    boxBreathingTitle: 'የሳጥን መተንፈስ',
    boxBreathingExerciseTitle: 'የሳጥን መተንፈስ ልምምድ',
    boxBreathingStepIn: 'እስትንፉ',
    boxBreathingStepHold: 'ይጠብቁ',
    boxBreathingStepOut: 'ተንፈሱ',
    boxBreathingInstruction: '4 ሰከንድ እስትንፉ፣ 4 ሰከንድ ይጠብቁ፣ 4 ሰከንድ ተንፈሱ፣ 4 ሰከንድ ይጠብቁ',
    boxBreathingStart: 'መተንፈስ ጀምር',
    boxBreathingReset: 'ዳግም ጀምር',
    boxBreathingDescription: 'አእምሮን ለማረጋጋት 4-4-4-4 የመተንፈስ ንድፍ',
  // five-four grounding
  fiveFourTitle: '5-4-3-2-1 መመርመሪያ',
  fiveFourExerciseTitle: '5-4-3-2-1 መመርመሪያ ልምምድ',
  fiveFourStep1: 'በዙሪያህ ተመልከት እና ማየት የምትችላቸውን 5 ነገሮች ስማቸውን',
  fiveFourStep2: 'በጥንቃቄ ስማ እና ማዳመጥ የምትችላቸውን 4 ነገሮች ስማቸውን',
  fiveFourStep3: 'ስምር እና ማስተዋል የምትችላቸውን 3 ነገሮች ተንከባከብ',
  fiveFourStep4: 'ማሽተት የምትችላቸውን 2 ነገሮች አስብ',
  fiveFourStep5: 'ማቀመጥ የምትችለውን 1 ነገር ስሙ',
  fiveFourPrevious: 'የቀድሞ',
  fiveFourNext: 'ቀጣይ',
  fiveFourReset: 'ዳግም ጀምር',
  fiveFourDescription: 'በአምስቱ ስሜቶችህ ላይ ትኩረት አድርግ እዚህ ቆይ',
  // offline toolkit screen
  offlineToolkitTitle: 'ከመስመር ውጭ መሣሪያዎች',
  offlineToolkitSubtitle: 'በድር አለመኖሩም የሚሰሩ ጤና መሣሪያዎች',
  offlineToolkitWorksOffline: 'ከመስመር ውጭ ይሰራል',
  // daily journal description
  dailyJournalDescription: 'ስለ ሐሳብህና ስሜቶችህ የሚያስተውል',
  // win tracker
  winTrackerTitle: 'የድል መቁጠሪያ',
  winTrackerDescription: 'ትንሽ እድገቶችን እና ድሎችን አክብር',
  winTrackerAddLabel: 'አዲስ ድል አክል:',
  winTrackerHint: 'ተግባሬን ጨረስሁ...',
  winTrackerAddButton: 'አክል',
  winTrackerYourWins: 'ድሎችህ:',
  winTrackerEmptyState: 'ድሎችህን መከታተል ጀምር፣ ቢትንሽም እንኳ!',
  // chat screen
  chatTagline: 'የAI የውርይ ጓደኛህ',
  chatTryAsking: 'ስለ እነዚህ ለመጠየቅ ሞክር:',
  chatExampleStressedExams: 'ስለ ፈተናዎቼ ብዙ ጭንቀት አለብኝ',
  chatExampleLostJob: 'ስራዬን አጣሁ ስለ ገንዘብ እጨነቃለሁ።',
  chatExampleFamilyFighting: 'ከቤተሰቤ ጋር በቀጥታ እንጣላለን',
  chatInputHint: 'መልዕክትህን ፃፍ...',
  // action card
  actionCardPanicSteps: 'የፍርሃት እርምጃዎች:',
  actionCardIfWorse: 'ከዚያ ቢበልጥ:',
  actionCardDisclaimerLabel: 'ማስታወሻ',
  actionCardTools: 'መሣሪያዎች:',
  actionCardLaunchError: 'URL መክፈት አልተቻለም',

    // Reminder (AM)
    reminderTitle: 'ዕለታዊ አስታዋሽ',
    reminderDescription: 'በየቀኑ ለእንባብ ወይም ለመመርመር የሚያስታውስ ቀላል እንኳን.',
    reminderEnableLabel: 'አስታዋሽ አቃል',
    reminderTimeLabel: 'የታቀደ ጊዜ',
    reminderPickTime: 'ጊዜ ምረጥ',
    reminderSet: 'አስቀምጥ',
    reminderCancel: 'ተወው',
    reminderSaved: 'አስታዋሽ ተመዝግቧል',
    reminderDisabled: 'አስታዋሽ አጥፋል',
    reminderError: 'አስታዋሽ መመዝገብ አልተቻለም',


    //preferences
    preferencesTitle: 'ምርጫዎችን ያዋቅሩ',
    preferencesSubtitle: 'ጨለማ/ብርሃን፣ ቋንቋ እና ውይይቶች እንዴት እንዲቀመጡ ያቀናብሩ።',
    preferencesContinue: 'ቀጥል',
    preferencesSaved: 'ምርጫዎች ተቀምጠዋል',
    // Legacy
    title: 'ቅንብሮች',
    body: 'ምርጫዎችን ያቀናብሩ'
  };
}