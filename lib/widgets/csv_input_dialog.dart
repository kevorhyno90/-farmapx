import 'package:flutter/material.dart';

/// Minimal CSV input dialog used by multiple pages.
/// Returns the input CSV string when "Import" is pressed.
class CsvInputDialog extends StatefulWidget {
  const CsvInputDialog({super.key});

  @override
  State<CsvInputDialog> createState() => _CsvInputDialogState();
}

class _CsvInputDialogState extends State<CsvInputDialog> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import CSV'),
      content: SizedBox(
        width: 600,
        child: TextField(
          controller: _ctrl,
          maxLines: 20,
          decoration: const InputDecoration(
            hintText: 'Paste CSV content here',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop<String?>(null),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop<String?>(_ctrl.text),
          child: const Text('Import'),
        ),
      ],
    );
  }
}
