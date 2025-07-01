class Gestures{
  final int? id;
  final String name;
  final String category;
  final DateTime? updated_at;

  const Gestures({
    this.id,
    required this.name,
    required this.category,
    this.updated_at
  });

  // Remote Databse / API Related Functions
  factory Gestures.fromJson(Map<String, dynamic> json) {
    return Gestures(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      updated_at: json['updated_at']
    );
  }

  // SQFLite Related Functions
  Map<String, Object?> toMap(){
    return {'id': id, 'name': name, 'category': category, 'updated_at': updated_at};
  }
  factory Gestures.fromMap(Map<String, dynamic> map){
    return Gestures(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      updated_at: map['updated_at']
    );
  }
}
