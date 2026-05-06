import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../core/localization/locales.dart';

class AiPromptSection extends StatelessWidget {
  final bool isDarkMode;
  final double deviceHeight;
  final TextEditingController controller;
  final List<String> quickPrompts; // already localized strings
  final VoidCallback onSubmit;
  const AiPromptSection({super.key, required this.isDarkMode, required this.deviceHeight, required this.controller, required this.quickPrompts, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalData.homeAskSupportTitle.getString(context),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: deviceHeight * 0.022,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickPrompts.map((p) {
            final selected = controller.text.trim() == p;
            return GestureDetector(
              onTap: () => controller.text = p,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? (isDarkMode
                          ? Colors.greenAccent.withOpacity(0.25)
                          : const Color.fromARGB(255, 9, 43, 71))
                      : (isDarkMode ? Colors.white12 : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  p,
                  style: TextStyle(
                    color: selected
                        ? (isDarkMode
                            ? Colors.greenAccent
                            : const Color.fromARGB(255, 9, 43, 71))
                        : (isDarkMode ? Colors.white70 : Colors.black54),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.grey[100],
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: LocalData.homePromptHint.getString(context),
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.grey[600]),
                    border: InputBorder.none,
                  ),
                  minLines: 1,
                  maxLines: 3,
                  onSubmitted: (_) => onSubmit(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send,
                    color: isDarkMode
                        ? Colors.greenAccent
                        : const Color.fromARGB(255, 9, 43, 71)),
                onPressed: onSubmit,
                tooltip: 'Send',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
