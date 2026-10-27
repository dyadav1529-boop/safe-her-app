import 'package:flutter/material.dart';

// SafeHer - Safety Tip Data Model
//
// Represents educational safety guidance displayed in the tips section.
// Each tip includes an icon, a category tag, and actionable bullet points.

class SafetyTip {
  final String id;
  final String title;
  final String category; // e.g. "Travel", "Transit", "Digital", "Emergency"
  final String summary;
  final List<String> bulletPoints;
  final IconData icon;

  const SafetyTip({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.bulletPoints,
    required this.icon,
  });
}
