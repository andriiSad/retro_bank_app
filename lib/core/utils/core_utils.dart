import 'package:flutter/material.dart';
import 'package:retro_bank_app/core/extensions/context_extension.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: context.textTheme.bodyMedium,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}
