// objects/remote_database.dart (Improvised for Pull-Only)

import 'gestures.dart';
import 'category.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RemoteDatabase {
  final String _baseUrl = 'http://localhost:3001/manuvox'; // Android emulator IP. Use localhost for iOS sim/web in same machine.

  // --- Category Fetching ---
  Future<List<Category>> fetchCategories({DateTime? since}) async {
    String apiUrl = '$_baseUrl/category';
    if (since != null) {
      // Encode the timestamp for URL. Your Node.js API needs to parse this.
      apiUrl += '?since=${Uri.encodeComponent(since.toIso8601String())}';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Category.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load categories from remote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // --- Gestures Fetching ---
  Future<List<Gestures>> fetchGestures({DateTime? since}) async {
    String apiUrl = '$_baseUrl/gestures';
    if (since != null) {
      apiUrl += '?since=${Uri.encodeComponent(since.toIso8601String())}';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Gestures.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load gestures from remote: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching gestures: $e');
    }
  }
}