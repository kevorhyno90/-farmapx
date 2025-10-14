import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/employee.dart';
import '../widgets/csv_input_dialog.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Employees'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final csv = context.read<AppState>().exportEmployeesCsv();
              showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(csv)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
              if (csv != null) {
                final count = await context.read<AppState>().importEmployeesCsvAndSave(csv);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported $count employees')));
              }
            })
      ]),
      body: ListView.builder(
        itemCount: app.employees.length,
        itemBuilder: (context, idx) {
          final e = app.employees[idx];
          return ListTile(
            title: Text(e.name),
            subtitle: Text(e.role),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteEmployee(e.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          await app.addEmployee(Employee(id: id, name: 'Employee $id', role: 'worker'));
        },
      ),
    );
  }
}
