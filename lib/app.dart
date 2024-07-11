import 'package:alexandria/add_edit_book/view/view.dart';
import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/book_details/book_details.dart';
import 'package:alexandria/books_repository.dart';
import 'package:alexandria/home/view/view.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/book',
      builder: (context, state) => BookDetailsPage(book: state.extra as Book),
    ),
    GoRoute(
      path: '/new',
      builder: (context, state) => const AddBookPage(),
    ),
    GoRoute(
      path: '/edit',
      builder: (context, state) => EditBookPage(book: state.extra as Book),
    ),
  ],
);

class AlexandriaApp extends StatelessWidget {
  const AlexandriaApp({required BooksRepository booksRepository, super.key})
      : _booksRepository = booksRepository;

  final BooksRepository _booksRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _booksRepository,
      child: BlocProvider(
        create: (context) => AllBooksCubit(_booksRepository)..fetchAllBooks(),
        child: const AlexandriaAppView(),
      ),
    );
  }
}

class AlexandriaAppView extends StatelessWidget {
  const AlexandriaAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AlexandriaTheme.data,
      routerConfig: _router,
    );
  }
}
