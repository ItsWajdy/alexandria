import 'package:alexandria/books_repository.dart';
import 'package:alexandria/edit_book/cubit/edit_book_bloc.dart';
import 'package:alexandria/edit_book/view/edit_book_form.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBookPage extends StatelessWidget {
  final Book book;

  const EditBookPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditBookBloc>(
      create: (_) => EditBookBloc(context.read<BooksRepository>(), book),
      child: const EditBookForm(),
    );
  }
}
