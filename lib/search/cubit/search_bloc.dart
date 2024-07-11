import 'package:alexandria/repository/models/book.dart';
import 'package:alexandria/search/cubit/search_event.dart';
import 'package:alexandria/search/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Book> books;

  SearchBloc(this.books) : super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) {
    emit(state.copyWith(status: SearchStatus.searching));

    String query = event.query;

    if (query.isEmpty) {
      emit(state.copyWith(results: [], status: SearchStatus.success));
      return;
    }

    List<Book> results = books
        .where((e) =>
            e.title.contains(query) ||
            e.author.contains(query) ||
            e.description.contains(query))
        .toList();

    emit(state.copyWith(results: results, status: SearchStatus.success));
  }
}
