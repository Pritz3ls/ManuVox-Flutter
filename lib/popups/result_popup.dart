import 'package:flutter/material.dart';

class ResultPopup extends StatelessWidget {
  const ResultPopup({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

                const SizedBox(height: 10), 
              //Text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Result Text", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text("Facial Features", style: TextStyle(color: Colors.grey)),
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
