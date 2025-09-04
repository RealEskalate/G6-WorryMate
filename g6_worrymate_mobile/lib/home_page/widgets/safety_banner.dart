import 'package:flutter/material.dart';

class SafetyBanner extends StatelessWidget {
  final bool isDarkMode;
  final double deviceHeight;
  final double deviceWidth;
  final ImageProvider image;
  final String text;
  final VoidCallback? onTap;
  const SafetyBanner({super.key, required this.isDarkMode, required this.deviceHeight, required this.deviceWidth, required this.image, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.12,
      width: deviceWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(isDarkMode ? 0.55 : 0.35),
            BlendMode.darken,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
            child: Icon(
              Icons.shield_rounded,
              color: isDarkMode
                  ? Colors.greenAccent
                  : const Color.fromARGB(255, 9, 43, 71),
              size: 42,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: deviceHeight * 0.02,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              maxLines: 2,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
            onPressed: onTap,
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
