// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Student {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  Student({
    this.id,
    this.firstName,
    this.lastName,
    this.createdAt,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      createdAt: map['createdAt'],
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, firstName: $firstName, lastName: $lastName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        createdAt.hashCode;
  }
}
