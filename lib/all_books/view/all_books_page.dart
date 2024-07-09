import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllBooksPage extends StatelessWidget {
  const AllBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AllBooksCubit(context.read<BooksRepository>())..fetchAllBooks(),
      child: const AllBooksView(),
    );
  }
}

class AllBooksView extends StatefulWidget {
  const AllBooksView({super.key});

  @override
  State<AllBooksView> createState() => _AllBooksViewState();
}

class _AllBooksViewState extends State<AllBooksView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AllBooksCubit, AllBooksState>(
        builder: (context, state) {
          if (state.status.isSuccess) {
            return ListView.builder(
              itemCount: state.allBooks.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Center(child: Text(state.allBooks[index].title)),
                );
              },
            );
          } else if (state.status.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status.isFailure) {
            return const Center(
              child: Text('failed'),
            );
          }
          return Container();
        },
      ),
    );
  }
}
