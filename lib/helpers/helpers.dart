import 'package:flutter/material.dart';

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
