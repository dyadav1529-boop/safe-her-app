import 'package:flutter/material.dart';
import '../models/contact.dart';

// SafeHer - Contact Form Dialog (Add & Edit)
//
// Demonstrates form handling, validation, state editing, and error feedback.
// Handles both:
// 1. Adding a new contact (`initialContact == null`)
// 2. Editing an existing contact (`initialContact != null`)

class ContactFormDialog extends StatefulWidget {
  final Contact? initialContact;
  final ValueChanged<Contact> onSave;

  const ContactFormDialog({
    super.key,
    this.initialContact,
    required this.onSave,
  });

  @override
  State<ContactFormDialog> createState() => _ContactFormDialogState();
}

class _ContactFormDialogState extends State<ContactFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  late String _selectedRelationship;
  late bool _isPrimary;

  final List<String> _relationshipOptions = [
    'Parent',
    'Sister',
    'Brother',
    'Friend',
    'Partner',
    'Roommate',
    'Guardian',
    'Other',
  ];

  bool get _isEditing => widget.initialContact != null;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if editing an existing contact
    _nameController = TextEditingController(
      text: widget.initialContact?.name ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.initialContact?.phoneNumber ?? '',
    );
    _selectedRelationship = widget.initialContact?.relationship ?? 'Parent';
    // Ensure the selected relationship is present in the options list
    if (!_relationshipOptions.contains(_selectedRelationship)) {
      _selectedRelationship = 'Other';
    }
    _isPrimary = widget.initialContact?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Validates user input and rejects invalid phone numbers
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final trimmed = value.trim();

    // 1. Check for invalid characters (only digits, +, -, (, ), and spaces allowed)
    final allowedFormatRegex = RegExp(r'^[0-9+\-\(\)\s]+$');
    if (!allowedFormatRegex.hasMatch(trimmed)) {
      return 'Contains invalid characters (only numbers, +, -, and spaces allowed)';
    }

    // 2. Check for + symbol position (can only be at the very start)
    if (trimmed.contains('+')) {
      if (!trimmed.startsWith('+') || '+'.allMatches(trimmed).length > 1) {
        return 'International code "+" must only appear once at the beginning';
      }
    }

    // 3. Count pure digits
    final pureDigits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (pureDigits.length < 7) {
      return 'Phone number too short (minimum 7 digits required)';
    }
    if (pureDigits.length > 15) {
      return 'Phone number too long (maximum 15 digits allowed)';
    }

    return null; // Valid
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.initialContact?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        relationship: _selectedRelationship,
        isPrimary: _isPrimary,
      );

      widget.onSave(contact);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
            color: const Color(0xFFD81B60),
          ),
          const SizedBox(width: 10),
          Text(_isEditing ? 'Edit Trusted Contact' : 'Add Trusted Contact'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditing
                    ? 'Update this contact’s name, phone, or relationship.'
                    : 'This contact will be stored securely on your phone for emergency alerts.',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Contact Name Input
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Contact Name *',
                  hintText: 'e.g. Mom, Sarah, or Maya',
                  prefixIcon: Icon(Icons.badge_outlined),
                  border: OutlineInputBorder(),
                  helperText: 'Required: at least 2 characters',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a contact name';
                  }
                  if (val.trim().length < 2) {
                    return 'Name must be at least 2 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number *',
                  hintText: 'e.g. +1 555-019-2834 or 9876543210',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                  helperText: '7 to 15 digits; numbers and standard format only',
                ),
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 14),

              // Relationship Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedRelationship,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  prefixIcon: Icon(Icons.people_outline),
                  border: OutlineInputBorder(),
                ),
                items: _relationshipOptions.map((rel) {
                  return DropdownMenuItem(
                    value: rel,
                    child: Text(rel),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedRelationship = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),

              // Set as Primary Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Set as primary emergency contact',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Primary contacts appear at the top and are alerted first in SOS',
                  style: TextStyle(fontSize: 11),
                ),
                value: _isPrimary,
                onChanged: (val) {
                  setState(() {
                    _isPrimary = val ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submitForm,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFD81B60),
          ),
          child: Text(_isEditing ? 'Save Changes' : 'Add Trusted Contact'),
        ),
      ],
    );
  }
}
