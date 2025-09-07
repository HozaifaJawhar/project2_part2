import 'package:flutter/foundation.dart';

/// Converts the string "null" to a true null or empty string as needed
String _cleanString(dynamic v, {String fallback = ''}) {
  if (v == null) return fallback;
  final s = v.toString();
  if (s.toLowerCase() == 'null') return fallback;
  return s;
}

@immutable
class Event {
  final int id;
  final String name;
  final String status;
  final String description;
  final DateTime? date;
  final int? minHours;
  final int? maxHours;
  final String? location;
  final int? volunteersCount;
  final int? acceptedCount;
  final int? pendingCount;
  final String? coverImage;
  final EventDepartment? department;

  const Event({
    required this.id,
    required this.name,
    required this.status,
    required this.description,
    required this.date,
    this.minHours,
    this.maxHours,
    this.location,
    this.volunteersCount,
    this.acceptedCount,
    this.pendingCount,
    this.coverImage,
    this.department,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      name: _cleanString(json['name']),
      status: _cleanString(json['status']),
      description: _cleanString(json['description']),
      date: (json['date'] is String) ? DateTime.tryParse(json['date']) : null,
      minHours: json['min_hours'],
      maxHours: json['max_hours'],
      location: _cleanString(json['location'], fallback: '').isEmpty
          ? null
          : _cleanString(json['location']),
      volunteersCount: json['volunteers_count'],
      acceptedCount: json['accepted_count'],
      pendingCount: json['pending_count'],
      coverImage: _parseImage(json['cover_image']),
      department: (json['department'] is Map)
          ? EventDepartment.fromJson(json['department'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'description': description,
      'date': date?.toIso8601String(),
      'min_hours': minHours,
      'max_hours': maxHours,
      'location': location,
      'volunteers_count': volunteersCount,
      'accepted_count': acceptedCount,
      'pending_count': pendingCount,
      'cover_image': coverImage,
      'department': department?.toJson(),
    };
  }

  Event copyWith({
    int? id,
    String? name,
    String? status,
    String? description,
    DateTime? date,
    int? minHours,
    int? maxHours,
    String? location,
    int? volunteersCount,
    int? acceptedCount,
    int? pendingCount,
    String? coverImage,
    EventDepartment? department,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      description: description ?? this.description,
      date: date ?? this.date,
      minHours: minHours ?? this.minHours,
      maxHours: maxHours ?? this.maxHours,
      location: location ?? this.location,
      volunteersCount: volunteersCount ?? this.volunteersCount,
      acceptedCount: acceptedCount ?? this.acceptedCount,
      pendingCount: pendingCount ?? this.pendingCount,
      coverImage: coverImage ?? this.coverImage,
      department: department ?? this.department,
    );
  }
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

// @immutable
// class EventImage {
//   final int id;
//   final String file;
//   final String extension;

//   const EventImage({
//     required this.id,
//     required this.file,
//     required this.extension,
//   });

//   factory EventImage.fromJson(Map<String, dynamic> json) {
//     return EventImage(
//       id: json['id'] ?? 0,
//       file: _cleanString(json['file']),
//       extension: _cleanString(json['extension']),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'file': file,
//     'extension': extension,
//   };
// }

@immutable
class EventDepartment {
  final int id;
  final String name;
  final String? description;

  const EventDepartment({
    required this.id,
    required this.name,
    required this.description,
  });

  factory EventDepartment.fromJson(Map<String, dynamic> json) {
    final desc = _cleanString(json['description'], fallback: '');
    return EventDepartment(
      id: json['id'] ?? 0,
      name: _cleanString(json['name']),
      description: desc.isEmpty ? null : desc,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };
}
