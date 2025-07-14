import 'package:flutter/material.dart';
import 'permission_screen.dart';
import 'splash_screen.dart';
import '../widgets/custom_icon.dart';
import 'dart:async'; // Import for using Timer

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0; // Tracks the current page index for the carousel
  Timer? _autoPlayTimer; // Timer for auto-play functionality

  // Configuration for auto-play speed and transition duration
  final Duration _autoPlayInterval = const Duration(seconds: 4); // Time each page stays visible
  final Duration _transitionDuration = const Duration(milliseconds: 800); // Speed of the transition animation
  final Curve _transitionCurve = Curves.easeOutCubic; // Animation curve

  // Data model for each onboarding item
  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: "Welcome to ManuVox",
      subtitle: "ManuVox is an app that helps you learn and understand Filipino sign language.",
      imageUrl: 'assets/images/Hand.png', // Placeholder image 1
    ),
    OnboardingItem(
      title: "Learn FSL Basics",
      subtitle: "Dive into interactive lessons designed for beginners and advanced learners.",
      imageUrl: 'assets/images/Hand.png', // Placeholder image 2
    ),
    OnboardingItem(
      title: "Practice & Connect",
      subtitle: "Improve your skills with practice exercises and connect with the community.",
      imageUrl: 'assets/images/Hand.png', // Placeholder image 3
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Start the auto-play timer when the widget is initialized
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (timer) {
      if (_pageController.hasClients) { // Check if controller is attached to a PageView
        int nextPage = _currentPage + 1;
        if (nextPage >= onboardingItems.length) {
          // If at the last page, jump to the first page instantly
          _pageController.jumpToPage(0);
          setState(() {
            _currentPage = 0;
          });
        } else {
          // Animate to the next page
          _pageController.animateToPage(
            nextPage,
            duration: _transitionDuration,
            curve: _transitionCurve,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose the page controller
    _autoPlayTimer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Header Section: Title and Subtitle
            // Using an AnimatedSwitcher for smooth text transitions
            AnimatedSwitcher(
              duration: _transitionDuration,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Column(
                key: ValueKey<int>(_currentPage), // Key for AnimatedSwitcher to identify content changes
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80), // Top spacing
                  Text(
                    onboardingItems[_currentPage].title, // Dynamic title based on current page
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    onboardingItems[_currentPage].subtitle, // Dynamic subtitle based on current page
                    style: const TextStyle(
                      fontSize: 16, // Increased font size as per request
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Spacer to push image and footer to center/bottom
            const Spacer(),

            // Centered Image Section
            Expanded(
              flex: 2, // Gives more space to the image area
              child: Center(
                // Using an AnimatedSwitcher for smooth image transitions
                child: AnimatedSwitcher(
                  duration: _transitionDuration,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child); // Example transition
                  },
                  child: Image.asset(
                    key: ValueKey<int>(_currentPage), // Key for AnimatedSwitcher
                    onboardingItems[_currentPage].imageUrl, // Dynamic image based on current page
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.7, // Responsive width
                    height: MediaQuery.of(context).size.height * 0.4, // Responsive height
                    // Optional: Add error handling for image loading
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // Spacer before the footer (dots and button)
            const Spacer(),

            // Footer Section: Carousel Dots and Continue Button
            Column(
              children: [
                // PageView for the carousel content (hidden, only used for tracking page changes)
                SizedBox(
                  height: 1.0, // Minimal height as content is shown in header/image area
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingItems.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page; // Update the current page index
                      });
                      // Optionally reset timer on manual scroll
                      // _autoPlayTimer?.cancel();
                      // _startAutoPlay();
                    },
                    itemBuilder: (context, index) {
                      // We are not displaying content here, only using PageView for page changes
                      return Container();
                    },
                  ),
                ),
                // Carousel Dots Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingItems.length,
                    (index) => buildDot(index, context), // Helper to build each dot
                  ),
                ),
                const SizedBox(height: 32), // Spacing between dots and button

                // "Continue" button
                SizedBox(
                  width: double.infinity, // Full width button
                  height: 50, // Fixed height
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for the Continue button
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PermissionScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White background
                      foregroundColor: Colors.black, // Black text
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // 15px rounded corners
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
            const SizedBox(height: 24), // Bottom spacing
          ],
        ),
      ),
    );
  }

  // Helper method to build each dot for the carousel indicator
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200), // Animation duration for dot change
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: _currentPage == index ? 24 : 10, // Wider for active dot
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white54, // White for active, greyish for inactive
        borderRadius: BorderRadius.circular(5),
      ),
      // Optional: Add GestureDetector to make dots tappable for navigation
      // child: GestureDetector(
      //   onTap: () {
      //     _pageController.animateToPage(
      //       index,
      //       duration: const Duration(milliseconds: 300),
      //       curve: Curves.easeIn,
      //     );
      //   },
      // ),
    );
  }
}

// Data class for an individual onboarding item
class OnboardingItem {
  final String title;
  final String subtitle;
  final String imageUrl;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}
