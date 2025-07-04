import 'package:flutter/material.dart';
// Import the OnboardingScreen as it's the next destination
import 'onboarding_screen.dart';
// import '../objects/local_database.dart';

// The SplashScreen widget, now in its own file
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // LocalDatabase localDatabase = LocalDatabase();
    // localDatabase.InitializeDatabase();
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            const Text(
              'ManuVox',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A Filipino Sign Language App.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'By clicking Continue you agree to our '),
                      TextSpan(
                        text: '\nPrivacy Policy',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the OnboardingScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                      );
                      // print('Continue button pressed from splash screen, navigating to OnboardingScreen!');
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
                      'Continue',
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
