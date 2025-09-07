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
  final String? rank;
  final double? progress;

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
    this.rank,
    this.progress,
  });

  factory NewVolunteer.fromJson(Map<String, dynamic> json) {
    final dept = json['department'];

    double? _parseProgress(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim(); // "0.4%" | "40%" | "0.4"
      final noPct = s.replaceAll('%', ''); // "0.4" | "40"
      final d = double.tryParse(noPct);
      if (d == null) return null;
      return s.contains('%') || d > 1 ? d / 100.0 : d;
    }

    String? _parseImage(dynamic v) {
      if (v == null) return null;
      if (v is String) {
        final s = v.trim();
        return s.isEmpty ? null : s;
      }
      if (v is Map<String, dynamic>) {
        final f = (v['file'] ?? '').toString().trim();
        if (f.isEmpty) return null;
        final cleaned = f.replaceFirst(RegExp(r'(?<=/)/+'), '/');
        return cleaned;
      }
      return null;
    }

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
      imageUrl: _parseImage(json['personalImage']),
    );
  }
}
