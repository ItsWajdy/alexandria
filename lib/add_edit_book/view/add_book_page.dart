import 'package:alexandria/add_edit_book/bloc/abstract_bloc.dart';
import 'package:alexandria/add_edit_book/bloc/add_book_bloc.dart';
import 'package:alexandria/add_edit_book/view/abstract_form.dart';
import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AbstractBloc>(
      create: (_) => AddBookBloc(
          context.read<AllBooksCubit>(), context.read<BooksRepository>()),
      child: const AbstractForm(),
    );
  }
}
