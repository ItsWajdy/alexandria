import 'package:alexandria/repository/models/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookPreview extends StatelessWidget {
  final Book book;

  const BookPreview({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/books/${book.id}');
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 260,
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
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              book.author,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
