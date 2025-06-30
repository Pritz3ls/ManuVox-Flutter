// import 'dart:convert'; // For jsonDecode
// import 'package:http/http.dart' as http; // As http to avoid naming conflicts
// import '../widgets/gestures.dart';

// // Ensure your Gestures class is defined as shown above

// // How to use it in your Flutter application (e.g., in a StatefulWidget)
// class MyDataFetcher extends StatefulWidget {
//   @override
//   _MyDataFetcherState createState() => _MyDataFetcherState();
// }

// class _MyDataFetcherState extends State<MyDataFetcher> {
//   List<Gestures> results = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     _loadGestures();
//   }

//   Future<void> _loadGestures() async {
//     try {
//       List<Gestures> fetchedGestures = await fetchGestures();
//       setState(() {
//         results = fetchedGestures;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Center(child: CircularProgressIndicator());
//     } else if (error != null) {
//       return Center(child: Text('Error: $error'));
//     } else if (results.isEmpty) {
//       return Center(child: Text('No gestures found.'));
//     } else {
//       return ListView.builder(
//         itemCount: results.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(results[index].name),
//             subtitle: Text('ID: ${results[index].id}'), // Or whatever 'category' maps to
//           );
//         },
//       );
//     }
//   }
// }