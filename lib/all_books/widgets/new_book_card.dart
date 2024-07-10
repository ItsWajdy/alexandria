import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewBookCard extends StatelessWidget {
  const NewBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/new');
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
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 40,
                    ),
                    Text('Add New Book'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
