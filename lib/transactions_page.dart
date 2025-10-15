import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/transaction.dart';
import '../widgets/csv_input_dialog.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Finance'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final csv = context.read<AppState>().exportTransactionsCsv();
              showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(csv)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
              import 'package:flutter/material.dart';
              import 'package:provider/provider.dart';
              import '../services/app_state.dart';
              import '../models/transaction.dart';
              import '../widgets/csv_input_dialog.dart';

              class TransactionsPage extends StatelessWidget {
                const TransactionsPage({super.key});

                @override
                Widget build(BuildContext context) {
                  final app = context.watch<AppState>();
                  return Scaffold(
                    appBar: AppBar(title: const Text('Finance'), actions: [
                      IconButton(
                          icon: const Icon(Icons.file_download),
                          onPressed: () {
                            final csv = context.read<AppState>().exportTransactionsCsv();
                            showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(csv)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
                          }),
                      IconButton(
                          icon: const Icon(Icons.file_upload),
                          onPressed: () async {
                            final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
                            if (csv != null) {
                              final count = await context.read<AppState>().importTransactionsCsvAndSave(csv);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported $count transactions')));
                            }
                          })
                    ]),
                    body: ListView.builder(
                      itemCount: app.transactions.length,
                      import 'package:flutter/material.dart';
                      import 'package:provider/provider.dart';
                      import '../services/app_state.dart';
                      import '../models/transaction.dart';
                      import '../widgets/csv_input_dialog.dart';

                      class TransactionsPage extends StatelessWidget {
                        const TransactionsPage({super.key});

                        @override
                        Widget build(BuildContext context) {
                          final app = context.watch<AppState>();
                          return Scaffold(
                            appBar: AppBar(title: const Text('Finance'), actions: [
                              IconButton(
                                icon: const Icon(Icons.file_download),
                                onPressed: () {
                                  final csv = context.read<AppState>().exportTransactionsCsv();
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
                                  if (csv != null) {
                                    final count = await context.read<AppState>().importTransactionsCsvAndSave(csv);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported $count transactions')));
                                  }
                                },
                              ),
                            ]),
                            body: ListView.builder(
                              itemCount: app.transactions.length,
                              itemBuilder: (context, idx) {
                                final t = app.transactions[idx];
                                return ListTile(
                                  title: Text('${t.type} • ${t.category}'),
                                  subtitle: Text('${t.amount} ${t.currency}'),
                                  trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteTransaction(t.id)),
                                );
                              },
                            ),
                            floatingActionButton: FloatingActionButton(
                              child: const Icon(Icons.add),
                              onPressed: () async {
                                final id = DateTime.now().millisecondsSinceEpoch.toString();
                                await app.addTransaction(TransactionModel(id: id, type: 'expense', amount: 0.0, currency: 'USD', category: 'General'));
                              },
                            ),
                          );
                        }
                      }
