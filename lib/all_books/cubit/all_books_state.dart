part of 'all_books_cubit.dart';

enum AllBooksStatus { initial, loading, success, failure }

extension AllBooksStatusX on AllBooksStatus {
  bool get isInitial => this == AllBooksStatus.initial;
  bool get isLoading => this == AllBooksStatus.loading;
  bool get isSuccess => this == AllBooksStatus.success;
  bool get isFailure => this == AllBooksStatus.failure;
}

final class AllBooksState extends Equatable {
  const AllBooksState({
    this.status = AllBooksStatus.initial,
    this.allBooks = const [],
    this.errorMessage,
  });

  final AllBooksStatus status;
  final List<Book> allBooks;
  final String? errorMessage;

  AllBooksState copyWith({
    AllBooksStatus? status,
    List<Book>? allBooks,
    String? errorMessage,
  }) {
    return AllBooksState(
      status: status ?? this.status,
      allBooks: allBooks ?? this.allBooks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allBooks,
        errorMessage,
      ];
}
