part of 'book_details_cubit.dart';

enum BookDetailsStatus { initial, loading, success, failure }

extension BookDetailsStatusX on BookDetailsStatus {
  bool get isInitial => this == BookDetailsStatus.initial;
  bool get isLoading => this == BookDetailsStatus.loading;
  bool get isSuccess => this == BookDetailsStatus.success;
  bool get isFailure => this == BookDetailsStatus.failure;
}

final class BookDetailsState extends Equatable {
  const BookDetailsState({
    this.status = BookDetailsStatus.initial,
    this.bookDetails = Book.empty,
  });

  final BookDetailsStatus status;
  final Book bookDetails;

  BookDetailsState copyWith({
    BookDetailsStatus? status,
    Book? bookDetails,
  }) {
    return BookDetailsState(
      status: status ?? this.status,
      bookDetails: bookDetails ?? this.bookDetails,
    );
  }

  @override
  List<Object?> get props => [status, bookDetails];
}
