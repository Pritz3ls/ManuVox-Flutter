// import '../widgets/gesture_header.dart';
// import '../widgets/gesture_search_bar.dart';
// import '../widgets/gesture_result_item.dart';
import '../screens/camera_screen.dart';
// import '../objects/local_database.dart';
import '../objects/gestures.dart'; // Assuming Gestures class and fetchGestures are here

import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // As http to avoid naming conflicts

class ReferenceScreen extends StatefulWidget {
  @override
  _ReferenceState createState() => _ReferenceState();
}

class _ReferenceState extends State<ReferenceScreen> {
  List<Gestures> results = [];
  bool isLoading = true;
  String? error;
  String searchValue = '';
  // LocalDatabase localDatabase = new LocalDatabase();

  @override
  void initState() {
    super.initState();
    _loadGestures();
  }

  Future<void> _loadGestures() async {
    try {
      List<Gestures> fetchedGestures = await fetchGestures();
      setState(() {
        results = fetchedGestures;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final filteredSearch = results.where((result) => result.name.toLowerCase().contains(searchValue.toLowerCase()) 
    || result.category.toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold( // <--- Wrap with Scaffold
      // body: Builder( // Using Builder to ensure context is available if needed
      //   builder: (BuildContext context) {
      //     if (isLoading) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (error != null) {
      //       return Center(child: Text('Error: $error'));
      //     } else if (results.isEmpty) {
      //       return Center(child: Text('No gestures found.'));
      //     }
      //     else {
      //       return ListView.builder(
      //         itemCount: results.length,
      //         itemBuilder: (context, index) {
      //           return ListTile(
      //             title: Text(results[index].name),
      //             // Double-check 'category' field in your Gestures class.
      //             // Based on your DB table, it has 'id' and 'name'.
      //             // If 'category' in your Gestures class maps to 'id' from the DB, then it should be an int.
      //             // If your React server provides a 'category' string, then it's fine.
      //             // Assuming 'category' in Gestures class now correctly holds some identifiable data.
      //             subtitle: Text('Category ID: ${results[index].category}'),
      //             // You might also consider onTap for navigation or details
      //             // onTap: () {
      //             //   // Handle tap
      //             // },
      //           );
      //         },
      //       );
      //     }
      //   },
      body: Column(
        children: [
          // Curved & Responsive Header for Camera notch
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
              ),
            ),
            padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Back Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: ElevatedButton(
                    onPressed: (){
                      // On pressed go back, but how?
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const CameraScreen())
                      );
                    }, 
                    child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18))
                ),
                SizedBox(height: 8),
                // Header Title
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    'View Gestures',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                SizedBox(height: 4),
                // Header Subtitle
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    'Learn how to do sign language',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search Word',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchValue = value;
                        });
                      },
                    ),
                  ),
                  Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Result Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredSearch.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${filteredSearch[index].name} - ${filteredSearch[index].category}",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Your fetchGestures function (kept as is, assuming it's in the same file or imported)
Future<List<Gestures>> fetchGestures() async {
  final String apiUrl = 'http://localhost:3001/manuvox/gestures'; // For Android emulator, use 10.0.2.2

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      
      // Ensure your Gestures.fromJson correctly parses the data from your React server
      // based on the fields it returns (e.g., 'name', 'category' if your API provides it).
      List<Gestures> gestures = jsonList.map((json) => Gestures.fromJson(json)).toList();
      
      return gestures;
    } else {
      throw Exception('Failed to load gestures: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching gestures: $e');
  }
}

// Ensure your Gestures class is defined like this (or similar, depending on what your API returns for 'category'):
// If your React server sends { "id": 1, "name": "GestureName", "category": "CategoryString" }
// Then your Gestures class should be:
// class Gestures {
//   final String name;
//   final String category; // Assuming your API provides a 'category' string

//   Gestures({
//     required this.name,
//     required this.category,
//   });

//   factory Gestures.fromJson(Map<String, dynamic> json) {
//     return Gestures(
//       name: json['name'],
//       category: json['category'], // Make sure this key matches your API response
//     );
//   }
// }

// If your React server only sends { "id": 1, "name": "GestureName" } (based on your DB schema)
// And you want 'category' in Gestures to be the 'id', then Gestures should be:
// class Gestures {
//   final int id;
//   final String name;

//   Gestures({
//     required this.id,
//     required this.name,
//   });

//   factory Gestures.fromJson(Map<String, dynamic> json) {
//     return Gestures(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
// }
// And your ListTile subtitle would be: Text('ID: ${results[index].id}'),

/*
  body: Column(
        children: [
          // Curved & Responsive Header for Camera notch
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF1E1E1E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
              ),
            ),
            padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Back Icon
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 18),
                ),
                SizedBox(height: 8),
                // Header Title
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    'View Gestures',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                SizedBox(height: 4),
                // Header Subtitle
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    'Learn how to do sign language',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search Word',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // Result Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    results[index].name,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
*/