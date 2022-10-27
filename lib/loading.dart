import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
