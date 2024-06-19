class Instructor {
  final int? id;
  final String name;
  final String email;
  final String phoneNumber;

  Instructor({this.id, required this.name, required this.email, required this.phoneNumber});

  // Convert a Instructor into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'instructor_id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    };
  }

  // Convert a Map into a Instructor.
  factory Instructor.fromMap(Map<String, dynamic> map) {
    return Instructor(
      id: map['instructor_id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
    );
  }
}
