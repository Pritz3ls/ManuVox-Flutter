class Category {
  final int? id;
  final String name;
  final DateTime? updatedAt; // Use camelCase for Dart conventions

  const Category({
    this.id,
    required this.name,
    this.updatedAt // Use the camelCase parameter
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?, // Safely cast to int?
      name: map['name'] as String, // Safely cast to String
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString()) // Ensure it's a string, then parse
          : null,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category.fromMap(json); // Just delegate to fromMap
  }

  // SQFLite / Serialization to Map for Database or API
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'name': name,
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}