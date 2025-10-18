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
      appBar: AppBar(title: const Text('Tasks', style: TextStyle(fontSize: 20)), actions: [
        IconButton(
            icon: const Icon(Icons.file_download, size: 24),
            onPressed: () {
              final s = context.read<AppState>().exportTasksCsv();
              showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Export CSV', style: TextStyle(fontSize: 18)), 
                content: SingleChildScrollView(child: SelectableText(s, style: TextStyle(fontSize: 14))), 
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(fontSize: 16)))]
              ));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload, size: 24),
            onPressed: () async {
              final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
              if (!context.mounted) return;
              if (csv != null) {
                final messenger = ScaffoldMessenger.of(context);
                final appState = context.read<AppState>();
                final count = await appState.importTasksCsvAndSave(csv);
                messenger.showSnackBar(SnackBar(content: Text('Imported $count tasks', style: TextStyle(fontSize: 16))));
              }
            })
      ]),
      body: ListView.builder(
        itemCount: app.tasks.length,
        itemBuilder: (context, idx) {
          final t = app.tasks[idx];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(t.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text('${t.status} — ${t.assignedTo}', style: TextStyle(fontSize: 14)),
            trailing: IconButton(icon: const Icon(Icons.delete, size: 24), onPressed: () => app.deleteTask(t.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 28),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newT = TaskItem(id: id, title: 'New Task');
          await app.addTask(newT);
        },
      ),
    );
  }
}
