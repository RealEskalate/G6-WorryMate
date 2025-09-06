import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/notification_service.dart';
import 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final NotificationService _notificationService;

  ReminderCubit(this._notificationService) : super(ReminderState.initial());

  void enableReminder(TimeOfDay time) {
    // A list of sample activities
    List<String> activities = [
      'journal',
      'Practice a 5-minute breathing exercise',
      'Track your mood',
      'Write a gratitude note',
      'Reframe a negative thought',
      'Check your progress dashboard',
      'Do a quick mindfulness check-in'
    ];
    // Select a random activity for the notification body
    final String randomActivity = (activities..shuffle()).first;

    _notificationService.scheduleDailyReminder(
      id: 0, // Use a static ID for the daily reminder
      title: 'Your Daily Reminder! 🚀',
      body: "Don't forget to: $randomActivity",
      hour: time.hour,
      minute: time.minute,
    );
    emit(state.copyWith(isEnabled: true, selectedTime: time));
  }

  void disableReminder() {
    _notificationService.cancelNotification(0); // Cancel the reminder with ID 0
    emit(state.copyWith(isEnabled: false));
  }

  void updateReminderTime(TimeOfDay newTime) {
    if (state.isEnabled) {
      // If reminders are already on, just reschedule with the new time
      enableReminder(newTime);
    } else {
      // If they are off, just update the time in the state
      emit(state.copyWith(selectedTime: newTime));
    }
  }
}