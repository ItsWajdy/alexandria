import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/all_books/widgets/book_preview.dart';
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
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<AllBooksCubit, AllBooksState>(
          builder: (context, state) {
            if (state.status.isSuccess) {
              return GridView.builder(
                shrinkWrap: true,
                itemCount: state.allBooks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 340),
                itemBuilder: (_, index) {
                  return BookPreview(
                    book: state.allBooks[index],
                  );
                },
              );
            } else if (state.status.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status.isFailure) {
              // TODO error handling
              return const Center(
                child: Text('failed'),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
