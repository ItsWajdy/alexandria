import 'package:alexandria/add_edit_book/view/abstract_form.dart';
import 'package:alexandria/add_edit_book/view/add_book_page.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AddBookPage', () {
    testWidgets('renders AbstractForm', (tester) async {
      await tester.pumpApp(const AddBookPage());

      expect(find.byType(AbstractForm), findsOneWidget);
    });
  });
}
