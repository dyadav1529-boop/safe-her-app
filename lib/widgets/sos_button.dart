import 'package:flutter/material.dart';

// SafeHer - SOS Button Widget
//
// This is the core emergency button on the Home Screen.
// It is designed to be highly prominent, instantly recognizable,
// and accessible even in high-stress situations.
//
// In accordance with development guidelines:
// - It does NOT send real SMS or place emergency phone calls.
// - It displays an honest Development Preview dialog explaining what
//   would happen in a production deployment.

class SosButton extends StatefulWidget {
  final VoidCallback onTriggerPreview;

  const SosButton({
    super.key,
    required this.onTriggerPreview,
  });

  @override
  State<SosButton> createState() => _SosButtonState();
}

class _SosButtonState extends State<SosButton>
    with SingleTickerProviderStateMixin {
  // Animation controller creates the gentle pulsating "radar" ring effect
  // around the button so users can easily spot it.
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing SOS Circle Button
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: child,
            );
          },
          child: Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.25),
                  blurRadius: 28,
                  spreadRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Material(
              color: const Color(0xFFD32F2F), // Accessible deep red
              shape: const CircleBorder(),
              elevation: 8,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: widget.onTriggerPreview,
                splashColor: Colors.red.shade900,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.campaign_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'TAP FOR PREVIEW',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Explanatory badge explaining development mode
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber.shade400, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.amber.shade900,
              ),
              const SizedBox(width: 6),
              Text(
                'Development Mode • Tap to simulate SOS flow',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
