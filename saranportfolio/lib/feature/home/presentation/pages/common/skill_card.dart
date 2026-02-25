import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:saranportfolio/common/constants/fontsize_constant.dart';

class SkillCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const SkillCard({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect, // Rounded rectangle
      radius: const Radius.circular(12),
      dashPattern: const [6, 3], // 6 pixels line, 3 pixels gap
      color: Colors.amber,
      strokeWidth: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.transparent,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.amber, size: 28),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: PageSubHeading.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
