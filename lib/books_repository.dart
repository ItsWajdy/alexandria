import 'dart:async';
import 'package:alexandria/api_service/api_response.dart';
import 'package:alexandria/api_service/books_api_service.dart';
import 'package:alexandria/repository/models/models.dart';

class BooksRepository {
  BooksRepository({BooksApiService? booksApiService})
      : _booksApiService = booksApiService ?? BooksApiService();

  final BooksApiService _booksApiService;
  static const _allBooksEndpoint = '/books';

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
}
