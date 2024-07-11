import 'package:alexandria/add_edit_book/bloc/abstract_bloc.dart';
import 'package:alexandria/add_edit_book/bloc/edit_book_bloc.dart';
import 'package:alexandria/add_edit_book/view/abstract_form.dart';
import 'package:alexandria/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBookPage extends StatelessWidget {
  final Book book;

  const EditBookPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AbstractBloc>(
      create: (_) => EditBookBloc(context.read<BooksRepository>(), book),
      child: const AbstractForm(),
    );
  }
}
