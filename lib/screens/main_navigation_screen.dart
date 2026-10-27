import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/contacts_storage_service.dart';
import '../utils/mock_data.dart';
import 'home_screen.dart';
import 'contacts_screen.dart';
import 'safety_tips_screen.dart';
import 'settings_screen.dart';

// SafeHer - Main Navigation Shell
//
// Uses Material 3 NavigationBar for clean, standard Android navigation.
// Maintains global state for the emergency contact list and persists all
// changes locally using `ContactsStorageService`.

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Current tab index (0: Home, 1: Contacts, 2: Tips, 3: Settings)
  int _currentIndex = 0;

  // The active list of trusted emergency contacts
  List<Contact> _contacts = [];
  bool _isLoading = true;

  // Local storage service for saving and loading contacts
  final ContactsStorageService _storageService = ContactsStorageService();

  @override
  void initState() {
    super.initState();
    _loadContactsFromStorage();
  }

  // Asynchronously loads contacts from local storage on app launch
  Future<void> _loadContactsFromStorage() async {
    final stored = await _storageService.loadContacts();
    if (mounted) {
      setState(() {
        _contacts = stored;
        _isLoading = false;
      });
    }
  }

  // Adds a new contact and saves to local storage
  Future<void> _handleAddContact(Contact newContact) async {
    setState(() {
      // If the new contact is primary, clear primary flag from previous contacts
      if (newContact.isPrimary) {
        _contacts = _contacts
            .map((c) => c.copyWith(isPrimary: false))
            .toList();
      }
      _contacts.add(newContact);
    });

    await _storageService.saveContacts(_contacts);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added "${newContact.name}" to trusted contacts.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Updates an existing contact and saves to local storage
  Future<void> _handleEditContact(Contact updatedContact) async {
    setState(() {
      final index = _contacts.indexWhere((c) => c.id == updatedContact.id);
      if (index != -1) {
        if (updatedContact.isPrimary) {
          // Clear primary flag from all others
          _contacts = _contacts
              .map((c) => c.copyWith(isPrimary: false))
              .toList();
        }
        _contacts[index] = updatedContact;
      }
    });

    await _storageService.saveContacts(_contacts);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Updated details for "${updatedContact.name}".'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Removes a contact by ID and saves to local storage
  Future<void> _handleDeleteContact(String contactId) async {
    setState(() {
      _contacts.removeWhere((c) => c.id == contactId);
    });

    await _storageService.saveContacts(_contacts);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact removed from emergency circle.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Designates a contact as primary and saves to local storage
  Future<void> _handleSetPrimary(String contactId) async {
    setState(() {
      _contacts = _contacts.map((c) {
        return c.copyWith(isPrimary: c.id == contactId);
      }).toList();
    });

    await _storageService.saveContacts(_contacts);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primary emergency contact updated.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Restores sample starter contacts for testing
  Future<void> _handleResetSampleContacts() async {
    setState(() {
      _contacts = List<Contact>.from(MockData.initialContacts);
    });

    await _storageService.saveContacts(_contacts);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loaded 3 sample contacts for testing.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List of screens corresponding to bottom navigation tabs
    final screens = [
      HomeScreen(
        contacts: _contacts,
        onNavigateToContacts: () => _switchTab(1),
      ),
      ContactsScreen(
        contacts: _contacts,
        isLoading: _isLoading,
        onAddContact: _handleAddContact,
        onEditContact: _handleEditContact,
        onDeleteContact: _handleDeleteContact,
        onSetPrimaryContact: _handleSetPrimary,
        onResetSampleContacts: _handleResetSampleContacts,
      ),
      const SafetyTipsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _switchTab,
        indicatorColor: Colors.pink.shade100,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFFD81B60)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Color(0xFFD81B60)),
            label: 'Contacts',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield, color: Color(0xFFD81B60)),
            label: 'Safety Tips',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Color(0xFFD81B60)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
