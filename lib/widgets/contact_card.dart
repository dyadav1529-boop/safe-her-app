import 'package:flutter/material.dart';
import '../models/contact.dart';

// SafeHer - Contact Card Widget
//
// Displays a saved trusted contact in an accessible, readable Material 3 card.
// Allows:
// 1. Viewing contact name, verified phone number, and relationship
// 2. Editing contact details via the Edit button
// 3. Setting a contact as Primary
// 4. Deleting a contact with a confirmation prompt

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetPrimary;

  const ContactCard({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.onSetPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: contact.isPrimary
              ? const Color(0xFFD81B60)
              : Colors.grey.shade300,
          width: contact.isPrimary ? 1.8 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar with the first letter of the contact's name
                CircleAvatar(
                  radius: 26,
                  backgroundColor: contact.isPrimary
                      ? Colors.pink.shade50
                      : Colors.deepPurple.shade50,
                  child: Text(
                    contact.name.isNotEmpty
                        ? contact.name.trim().substring(0, 1).toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: contact.isPrimary
                          ? const Color(0xFFD81B60)
                          : const Color(0xFF6A1B9A),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name and Phone number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              contact.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (contact.isPrimary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: const Color(0xFFD81B60), width: 1),
                              ),
                              child: const Text(
                                'PRIMARY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: Color(0xFFD81B60),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined,
                              size: 15, color: Colors.grey.shade700),
                          const SizedBox(width: 6),
                          SelectableText(
                            contact.phoneNumber,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  color: Colors.blue.shade700,
                  tooltip: 'Edit Contact Details',
                  onPressed: onEdit,
                ),

                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red.shade700,
                  tooltip: 'Remove Contact',
                  onPressed: () => _confirmDelete(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Bottom Action Row: Relationship Chip + Primary Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: const Icon(Icons.people_outline, size: 16),
                  label: Text(
                    contact.relationship,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  backgroundColor: Colors.grey.shade100,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),

                // Action to make this contact primary
                if (!contact.isPrimary)
                  TextButton.icon(
                    onPressed: onSetPrimary,
                    icon: const Icon(Icons.star_outline_rounded, size: 18),
                    label: const Text('Set as Primary'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFD81B60),
                      visualDensity: VisualDensity.compact,
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  )
                else
                  const Row(
                    children: [
                      Icon(Icons.star_rounded,
                          color: Color(0xFFD81B60), size: 18),
                      SizedBox(width: 4),
                      Text(
                        'Notified first in SOS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD81B60),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Asks for confirmation before deleting (Requirement 7)
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Remove Contact?'),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${contact.name}" from your trusted emergency circle?\n\n'
          'They will no longer be contacted if an emergency alert is triggered.',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            child: const Text('Remove Contact'),
          ),
        ],
      ),
    );
  }
}
