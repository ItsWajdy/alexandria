import 'package:alexandria/all_books/all_books.dart';
import 'package:alexandria/ui/widgets/book_preview.dart';
import 'package:alexandria/search/bloc/search_bloc.dart';
import 'package:alexandria/search/bloc/search_event.dart';
import 'package:alexandria/search/bloc/search_state.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllBooksCubit, AllBooksState>(
      builder: (context, state) {
        if (state.status.isSuccess) {
          return BlocProvider<SearchBloc>(
            create: (context) => SearchBloc(state.allBooks),
            child: const SearchView(),
          );
        } else if (state.status.isFailure) {
          return Center(child: Text(state.errorMessage ?? 'Unknown error'));
        }
        return const Center(child: Text('Fatal error'));
      },
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlexandriaTheme.backgroundColor,
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.grey,
          decoration: AlexandriaTheme.searchBoxDecoration.copyWith(
            hintText: 'Search',
            hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (value) =>
              context.read<SearchBloc>().add(SearchQueryChanged(query: value)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return Builder(
              builder: (context) {
                if (state.status.isSearching) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status.isSuccess) {
                  return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.results.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 340),
                    itemBuilder: (_, index) {
                      return BookPreview(
                        book: state.results[index],
                      );
                    },
                  );
                } else if (state.status.isNoResults) {
                  return const Center(child: Text('No Results'));
                }
                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
