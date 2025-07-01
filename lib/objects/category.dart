class Category {
  final int? id;
  final String name;
  final DateTime? updated_at;

  const Category({
    this.id,
    required this.name,
    this.updated_at
  });

  // Remote Databse / API Related Functions
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      updated_at: json['updated_at']
    );
  }

  // SQFLite Related Functions
  Map<String, Object?> toMap(){
    return {'id': id, 'name': name, 'updated_at': updated_at};
  }
  factory Category.fromMap(Map<String, dynamic> map){
    return Category(
      id: map['id'],
      name: map['name'],
      updated_at: map['updated_at']
    );
  }
}