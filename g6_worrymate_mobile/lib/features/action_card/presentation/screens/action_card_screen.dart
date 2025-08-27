import 'package:flutter/material.dart';

import 'offline_toolkit_screen.dart';

class ActionCardScreen extends StatefulWidget {
  const ActionCardScreen({super.key});

  @override
  State<ActionCardScreen> createState() => _ActionCardScreenState();
}

class _ActionCardScreenState extends State<ActionCardScreen> {
  // It's easier to use a List of Strings for steps
  List<String> steps = [
    "Take a deep breath",
    "Try a 25-minute focused study session (Pomodoro technique)",
    "Block social media apps during study time",
    "Write down your top 3 priorities for tomorrow",
    "Write down your top 3 priorities for tomorrow",
    "Write down your top 3 priorities for tomorrow",
  ];

  Widget _buildStepItem({required int index, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF2ECC71),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            index.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 39, 40, 48),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTool({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF2ECC71)),
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFEFFAF3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF2ECC71), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2ECC71),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE7E7EA)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'Exam Stress Relief',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 39, 40, 48),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2ECC71),
                          side: const BorderSide(color: Color(0xFF2ECC71)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Action Plan"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Let's break this down into manageable steps.",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "You can try now:",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 39, 40, 48),
                    ),
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildStepItem(
                            index: index + 1,
                            text: steps[index],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    "Quick tools:",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 39, 40, 48),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _buildQuickTool(
                        icon: Icons.favorite_border,
                        label: "Breathing Exercise",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OfflineToolkitScreen(),
                            ),
                          );
                        },
                      ),
                      _buildQuickTool(
                        icon: Icons.camera,
                        label: "5-4-3-2-1 Grounding",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OfflineToolkitScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7E6),
                      border: Border.all(color: const Color(0xFFFFE0A6)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFF6A800),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "If it gets worse: If panic sets in, try the grounding exercise or reach out to a trusted friend.",
                            style: TextStyle(color: Color(0xFF6B5E3C)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F2F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "This is general wellbeing information, not medical or mental health advice.",
                      style: TextStyle(color: Colors.black54),
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
