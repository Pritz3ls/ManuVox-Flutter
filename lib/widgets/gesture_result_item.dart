import 'package:flutter/material.dart';

class GestureResultItem extends StatelessWidget {
  final String text;

  const GestureResultItem({required this.text});

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
          text,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () {
          // Handle tap if needed
        },
      ),
    );
  }
}
