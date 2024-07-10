import 'package:flutter/material.dart';

class FloatingCard extends StatelessWidget {
  final double height;
  final double width;
  final double topPosition;
  final List<Widget> children;

  const FloatingCard({
    super.key,
    required this.height,
    required this.width,
    required this.topPosition,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top: topPosition,
      left: (screenWidth - width) / 2,
      child: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.grey[350]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
