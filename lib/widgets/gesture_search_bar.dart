
import 'package:flutter/material.dart';

class GestureSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black,
        hintText: 'Search Word',
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(Icons.search, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white24),
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
