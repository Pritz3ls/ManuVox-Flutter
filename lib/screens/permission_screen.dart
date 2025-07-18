import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'finalization_screen.dart';
import '../widgets/custom_icon.dart';
import 'package:permission_handler/permission_handler.dart';
// Import the OnboardingScreen as it's the next destination

// The SplashScreen widget, now in its own file
class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});
  
  Future<bool> isCameraAccessGranted() async{
    final status = await Permission.camera.isGranted;
    return status;
  }

  @override
  Widget build(BuildContext context) {
    Permission.camera.request();
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: 48,
              height: 48,
              child: ElevatedButton(
                onPressed: (){
                  // On pressed go back, but how?
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const OnboardingScreen())
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap
                ),
                child: CustomIcon(icon: Icons.chevron_left, iconSize: 32),
              ),
            ),
            const SizedBox(height: 80),
            const Text(
              'Allow Camera Access',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'In order for our deliver the best experience in recognizing sign language we need access to your camera.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/images/Hand.png',
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.4, // Responsive width
                  height: MediaQuery.of(context).size.height * 0.2, // Responsive height
                  errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '(Please note that we only use the device camera for recognition only!)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Navigate to the Finalization Screen
                      // print('Continue button pressed from splash screen, navigating to OnboardingScreen!');
                      if(await isCameraAccessGranted()){
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const FinalizationScreen())
                        );
                      }else{
                        Permission.camera.request();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Allow Access',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
