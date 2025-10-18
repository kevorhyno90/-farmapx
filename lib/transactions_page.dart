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
      appBar: AppBar(title: const Text('Finance', style: TextStyle(fontSize: 20)), actions: [
        IconButton(
          icon: const Icon(Icons.file_download, size: 24),
          onPressed: () {
            final csv = context.read<AppState>().exportTransactionsCsv();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Export CSV', style: TextStyle(fontSize: 18)),
                content: SingleChildScrollView(child: SelectableText(csv, style: TextStyle(fontSize: 14))),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close', style: TextStyle(fontSize: 16)))],
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_upload, size: 24),
          onPressed: () async {
            final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
            if (!context.mounted) return;
              if (csv != null) {
                final messenger = ScaffoldMessenger.of(context);
                final appState = context.read<AppState>();
                final count = await appState.importTransactionsCsvAndSave(csv);
                messenger.showSnackBar(SnackBar(content: Text('Imported $count transactions', style: TextStyle(fontSize: 16))));
              }
          },
        ),
      ]),
      body: ListView.builder(
        itemCount: app.transactions.length,
        itemBuilder: (context, idx) {
          final t = app.transactions[idx];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text('${t.type} • ${t.category}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text('${t.amount} ${t.currency}', style: TextStyle(fontSize: 14)),
            trailing: IconButton(icon: const Icon(Icons.delete, size: 24), onPressed: () => app.deleteTransaction(t.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, size: 28),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          await app.addTransaction(TransactionModel(
            id: id, 
            type: TransactionType.expense, 
            amount: 0.0, 
            currency: 'USD', 
            category: 'General'
          ));
        },
      ),
    );
  }
}

