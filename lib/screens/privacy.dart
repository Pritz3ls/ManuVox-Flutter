import 'package:flutter/material.dart';
import 'splash_screen.dart';
import '../widgets/custom_icon.dart';
// import 'dart:async'; // Import for using Timer

class PrivacyPolicy extends StatelessWidget{
  const PrivacyPolicy({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            SizedBox(
              width: 48,
              height: 48,
              child: ElevatedButton(
                onPressed: (){
                  // On pressed go back, but how?
                  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SplashScreen())
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
            const SizedBox(height: 10),
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            // const Spacer(),
            new Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,//.horizontal
                child: new Text(
                  """
This privacy policy applies to the ManuVox app (hereby referred to as the "Application") for mobile devices, created by Pritzels (hereby referred to as the "Service Provider") as a free service. This Application is provided "AS IS" and is intended for use as such.

Information Collection and Use
The Application does not collect or store any personally identifiable data from users. No user accounts, names, emails, or contact details are collected or stored.
The Application uses the camera only for gesture recognition purposes. The camera functionality is strictly limited to real-time processing for recognizing sign language gestures and is not used for surveillance or data collection.
No camera recordings or images are stored or transmitted unless the user explicitly saves them through the app interface.

Downloaded Content
All downloadable content used within the Application (such as gesture libraries or learning materials) originates from official and verified sources. The Application does not distribute third-party content without appropriate permissions or verification.

Third-Party Services
The Application does not use analytics services, ad networks, or tracking technologies. No data is sent to third parties for advertising or behavioral profiling.
If third-party components (such as gesture recognition libraries or rendering engines) are used, they do not collect or transmit any personal or usage data.

Children’s Privacy
The Application does not knowingly collect any personal data from children under the age of 13. As no personal information is collected from any user, the Application is compliant with privacy regulations for children by design.

Security
While the Application does not collect user data, the Service Provider takes the security of device-level interactions seriously. The app uses only necessary permissions (such as camera access) to function and does not exploit any device data beyond its intended purpose.

Changes to This Privacy Policy
This Privacy Policy may be updated from time to time. Changes will be posted within the Application or on the designated official page. Users are encouraged to review this policy periodically. Continued use of the Application after changes indicates acceptance.
This Privacy Policy is effective as of 2025-06-20.

Your Consent
By using the Application, you agree to the terms outlined in this Privacy Policy, including the limited use of device camera for gesture recognition and the absence of personal data collection.

Contact Us
If you have any questions or concerns regarding privacy while using the Application, please contact the Service Provider via email at manuvox.app@gmail.com.
""",
                  style: TextStyle(
                    fontSize: 16.0, color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}