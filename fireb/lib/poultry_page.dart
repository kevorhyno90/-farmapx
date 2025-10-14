import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:farm_management_app/services/app_state.dart';
import 'package:farm_management_app/models/poultry.dart';
import 'package:farm_management_app/widgets/csv_input_dialog.dart';

class PoultryPage extends StatelessWidget {
  const PoultryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Poultry'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final csv = context.read<AppState>().exportPoultryCsv();
              showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Export CSV'), content: SingleChildScrollView(child: SelectableText(csv)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
              if (csv != null) {
                final count = await context.read<AppState>().importPoultryCsvAndSave(csv);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported $count poultry records')));
              }
            })
      ]),
      body: ListView.builder(
        itemCount: app.poultry.length,
        itemBuilder: (context, idx) {
          final p = app.poultry[idx];
          return ListTile(
            title: Text(p.tag),
            subtitle: Text('${p.species} • ${p.breed}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () async {
                final changed = await Navigator.push<Poultry?>(context, MaterialPageRoute(builder: (_) => _EditPoultryPage(p: p)));
                if (changed != null) await app.updatePoultry(changed);
              }),
              IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deletePoultry(p.id))
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newP = Poultry(id: id, tag: 'P$id');
          final created = await Navigator.push<Poultry?>(context, MaterialPageRoute(builder: (_) => _EditPoultryPage(p: newP)));
          if (created != null) await app.addPoultry(created);
        },
      ),
    );
  }
}

class _EditPoultryPage extends StatefulWidget {
  final Poultry p;
  const _EditPoultryPage({required this.p});
  @override
  State<_EditPoultryPage> createState() => _EditPoultryPageState();
}

class _EditPoultryPageState extends State<_EditPoultryPage> {
  late TextEditingController tagCtrl;
  late TextEditingController speciesCtrl;
  late TextEditingController breedCtrl;
  late TextEditingController dobCtrl;
  late TextEditingController sexCtrl;
  late TextEditingController purposeCtrl;

  @override
  void initState() {
    super.initState();
    tagCtrl = TextEditingController(text: widget.p.tag);
    speciesCtrl = TextEditingController(text: widget.p.species);
    breedCtrl = TextEditingController(text: widget.p.breed);
    dobCtrl = TextEditingController(text: widget.p.dob);
    sexCtrl = TextEditingController(text: widget.p.sex);
    purposeCtrl = TextEditingController(text: widget.p.purpose);
  }

  @override
  void dispose() {
    tagCtrl.dispose();
    speciesCtrl.dispose();
    breedCtrl.dispose();
    dobCtrl.dispose();
    sexCtrl.dispose();
    purposeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Poultry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: 'Tag')),
          TextField(controller: speciesCtrl, decoration: const InputDecoration(labelText: 'Species')),
          TextField(controller: breedCtrl, decoration: const InputDecoration(labelText: 'Breed')),
          TextField(controller: dobCtrl, decoration: const InputDecoration(labelText: 'DOB')),
          TextField(controller: sexCtrl, decoration: aconst InputDecoration(labelText: 'Sex')),
          TextField(controller: purposeCtrl, decoration: const InputDecoration(labelText: 'Purpose')),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {
            final u = Poultry(id: widget.p.id, tag: tagCtrl.text, species: speciesCtrl.text, breed: breedCtrl.text, dob: dobCtrl.text, sex: sexCtrl.text, purpose: purposeCtrl.text);
            Navigator.pop(context, u);
          }, child: const Text('Save'))
        ]),
      ),
    );
  }
}
