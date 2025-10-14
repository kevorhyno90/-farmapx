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
      appBar: AppBar(title: const Text('Reports'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final csv = context.read<AppState>().exportReportsCsv();
              showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(csv)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
              if (csv != null) {
                final count = await context.read<AppState>().importReportsCsvAndSave(csv);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported $count reports')));
              }
            })
      ]),
      body: ListView(
        children: app.reports.map((r) => ListTile(title: Text(r.name), subtitle: Text(r.generatedAt))).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          // use ReportMeta since AppState/reports use ReportMeta for storage
          await app.addReport(ReportMeta(id: id, name: 'Report $id', generatedAt: DateTime.now().toIso8601String()));
        },
      ),
    );
  }
}
