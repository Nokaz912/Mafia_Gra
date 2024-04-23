import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/views/RoomSettings.dart';

void main() {
  testWidgets('Login view test', (widgetTester) async {
    //Przygotowujemy potrzebne dane
    final loginView = RoomSettingsPage();

    //Ładujemy widok do pamięci
    await widgetTester.pumpWidget(loginView);

    final titleFinder = find.text("Room Settings");

    //Testujemy widok
    expect(titleFinder, findsOneWidget);
  });
}