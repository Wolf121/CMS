import 'package:flutter/material.dart';

class FileUploadProgressDialog extends StatefulWidget {
  final String message;

  FileUploadProgressDialog({required this.message});

  @override
  _FileUploadProgressDialogState createState() =>
      _FileUploadProgressDialogState();
}

class _FileUploadProgressDialogState extends State<FileUploadProgressDialog> {
  bool _showDialog = true;

  void hideDialog() {
    setState(() {
      _showDialog = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showDialog) {
      return Container(); // Return an empty container if the dialog is not visible
    }

    return AlertDialog(
      title: Text("Uploading..."),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(widget.message),
          ],
        ),
      ),
    );
  }
}
