import 'gestures.dart'; // Import Gestures if you want to reuse its properties easily

class GestureWithCategory {
  final int id; // The gesture's ID
  final String gestureName; // The gesture's name
  final String categoryName; // The category's name from the JOIN
  final int categoryFk; // The foreign key ID (optional, but good for completeness)
  final DateTime? updatedAt; // The gesture's updated_at timestamp

  const GestureWithCategory({
    required this.id,
    required this.gestureName,
    required this.categoryName,
    required this.categoryFk,
    this.updatedAt,
  });

  // Factory constructor to create a GestureWithCategory from a Map (result of a joined query)
  factory GestureWithCategory.fromMap(Map<String, dynamic> map) {
    return GestureWithCategory(
      id: map['id'] as int, // Assuming gesture.id is always present
      gestureName: map['name'] as String, // Assuming gesture.name is aliased as 'name'
      categoryName: map['category_name'] as String, // Assuming category.name is aliased as 'category_name'
      categoryFk: map['category_fk'] as int, // Assuming gesture.category_fk is present
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : null,
    );
  }
}