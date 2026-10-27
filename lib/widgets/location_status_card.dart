import 'package:flutter/material.dart';

// SafeHer - Location Sharing Status Card
//
// Requirement 5: A clearly visible location-sharing status section.
// Requirement 14: Clear permission and error states.
//
// This widget clearly communicates whether GPS permissions are granted,
// whether location sharing is actively on or on standby, and how errors
// are handled when permissions are denied.

enum LocationPermissionState {
  granted,
  notRequested,
  denied,
}

class LocationStatusCard extends StatelessWidget {
  final LocationPermissionState permissionState;
  final bool isSharingActive;
  final VoidCallback onToggleSharing;
  final ValueChanged<LocationPermissionState> onPermissionChanged;

  const LocationStatusCard({
    super.key,
    required this.permissionState,
    required this.isSharingActive,
    required this.onToggleSharing,
    required this.onPermissionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine visual style depending on current permission and sharing state
    Color statusColor;
    IconData statusIcon;
    String statusTitle;
    String statusSubtitle;

    if (permissionState == LocationPermissionState.denied) {
      statusColor = Colors.red.shade700;
      statusIcon = Icons.location_off_rounded;
      statusTitle = 'Location Access Denied';
      statusSubtitle =
          'Error: SafeHer cannot attach emergency GPS coordinates without location permission.';
    } else if (permissionState == LocationPermissionState.notRequested) {
      statusColor = Colors.orange.shade800;
      statusIcon = Icons.warning_amber_rounded;
      statusTitle = 'Permission Needed';
      statusSubtitle =
          'Location permission is not yet enabled. Emergency contacts will not receive your map link.';
    } else if (isSharingActive) {
      statusColor = Colors.teal.shade700;
      statusIcon = Icons.fmd_good_rounded;
      statusTitle = 'Location Sharing Active (Simulated)';
      statusSubtitle =
          'Live coordinates ready for emergency transmission (Preview: 28.6139° N, 77.2090° E).';
    } else {
      statusColor = Colors.indigo.shade700;
      statusIcon = Icons.location_searching_rounded;
      statusTitle = 'Location Ready (Standby)';
      statusSubtitle =
          'GPS permission granted. Location broadcast is on standby until SOS is triggered.';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: statusColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon + Title + Status Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location Status',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        statusTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge showing state
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    permissionState == LocationPermissionState.denied
                        ? 'ERROR'
                        : isSharingActive
                            ? 'ACTIVE'
                            : 'STANDBY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description / Status explanation
            Text(
              statusSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black87,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),

            // Interactive Controls for beginners to test various states
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quick Permission State Selector
                DropdownButtonHideUnderline(
                  child: DropdownButton<LocationPermissionState>(
                    value: permissionState,
                    isDense: true,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: LocationPermissionState.granted,
                        child: Text('State: Granted'),
                      ),
                      DropdownMenuItem(
                        value: LocationPermissionState.notRequested,
                        child: Text('State: Not Requested'),
                      ),
                      DropdownMenuItem(
                        value: LocationPermissionState.denied,
                        child: Text('State: Denied (Error)'),
                      ),
                    ],
                    onChanged: (newState) {
                      if (newState != null) {
                        onPermissionChanged(newState);
                      }
                    },
                  ),
                ),

                // Button to toggle sharing if permission is granted
                if (permissionState == LocationPermissionState.granted)
                  FilledButton.tonal(
                    onPressed: onToggleSharing,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      isSharingActive ? 'Turn Off' : 'Test Turn On',
                      style: const TextStyle(fontSize: 13),
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: () {
                      // Simulates granting permission
                      onPermissionChanged(LocationPermissionState.granted);
                    },
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('Fix / Allow'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
