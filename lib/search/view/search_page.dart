import 'package:alexandria/all_books/widgets/book_preview.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:alexandria/search/cubit/search_bloc.dart';
import 'package:alexandria/search/cubit/search_event.dart';
import 'package:alexandria/search/cubit/search_state.dart';
import 'package:alexandria/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  final List<Book> books;

  const SearchPage({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(books),
      child: const SearchView(),
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
      backgroundColor: const Color(0xFFF2F2F2),
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
                }
                if (state.status.isSuccess) {
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
