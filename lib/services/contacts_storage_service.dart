import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/contact.dart';
import '../utils/mock_data.dart';

// SafeHer - Local Contacts Storage Service
//
// Privacy First:
// Contacts are stored 100% locally on the device using the official
// `shared_preferences` package.
// No data is sent over the internet or uploaded to any remote server.
// No extra device permissions (like internet or sensitive system permissions) are required.

class ContactsStorageService {
  // Key used to store contacts in SharedPreferences
  static const String _contactsKey = 'safeher_trusted_contacts';
  static const String _firstRunKey = 'safeher_first_run_completed';

  // Loads trusted contacts from the device's local storage.
  Future<List<Contact>> loadContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // If stored contacts JSON exists, parse and return it
      final String? jsonString = prefs.getString(_contactsKey);
      if (jsonString != null) {
        if (jsonString.trim().isEmpty) return [];
        final List<dynamic> decodedList =
            jsonDecode(jsonString) as List<dynamic>;
        return decodedList
            .map((item) => Contact.fromMap(item as Map<String, dynamic>))
            .toList();
      }

      // If no stored contacts key exists, check if user has launched before
      final bool hasInitialized = prefs.getBool(_firstRunKey) ?? false;
      if (!hasInitialized) {
        // First run: load starter sample contacts and save them
        await saveContacts(MockData.initialContacts);
        return List<Contact>.from(MockData.initialContacts);
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // Saves the entire list of contacts to local storage as a JSON string.
  Future<bool> saveContacts(List<Contact> contacts) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstRunKey, true);

      final List<Map<String, dynamic>> mapList =
          contacts.map((c) => c.toMap()).toList();
      final String jsonString = jsonEncode(mapList);

      return await prefs.setString(_contactsKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  // Clears all contacts from local storage (useful for testing empty states)
  Future<bool> clearContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_contactsKey);
    } catch (e) {
      return false;
    }
  }
}
