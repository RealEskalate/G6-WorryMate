import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class CrisisCard extends StatelessWidget {
  const CrisisCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.red.shade50;
    final textColor = isDark ? Colors.white : const Color(0xFF22314A);
    final subTextColor = isDark ? Colors.white70 : Colors.black87;
    final sectionTitleColor = isDark
        ? Colors.red.shade200
        : Colors.red.shade700;
    final badgeBg = isDark ? Colors.red.shade700 : Colors.red;
    final badgeText = Colors.white;
    final dividerColor = isDark ? Colors.white24 : Colors.red.shade100;

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardBg,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: sectionTitleColor),
                      const SizedBox(width: 8),
                      Text(
                        "Crisis Support",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: sectionTitleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    icon: Icon(Icons.close, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 🟢 Immediate Help Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Immediate Help Available",
                  style: TextStyle(
                    color: badgeText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🟡 Immediate Steps Section
              Text(
                "Immediate Steps:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: sectionTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildStep(
                context,
                1,
                "If you're in immediate danger, call 911 or go to the nearest emergency room",
              ),
              _buildStep(
                context,
                2,
                "Reach out to a trusted friend, family member, or mental health professional",
              ),
              _buildStep(
                context,
                3,
                "Remove any means of self-harm from your immediate environment",
              ),
              _buildStep(
                context,
                4,
                "Stay with someone you trust until you feel safer",
              ),

              Divider(height: 32, color: dividerColor),

              // 📞 Emergency Contacts Section
              Text(
                "Emergency Contacts:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: sectionTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildContactCard(
                title: "Ethiopian Emergency Line",
                subtitle: "National emergency services",
                availability: "24/7",
                buttonText: "Call 991",
                onPressed: () {},
              ),
              _buildContactCard(
                title: "National Mental Health Hotilne",
                subtitle: "Local mental health crisis support",
                availability: "24/7",
                buttonText: "8335",
                onPressed: () => _makePhoneCall('8335'),
              ),
              _buildContactCard(
                title: "Ethiopia Red Cross Society",
                subtitle: "Emergency assistance and support",
                availability: "24/7",
                buttonText: "Call +251-11-515-4600",
                onPressed: () {},
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(16, 185, 129, 1),
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    "I'm safe now",
                    style: TextStyle(
                      color: Colors.black, // Black text as requested
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper for numbered steps
  Widget _buildStep(BuildContext context, int number, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stepTextColor = isDark ? Colors.white : const Color(0xFF22314A);
    final avatarBg = isDark ? Colors.red.shade700 : Colors.red.shade200;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: avatarBg,
            child: Text(
              "$number",
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
              style: GoogleFonts.poppins(
                color: stepTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper for contact cards
  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required String availability,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    availability,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.phone, color: Colors.white),
              label: Text(
                buttonText,
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel', // This tells the phone to use the dialer
    path: phoneNumber, // The number to call
  );

  // Check if the device can make phone calls
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri); // Open the phone app with the number
  } else {
    throw 'Could not launch $phoneNumber'; // Error handling
  }
}
