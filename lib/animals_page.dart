import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/animal.dart';
import '../widgets/csv_input_dialog.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Animals'), actions: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () {
            final csv = context.read<AppState>().exportAnimalsCsv();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Export CSV'),
                content: SingleChildScrollView(child: SelectableText(csv)),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_upload),
          onPressed: () async {
            final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
            if (!context.mounted) return;
            if (csv != null && csv.isNotEmpty) {
              final messenger = ScaffoldMessenger.of(context);
              final appState = context.read<AppState>();
              final count = await appState.importAnimalsCsvAndSave(csv);
              messenger.showSnackBar(SnackBar(content: Text('Imported $count animals')));
            }
          },
        ),
      ]),
      body: ListView.builder(
        itemCount: app.animals.length,
        itemBuilder: (context, idx) {
          final a = app.animals[idx];
          return ListTile(
            title: Text(a.tag),
            subtitle: Text('${a.species} • ${a.breed}'),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteAnimal(a.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          await app.addAnimal(Animal(id: id, tag: 'T$id', species: 'cow', breed: 'unknown'));
        },
      ),
    );
  }
}
