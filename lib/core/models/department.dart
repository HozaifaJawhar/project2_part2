class Department {
  final int id;
  final String name;
  final String? description;

  Department({required this.id, required this.name, this.description});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      description: (json['description']?.toString().toLowerCase() == 'null')
          ? null
          : json['description']?.toString(),
    );
  }
}
