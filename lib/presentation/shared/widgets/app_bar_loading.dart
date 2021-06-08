import 'package:flutter/material.dart';

class AppBarLoading extends StatelessWidget {
  const AppBarLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
        height: 20.0,
        width: 20.0,
      ),
    );
  }
}
