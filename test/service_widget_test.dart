import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_mechanic/Data/dataModel.dart';

import 'package:my_mechanic/main.dart';
void main() {
  final dataModel = DataModel();
  // final File image = File("images/placeHolder2.webp");
  // dataModel.getCarMap()[0] =
  //     Car("Test Car", 12345, base64Encode(image.readAsBytesSync()));
  // ServiceType type = ServiceType("Oil Filter");
  // dataModel.getServiceTypeMap()[0] = type;

  testWidgets('Car Service add', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // await tester.pumpWidget(MyApp());
    await tester.pumpWidget(MaterialApp(home:MyHomePage(title: 'MyMechanic')));
    await dataModel.loadSampleData();

    expect(find.text("MyMechanic"), findsOneWidget);
    // Verify that our counter starts at 0.
    // expect(find.text("Cars: 3"), findsOneWidget);

    print(DataModel().getCarMap().length);
    // // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Add Car'), findsOneWidget);
  });
}

