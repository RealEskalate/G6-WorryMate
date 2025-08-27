import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool saveChat = false;
  double fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),

        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Language Section
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Language", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("English"),
                        selectedColor: Color.fromARGB(255, 9, 43, 71),
                        selected: true,
                        onSelected: (_) {
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("አማርኛ"),
                        selectedColor: Color.fromARGB(255, 9, 43, 71),

                        selected: false,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("Font Size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            if (fontSize > 12) fontSize -= 2;
                          });
                        },
                      ),
                      Text("A", style: TextStyle(fontSize: fontSize)),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () {
                          setState(() {
                            if (fontSize < 30) fontSize += 2;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 About WorryMate
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("About WorryMate", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "WorryMate is your AI-powered worry buddy designed specifically for Africa. "
                        "We provide supportive conversation and practical suggestions for everyday stressors.",
                  ),
                  SizedBox(height: 12),
                  Chip(label: Text("Version 1.0 Demo")),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Privacy & Security
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Privacy & Safety", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text("Save chat"),
                    value: saveChat,
                    activeColor: Color.fromARGB(255, 9, 43, 71),

                    onChanged: (val) {
                      setState(() {
                        saveChat = val;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Implement delete history logic
                    },
                    child: const Text("Delete chat history", style: TextStyle(color: Colors.red)),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text("• Your conversations are stored locally only"),
                  const Text("• No personal data is sent to servers"),
                  const Text("• Crisis detection prioritizes your safety"),
                  const Text("• This is not medical or professional advice"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Back button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back to Chat"),
          ),
        ],
      ),
    );
  }
}
