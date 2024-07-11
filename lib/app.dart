import 'package:alexandria/add_edit_book/view/view.dart';
import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/book_details/book_details.dart';
import 'package:alexandria/books_repository.dart';
import 'package:alexandria/favorites/cubit/favorites_cubit.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
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
  const AlexandriaApp({
    required BooksRepository booksRepository,
    required FavoritesRepository favoritesRepository,
    super.key,
  })  : _booksRepository = booksRepository,
        _favoritesRepository = favoritesRepository;

  final BooksRepository _booksRepository;
  final FavoritesRepository _favoritesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _booksRepository),
        RepositoryProvider.value(value: _favoritesRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AllBooksCubit(_booksRepository)..fetchAllBooks(),
          ),
          BlocProvider(
            create: (context) => FavoritesCubit(_favoritesRepository),
          ),
        ],
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
