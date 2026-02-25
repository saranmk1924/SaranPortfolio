import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saranportfolio/common/constants/color_constant.dart';
import 'package:saranportfolio/common/constants/fontsize_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url; // Can be phone/email link or web link

  const ContactIcon({
    required this.icon,
    required this.label,
    required this.url,
    super.key,
  });

  Future<void> _handleTap(BuildContext context) async {
    if (url.startsWith("http")) {
      // GitHub / LinkedIn -> open browser
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint("Could not launch $url");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not open $url"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else if (RegExp(r'^\d+$').hasMatch(url)) {
      // Phone -> copy
      await Clipboard.setData(ClipboardData(text: url));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Phone number copied",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.darkYellow,
              fontSize: PageLabel.small,
            ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black87,
        ),
      );
    } else if (url.contains("@")) {
      // Email -> copy
      await Clipboard.setData(ClipboardData(text: url));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Mail-id copied",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorConstant.darkYellow,
              fontSize: PageLabel.small,
            ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _handleTap(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.black, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
