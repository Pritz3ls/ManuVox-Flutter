// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp()); 
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Popup Demo',
//       debugShowCheckedModeBanner: false,
//       home: HomePage(), 
//     );
//   }
// }

// // The main screen with a button to trigger the popup
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   // Custom function to display the popup dialog with a dynamic message
//   void voidPopup(BuildContext context, String message) {
//     showDialog(
//       context: context, 
//       builder: (BuildContext context) {
//         return Center(
//           child: Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20), 
//             ),
//             backgroundColor: Colors.grey[800], 
//             child: Padding(
//               padding: const EdgeInsets.all(20.0), 
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, 
//                 children: [
//                   // Title of the popup
//                   Text(
//                     "Warning",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white, 
//                     ),
//                   ),
//                   SizedBox(height: 10), 

//                   // Dynamic message 
//                   Text(
//                     message,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                   SizedBox(height: 20), 

//                   // Continue button to close the popup
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop(); // Dismiss the dialog
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white, 
//                       foregroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12), 
//                       ),
//                     ),
//                     child: Text("Continue"), // Button label
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text('Popup Demo'),
//         backgroundColor: Colors.grey[900], 
//       ),
//       body: Center(
//         // Button to trigger the custom popup
//         child: ElevatedButton(
//           onPressed: () {
//             voidPopup(
//               context,
//               "This feature is still in beta, expect bugs or crashes.", 
//             );
//           },
//           child: Text('Show Popup'),
//         ),
//       ),
//     );
//   }
// }
