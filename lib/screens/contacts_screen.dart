import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/contact_card.dart';
import '../widgets/contact_form_dialog.dart';

// SafeHer - Trusted Contacts Screen
//
// Key Requirements Implemented:
// 1. Clean, accessible Material 3 interface on Android
// 2. Prominent button labelled "Add Trusted Contact"
// 3. Enter contact name, relationship, and phone number
// 4. Validate all fields and reject invalid phone numbers
// 5. Readable list of saved contacts
// 6. Edit and delete contacts
// 7. Confirmation prompt before deleting
// 8. Clear messages for empty list and invalid inputs
// 9. 100% local persistence on device (no remote uploads, no SMS sent)

class ContactsScreen extends StatelessWidget {
  final List<Contact> contacts;
  final bool isLoading;
  final ValueChanged<Contact> onAddContact;
  final ValueChanged<Contact> onEditContact;
  final ValueChanged<String> onDeleteContact;
  final ValueChanged<String> onSetPrimaryContact;
  final VoidCallback onResetSampleContacts;

  const ContactsScreen({
    super.key,
    required this.contacts,
    this.isLoading = false,
    required this.onAddContact,
    required this.onEditContact,
    required this.onDeleteContact,
    required this.onSetPrimaryContact,
    required this.onResetSampleContacts,
  });

  // Opens the form dialog to add a new contact
  void _openAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ContactFormDialog(
        onSave: onAddContact,
      ),
    );
  }

  // Opens the form dialog pre-filled to edit an existing contact
  void _openEditContactDialog(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (ctx) => ContactFormDialog(
        initialContact: contact,
        onSave: onEditContact,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trusted Contacts'),
        actions: [
          // Extra menu option to restore sample contacts for testing
          PopupMenuButton<String>(
            tooltip: 'Options',
            onSelected: (val) {
              if (val == 'reset') {
                _confirmResetSamples(context);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restart_alt_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Load Sample Contacts'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // Prominent Floating Action Button with exact label (Requirement 2)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddContactDialog(context),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text(
          'Add Trusted Contact',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD81B60),
        foregroundColor: Colors.white,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : contacts.isEmpty
              ? _buildEmptyState(context, theme)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                  children: [
                    // Privacy & Local Storage Indicator Banner
                    _buildPrivacyBanner(),
                    const SizedBox(height: 14),

                    // Top Action Bar with prominent button (Requirement 2)
                    FilledButton.icon(
                      onPressed: () => _openAddContactDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add Trusted Contact',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFD81B60),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section Title & Count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Emergency Circle (${contacts.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        Text(
                          'Saved on device',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // List of contact cards
                    ...contacts.map((contact) {
                      return ContactCard(
                        key: ValueKey(contact.id),
                        contact: contact,
                        onEdit: () => _openEditContactDialog(context, contact),
                        onDelete: () => onDeleteContact(contact.id),
                        onSetPrimary: () => onSetPrimaryContact(contact.id),
                      );
                    }),
                  ],
                ),
    );
  }

  // Clear, helpful Empty State (Requirement 8)
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                size: 64,
                color: Color(0xFFD81B60),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Trusted Contacts Yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your emergency contacts list is currently empty.\n'
              'Add friends, parents, or guardians who should be notified when an alert is triggered. All contacts are saved privately on your device.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            // Prominent button on empty state (Requirement 2)
            FilledButton.icon(
              onPressed: () => _openAddContactDialog(context),
              icon: const Icon(Icons.person_add_rounded),
              label: const Text(
                'Add Trusted Contact',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFD81B60),
                minimumSize: const Size(220, 48),
              ),
            ),
            const SizedBox(height: 12),

            // Option to load starter test data
            TextButton.icon(
              onPressed: onResetSampleContacts,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Load Sample Contacts For Testing'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Explains that data stays on device
  Widget _buildPrivacyBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded,
              color: Colors.green.shade800, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Privacy Guard: Contacts are stored only on your local phone storage and never uploaded to any remote server.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green.shade900,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmResetSamples(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Sample Contacts?'),
        content: const Text(
          'This will populate your list with 3 starter example contacts for testing.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onResetSampleContacts();
            },
            child: const Text('Load Samples'),
          ),
        ],
      ),
    );
  }
}
