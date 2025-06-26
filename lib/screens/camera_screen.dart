import 'package:flutter/material.dart';
import '../widgets/custom_icon.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Positioned.fill(
            child: Image.asset(
              'assets/Background-Demo-Image.png',
              fit: BoxFit.cover,
            ),
          ),

        
          SafeArea(
            child: Column(
              children: [
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(icon: Icons.menu, iconSize: 30),
                      CustomIcon(icon: Icons.menu_book_outlined, iconSize: 30),
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
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIcon(icon: Icons.tune, color: Colors.blue, iconSize:30),
                      CustomIcon(icon: Icons.camera_alt_outlined, color: Colors.blue, iconSize:30),
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
