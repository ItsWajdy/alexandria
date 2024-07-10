part of 'edit_book_cubit.dart';

final class EditBookState extends Equatable {
  const EditBookState({
    required this.bookId,
    this.title = const Text.pure(),
    this.author = const Text.pure(),
    this.description = const Text.pure(),
    this.image = const Url.pure(),
    this.publicationDate,
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  final int bookId;
  final Text title;
  final Text author;
  final Text description;
  final Url image;
  final DateTime? publicationDate;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  EditBookState copyWith({
    Text? title,
    Text? author,
    Text? description,
    Url? image,
    DateTime? publicationDate,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return EditBookState(
      bookId: this.bookId,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      image: image ?? this.image,
      publicationDate: publicationDate ?? this.publicationDate,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        title,
        author,
        description,
        image,
        publicationDate,
        status,
        isValid,
        errorMessage,
      ];
}
