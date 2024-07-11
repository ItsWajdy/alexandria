import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/all_books/widgets/book_preview.dart';
import 'package:alexandria/favorites/cubit/favorites_cubit.dart';
import 'package:alexandria/favorites/cubit/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllBooksCubit, AllBooksState>(
      builder: (context, state) {
        if (state.status.isSuccess) {
          context.read<FavoritesCubit>().getFavoritesFrom(state.allBooks);
          return const FavoritesView();
        } else {
          // TODO error handling
          return const Center(
            child: Text('error'),
          );
        }
      },
    );
  }
}

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.status.isSuccess) {
            return GridView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: state.favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 340),
              itemBuilder: (_, index) {
                return BookPreview(
                  book: state.favorites[index],
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
