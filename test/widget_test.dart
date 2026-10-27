import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safe_her/main.dart';
import 'package:safe_her/models/contact.dart';
import 'package:safe_her/services/contacts_storage_service.dart';

void main() {
  setUp(() {
    // Set up mock SharedPreferences values for testing environment
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SafeHer initial UI and navigation smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SafeHerApp());
    // Pump frames to allow async storage and animations to render
    await tester.pump(const Duration(milliseconds: 500));

    // Verify app title appears
    expect(find.text('SafeHer'), findsOneWidget);

    // Verify prominent SOS button text is present
    expect(find.text('SOS'), findsOneWidget);

    // Verify navigation tabs are present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Contacts'), findsOneWidget);
    expect(find.text('Safety Tips'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets(
      'Trusted Contacts screen renders button labelled "Add Trusted Contact"',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SafeHerApp());
    await tester.pump(const Duration(milliseconds: 500));

    // Tap on Contacts navigation tab
    await tester.tap(find.text('Contacts'));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify the "Add Trusted Contact" button is present (Requirement 2)
    expect(find.text('Add Trusted Contact'), findsAtLeastNWidgets(1));

    // Verify screen title
    expect(find.text('Trusted Contacts'), findsOneWidget);
  });

  testWidgets('Add Trusted Contact dialog validates empty and invalid inputs',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SafeHerApp());
    await tester.pump(const Duration(milliseconds: 500));

    // Tap on Contacts tab
    await tester.tap(find.text('Contacts'));
    await tester.pump(const Duration(milliseconds: 500));

    // Tap on the FAB "Add Trusted Contact"
    final addBtn = find.byType(FloatingActionButton);
    await tester.tap(addBtn);
    await tester.pump(const Duration(milliseconds: 500));

    // Dialog title check
    expect(find.text('Add Trusted Contact'), findsAtLeastNWidgets(1));

    // Tap Save button inside the dialog without entering anything
    final dialogFinder = find.byType(AlertDialog);
    final saveButton = find.descendant(
      of: dialogFinder,
      matching: find.widgetWithText(FilledButton, 'Add Trusted Contact'),
    );
    await tester.tap(saveButton);
    await tester.pump(const Duration(milliseconds: 300));

    // Verify validation error messages are displayed
    expect(find.text('Please enter a contact name'), findsOneWidget);
    expect(find.text('Phone number is required'), findsOneWidget);

    // Enter invalid phone number (letters)
    final textFields = find.byType(TextFormField);
    await tester.enterText(textFields.first, 'Maya Lin');
    await tester.enterText(textFields.at(1), 'not-a-number');
    await tester.tap(saveButton);
    await tester.pump(const Duration(milliseconds: 300));

    // Verify rejection of invalid characters
    expect(
        find.text(
            'Contains invalid characters (only numbers, +, -, and spaces allowed)'),
        findsOneWidget);
  });

  test('Contact model converts to and from Map correctly', () {
    const contact = Contact(
      id: 'test_123',
      name: 'Maya',
      phoneNumber: '+1 555-019-2834',
      relationship: 'Sister',
      isPrimary: true,
    );

    final map = contact.toMap();
    expect(map['id'], 'test_123');
    expect(map['name'], 'Maya');
    expect(map['phoneNumber'], '+1 555-019-2834');
    expect(map['relationship'], 'Sister');
    expect(map['isPrimary'], true);

    final restored = Contact.fromMap(map);
    expect(restored.id, contact.id);
    expect(restored.name, contact.name);
    expect(restored.phoneNumber, contact.phoneNumber);
    expect(restored.relationship, contact.relationship);
    expect(restored.isPrimary, contact.isPrimary);
  });

  test('ContactsStorageService saves and loads contacts locally', () async {
    final service = ContactsStorageService();
    const testList = [
      Contact(
        id: '1',
        name: 'Aunt May',
        phoneNumber: '+1 555-999-0000',
        relationship: 'Guardian',
        isPrimary: true,
      ),
    ];

    final saved = await service.saveContacts(testList);
    expect(saved, true);

    final loaded = await service.loadContacts();
    expect(loaded.length, 1);
    expect(loaded.first.name, 'Aunt May');
    expect(loaded.first.phoneNumber, '+1 555-999-0000');
  });
}
