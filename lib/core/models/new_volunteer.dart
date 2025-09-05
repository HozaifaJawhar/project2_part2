class NewVolunteer {
  final int id;
  final String name;
  final String? email;
  final String? gender;
  final String? phone;
  final String? whatsapp;
  final String? birthDate;
  final String? facebook;
  final String? linkedIn;
  final String? instagram;
  final int? points;
  final int? active;
  final String? departmentName;
  final String? departmentId;
  final String? imageUrl;

  NewVolunteer({
    required this.id,
    required this.name,
    this.email,
    this.gender,
    this.phone,
    this.whatsapp,
    this.birthDate,
    this.facebook,
    this.linkedIn,
    this.instagram,
    this.points,
    this.active,
    this.departmentName,
    this.departmentId,
    this.imageUrl,
  });

  factory NewVolunteer.fromJson(Map<String, dynamic> json) {
    final dept = json['department'];
    return NewVolunteer(
      id: (json['id'] ?? 0) is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      phone: (json['mobile_number'] ?? '').toString(),
      whatsapp: (json['whatsapp_number'] ?? '').toString(),
      birthDate: (json['birth_date'] ?? '').toString(),
      facebook: (json['facebook'] ?? '').toString(),
      linkedIn: (json['linked_in'] ?? '').toString(),
      instagram: (json['instagram'] ?? '').toString(),
      points: (json['points'] is int)
          ? json['points']
          : int.tryParse('${json['points']}'),
      active: (json['active'] is int)
          ? json['active']
          : int.tryParse('${json['active']}'),
      departmentName: (dept is Map && dept['name'] != null)
          ? '${dept['name']}'
          : null,
      departmentId: (dept is Map && dept['id'] != null)
          ? '${dept['id']}'
          : null,
      imageUrl:
          (json['personalImage'] == null ||
              json['personalImage'].toString().isEmpty)
          ? null
          : json['personalImage'].toString(),
    );
  }
}
