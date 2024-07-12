import 'package:alexandria/add_edit_book/view/abstract_form.dart';
import 'package:alexandria/add_edit_book/view/edit_book_page.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  final Book mockBook = Book(
    id: 0,
    title: 'title 0',
    author: 'author 0',
    description: 'description 0',
    image:
        'https://storage.googleapis.com/du-prd/books/images/9781501183058.jpg',
    publicationDate: DateTime(0),
  );

  group('EditBookPage', () {
    testWidgets('renders AbstractForm', (tester) async {
      await tester.pumpApp(EditBookPage(book: mockBook));

      expect(find.byType(AbstractForm), findsOneWidget);
    });
  });
}
