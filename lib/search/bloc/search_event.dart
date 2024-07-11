import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
}

final class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged({required this.query});

  @override
  List<Object?> get props => [query];
}
