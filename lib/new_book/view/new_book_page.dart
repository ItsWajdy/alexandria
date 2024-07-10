import 'package:alexandria/books_repository.dart';
import 'package:alexandria/new_book/cubit/new_book_cubit.dart';
import 'package:alexandria/new_book/view/new_book_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewBookPage extends StatelessWidget {
  const NewBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewBookCubit>(
      create: (_) => NewBookCubit(context.read<BooksRepository>()),
      child: const NewBookForm(),
    );
  }
}
