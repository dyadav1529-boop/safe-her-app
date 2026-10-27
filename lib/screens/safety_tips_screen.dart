import 'package:flutter/material.dart';
import '../utils/mock_data.dart';

// SafeHer - Safety Tips Screen
//
// Requirement 6: A safety tips section.
// Requirement 8: Accessible design with readable text and clear buttons.
//
// Provides practical, actionable guidance for women's daily safety,
// public transit, rideshares, night walks, and digital awareness.

class SafetyTipsScreen extends StatefulWidget {
  const SafetyTipsScreen({super.key});

  @override
  State<SafetyTipsScreen> createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Street Safety',
    'Transit',
    'Cyber Safety',
    'Situational Awareness',
    'Emergency Resources',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredTips = _selectedCategory == 'All'
        ? MockData.safetyTips
        : MockData.safetyTips
            .where((tip) => tip.category == _selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Tips & Resources'),
      ),
      body: Column(
        children: [
          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.pink.shade100,
                    checkmarkColor: Colors.pink.shade900,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.pink.shade900
                          : Colors.grey.shade800,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),

          // Tips List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredTips.length,
              itemBuilder: (context, index) {
                final tip = filteredTips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(tip.icon, color: Colors.pink.shade800),
                      ),
                      title: Text(
                        tip.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          tip.summary,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const Text(
                                'Recommended Actions:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...tip.bulletPoints.map(
                                (point) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 6.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '• ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFFD81B60),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          point,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
