import 'package:alexandria/add_edit_book/bloc/abstract_bloc.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_event.dart';
import 'package:alexandria/add_edit_book/bloc/abstract_state.dart';
import 'package:alexandria/add_edit_book/bloc/add_book_bloc.dart';
import 'package:alexandria/add_edit_book/bloc/edit_book_bloc.dart';
import 'package:alexandria/add_edit_book/view/abstract_form.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart' as form_input;
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

class MockAddBookBloc extends MockBloc<AbstractEvent, AbstractState>
    implements AddBookBloc {}

class MockEditBookBloc extends MockBloc<AbstractEvent, AbstractState>
    implements EditBookBloc {}

class MockUrl extends Mock implements form_input.Url {}

class MockText extends Mock implements form_input.Text {}

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

  group('AbstractForm', () {
    late AddBookBloc addBookBloc;
    late EditBookBloc editBookBloc;

    setUp(() {
      addBookBloc = MockAddBookBloc();
      editBookBloc = MockEditBookBloc();
    });

    Widget buildAddBookSubject() {
      return BlocProvider<AbstractBloc>.value(
        value: addBookBloc,
        child: const AbstractForm(),
      );
    }

    Widget buildEditBookSubject() {
      return BlocProvider<AbstractBloc>.value(
        value: editBookBloc,
        child: const AbstractForm(),
      );
    }

    group('renders', () {
      setUp(() {
        when(() => addBookBloc.state).thenReturn(const AbstractState());
        when(() => editBookBloc.state).thenReturn(
          AbstractState(
            bookId: mockBook.id,
            title: form_input.Text.dirty(mockBook.title),
            author: form_input.Text.dirty(mockBook.author),
            description: form_input.Text.dirty(mockBook.description),
            image: form_input.Url.dirty(mockBook.image),
            publicationDate: mockBook.publicationDate,
          ),
        );
      });

      testWidgets('initial title in edit book page', (tester) async {
        await tester.pumpApp(
          buildEditBookSubject(),
        );
        expect(find.text(mockBook.title), findsOne);
      });

      testWidgets('initial author in edit book page', (tester) async {
        await tester.pumpApp(
          buildEditBookSubject(),
        );
        expect(find.text(mockBook.author), findsOne);
      });

      testWidgets('initial description in edit book page', (tester) async {
        await tester.pumpApp(
          buildEditBookSubject(),
        );
        expect(find.text(mockBook.description), findsOne);
      });

      testWidgets('initial image in edit book page', (tester) async {
        await tester.pumpApp(
          buildEditBookSubject(),
        );
        expect(find.text(mockBook.image), findsOne);
      });

      testWidgets('invalid title error text when title is invalid',
          (tester) async {
        final title = MockText();
        when(() => title.value).thenReturn('');
        when(() => title.displayError)
            .thenReturn(form_input.TextValidationError.invalid);
        when(() => addBookBloc.state).thenReturn(AbstractState(title: title));
        await tester.pumpApp(
          buildAddBookSubject(),
        );
        expect(find.text('Invalid Title'), findsOneWidget);
      });

      testWidgets('invalid author error text when author is invalid',
          (tester) async {
        final author = MockText();
        when(() => author.value).thenReturn('');
        when(() => author.displayError)
            .thenReturn(form_input.TextValidationError.invalid);
        when(() => addBookBloc.state).thenReturn(AbstractState(author: author));
        await tester.pumpApp(
          buildAddBookSubject(),
        );
        expect(find.text('Invalid Author'), findsOneWidget);
      });

      testWidgets('invalid description error text when description is invalid',
          (tester) async {
        final description = MockText();
        when(() => description.value).thenReturn('');
        when(() => description.displayError)
            .thenReturn(form_input.TextValidationError.invalid);
        when(() => addBookBloc.state)
            .thenReturn(AbstractState(description: description));
        await tester.pumpApp(
          buildAddBookSubject(),
        );
        expect(find.text('Invalid Description'), findsOneWidget);
      });

      testWidgets('invalid image error text when image is invalid',
          (tester) async {
        final image = MockUrl();
        when(() => image.value).thenReturn('');
        when(() => image.displayError)
            .thenReturn(form_input.UrlValidationError.invalid);
        when(() => addBookBloc.state).thenReturn(AbstractState(image: image));
        await tester.pumpApp(
          buildAddBookSubject(),
        );
        expect(find.text('Invalid Path'), findsOneWidget);
      });

      testWidgets('error SnackBar when submission fails', (tester) async {
        whenListen(
          addBookBloc as AbstractBloc,
          Stream.fromIterable(const <AbstractState>[
            AbstractState(status: FormzSubmissionStatus.inProgress),
            AbstractState(
                status: FormzSubmissionStatus.failure,
                errorMessage: 'Unknown error'),
          ]),
        );
        await tester.pumpApp(
          buildAddBookSubject(),
        );
        await tester.pump();
        expect(find.text('Unknown error'), findsOneWidget);
      });
    });
  });
}
