import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/csv_input_dialog.dart';
import '../models/report.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Reports', style: TextStyle(fontSize: 20)), actions: [
        IconButton(
            icon: const Icon(Icons.file_download, size: 24),
            onPressed: () {
              final csv = context.read<AppState>().exportReportsCsv();
              showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Export CSV', style: TextStyle(fontSize: 18)), 
                content: SingleChildScrollView(child: SelectableText(csv, style: TextStyle(fontSize: 14))), 
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
                final count = await appState.importReportsCsvAndSave(csv);
                messenger.showSnackBar(SnackBar(content: Text('Imported $count reports', style: TextStyle(fontSize: 16))));
              }
            })
      ]),
      body: ListView(
        children: app.reports.map((r) => ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(r.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)), 
          subtitle: Text(r.generatedAt, style: TextStyle(fontSize: 14))
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 28),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          // use ReportMeta since AppState/reports use ReportMeta for storage
          await app.addReport(ReportMeta(id: id, name: 'Report $id', generatedAt: DateTime.now().toIso8601String()));
        },
      ),
    );
  }
}
