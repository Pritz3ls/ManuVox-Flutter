import 'package:flutter/material.dart';
import 'dart:ui';
import 'reference_screen.dart';

import '../widgets/custom_icon.dart';
import '../popups/speed_popup.dart';
import '../popups/settings_popup.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  void showPopup(BuildContext context, Widget child) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Popup',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                child,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Background-Demo-Image.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [    
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 48,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => showPopup(context, const SettingsPopup()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap
                            ),
                            child: CustomIcon(icon: Icons.menu, iconSize: 32),
                          ),
                        ),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => ReferenceScreen())
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.lightBlue,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap
                            ),
                            child: CustomIcon(icon: Icons.menu_book_outlined, iconSize: 32),
                          ),
                        ),
                      // CustomIcon(icon: Icons.menu, iconSize: 32),
                      // CustomIcon(icon: Icons.menu_book_outlined, iconSize: 32),
                    ],
                  ),
                ),
                const Spacer(),        
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Magandang Umaga!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Ako si JOE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => showPopup(context, const SpeedPopup()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap
                            ),
                            child: CustomIcon(icon: Icons.tune, iconSize: 32),
                          ),
                        ),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushReplacement(context,
                              //   MaterialPageRoute(builder: (context) => ViewGesturesPage())
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap
                            ),
                            child: CustomIcon(icon: Icons.camera_alt_outlined, iconSize: 32),
                          ),
                        ),
                        // CustomIcon(icon: Icons.tune, color: Colors.blue, iconSize:32),
                        // CustomIcon(icon: Icons.camera_alt_outlined, color: Colors.blue, iconSize:32),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
