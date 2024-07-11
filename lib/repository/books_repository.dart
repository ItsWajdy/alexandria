import 'dart:async';
import 'package:alexandria/api_service/api_response.dart';
import 'package:alexandria/api_service/books_api_service.dart';
import 'package:alexandria/repository/models/models.dart';

/// Thrown when the BooksApiService returns an error.
class ApiServiceException implements Exception {
  const ApiServiceException(this.message);

  factory ApiServiceException.fromMessage(String message) {
    switch (message) {
      case 'Hive was not correctly initialized':
        return const ApiServiceException(
          'Our servers are having some issues.',
        );
      case 'Book Already Exists':
        return const ApiServiceException(
          'This book already exists.',
        );
      case 'Book Not In Database':
        return const ApiServiceException(
          'Could not find this book in database.',
        );
      case 'Bad Request Error':
        return const ApiServiceException(
          'Please make sure you have entered all required information.',
        );
      default:
        return const ApiServiceException('Unknown error.');
    }
  }

  /// The associated error message.
  final String message;
}

class BooksRepository {
  BooksRepository({BooksApiService? booksApiService})
      : _booksApiService = booksApiService ?? BooksApiService();

  final BooksApiService _booksApiService;
  static const _allBooksEndpoint = '/books';
  static const _bookDetailsEndpoint = '/books/details';
  static const _newBookEndpoint = '/books/add';
  static const _editBookEndpoint = '/books';
  static const _deleteBookEndpoint = '/books';

  Future<List<Book>> fetchAllBooks() async {
    ApiResponse response = await _booksApiService.request(
        requestType: RequestType.get, endpoint: _allBooksEndpoint);

    if (response.status == ResponseStatus.error) {
      throw ApiServiceException.fromMessage(response.data['message']);
    }

    return List<Book>.from(
        response.data['result'].map((jsonBook) => Book.fromJson(jsonBook)));
  }

  Future<Book> fetchBookDetails({required int id}) async {
    ApiResponse response = await _booksApiService.request(
      requestType: RequestType.get,
      endpoint: _bookDetailsEndpoint,
      parameters: {'id': id},
    );

    if (response.status == ResponseStatus.error) {
      throw ApiServiceException.fromMessage(response.data['message']);
    }

    return Book.fromJson(response.data['result']);
  }

  Future<void> addNewBook({
    required String title,
    required String author,
    required String description,
    required String image,
    required String publicationDate,
  }) async {
    ApiResponse response = await _booksApiService.request(
      requestType: RequestType.post,
      endpoint: _newBookEndpoint,
      body: {
        'title': title,
        'author': author,
        'description': description,
        'cover_image_path': image,
        'publication_date': publicationDate,
      },
    );

    if (response.status == ResponseStatus.error) {
      throw ApiServiceException.fromMessage(response.data['message']);
    }
  }

  Future<void> editBook({
    required int id,
    required String title,
    required String author,
    required String description,
    required String image,
    required String publicationDate,
  }) async {
    ApiResponse response = await _booksApiService.request(
      requestType: RequestType.patch,
      endpoint: _editBookEndpoint,
      body: {
        'id': id,
        'title': title,
        'author': author,
        'description': description,
        'cover_image_path': image,
        'publication_date': publicationDate,
      },
    );

    if (response.status == ResponseStatus.error) {
      // TODO create exception
      throw Exception();
    }
  }

  Future<void> deleteBook({required int id}) async {
    ApiResponse response = await _booksApiService.request(
      requestType: RequestType.delete,
      endpoint: _deleteBookEndpoint,
      body: {
        'id': id,
      },
    );

    if (response.status == ResponseStatus.error) {
      throw ApiServiceException.fromMessage(response.data['message']);
    }
  }
}
