class Gestures{
  final int id;
  final String name;
  final String category;

  const Gestures({
    required this.id,
    required this.name,
    required this.category
  });

  factory Gestures.fromJson(Map<String, dynamic> json) {
    return Gestures(
      id: json['id'],
      name: json['name'],
      category: json['category']
    );
  }
}
