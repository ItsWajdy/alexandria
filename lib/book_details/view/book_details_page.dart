import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/book_details/cubit/delete_book_cubit.dart';
import 'package:alexandria/book_details/widgets/book_edit_preview.dart';
import 'package:alexandria/book_details/widgets/floating_card.dart';
import 'package:alexandria/favorites/edit_favorites_cubit/edit_favorites_cubit.dart';
import 'package:alexandria/favorites/repository/favorites_repository.dart';
import 'package:alexandria/repository/books_repository.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DeleteBookCubit(context.read<AllBooksCubit>(),
              context.read<BooksRepository>(), book.id),
        ),
        BlocProvider(
          create: (context) =>
              EditFavoritesCubit(context.read<FavoritesRepository>(), book.id),
        ),
      ],
      child: BookDetailsView(
        book: book,
      ),
    );
  }
}

class BookDetailsView extends StatelessWidget {
  final Book book;

  const BookDetailsView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
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
          BlocConsumer<EditFavoritesCubit, EditFavoritesState>(
            listener: (context, state) {
              if (!state.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(state.errorMessage ?? 'Unknown error')),
                );
              }
            },
            builder: (context, state) => IconButton(
              icon: Icon(state.isBookInFavorites
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                context.read<EditFavoritesCubit>().flipFavoriteStatus();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: AlexandriaTheme.darkBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: BookEditPreview(
                      height: screenHeight * 200 / 890 + 5,
                      book: book,
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
                  width: double.infinity,
                  color: AlexandriaTheme.backgroundColor,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 73 / 890 + 5, left: 15, right: 15),
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
                          book.description,
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
            height: screenHeight * 74 / 890 + 5,
            width: screenWidth * 250 / 411,
            topPosition: screenHeight * 5 / 11 - 37,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(book.publicationDate!),
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: AlexandriaTheme.highlightColor,
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
                          color: AlexandriaTheme.highlightColor,
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
            height: screenHeight * 65 / 890 + 5,
            width: screenWidth * 150 / 411,
            topPosition: screenHeight * 9 / 11,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    context.go('/edit', extra: book);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.edit,
                        color: AlexandriaTheme.highlightColor,
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
              ),
              const VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
              BlocListener<DeleteBookCubit, DeleteBookState>(
                listener: (context, state) {
                  if (state.status.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Success'),
                      ),
                    );
                    context.go('/');
                  } else if (state.status.isFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? 'Unknown'),
                      ),
                    );
                  }
                },
                child: Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      bool? userConfirmedDelete = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete this book? This action cannot be reversed'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );

                      if (userConfirmedDelete != null && userConfirmedDelete) {
                        context.read<DeleteBookCubit>().deleteBook();
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.delete,
                          color: AlexandriaTheme.highlightColor,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
