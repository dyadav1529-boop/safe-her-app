import 'dart:async';
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/location_status_card.dart';
import '../widgets/sos_button.dart';

// SafeHer - Home Screen
//
// The central hub of the app. It displays:
// 1. Prominent Red SOS Button (Requirement 3)
// 2. Visible Location Status Section (Requirement 5)
// 3. Permission & Error Handling (Requirement 14)
// 4. Emergency Action Preview without fake alerts or real calls (Requirements 12 & 13)

class HomeScreen extends StatefulWidget {
  final List<Contact> contacts;
  final VoidCallback onNavigateToContacts;

  const HomeScreen({
    super.key,
    required this.contacts,
    required this.onNavigateToContacts,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State for simulated location status
  LocationPermissionState _locationPermission = LocationPermissionState.granted;
  bool _isLocationSharingActive = false;

  void _toggleLocationSharing() {
    setState(() {
      _isLocationSharingActive = !_isLocationSharingActive;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLocationSharingActive
              ? 'Simulated location tracking enabled'
              : 'Location sharing deactivated',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handlePermissionChange(LocationPermissionState newState) {
    setState(() {
      _locationPermission = newState;
      if (newState != LocationPermissionState.granted) {
        _isLocationSharingActive = false;
      }
    });
  }

  // Shows the Development Mode SOS Preview Modal
  // Requirements 12 & 13: Honest simulation, no fake alerts or real transmissions.
  void _showSosPreviewSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SosPreviewModal(
        contacts: widget.contacts,
        locationPermission: _locationPermission,
        isLocationActive: _isLocationSharingActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: Color(0xFFD81B60),
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SafeHer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'Personal Safety Companion',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'About Development Mode',
            onPressed: () {
              _showDevModeInfoDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Emergency Hotlines Strip
            _buildHelplinesStrip(context),
            const SizedBox(height: 16),

            // Location Sharing Status Section (Requirement 5 & 14)
            LocationStatusCard(
              permissionState: _locationPermission,
              isSharingActive: _isLocationSharingActive,
              onToggleSharing: _toggleLocationSharing,
              onPermissionChanged: _handlePermissionChange,
            ),
            const SizedBox(height: 24),

            // Prominent Red SOS Button (Requirement 3)
            Center(
              child: SosButton(
                onTriggerPreview: _showSosPreviewSheet,
              ),
            ),
            const SizedBox(height: 24),

            // Trusted Contacts Summary Card
            _buildContactsSummaryCard(context, theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Quick Helpline quick-reference strip
  Widget _buildHelplinesStrip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.phone_in_talk, color: Colors.purple.shade700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Helplines Reference',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  '112 / 911 (General) • 1091 / 181 (Women Support)',
                  style: TextStyle(fontSize: 11, color: Colors.purple.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card displaying current trusted contacts count and quick link
  Widget _buildContactsSummaryCard(BuildContext context, ThemeData theme) {
    final contactCount = widget.contacts.length;
    final primaryContact = widget.contacts
        .cast<Contact?>()
        .firstWhere((c) => c?.isPrimary == true, orElse: () => null);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people_alt_rounded,
                        color: Colors.pink.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Emergency Circle',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: widget.onNavigateToContacts,
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              contactCount == 0
                  ? 'No contacts added yet. Add trusted contacts so they can be alerted in an emergency.'
                  : '$contactCount trusted contact${contactCount > 1 ? 's' : ''} configured on this device. '
                      '${primaryContact != null ? "Primary contact: ${primaryContact.name} (${primaryContact.relationship})." : "No primary contact set."}',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.35),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.onNavigateToContacts,
                icon: Icon(
                  contactCount == 0 ? Icons.person_add_rounded : Icons.people_outline_rounded,
                  size: 18,
                  color: const Color(0xFFD81B60),
                ),
                label: Text(
                  contactCount == 0 ? 'Add Trusted Contact' : 'Manage Trusted Contacts',
                  style: const TextStyle(
                    color: Color(0xFFD81B60),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD81B60)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDevModeInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Development Mode Notice'),
        content: const Text(
          'SafeHer is currently in development mode. Tapping the SOS button shows '
          'a safe preview simulation of the emergency sequence.\n\n'
          'No real SMS messages, police calls, or live location broadcasts will be sent.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

// Modal bottom sheet showing what the SOS workflow does in simulation
class _SosPreviewModal extends StatefulWidget {
  final List<Contact> contacts;
  final LocationPermissionState locationPermission;
  final bool isLocationActive;

  const _SosPreviewModal({
    required this.contacts,
    required this.locationPermission,
    required this.isLocationActive,
  });

  @override
  State<_SosPreviewModal> createState() => _SosPreviewModalState();
}

class _SosPreviewModalState extends State<_SosPreviewModal> {
  int _countdown = 5;
  Timer? _timer;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    // 5-second countdown to simulate an emergency cancel grace period
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _cancelSos() {
    _timer?.cancel();
    setState(() {
      _isCancelled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SOS Simulation Preview',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Development Mode • No real SMS or emergency calls dispatched.',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Countdown / Cancel Status
            if (!_isCancelled) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircularProgressIndicator(
                      value: _countdown / 5.0,
                      color: Colors.deepOrange,
                      backgroundColor: Colors.orange.shade100,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _countdown > 1
                                ? 'Grace Period: $_countdown seconds left'
                                : 'Simulation Triggered',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'In production, this timer lets you cancel false alarms before SMS is sent.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _cancelSos,
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                  label: const Text(
                    'Cancel SOS (False Alarm Test)',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'SOS Cancelled successfully.',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 18),
            Text(
              'Actions Planned in Production Release:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Checklist of realistic production actions
            _buildActionItem(
              icon: Icons.sms_outlined,
              title: 'SMS Alert to ${widget.contacts.length} Contact(s)',
              subtitle: widget.contacts.isEmpty
                  ? 'Warning: No contacts configured!'
                  : 'Recipient list: ${widget.contacts.map((c) => c.name).join(", ")}',
              statusColor: widget.contacts.isEmpty ? Colors.red : Colors.green,
            ),
            _buildActionItem(
              icon: Icons.my_location_rounded,
              title: 'Attach Live GPS Coordinates',
              subtitle: widget.locationPermission ==
                      LocationPermissionState.granted
                  ? 'Simulated coordinates: 28.6139° N, 77.2090° E'
                  : 'Unavailable: Location permission not granted.',
              statusColor: widget.locationPermission ==
                      LocationPermissionState.granted
                  ? Colors.green
                  : Colors.orange,
            ),
            _buildActionItem(
              icon: Icons.volume_up_outlined,
              title: 'Sound Loud Local Siren',
              subtitle: 'Plays an audible alert to deter immediate threats.',
              statusColor: Colors.blue,
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close Preview'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
