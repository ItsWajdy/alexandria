import 'package:alexandria/books_repository.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home/view/view.dart';

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
    return MaterialApp(
      theme: AlexandriaTheme.data,
      home: const HomePage(),
    );
  }
}
