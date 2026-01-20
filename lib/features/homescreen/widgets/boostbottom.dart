// features/homescreen/widgets/boost_button_widget.dart
import 'package:flutter/material.dart';

class BoostButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const BoostButtonWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      backgroundColor: Colors.amber[600],
      foregroundColor: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      label: Text(
        "2x BOOST",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: theme.colorScheme.onSecondary,
        ),
      ),
      icon: Icon(Icons.bolt, size: 24, color: theme.colorScheme.onSecondary),
      onPressed: onPressed,
    );
  }
}