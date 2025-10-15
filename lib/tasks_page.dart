import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/task.dart';
import '../widgets/csv_input_dialog.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final s = context.read<AppState>().exportTasksCsv();
              showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(s)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
              if (!context.mounted) return;
              if (csv != null) {
                final messenger = ScaffoldMessenger.of(context);
                final appState = context.read<AppState>();
                final count = await appState.importTasksCsvAndSave(csv);
                messenger.showSnackBar(SnackBar(content: Text('Imported $count tasks')));
              }
            })
      ]),
      body: ListView.builder(
        itemCount: app.tasks.length,
        itemBuilder: (context, idx) {
          final t = app.tasks[idx];
          return ListTile(
            title: Text(t.title),
            subtitle: Text('${t.status} — ${t.assignedTo}'),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteTask(t.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newT = TaskItem(id: id, title: 'New Task');
          await app.addTask(newT);
        },
      ),
    );
  }
}
