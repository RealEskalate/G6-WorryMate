import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_manager.dart';
import '../../../../core/localization/locales.dart';
import '../../../action_card/data/datasources/chat_prefs_local_data_source.dart';
import '../cubit/preferences_cubit.dart';
import '../widgets/theme_mode_selector.dart';
import '../widgets/language_selector.dart';
import '../widgets/save_chat_switch.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  bool _chatSaveLoaded = false;
  bool _chatSaveEnabled = true;

  @override
  void initState() {
    super.initState();
    context.read<PreferencesCubit>().load();
    _loadChatSavePref();
  }

  Future<void> _loadChatSavePref() async {
    final ds = ChatPrefsLocalDataSource();
    final val = await ds.isSaveEnabled();
    if (!mounted) return;
    setState(() {
      _chatSaveEnabled = val;
      _chatSaveLoaded = true;
    });
    context.read<PreferencesCubit>().setSaveChat(val);
  }

  Future<void> _onSaveChatChanged(bool value) async {
    setState(() => _chatSaveEnabled = value);
    final ds = ChatPrefsLocalDataSource();
    await ds.setSaveEnabled(value);
    context.read<PreferencesCubit>().setSaveChat(value);
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B2F4E) : const Color(0xFFF6F7FB),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/preferences_image.png',
              fit: BoxFit.cover,
            ),
          ),
            Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF0B2F4E).withOpacity(0.90),
                          const Color(0xFF0B2F4E).withOpacity(0.70),
                          const Color(0xFF0B2F4E).withOpacity(0.55),
                        ]
                      : [
                          Colors.white.withOpacity(0.92),
                          Colors.white.withOpacity(0.88),
                          Colors.white.withOpacity(0.80),
                        ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          BlocConsumer<PreferencesCubit, PreferencesState>(
            listener: (ctx, state) {
              // Apply theme + language
              themeManager.setTheme(state.prefs.darkMode);
              FlutterLocalization.instance.translate(state.prefs.languageCode);
              if (state.saved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      LocalData.preferencesSaved.getString(context),
                    ),
                    duration: const Duration(milliseconds: 1200),
                  ),
                );
              }
            },
            builder: (ctx, state) {
              final loading = state.loading || !_chatSaveLoaded;
              if (loading) {
                return const Center(child: CircularProgressIndicator());
              }
              final p = state.prefs;

              return SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(24, topPad + 8, 24, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_rounded),
                                  onPressed: () => Navigator.maybePop(context),
                                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              LocalData.preferencesTitle.getString(context),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.78,
                              child: Text(
                                LocalData.preferencesSubtitle.getString(context),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: isDark ? Colors.white : const Color(0xFF1F2A33),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            const SizedBox(height: 60),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF123A54).withOpacity(0.85)
                                    : Colors.white.withOpacity(0.92),
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDark ? 0.30 : 0.06),
                                    blurRadius: 14,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  _ListSectionWrapper(
                                    child: ThemeModeSelector(
                                      darkMode: p.darkMode,
                                      onChanged: (v) =>
                                          context.read<PreferencesCubit>().toggleDark(v),
                                    ),
                                  ),
                                  const _DividerRow(),
                                  _ListSectionWrapper(
                                    child: LanguageSelector(
                                      current: p.languageCode,
                                      onChanged: (code) =>
                                          context.read<PreferencesCubit>().setLanguage(code),
                                    ),
                                  ),
                                  const _DividerRow(),
                                  _ListSectionWrapper(
                                    child: SaveChatSwitch(
                                      value: _chatSaveEnabled,
                                      onChanged: _onSaveChatChanged,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        0,
                        24,
                        32,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: state.saving
                              ? null
                              : () async {
                                  await context.read<PreferencesCubit>().persist();
                                  if (!mounted) return;
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                          child: state.saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(LocalData.preferencesContinue.getString(context)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ListSectionWrapper extends StatelessWidget {
  final Widget child;
  const _ListSectionWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: child,
    );
  }
}

class _DividerRow extends StatelessWidget {
  const _DividerRow();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 0,
      thickness: 1,
      color: isDark ? Colors.white12 : Colors.grey.shade200,
    );
  }
}