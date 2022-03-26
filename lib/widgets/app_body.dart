import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  const AppBody({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/gifs/goodnight.gif'), fit: BoxFit.cover),
      ),
      child: child,
    );
  }
}
