import 'package:flutter/material.dart';
import '../widgets/gesture_header.dart';
import '../widgets/gesture_search_bar.dart';
import '../widgets/gesture_result_item.dart';

class ViewGesturesPage extends StatelessWidget {
  final List<String> results = List.filled(6, 'Result - Text');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureHeader(),
              SizedBox(height: 24),
              GestureSearchBar(),
              SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return GestureResultItem(text: results[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
