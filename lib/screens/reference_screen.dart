import '../objects/gesture_category.dart';
import '../objects/local_database.dart';
import '../objects/sync_service.dart';
import '../popups/popup_handler.dart';
import '../popups/update_popup.dart';

import '../screens/camera_screen.dart';
import 'package:flutter/material.dart';

class ReferenceScreen extends StatefulWidget {
  @override
  _ReferenceState createState() => _ReferenceState();
}

class _ReferenceState extends State<ReferenceScreen> {
  List<GestureWithCategory> results = [];
  bool isLoading = true;
  String? error;
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    _checkUpdates();
    _loadGestures();
  }

  Future <void> _checkUpdates() async{
    bool availableUpdates = await SyncService.instance.hasPendingUpdates();
    if(availableUpdates){
      PopupHandler.instance.showPopup(context, const UpdatePopup());
    }
  }

  Future<void> _loadGestures() async {
    try {
      List<GestureWithCategory> fetchedGestures = await LocalDatabase.instance.selectGesturesWithCategoryNames();

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
    final filteredSearch = results.where((result) => result.gestureName.toLowerCase().contains(searchValue.toLowerCase()) 
    || result.categoryName.toLowerCase().contains(searchValue.toLowerCase())).toList();

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
                    "${filteredSearch[index].gestureName} - ${filteredSearch[index].categoryName}",
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