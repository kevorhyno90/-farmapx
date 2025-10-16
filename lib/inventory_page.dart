import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/inventory_item.dart';
import '../widgets/csv_input_dialog.dart';
import 'widgets/section_scaffold.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  Widget _overview(BuildContext context, AppState app) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Inventory Overview', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(spacing: 12, children: [
          Card(child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Total items: ${app.inventory.length}'))),
          Card(child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Distinct SKUs: ${app.inventory.map((e) => e.sku).toSet().length}'))),
        ])
      ]),
    );
  }

  Widget _list(BuildContext context, AppState app) {
    return ListView.builder(
      itemCount: app.inventory.length,
      itemBuilder: (context, idx) {
        final item = app.inventory[idx];
        return ListTile(
          title: Text(item.name),
          subtitle: Text('${item.quantity} ${item.unit} — ${item.category}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () async {
              final changed = await Navigator.push<InventoryItem?>(context, MaterialPageRoute(builder: (_) => InventoryEditPage(item: item)));
              if (changed != null) await app.updateInventory(changed);
            }),
            IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteInventory(item.id))
          ]),
        );
      },
    );
  }

  Widget _csv(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final appState = context.read<AppState>();
          final messenger = ScaffoldMessenger.of(context);
          final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
          if (csv == null || csv.isEmpty) return;
          final count = await appState.importInventoryCsvAndSave(csv);
          if (!context.mounted) return;
          messenger.showSnackBar(SnackBar(content: Text('Imported $count items')));
        },
        child: const Text('Import CSV'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return SectionScaffold(
      title: 'Inventory',
      subsections: const ['Overview', 'List', 'CSV'],
      builder: (ctx, sub) {
        if (sub == 'Overview') return _overview(ctx, app);
        if (sub == 'List') return _list(ctx, app);
        return _csv(ctx);
      },
    );
  }
}

class _CsvInputDialog extends StatefulWidget {
  const _CsvInputDialog();

  @override
  State<_CsvInputDialog> createState() => _CsvInputDialogState();
}

class _CsvInputDialogState extends State<_CsvInputDialog> {
  final _ctrl = TextEditingController();
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import CSV'),
      content: SizedBox(height: 300, width: 600, child: TextField(controller: _ctrl, maxLines: null, expands: true, decoration: const InputDecoration(hintText: 'Paste CSV here'))),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(context, _ctrl.text), child: const Text('Import'))],
    );
  }
}

class InventoryEditPage extends StatefulWidget {
  final InventoryItem item;
  const InventoryEditPage({required this.item, super.key});

  @override
  State<InventoryEditPage> createState() => _InventoryEditPageState();
}

class _InventoryEditPageState extends State<InventoryEditPage> {
  late final TextEditingController _name;
  late final TextEditingController _sku;
  late final TextEditingController _category;
  late final TextEditingController _quantity;
  late final TextEditingController _unit;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.item.name);
    _sku = TextEditingController(text: widget.item.sku);
    _category = TextEditingController(text: widget.item.category);
    _quantity = TextEditingController(text: widget.item.quantity.toString());
    _unit = TextEditingController(text: widget.item.unit);
  }

  @override
  void dispose() {
    _name.dispose();
    _sku.dispose();
    _category.dispose();
    _quantity.dispose();
    _unit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _sku, decoration: const InputDecoration(labelText: 'SKU')),
          TextField(controller: _category, decoration: const InputDecoration(labelText: 'Category')),
          TextField(controller: _quantity, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
          TextField(controller: _unit, decoration: const InputDecoration(labelText: 'Unit')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final updated = InventoryItem(
                id: widget.item.id,
                name: _name.text,
                sku: _sku.text,
                category: _category.text,
                quantity: int.tryParse(_quantity.text) ?? 0,
                unit: _unit.text,
              );
              Navigator.pop(context, updated);
            },
            child: const Text('Save'),
          )
        ]),
      ),
    );
  }
}
