// lib/features/setting/settings.dart
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:g6_worrymate_mobile/core/localization/locales.dart';
import 'package:g6_worrymate_mobile/core/theme/theme_manager.dart';
import 'package:g6_worrymate_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:g6_worrymate_mobile/features/action_card/data/datasources/chat_prefs_local_data_source.dart';
import 'package:g6_worrymate_mobile/features/action_card/presentation/bloc/chat_bloc.dart';
import 'package:g6_worrymate_mobile/features/action_card/presentation/bloc/chat_event.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool saveChat = false;
  double fontSize = 16;

  late FlutterLocalization _flutterLocalization;
  late String _currentLocale;

  @override
  void initState() {
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;
    // Load initial toggle from local prefs
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ds = ChatPrefsLocalDataSource();
      final enabled = await ds.isSaveEnabled();
      if (mounted) setState(() => saveChat = enabled);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final isDarkMode = themeManager.isDarkMode;

    Color getPrimaryColor() =>
        isDarkMode ? Colors.greenAccent : const Color.fromARGB(255, 9, 43, 71);
    Color getTextColor() => isDarkMode ? Colors.white : Colors.black;
    Color getContainerColor() => isDarkMode ? Colors.white10 : Colors.grey[50]!;
    Color getBorderColor() =>
        isDarkMode ? Colors.transparent : Colors.grey[200]!;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 9, 43, 71)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 9, 43, 71)
            : Colors.white,
        elevation: 0,
        leading: Icon(Icons.settings_outlined, color: getPrimaryColor()),
        title: Text(
          LocalData.settingsTitle.getString(context),
          style: GoogleFonts.poppins(
            color: getPrimaryColor(),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSection(
            title: LocalData.appearance.getString(context),
            children: [
              SwitchListTile(
                title: Text(
                  LocalData.darkMode.getString(context),
                  style: TextStyle(color: getTextColor()),
                ),
                value: isDarkMode,
                activeColor: getPrimaryColor(),
                onChanged: (value) => themeManager.setTheme(value),
              ),
            ],
            isDarkMode: isDarkMode,
            containerColor: getContainerColor(),
            borderColor: getBorderColor(),
          ),

          const SizedBox(height: 16),

          // Language & Font Section
          _buildSection(
            title: LocalData.language.getString(context),
            children: [
              Row(
                children: [
                  ChoiceChip(
                    label: Text(
                      'English',
                      style: TextStyle(
                        color: _currentLocale == 'en'
                            ? (isDarkMode ? Colors.black : Colors.white)
                            : getTextColor(),
                      ),
                    ),
                    selectedColor: getPrimaryColor(),
                    backgroundColor: isDarkMode
                        ? Colors.white12
                        : Colors.grey[300],
                    selected: _currentLocale == 'en',
                    onSelected: (_) {
                      _flutterLocalization.translate('en');
                      setState(() => _currentLocale = 'en');
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text(
                      'አማርኛ',
                      style: TextStyle(
                        color: _currentLocale == 'am'
                            ? (isDarkMode ? Colors.black : Colors.white)
                            : getTextColor(),
                      ),
                    ),
                    selectedColor: getPrimaryColor(),
                    backgroundColor: isDarkMode
                        ? Colors.white12
                        : Colors.grey[300],
                    selected: _currentLocale == 'am',
                    onSelected: (_) {
                      _flutterLocalization.translate('am');
                      setState(() => _currentLocale = 'am');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            isDarkMode: isDarkMode,
            containerColor: getContainerColor(),
            borderColor: getBorderColor(),
          ),

          const SizedBox(height: 16),


          _buildSection(
            title: LocalData.aboutTitle.getString(context),
            children: [
              Text(
                LocalData.aboutDescription.getString(context),
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Chip(
                backgroundColor: getPrimaryColor(),
                label: Text(
                  LocalData.versionLabel.getString(context),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
            isDarkMode: isDarkMode,
            containerColor: getContainerColor(),
            borderColor: getBorderColor(),
          ),

          const SizedBox(height: 16),

          // Privacy Section
          _buildSection(
            title: LocalData.privacyTitle.getString(context),
            children: [
              SwitchListTile(
                title: Text(
                  LocalData.saveChat.getString(context),
                  style: TextStyle(color: getTextColor()),
                ),
                value: saveChat,
                activeColor: getPrimaryColor(),
                onChanged: (value) async {
                  setState(() => saveChat = value);
                  final ds = ChatPrefsLocalDataSource();
                  await ds.setSaveEnabled(value);
                },
              ),
              TextButton(
                onPressed: () {
                  context.read<ChatBloc>().add(DeleteAllChatHistoryEvent());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chat history deleted')),
                  );
                },
                child: Text(
                  LocalData.deleteChatHistory.getString(context),
                  style: TextStyle(
                    color: isDarkMode ? Colors.red : Colors.red[700],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                LocalData.privacyPointLocal.getString(context),
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 13,
                ),
              ),
              Text(
                LocalData.privacyPointNoServer.getString(context),
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
            isDarkMode: isDarkMode,
            containerColor: getContainerColor(),
            borderColor: getBorderColor(),
          ),

          const SizedBox(height: 24),

          // Back Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: getPrimaryColor(),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, '/chat'),
            child: Text(LocalData.backToChat.getString(context)),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 4) return;
          final routes = ['/', '/journal', '/offlinetoolkit', '/chat'];
          Navigator.pushReplacementNamed(context, routes[index]);
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    required bool isDarkMode,
    required Color containerColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
