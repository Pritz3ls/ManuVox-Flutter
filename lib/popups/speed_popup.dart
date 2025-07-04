import 'package:flutter/material.dart';
import '../widgets/custom_icon.dart';

class SpeedPopup extends StatelessWidget {
  const SpeedPopup({super.key});
  // Dark rounded container
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900], 
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title text
            const Text(
              "How fast do you sign?",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16), 

            //  Row of options with manual spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SpeedOption(label: "Slow", icon: Icons.fast_rewind),
                SizedBox(width: 10),
                SpeedOption(label: "Average", icon: Icons.play_circle),
                SizedBox(width: 10), 
                SpeedOption(label: "Fast", icon: Icons.bolt),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SpeedOption extends StatelessWidget {
  final String label;
  final IconData icon;

  const SpeedOption({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //White-bordered box
        Container(
          height: 90,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
            color: Colors.transparent,
          ),
          child: Icon(icon, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 8),

        //Label under the box
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}
