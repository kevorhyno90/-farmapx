import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/calf.dart';
import '../widgets/csv_input_dialog.dart';
import 'widgets/section_scaffold.dart';

class CalfPage extends StatefulWidget {
  const CalfPage({super.key});

  @override
  State<CalfPage> createState() => _CalfPageState();
}

class _CalfPageState extends State<CalfPage> {

  Widget _overview(BuildContext context, AppState app) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Calves Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Total calves: ${app.calves.length}'),
        ]),
      );

  Widget _list(BuildContext context, AppState app) {
    return ListView.builder(
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
                  final changed = await Navigator.push<Calf?>(context, MaterialPageRoute(builder: (_) => _EditCalfPage(c: c)));
                  if (changed != null) await app.updateCalf(changed);
                }),
            IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteCalf(c.id))
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
          final count = await appState.importCalvesCsvAndSave(csv);
          if (!context.mounted) return;
          messenger.showSnackBar(SnackBar(content: Text('Imported $count calves')));
        },
        child: const Text('Import CSV'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return SectionScaffold(
      title: 'Calves',
      subsections: const ['Overview', 'List', 'CSV'],
      builder: (ctx, sub) {
        if (sub == 'Overview') return _overview(ctx, app);
        if (sub == 'List') return _list(ctx, app);
        return _csv(ctx);
      },
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
