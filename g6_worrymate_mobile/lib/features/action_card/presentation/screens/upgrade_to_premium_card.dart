import 'package:flutter/material.dart';

class UpgradeToPremiumCard extends StatelessWidget {
  const UpgradeToPremiumCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Use your app's theme colors
    final cardColor = colorScheme.surfaceVariant;
    final borderColor = colorScheme.primary.withOpacity(0.3);
    final iconColor = colorScheme.secondary;
    final warningColor = colorScheme.error;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final subtitleColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.black54;
    final tipColor =
        theme.textTheme.bodySmall?.color?.withOpacity(0.7) ?? Colors.black54;

    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: warningColor,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Rate Limit Reached",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: warningColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.access_time, color: warningColor, size: 18),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "You've reached your usage limit for today. Please try again later or upgrade to premium for unlimited access.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subtitleColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor.withOpacity(0.5)),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium, color: iconColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upgrade to Premium",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Get unlimited access to all features and priority support",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: subtitleColor,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Upgrade feature coming soon!"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: colorScheme.primary,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text("Upgrade Now"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: iconColor, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Tip: Try again in a few minutes or contact support if you need immediate assistance",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: tipColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
