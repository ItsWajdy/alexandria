import 'package:alexandria/book_details/book_details.dart';
import 'package:alexandria/book_details/widgets/book_preview.dart';
import 'package:alexandria/book_details/widgets/floating_card.dart';
import 'package:alexandria/books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BookDetailsPage extends StatelessWidget {
  final int bookId;

  const BookDetailsPage({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookDetailsCubit(context.read<BooksRepository>())
        ..fetchBookDetails(bookId),
      child: const BookDetailsView(),
    );
  }
}

class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          if (state.status.isSuccess) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        color: const Color(0xFFF2EFE5),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: BookPreview(
                            book: state.bookDetails,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey[350],
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: const Color(0xFFF4F4F4),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 73.0, left: 15, right: 15),
                          child: Column(
                            children: [
                              Text(
                                'Description',
                                style: theme.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                state.bookDetails.description,
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                FloatingCard(
                  height: 74,
                  width: 250,
                  topPosition: height * 5 / 11 - 37,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            DateFormat.yMMMMd()
                                .format(state.bookDetails.publicationDate!),
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: const Color(0xFFC5AB63),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            'Publish Date',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'English',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: const Color(0xFFC5AB63),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Text(
                            'Language',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                FloatingCard(
                  height: 65,
                  width: 150,
                  topPosition: height * 9 / 11,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.edit,
                            color: Color(0xFFC5AB63),
                          ),
                          Text(
                            'EDIT',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.delete,
                            color: Color(0xFFC5AB63),
                          ),
                          Text(
                            'DELETE',
                            style: theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (state.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status.isFailure) {
            // TODO error handling
            return Text('failed');
          }
          return Container();
        },
      ),
    );
  }
}
