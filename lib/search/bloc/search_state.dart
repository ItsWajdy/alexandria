import 'package:alexandria/repository/models/book.dart';
import 'package:equatable/equatable.dart';

enum SearchStatus { initial, searching, success, noResults }

extension SearchStatusX on SearchStatus {
  bool get isInitial => this == SearchStatus.initial;
  bool get isSearching => this == SearchStatus.searching;
  bool get isSuccess => this == SearchStatus.success;
  bool get isNoResults => this == SearchStatus.noResults;
}

final class SearchState extends Equatable {
  final String query;
  final List<Book> results;
  final SearchStatus status;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.status = SearchStatus.initial,
  });

  SearchState copyWith({
    String? query,
    List<Book>? results,
    SearchStatus? status,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        query,
        results,
        status,
      ];
}
