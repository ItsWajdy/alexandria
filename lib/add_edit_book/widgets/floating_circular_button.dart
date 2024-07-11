import 'package:flutter/material.dart';

class FloatingCircularButton extends StatelessWidget {
  final double size;
  final void Function() onClicked;
  final Widget child;

  const FloatingCircularButton({
    super.key,
    required this.size,
    required this.onClicked,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0), child: child),
      ),
    );
  }
}
