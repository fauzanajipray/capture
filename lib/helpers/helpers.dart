import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showDialogMsg(BuildContext mainContext, String errorMessage,
    {String title = 'Error'}) {
  showAdaptiveDialog(
    context: mainContext,
    builder: (context) => AlertDialog(
      scrollable: true,
      title: Text(title),
      content: Text(errorMessage),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

void showDialogConfirmationDelete(BuildContext mainContext, Function onDelete,
    {String title = 'Confirmation',
    String message = 'Are you sure you want to delete this data?',
    String errorBtn = 'Delete'}) {
  showAdaptiveDialog(
    context: mainContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(errorBtn),
          ),
        ],
      );
    },
  );
}

String formatCurrency(dynamic number) {
  if (number is int) {
    return NumberFormat().format(number).replaceAll(',', '.');
  } else if (number is double) {
    return NumberFormat()
        .format(number)
        .replaceAll(',', 'X')
        .replaceAll('.', ',')
        .replaceAll('X', '.');
  } else {
    return '0';
  }
}

String capitalize(String text) {
  return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
}

void showDialogInfo(BuildContext mainContext, Function onYes,
    {String title = 'Info',
    String message = 'Success',
    String errorBtn = 'Ok'}) {
  showAdaptiveDialog(
    context: mainContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onYes();
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary),
            child: Text(errorBtn),
          ),
        ],
      );
    },
  );
}

String extractErrorMessage(dynamic error) {
  if (error is DioException && error.response != null) {
    try {
      final Map<String, dynamic> jsonResponse =
          jsonDecode(error.response.toString());
      var errorMessage = jsonResponse["error"];
      errorMessage ??= jsonResponse["message"];
      return errorMessage ?? "An error occurred";
    } catch (e) {
      return "An error occurred";
    }
  } else {
    return "An error occurred";
  }
}
