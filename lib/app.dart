import 'package:alexandria/book_details/book_details.dart';
import 'package:alexandria/books_repository.dart';
import 'package:alexandria/home/view/view.dart';
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
      path: '/book/:bookId',
      builder: (context, state) =>
          BookDetailsPage(bookId: int.parse(state.pathParameters['bookId']!)),
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
      child: const AlexandriaAppView(),
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
