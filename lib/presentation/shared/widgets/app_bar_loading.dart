import 'package:flutter/material.dart';

import 'loading_view.dart';

class AppBarLoading extends StatelessWidget {
  const AppBarLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingView(
        color: Colors.white,
        size: 20.0,
        strokeWidth: 3.0,
      ),
    );
  }
}
