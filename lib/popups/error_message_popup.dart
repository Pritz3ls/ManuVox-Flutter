import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String title;
  final String message;
  final String buttonMessage;
  final VoidCallback subEvent;

  const ErrorMessage({
    super.key,
    required this.title,
    required this.message,
    required this.buttonMessage,
    required this.subEvent
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
        ),
        backgroundColor: Colors.grey[800], 
        child: Padding(
          padding: const EdgeInsets.all(20.0), 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              // Title of the popup
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
              SizedBox(height: 10), 

              // Dynamic message 
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20), 

              // Continue button to close the popup
              ElevatedButton(
                onPressed: () {
                  subEvent();
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), 
                  ),
                ),
                child: Text(buttonMessage), // Button label
              ),
            ],
          ),
        ),
      ),
    );
  }
}
