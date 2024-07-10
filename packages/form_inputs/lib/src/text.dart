import 'package:formz/formz.dart';

/// Validation errors for the [Text] [FormzInput].
enum TextValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template email}
/// Form input for a text input.
/// {@endtemplate}
class Text extends FormzInput<String, TextValidationError> {
  const Text.pure() : super.pure('');

  const Text.dirty([super.value = '']) : super.dirty();

  static final RegExp _nonEmptyRegExp = RegExp(
    r'(.|\s)*\S(.|\s)*',
  );

  @override
  TextValidationError? validator(String? value) {
    return _nonEmptyRegExp.hasMatch(value ?? '')
        ? null
        : TextValidationError.invalid;
  }
}
