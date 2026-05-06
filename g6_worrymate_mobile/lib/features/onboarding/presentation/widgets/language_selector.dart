import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String current;
  final void Function(String code) onChanged;
  const LanguageSelector({super.key, required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('Language', style: Theme.of(context).textTheme.titleMedium)),
        DropdownButton<String>(
          value: current,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'am', child: Text('Amharic')),
            ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}