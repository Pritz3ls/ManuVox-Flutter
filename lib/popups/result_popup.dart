import 'package:flutter/material.dart';

class ResultPopup extends StatelessWidget {
  final String name;
  final String category;

  const ResultPopup({
    super.key, 
    required this.name, 
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    //black border
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Container(
          width: screenWidth * 0.75, 
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Line button at the top 
              Container(
                width: 40,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),

              // White panel
              Container(
                width: screenWidth * 0.6, 
                height: screenHeight * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

                const SizedBox(height: 10), 
              //Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name, 
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        SizedBox(height: 4),

                        Text(
                          category, 
                          style: TextStyle(color: Colors.grey)
                        ),
                      ],
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
