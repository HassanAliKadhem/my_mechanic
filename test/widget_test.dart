// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_mechanic/Data/dataModel.dart';

import 'package:my_mechanic/main.dart';
import 'package:my_mechanic/widgets/snackBar.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Open add car page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(
        size: Size.square(400),
      ),
      child: ChangeNotifierProvider(
        create: (context) => DataModel(),
        child: MaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: 'MyMechanic',
          home: MyApp(),
        ),
      ),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('MyMechanic'), findsOneWidget);

    // look for the bottom bar items
    expect(find.text('Cars'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    expect(find.text('Add Car'), findsNothing);

    // Tap the '+' icon and open the add car page
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that our page opened
    expect(find.text('Add Car'), findsOneWidget);

    expect(find.byType(TextFormField), findsNWidgets(3));
    // return to home page
    await tester.pageBack();

    // open the setting page
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();
  });
}
