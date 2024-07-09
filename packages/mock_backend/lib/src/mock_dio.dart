import 'package:dio/dio.dart';
import 'package:mock_backend/src/database/database.dart';
import 'package:mocktail/mocktail.dart';

/// Exception thrown when the Dio request is not as expected.
class BadRequestException implements Exception {
  const BadRequestException([
    this.message = 'Bad Request Error',
  ]);

  /// The associated error message.
  final String message;
}

/*
  Mock of Dio
  TODO write documentation
*/
class MockDio extends Mock implements Dio {
  static Future<void> init() async {
    await Database.init();
  }

  MockDio() {
    when(() => get(
          '/books',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(_onBooksRequested);
    when(() => post(
          '/books/add',
          data: captureAny(named: 'data'),
          queryParameters: captureAny(named: 'queryParameters'),
        )).thenAnswer(_onAddBookRequested);
    when(() => patch(
          '/books',
          data: captureAny(named: 'data'),
          queryParameters: captureAny(named: 'queryParameters'),
        )).thenAnswer(_onEditBookRequested);
    when(() => delete(
          '/books',
          data: captureAny(named: 'data'),
          queryParameters: captureAny(named: 'queryParameters'),
        )).thenAnswer(_onDeleteBookRequested);
  }

  /// Mock request to return all books in database
  Future<Response<dynamic>> _onBooksRequested(Invocation invocation) async {
    try {
      List<DatabaseBook> allBooks = Database.getAll();
      return Response(
        requestOptions: RequestOptions(),
        data: {
          'success': true,
          'result': allBooks.map((e) => e.toJson()),
        },
        statusCode: 200,
      );
    } on BadRequestException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 400,
      );
    } on DatabaseException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 500,
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': 'Unknown Error Occurred'},
        statusCode: 500,
      );
    }
  }

  /// Mock request to add book to database request
  Future<Response<dynamic>> _onAddBookRequested(Invocation invocation) async {
    try {
      Map<String, dynamic> data = invocation.namedArguments[Symbol('data')];

      // Validate request
      if (!data.containsKey('id') ||
          !data.containsKey('title') ||
          !data.containsKey('author') ||
          !data.containsKey('description') ||
          !data.containsKey('publication_date')) {
        throw BadRequestException();
      }

      await Database.add(DatabaseBook.fromJson(data));

      return Response(
        requestOptions: RequestOptions(),
        data: {
          'success': true,
        },
        statusCode: 200,
      );
    } on BadRequestException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 400,
      );
    } on DatabaseException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 500,
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': 'Unknown Error Occurred'},
        statusCode: 500,
      );
    }
  }

  /// Mock request to edit a book in database
  Future<Response<dynamic>> _onEditBookRequested(Invocation invocation) async {
    try {
      Map<String, dynamic> data = invocation.namedArguments[Symbol('data')];

      // Validate request
      if (!data.containsKey('id') ||
          !data.containsKey('title') ||
          !data.containsKey('author') ||
          !data.containsKey('description') ||
          !data.containsKey('publication_date')) {
        throw BadRequestException();
      }

      await Database.update(DatabaseBook.fromJson(data));

      return Response(
        requestOptions: RequestOptions(),
        data: {
          'success': true,
        },
        statusCode: 200,
      );
    } on BadRequestException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 400,
      );
    } on DatabaseException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 500,
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': 'Unknown Error Occurred'},
        statusCode: 500,
      );
    }
  }

  /// Mock request to delete a book from database
  Future<Response<dynamic>> _onDeleteBookRequested(
      Invocation invocation) async {
    try {
      Map<String, dynamic> data = invocation.namedArguments[Symbol('data')];

      // Validate request
      if (!data.containsKey('id')) {
        throw BadRequestException();
      }

      await Database.delete(data['id']);

      return Response(
        requestOptions: RequestOptions(),
        data: {
          'success': true,
        },
        statusCode: 200,
      );
    } on BadRequestException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 400,
      );
    } on DatabaseException catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': e.message},
        statusCode: 500,
      );
    } catch (e) {
      return Response(
        requestOptions: RequestOptions(),
        data: {'success': false, 'message': 'Unknown Error Occurred'},
        statusCode: 500,
      );
    }
  }
}
