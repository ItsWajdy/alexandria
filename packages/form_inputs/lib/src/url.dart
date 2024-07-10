import 'package:formz/formz.dart';

/// Validation errors for the [URL] [FormzInput].
enum UrlValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template email}
/// Form input for a URL input.
/// {@endtemplate}
class Url extends FormzInput<String, UrlValidationError> {
  const Url.pure() : super.pure('');

  const Url.dirty([super.value = '']) : super.dirty();

  static final RegExp _urlRegExp = RegExp(
    r'(http[s]?:\/\/)?([^\/\s]+\/)(.*)',
  );

  @override
  UrlValidationError? validator(String? value) {
    return _urlRegExp.hasMatch(value ?? '') ? null : UrlValidationError.invalid;
  }
}
