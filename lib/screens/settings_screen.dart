import 'package:flutter/material.dart';

// SafeHer - Settings Screen
//
// Requirement 7: A settings screen.
// Requirement 14: Permission status & error states overview.
//
// Allows beginners and users to review simulated permissions,
// customize emergency preferences, and understand development disclaimers.

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Simulated permission toggles
  bool _locationPermission = true;
  bool _smsPermission = true;
  bool _notificationPermission = true;

  // Preferences
  int _sosCountdownSeconds = 5;
  bool _soundSirenOnSos = true;
  final TextEditingController _customMessageController = TextEditingController(
    text: 'EMERGENCY: I am in danger and need immediate assistance. Please track my location.',
  );

  @override
  void dispose() {
    _customMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // Section 1: System Permissions Status (Requirement 14)
          _buildSectionHeader(theme, 'Android Permissions Status', Icons.security),
          Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.location_on,
                    color: _locationPermission ? Colors.green : Colors.red,
                  ),
                  title: const Text('Location Access (GPS)'),
                  subtitle: Text(
                    _locationPermission
                        ? 'Granted: Allows attaching live coordinate link.'
                        : 'Denied: Emergency contacts cannot receive your location.',
                    style: TextStyle(
                      fontSize: 12,
                      color: _locationPermission
                          ? Colors.grey.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                  value: _locationPermission,
                  onChanged: (val) {
                    setState(() {
                      _locationPermission = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    Icons.sms,
                    color: _smsPermission ? Colors.green : Colors.red,
                  ),
                  title: const Text('SMS Transmission Access'),
                  subtitle: Text(
                    _smsPermission
                        ? 'Granted: Allows sending distress texts.'
                        : 'Denied: App cannot send SMS automatically in SOS.',
                    style: TextStyle(
                      fontSize: 12,
                      color: _smsPermission
                          ? Colors.grey.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                  value: _smsPermission,
                  onChanged: (val) {
                    setState(() {
                      _smsPermission = val;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    Icons.notifications_active,
                    color: _notificationPermission ? Colors.green : Colors.red,
                  ),
                  title: const Text('Emergency Push Notifications'),
                  subtitle: Text(
                    _notificationPermission
                        ? 'Granted: High-priority background alerts enabled.'
                        : 'Denied: Notification alerts disabled.',
                    style: TextStyle(
                      fontSize: 12,
                      color: _notificationPermission
                          ? Colors.grey.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                  value: _notificationPermission,
                  onChanged: (val) {
                    setState(() {
                      _notificationPermission = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section 2: SOS Emergency Preferences
          _buildSectionHeader(
              theme, 'SOS Emergency Preferences', Icons.tune_rounded),
          Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Countdown Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cancellation Grace Period',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(
                            'Time window to cancel an accidental SOS tap',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                      DropdownButton<int>(
                        value: _sosCountdownSeconds,
                        items: const [
                          DropdownMenuItem(value: 3, child: Text('3s')),
                          DropdownMenuItem(value: 5, child: Text('5s')),
                          DropdownMenuItem(value: 10, child: Text('10s')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _sosCountdownSeconds = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(),

                  // Siren Toggle
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sound Audible Siren on SOS',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                      'Trigger loud local alarm to attract nearby bystanders',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: _soundSirenOnSos,
                    onChanged: (val) {
                      setState(() {
                        _soundSirenOnSos = val;
                      });
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 6),

                  // Custom SOS message preview
                  const Text(
                    'Distress SMS Message Template',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'This text will precede your live location link in an emergency.',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _customMessageController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your custom emergency message...',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 3: Safety & Development Disclaimer (Requirements 12 & 13)
          _buildSectionHeader(
              theme, 'Development Mode Disclaimer', Icons.info_outline),
          Card(
            color: Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.amber.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined,
                          color: Colors.amber.shade900),
                      const SizedBox(width: 8),
                      Text(
                        'Safe Development Sandbox',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Real emergency services (911/112/police) are NEVER called automatically.\n'
                    '• Real SMS charges or transmissions are NEVER dispatched.\n'
                    '• All triggers execute in preview / simulation mode so you can build and test safely.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Section 4: About SafeHer
          _buildSectionHeader(theme, 'About SafeHer', Icons.phone_android),
          Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: const Column(
              children: [
                ListTile(
                  title: Text('Application Name'),
                  trailing: Text('SafeHer',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('Version'),
                  trailing: Text('1.0.0 (Initial Prototype)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('Design Framework'),
                  trailing: Text('Flutter Material 3',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.pink.shade800),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
