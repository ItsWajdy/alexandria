import 'package:alexandria/repository/models/models.dart';
import 'package:flutter/material.dart';

class BookEditPreview extends StatelessWidget {
  final Book book;
  final double? height;

  const BookEditPreview({
    super.key,
    required this.book,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(11),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(book.image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              book.title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Text(
            book.author,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
