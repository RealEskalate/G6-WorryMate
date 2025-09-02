import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/action_card_entity.dart';

class ActionCardWidget extends StatelessWidget {
  final ActionCardEntity actionCard;

  const ActionCardWidget({Key? key, required this.actionCard})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF092B47) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF092B47);
    final subTextColor = isDark ? Colors.white70 : Colors.black87;
    final stepNumColor = isDark ? Colors.greenAccent : Colors.green.shade700;
    final sectionTitleColor = isDark ? Colors.white : const Color(0xFF092B47);
    final toolTileColor = isDark
        ? const Color(0xFF0E3A5B)
        : Colors.grey.shade100;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              actionCard.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              actionCard.description,
              style: TextStyle(color: subTextColor, fontSize: 15),
            ),

            // Micro Steps as numbered steps
            if (actionCard.steps.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Panic Steps:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: sectionTitleColor,
                      ),
                    ),
                    ...List.generate(
                      actionCard.steps.length,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${i + 1}. ',
                              style: TextStyle(
                                color: stepNumColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                actionCard.steps[i],
                                style: TextStyle(color: subTextColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // If Worse
            if (actionCard.ifWorse.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "If Worse:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: sectionTitleColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Text(
                        '• ${actionCard.ifWorse}',
                        style: TextStyle(color: subTextColor),
                      ),
                    ),
                  ],
                ),
              ),

            // Disclaimer
            if (actionCard.disclaimer.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  'Disclaimer: ${actionCard.disclaimer}',
                  style: TextStyle(
                    color: Colors.amber.shade700,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                  ),
                ),
              ),
            // Tools
            if (actionCard.miniTools.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    "Tools:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sectionTitleColor,
                    ),
                  ),
                  ...actionCard.miniTools.map(
                    (tool) => ListTile(
                      title: Text(
                        tool.title,
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Text(
                        tool.url,
                        style: TextStyle(
                          color: subTextColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      tileColor: toolTileColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () async {
                        final url = Uri.parse(tool.url);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch URL')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            // Buttons below the card content
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // greenish
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/offlinetoolkit');
                  },
                  child: const Text('Win Tracker'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // greenish
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/offlinetoolkit');
                  },
                  child: const Text('Journaling'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
