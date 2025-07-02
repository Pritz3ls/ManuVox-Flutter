// objects/gestures.dart

class Gestures {
  final int? id;
  final String name;
  final int categoryFk; // Changed from String category to int categoryFk
  final DateTime? updatedAt; // Changed updated_at to updatedAt (camelCase)

  const Gestures({
    this.id,
    required this.name,
    required this.categoryFk, // Changed to categoryFk
    this.updatedAt, // Changed to updatedAt
  });

  // Factory constructor for deserialization from both JSON (API) and Map (SQFlite)
  // They both handle String timestamps and int foreign keys.
  factory Gestures.fromMap(Map<String, dynamic> map) {
    return Gestures(
      id: map['id'] as int?,
      name: map['name'] as String,
      categoryFk: map['category_fk'] as int, // Access category_fk from map
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : null,
    );
  }

  // Helper method for API JSON parsing, delegates to fromMap
  factory Gestures.fromJson(Map<String, dynamic> json) {
    // The JSON from your API should now return 'category_fk' as an integer.
    return Gestures.fromMap(json);
  }

  // SQFLite / Serialization to Map for Database
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'name': name,
      'category_fk': categoryFk, // Use category_fk here
      'updated_at': updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}