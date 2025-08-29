import 'package:flutter/material.dart';
import 'package:g6_worrymate_mobile/core/widgets/custom_bottom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color.fromARGB(255, 9, 43, 71),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 9, 43, 71),
        elevation: 0,
        leading: const Icon(Icons.settings_outlined, color: Colors.greenAccent),

        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // 🔹 Language Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Language",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text("English"),
                      selectedColor: Colors.greenAccent,
                      backgroundColor: Colors.white12,
                      labelStyle: const TextStyle(color: Colors.black),
                      selected: true,
                      onSelected: (_) {},
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("አማርኛ"),
                      selectedColor: Colors.greenAccent,
                      backgroundColor: Colors.white12,
                      labelStyle: const TextStyle(color: Colors.black),
                      selected: false,
                      onSelected: (_) {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Font Size",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.greenAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          if (fontSize > 12) fontSize -= 2;
                        });
                      },
                    ),
                    Text(
                      "A",
                      style: GoogleFonts.poppins(
                        fontSize: fontSize,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.greenAccent,
                      ),
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

          const SizedBox(height: 16),

          // 🔹 About WorryMate
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About WorryMate",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "WorryMate is your AI-powered worry buddy designed specifically for Africa. "
                  "We provide supportive conversation and practical suggestions for everyday stressors.",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text(
                    "Version 1.0 Demo",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Privacy & Security
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Privacy & Safety",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(
                    "Save chat",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  value: saveChat,
                  activeColor: Colors.greenAccent,
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
                  child: const Text(
                    "Delete chat history",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),
                Text(
                  "• Your conversations are stored locally only",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "• No personal data is sent to servers",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "• Crisis detection prioritizes your safety",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                Text(
                  "• This is not medical or professional advice",
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Back button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.greenAccent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
            child: Text(
              "Back to Chat",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (i) {
          if (i == 4) return;
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/journal');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/offlinetoolkit');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 4:
              // Already on settings
              break;
          }
        },
      ),
    );
  }
}
