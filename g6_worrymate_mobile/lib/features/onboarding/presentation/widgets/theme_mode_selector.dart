import 'package:flutter/material.dart';

class ThemeModeSelector extends StatelessWidget {
  final bool darkMode;
  final void Function(bool dark) onChanged;
  const ThemeModeSelector({super.key, required this.darkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('Theme', style: Theme.of(context).textTheme.titleMedium)),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, icon: Icon(Icons.wb_sunny_outlined), label: Text('Light')),
            ButtonSegment(value: true, icon: Icon(Icons.nights_stay_outlined), label: Text('Dark')),
          ],
          selected: {darkMode},
          onSelectionChanged: (s) => onChanged(s.first),
        ),
      ],
    );
  }
}