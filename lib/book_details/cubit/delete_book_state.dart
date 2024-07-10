part of 'delete_book_cubit.dart';

enum DeleteBookStatus { initial, deleting, success, failure }

extension DeleteBookStatusX on DeleteBookStatus {
  bool get isInitial => this == DeleteBookStatus.initial;
  bool get isDeleting => this == DeleteBookStatus.deleting;
  bool get isSuccess => this == DeleteBookStatus.success;
  bool get isFailure => this == DeleteBookStatus.failure;
}

final class DeleteBookState extends Equatable {
  const DeleteBookState({
    required this.bookId,
    this.status = DeleteBookStatus.initial,
    this.errorMessage,
  });

  final int bookId;
  final DeleteBookStatus status;
  final String? errorMessage;

  DeleteBookState copyWith({
    DeleteBookStatus? status,
    String? errorMessage,
  }) {
    return DeleteBookState(
      bookId: bookId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        status,
        errorMessage,
      ];
}
