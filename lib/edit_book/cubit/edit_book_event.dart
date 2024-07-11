import 'package:equatable/equatable.dart';

sealed class EditBookEvent extends Equatable {
  const EditBookEvent();
}

final class TitleChanged extends EditBookEvent {
  final String text;

  const TitleChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class AuthorChanged extends EditBookEvent {
  final String text;

  const AuthorChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class DescriptionChanged extends EditBookEvent {
  final String text;

  const DescriptionChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class ImageChanged extends EditBookEvent {
  final String text;

  const ImageChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class PublicationDateChanged extends EditBookEvent {
  final DateTime date;

  const PublicationDateChanged({required this.date});

  @override
  List<Object?> get props => [date];
}

final class FormSubmitted extends EditBookEvent {
  @override
  List<Object?> get props => [];
}
