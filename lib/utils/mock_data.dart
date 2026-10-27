import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../models/safety_tip.dart';

// SafeHer - Starter Data
//
// These default entries give beginners an immediate visual preview
// of how the app handles contacts and safety guidelines before
// connecting to local storage or an online database.

class MockData {
  // Sample trusted contacts to display out-of-the-box
  static List<Contact> initialContacts = [
    const Contact(
      id: 'c1',
      name: 'Mom',
      phoneNumber: '+1 (555) 019-2834',
      relationship: 'Parent',
      isPrimary: true,
    ),
    const Contact(
      id: 'c2',
      name: 'Sarah Jenkins',
      phoneNumber: '+1 (555) 014-9921',
      relationship: 'Sister',
      isPrimary: false,
    ),
    const Contact(
      id: 'c3',
      name: 'Priya Sharma',
      phoneNumber: '+1 (555) 018-7742',
      relationship: 'Friend / Roommate',
      isPrimary: false,
    ),
  ];

  // Comprehensive safety tips categorized for quick learning
  static List<SafetyTip> safetyTips = [
    const SafetyTip(
      id: 'tip1',
      title: 'Walking Alone After Dark',
      category: 'Street Safety',
      icon: Icons.nightlight_round,
      summary: 'Stay alert, stay visible, and plan your route ahead of time.',
      bulletPoints: [
        'Stick to well-lit, populated main streets rather than shortcuts through alleys or empty parks.',
        'Keep your head up and avoid looking down at your phone for extended periods.',
        'Keep both ears free—avoid wearing noise-canceling headphones when walking at night.',
        'Hold your keys between your fingers before approaching your vehicle or doorstep.',
        'If you suspect you are being followed, cross the street or step into an open store or restaurant.',
      ],
    ),
    const SafetyTip(
      id: 'tip2',
      title: 'Cabs & Rideshare Safety',
      category: 'Transit',
      icon: Icons.local_taxi_rounded,
      summary: 'Confirm details before getting into any vehicle.',
      bulletPoints: [
        'Always verify the license plate, driver name, and car model before opening the door.',
        'Ask the driver "Who are you picking up?" rather than saying "Are you here for [Your Name]?"',
        'Sit in the back seat so you can exit from either side and maintain personal space.',
        'Share your live trip progress or ride status with a trusted family member or friend.',
        'Check child-lock status if you feel uneasy and keep your window cracked slightly.',
      ],
    ),
    const SafetyTip(
      id: 'tip3',
      title: 'Digital Privacy & Location Safety',
      category: 'Cyber Safety',
      icon: Icons.security_rounded,
      summary: 'Control who sees your real-time whereabouts online.',
      bulletPoints: [
        'Avoid posting real-time check-ins on social media—post photos after leaving the venue.',
        'Regularly review app permissions for apps that access your GPS in the background.',
        'Be cautious of strangers asking to borrow your phone for an "emergency call"; dial for them on speaker instead.',
        'Keep Bluetooth and Wi-Fi hotspot discovery disabled when in crowded public places.',
      ],
    ),
    const SafetyTip(
      id: 'tip4',
      title: 'Crowded Areas & Safe Havens',
      category: 'Situational Awareness',
      icon: Icons.storefront_rounded,
      summary: 'Know where to seek assistance in an unfamiliar neighborhood.',
      bulletPoints: [
        'Identify 24/7 locations nearby: gas stations, hotel lobbies, pharmacies, or police kiosks.',
        'If someone makes you uncomfortable, make loud, clear statements: "Step back, you are too close."',
        'Never hesitate to attract public attention or seek out security personnel.',
        'Trust your gut instinct: if a situation feels wrong, leave immediately without apologizing.',
      ],
    ),
    const SafetyTip(
      id: 'tip5',
      title: 'Emergency Helplines Reference',
      category: 'Emergency Resources',
      icon: Icons.contact_phone_rounded,
      summary: 'Key public emergency services you can dial from any phone.',
      bulletPoints: [
        'National Emergency Service: 112 (Universal emergency in India & EU) / 911 (US & Canada)',
        'Women Helpline: 1091 or 181 (India national support lines)',
        'National Domestic Violence Hotline: 1-800-799-SAFE (7233)',
        'Mental Health Crisis Lifeline: 988',
      ],
    ),
  ];
}
