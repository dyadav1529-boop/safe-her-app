// SafeHer - Contact Data Model
//
// In Flutter/Dart, a "Model" class represents a piece of structured data.
// This class stores the details of an emergency contact trusted by the user.
// It also provides methods to convert the contact to and from JSON (Map)
// so it can be saved locally on the device via SharedPreferences.

class Contact {
  // Unique identifier for each contact (e.g., generated timestamp string)
  final String id;

  // The full name or nickname of the trusted contact (e.g., "Mom")
  final String name;

  // The verified phone number that would receive SMS or calls in an emergency
  final String phoneNumber;

  // The relationship label (e.g., "Parent", "Sibling", "Friend", "Guardian")
  final String relationship;

  // Indicates if this contact is the primary contact alerted first
  final bool isPrimary;

  const Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    this.isPrimary = false,
  });

  // copyWith allows creating a modified copy while keeping original values
  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? relationship,
    bool? isPrimary,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  // Converts a Contact object into a Map so it can be converted to JSON.
  // This is used when saving contacts to the device's local storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'isPrimary': isPrimary,
    };
  }

  // Creates a Contact object from a Map.
  // This is used when reading contacts back from the device's local storage.
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      relationship: map['relationship'] as String? ?? 'Other',
      isPrimary: map['isPrimary'] as bool? ?? false,
    );
  }
}
