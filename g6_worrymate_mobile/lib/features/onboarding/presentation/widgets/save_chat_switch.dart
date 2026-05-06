import 'package:flutter/material.dart';

class SaveChatSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  const SaveChatSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Save chat history',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}