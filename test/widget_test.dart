import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verselight/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('VerseLight app loads home', (tester) async {
    await tester.pumpWidget(const VerseLightApp());
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('VerseLight'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
  });
}
