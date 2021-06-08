import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget._({
    required this.title,
    required this.message,
    required this.actionLabel,
    this.onActionPressed,
  });

  final String title, message, actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    height: 6.0,
                    width: 88.0,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                title,
                style: theme.textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              Text(message, style: theme.textTheme.subtitle1),
              SizedBox(height: 36),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                      Size(double.maxFinite, 48),
                    ),
                  ),
                  child: Text(actionLabel),
                  onPressed: () {
                    onActionPressed?.call();
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    required String actionLabel,
    VoidCallback? onActionPressed,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheetWidget._(
          title: title,
          message: message,
          actionLabel: actionLabel,
          onActionPressed: onActionPressed,
        );
      },
    );
  }
}
