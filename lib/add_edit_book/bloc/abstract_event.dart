import 'package:equatable/equatable.dart';

sealed class AbstractEvent extends Equatable {
  const AbstractEvent();
}

final class TitleChanged extends AbstractEvent {
  final String text;

  const TitleChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class AuthorChanged extends AbstractEvent {
  final String text;

  const AuthorChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class DescriptionChanged extends AbstractEvent {
  final String text;

  const DescriptionChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class ImageChanged extends AbstractEvent {
  final String text;

  const ImageChanged({required this.text});

  @override
  List<Object?> get props => [text];
}

final class PublicationDateChanged extends AbstractEvent {
  final DateTime date;

  const PublicationDateChanged({required this.date});

  @override
  List<Object?> get props => [date];
}

final class FormSubmitted extends AbstractEvent {
  @override
  List<Object?> get props => [];
}
