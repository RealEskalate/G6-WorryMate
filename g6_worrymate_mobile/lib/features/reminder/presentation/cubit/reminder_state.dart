import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ReminderState extends Equatable {
  final bool isEnabled;
  final TimeOfDay selectedTime;

  const ReminderState({required this.isEnabled, required this.selectedTime});

  factory ReminderState.initial() {
    return const ReminderState(
        isEnabled: false, selectedTime: TimeOfDay(hour: 8, minute: 0));
  }

  ReminderState copyWith({
    bool? isEnabled,
    TimeOfDay? selectedTime,
  }) {
    return ReminderState(
      isEnabled: isEnabled ?? this.isEnabled,
      selectedTime: selectedTime ?? this.selectedTime,
    );
  }

  @override
  List<Object> get props => [isEnabled, selectedTime];
}