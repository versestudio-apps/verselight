import 'package:flutter_test/flutter_test.dart';
import 'package:verselight/app.dart';

void main() {
  testWidgets('VerseLight app loads home', (tester) async {
    await tester.pumpWidget(const VerseLightApp());
    await tester.pumpAndSettle();
    expect(find.text('VerseLight'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
  });
}
