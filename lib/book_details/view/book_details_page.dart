import 'package:alexandria/book_details/widgets/book_preview.dart';
import 'package:alexandria/book_details/widgets/floating_card.dart';
import 'package:alexandria/repository/models/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  // TODO extract all colors into theme
                  color: const Color(0xFFF2EFE5),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: BookPreview(
                      book: book,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: Colors.grey[350],
              ),
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFF4F4F4),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 73.0, left: 15, right: 15),
                    child: Column(
                      children: [
                        Text(
                          'Description',
                          style: theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          book.description,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // TODO extract this card into separate widget
          FloatingCard(
            height: 74,
            width: 250,
            topPosition: height * 5 / 11 - 37,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(book.publicationDate!),
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFFC5AB63),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      'Publish Date',
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'English',
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: const Color(0xFFC5AB63),
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      'Language',
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          FloatingCard(
            height: 65,
            width: 150,
            topPosition: height * 9 / 11,
            children: [
              Expanded(
                flex: 1,
                // TODO change all GestureDetectors to InkWell
                child: InkWell(
                  onTap: () {
                    context.go('/edit', extra: book);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Color(0xFFC5AB63),
                      ),
                      Text(
                        'EDIT',
                        style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(
                thickness: 1,
                color: Colors.grey,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(
                      Icons.delete,
                      color: Color(0xFFC5AB63),
                    ),
                    Text(
                      'DELETE',
                      style: theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
