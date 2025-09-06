import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../core/localization/locales.dart';

class MoodCheckInCard extends StatelessWidget {
  final bool isDarkMode;
  final double deviceHeight;
  final void Function(String label) onMoodSelected;
  const MoodCheckInCard({
    super.key,
    required this.isDarkMode,
    required this.deviceHeight,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final moods = [
      ('😞', LocalData.homeMoodLow.getString(context)),
      ('😐', LocalData.homeMoodMeh.getString(context)),
      ('🙂', LocalData.homeMoodOkay.getString(context)),
      ('😄', LocalData.homeMoodGood.getString(context)),
      ('🤩', LocalData.homeMoodGreat.getString(context)),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalData.homeMoodCheckInTitle.getString(context),
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: deviceHeight * 0.02,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods
                .map(
                  (m) => Expanded(
                    child: _MoodEmojiButton(
                      emoji: m.$1,
                      label: m.$2,
                      isDark: isDarkMode,
                      onSelected: onMoodSelected,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _MoodEmojiButton extends StatefulWidget {
  final String emoji;
  final String label;
  final bool isDark;
  final void Function(String label) onSelected;

  const _MoodEmojiButton({
    required this.emoji,
    required this.label,
    required this.isDark,
    required this.onSelected,
  });

  @override
  State<_MoodEmojiButton> createState() => _MoodEmojiButtonState();
}

class _MoodEmojiButtonState extends State<_MoodEmojiButton> {
  bool _pressed = false;
  bool _recentlySelected = false;

  void _triggerSelection() {
    widget.onSelected(widget.label);
    setState(() => _recentlySelected = true);
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) setState(() => _recentlySelected = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark ? Colors.white70 : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        scale: _pressed ? 0.82 : 1.0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            splashColor: (widget.isDark
                    ? const Color(0xFF60C2A8)
                    : const Color(0xFF0A4A73))
                .withOpacity(0.15),
            highlightColor: (widget.isDark
                    ? const Color(0xFF60C2A8)
                    : const Color(0xFF0A4A73))
                .withOpacity(0.08),
            onHighlightChanged: (h) {
              if (h != _pressed) setState(() => _pressed = h);
            },
            onTap: _triggerSelection,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOut,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _recentlySelected
                          ? (widget.isDark
                                  ? const Color(0xFF1C3F55)
                                  : const Color(0xFF0A4A73))
                              .withOpacity(0.12)
                          : Colors.transparent,
                      boxShadow: _recentlySelected
                          ? [
                              BoxShadow(
                                color: (widget.isDark
                                        ? const Color(0xFF9FE8C9)
                                        : const Color(0xFF0A4A73))
                                    .withOpacity(0.35),
                                blurRadius: 16,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                      border: _recentlySelected
                          ? Border.all(
                              width: 1.1,
                              color: (widget.isDark
                                      ? const Color(0xFF9FE8C9)
                                      : const Color(0xFF0A4A73))
                                  .withOpacity(0.6),
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: baseColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}