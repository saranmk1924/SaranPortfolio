import 'package:flutter/material.dart';
import 'package:saranportfolio/common/constants/color_constant.dart';
import 'package:saranportfolio/common/constants/fontsize_constant.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path; // Add this import at top
import 'package:permission_handler/permission_handler.dart';

class BlinkingCvLink extends StatefulWidget {
  final double? fontSize;
  final double? iconSize;
  const BlinkingCvLink({super.key, this.fontSize, this.iconSize});

  @override
  State<BlinkingCvLink> createState() => _BlinkingCvLinkState();
}

class _BlinkingCvLinkState extends State<BlinkingCvLink>
    with TickerProviderStateMixin {
  late AnimationController _breathController;
  late AnimationController _danceController;

  late Animation<double> _breathAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // 🌊 Breathing animation
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    // 💃 Dance animation (tap)
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_danceController);

    _rotationAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.05), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.0), weight: 25),
    ]).animate(_danceController);
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<bool> _savePDFToDownloads(Uint8List bytes) async {
    try {
      if (kIsWeb) {
      // Web: download using browser
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "Saran_Resume.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
        return true;
      } else if (Platform.isAndroid) {
        final granted = await _requestStoragePermission();
        if (!granted) {
          return false; // ❌ Permission denied
        }

        final downloadsDir = Directory('/storage/emulated/0/Download');

        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        final file = File('${downloadsDir.path}/Saran_Resume.pdf');
        await file.writeAsBytes(bytes, flush: true);
        return true;
      } else if (Platform.isWindows) {
        final user = Platform.environment['USERPROFILE'] ?? '';
        final dir = Directory(path.join(user, 'Downloads'));
        if (!await dir.exists()) await dir.create(recursive: true);
        final file = File(path.join(dir.path, 'Saran_Resume.pdf'));
        await file.writeAsBytes(bytes);
        return true;
      } else if (Platform.isLinux || Platform.isMacOS) {
        final home = Platform.environment['HOME'] ?? '';
        final dir = Directory(path.join(home, 'Downloads'));
        if (!await dir.exists()) await dir.create(recursive: true);
        final file = File(path.join(dir.path, 'Saran_Resume.pdf'));
        await file.writeAsBytes(bytes);
        return true;
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(path.join(dir.path, 'Saran_Resume.pdf'));
        await file.writeAsBytes(bytes);
        return true;
      }
    } catch (e) {
      print("Download error: $e");
      return false; // ❌ Any error
    }
  }

  void _downloadPDF(BuildContext context) async {
    const pdfAssetPath = 'assets/SaranMK_Resume_2.pdf';

    // Pre-download snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Downloading resume...",
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

    try {
      final bytes = await rootBundle.load(pdfAssetPath);
      final success = await _savePDFToDownloads(bytes.buffer.asUint8List());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? "Resume Downloaded Successfully!"
                : "Download Failed - Permission Denied",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: success ? ColorConstant.darkYellow : Colors.red,
              fontSize: PageLabel.small,
            ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black87,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Something went wrong!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: PageLabel.small),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _danceController.dispose();
    super.dispose();
  }

  void _startDance() {
    _danceController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            _startDance(); // 💃 trigger dance
            _downloadPDF(context);
          },
          child: AnimatedBuilder(
            animation: Listenable.merge([_breathAnimation, _danceController]),
            builder: (context, child) {
              final glow = _breathAnimation.value;

              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4 * glow),
                          blurRadius: 8 + (10 * glow),
                          spreadRadius: 1 + (3 * glow),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.link,
                          color: Colors.black,
                          size: widget.iconSize ?? 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Download CV",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.fontSize ?? PageLabel.small,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
