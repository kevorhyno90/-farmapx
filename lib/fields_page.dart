import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/csv_input_dialog.dart';
import '../models/field.dart';

class FieldsPage extends StatelessWidget {
  const FieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Fields'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final csv = context.read<AppState>().exportFieldsCsv();
              showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(csv)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
              if (!context.mounted) return;
              if (csv != null) {
                final messenger = ScaffoldMessenger.of(context);
                final appState = context.read<AppState>();
                final count = await appState.importFieldsCsvAndSave(csv);
                messenger.showSnackBar(SnackBar(content: Text('Imported $count fields')));
              }
            })
      ]),
      body: ListView.builder(
        itemCount: app.fields.length,
        itemBuilder: (context, idx) {
          final f = app.fields[idx];
          return ListTile(
            title: Text(f.name),
            subtitle: Text('${f.areaHa} ha — ${f.soilType}'),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteField(f.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newF = FieldModel(id: id, name: 'New Field');
          await app.addField(newF);
        },
      ),
    );
  }
}
