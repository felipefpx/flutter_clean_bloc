import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
    this.size = 48.0,
    this.strokeWidth = 4.0,
    this.color,
  }) : super(key: key);

  final double size, strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor:
              color != null ? AlwaysStoppedAnimation(Colors.white) : null,
        ),
      ),
    );
  }
}
