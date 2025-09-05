import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import '../../../../core/localization/locales.dart';
import '../cubit/reminder_cubit.dart';
import '../cubit/reminder_state.dart';

/// Helper to open the reminder UI as a modal bottom sheet.
Future<void> showReminderSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor:
        isDark ? const Color(0xFF0B2F4E) : Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => const ReminderPage(),
  );
}

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color cardColor = isDark ? Colors.white10 : scheme.surface;
    Color borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BlocBuilder<ReminderCubit, ReminderState>(
        builder: (context, state) {
          final cubit = context.read<ReminderCubit>();
          final enabled = state.isEnabled;
          final time = state.selectedTime;

            return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                // Header row with close
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        LocalData.reminderTitle.getString(context),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                      color: scheme.onSurface.withOpacity(0.7),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  LocalData.reminderDescription.getString(context),
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.3,
                    color: scheme.onSurface.withOpacity(0.70),
                  ),
                ),
                const SizedBox(height: 20),

                // Enable switch
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          LocalData.reminderEnableLabel.getString(context),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      Switch(
                        value: enabled,
                        onChanged: (v) async {
                          if (v) {
                            // Pick time first (use current time as fallback)
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );
                            if (picked != null) {
                              cubit.updateReminderTime(picked);
                              cubit.enableReminder(picked);
                            }
                          } else {
                            cubit.disableReminder();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Time selection card
                AnimatedOpacity(
                  opacity: enabled ? 1.0 : 0.45,
                  duration: const Duration(milliseconds: 250),
                  child: IgnorePointer(
                    ignoring: !enabled,
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: Icon(Icons.alarm,
                            color: isDark
                                ? Colors.greenAccent
                                : const Color.fromARGB(255, 9, 43, 71)),
                        title: Text(
                          LocalData.reminderTimeLabel.getString(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: scheme.onSurface.withOpacity(0.75),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            time.format(context),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        trailing: TextButton.icon(
                          icon: const Icon(Icons.schedule_rounded, size: 18),
                          label: Text(LocalData.reminderPickTime.getString(context)),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );
                            if (picked != null) {
                              cubit.updateReminderTime(picked);
                              if (enabled) {
                                cubit.enableReminder(picked);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Close button (optional quick action)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      LocalData.reminderCancel.getString(context),
                      style: TextStyle(
                        color: isDark
                            ? Colors.greenAccent
                            : const Color.fromARGB(255, 9, 43, 71),
                      ),
                    ),
                  ),
                ),
                MediaQuery.of(context).viewPadding.bottom > 0
                    ? const SizedBox(height: 8)
                    : const SizedBox(height: 4),
              ],
            ),
          );
        },
      ),
    );
  }
}