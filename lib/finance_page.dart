import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/transaction.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Finance')),
      body: ListView.builder(
        itemCount: app.transactions.length,
        itemBuilder: (context, idx) {
          final t = app.transactions[idx];
          return ListTile(
            title: Text('${t.category} — \$${t.amount.toStringAsFixed(2)}'),
            subtitle: Text(t.date.toString().split(' ')[0]),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteTransaction(t.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newT = TransactionModel(
            id: id, 
            type: TransactionType.expense, 
            amount: 0.0,
            category: 'General',
          );
          await app.addTransaction(newT);
        },
      ),
    );
  }
}
