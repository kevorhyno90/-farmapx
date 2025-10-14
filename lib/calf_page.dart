import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/calf.dart';
import '../widgets/csv_input_dialog.dart';

class CalfPage extends StatelessWidget {
  const CalfPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Calves'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final csv = context.read<AppState>().exportCalvesCsv();
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                          title: const Text('Export CSV'),
                          content:
                              SingleChildScrollView(child: SelectableText(csv)),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'))
                          ]));
            }),
        IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: () async {
              final csv = await showDialog<String?>(
                  context: context, builder: (_) => const CsvInputDialog());
              if (csv != null) {
                final count =
                    await context.read<AppState>().importCalvesCsvAndSave(csv);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Imported $count calves')));
              }
            })
      ]),
      body: ListView.builder(
        itemCount: app.calves.length,
        itemBuilder: (context, idx) {
          final c = app.calves[idx];
          return ListTile(
            title: Text(c.tag),
            subtitle: Text('${c.sex} • ${c.dob}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final changed = await Navigator.push<Calf?>(context,
                        MaterialPageRoute(builder: (_) => _EditCalfPage(c: c)));
                    if (changed != null) await app.updateCalf(changed);
                  }),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => app.deleteCalf(c.id))
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newC = Calf(id: id, tag: 'Calf $id');
          final created = await Navigator.push<Calf?>(context,
              MaterialPageRoute(builder: (_) => _EditCalfPage(c: newC)));
          if (created != null) await app.addCalf(created);
        },
      ),
    );
  }
}

class _EditCalfPage extends StatefulWidget {
  final Calf c;
  const _EditCalfPage({required this.c});
  @override
  State<_EditCalfPage> createState() => _EditCalfPageState();
}

class _EditCalfPageState extends State<_EditCalfPage> {
  late TextEditingController tagCtrl;
  late TextEditingController damCtrl;
  late TextEditingController sireCtrl;
  late TextEditingController dobCtrl;
  late TextEditingController sexCtrl;
  late TextEditingController statusCtrl;

  @override
  void initState() {
    super.initState();
    tagCtrl = TextEditingController(text: widget.c.tag);
    damCtrl = TextEditingController(text: widget.c.damId);
    sireCtrl = TextEditingController(text: widget.c.sireId);
    dobCtrl = TextEditingController(text: widget.c.dob);
    sexCtrl = TextEditingController(text: widget.c.sex);
    statusCtrl = TextEditingController(text: widget.c.status);
  }

  @override
  void dispose() {
    tagCtrl.dispose();
    damCtrl.dispose();
    sireCtrl.dispose();
    dobCtrl.dispose();
    sexCtrl.dispose();
    statusCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Calf')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
              controller: tagCtrl,
              decoration: const InputDecoration(labelText: 'Tag')),
          TextField(
              controller: damCtrl,
              decoration: const InputDecoration(labelText: 'Dam ID')),
          TextField(
              controller: sireCtrl,
              decoration: const InputDecoration(labelText: 'Sire ID')),
          TextField(
              controller: dobCtrl,
              decoration: const InputDecoration(labelText: 'DOB (ISO)')),
          TextField(
              controller: sexCtrl,
              decoration: const InputDecoration(labelText: 'Sex')),
          TextField(
              controller: statusCtrl,
              decoration: const InputDecoration(labelText: 'Status')),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () {
                final updated = Calf(
                    id: widget.c.id,
                    tag: tagCtrl.text,
                    damId: damCtrl.text,
                    sireId: sireCtrl.text,
                    dob: dobCtrl.text,
                    sex: sexCtrl.text,
                    status: statusCtrl.text);
                Navigator.pop(context, updated);
              },
              child: const Text('Save'))
        ]),
      ),
    );
  }
}
