import 'package:flutter/material.dart';
import 'dart:ui';
import '../popups/result_popup.dart';

class GestureResultItem extends StatelessWidget {
  final String name;
  final String category;

  const GestureResultItem({
    super.key,
    required this.name,
    required this.category
  });

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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          "$name - $category",
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          // Handle tap if needed
          showPopup(context, ResultPopup(name: name, category: category));
        },
      ),
    );
  }
}
