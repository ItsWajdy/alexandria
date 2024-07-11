import 'package:alexandria/repository/models/book.dart';
import 'package:alexandria/search/bloc/search_event.dart';
import 'package:alexandria/search/bloc/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Book> books;

  SearchBloc(this.books) : super(const SearchState()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) {
    emit(state.copyWith(status: SearchStatus.searching));

    String lowerCaseQuery = event.query.toLowerCase();

    if (lowerCaseQuery.isEmpty) {
      emit(state.copyWith(results: [], status: SearchStatus.noResults));
      return;
    }

    List<Book> results = books
        .where((e) =>
            e.title.toLowerCase().contains(lowerCaseQuery) ||
            e.author.toLowerCase().contains(lowerCaseQuery) ||
            e.description.toLowerCase().contains(lowerCaseQuery))
        .toList();

    if (results.isEmpty) {
      emit(state.copyWith(results: [], status: SearchStatus.noResults));
    } else {
      emit(state.copyWith(results: results, status: SearchStatus.success));
    }
  }
}
