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
    this.status = DeleteBookStatus.initial,
    this.errorMessage,
  });

  final DeleteBookStatus status;
  final String? errorMessage;

  DeleteBookState copyWith({
    DeleteBookStatus? status,
    String? errorMessage,
  }) {
    return DeleteBookState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
      ];
}
