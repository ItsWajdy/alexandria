import 'dart:async';
import 'package:alexandria/api_service/api_response.dart';
import 'package:alexandria/api_service/books_api_service.dart';
import 'package:alexandria/repository/models/models.dart';

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
      // TODO create exception
      throw Exception();
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
      // TODO create exception
      throw Exception();
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
      // TODO create exception
      throw Exception();
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
      // TODO create exception
      throw Exception();
    }
  }
}
