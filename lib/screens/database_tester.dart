import 'package:flutter/material.dart';
import '../objects/local_database.dart'; // Import the DatabaseHelper class
// import '../objects/gestures.dart';
import '../objects/category.dart';
// import 'user.dart'; // Import the User class

void main() async {
  // Initialize the database and insert users
  runApp(DatabaseTester());
}

class DatabaseTester extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database Tester',
      home: DatabaseList(),
    );
  }
}

class DatabaseList extends StatefulWidget {
  @override
  _DatabaseListState createState() => _DatabaseListState();
}

class _DatabaseListState extends State<DatabaseList> {
  List<Category> _category = [];

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    final userMaps = await LocalDatabase.instance.selectAllCategory();
    setState(() {
      _category = userMaps.map((userMap) => Category.fromMap(userMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GFG User List'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: _category.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_category[index].name),
            subtitle: Text(_category[index].id.toString()),
          );
        },
      ),
    );
  }
}
// 