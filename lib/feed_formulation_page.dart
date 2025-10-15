import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/feed_formulation.dart';
import '../widgets/csv_input_dialog.dart';

class FeedFormulationPage extends StatelessWidget {
  const FeedFormulationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Feed Formulations'), actions: [
        IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              final csv = context.read<AppState>().exportFeedFormulationsCsv();
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
              if (!context.mounted) return;
              if (csv != null) {
                final messenger = ScaffoldMessenger.of(context);
                final appState = context.read<AppState>();
                final count = await appState.importFeedFormulationsCsvAndSave(csv);
                messenger.showSnackBar(SnackBar(content: Text('Imported $count formulations')));
              }
            })
      ]),
      body: ListView.builder(
        itemCount: app.feedFormulations.length,
        itemBuilder: (context, idx) {
          final f = app.feedFormulations[idx];
          return ListTile(
            title: Text(f.name),
            subtitle: Text(
                'CP: ${f.crudeProteinTarget}% • ME: ${f.metabolisableEnergyTarget} MJ/kg'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final changed = await Navigator.push<FeedFormulation?>(
                        context,
                        MaterialPageRoute(builder: (_) => _EditFeedPage(f: f)));
                    if (changed != null) {
                      await app.updateFeedFormulation(changed);
                    }
                  }),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => app.deleteFeedFormulation(f.id))
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newF = FeedFormulation(id: id, name: 'New formula');
          final created = await Navigator.push<FeedFormulation?>(context,
              MaterialPageRoute(builder: (_) => _EditFeedPage(f: newF)));
          if (created != null) {
            await app.addFeedFormulation(created);
          }
        },
      ),
    );
  }
}

class _EditFeedPage extends StatefulWidget {
  final FeedFormulation f;
  const _EditFeedPage({required this.f});
  @override
  State<_EditFeedPage> createState() => _EditFeedPageState();
}

class _EditFeedPageState extends State<_EditFeedPage> {
  late TextEditingController nameCtrl;
  late TextEditingController cpCtrl;
  late TextEditingController meCtrl;
  late TextEditingController ingredientsCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.f.name);
    cpCtrl =
        TextEditingController(text: widget.f.crudeProteinTarget.toString());
    meCtrl = TextEditingController(
        text: widget.f.metabolisableEnergyTarget.toString());
    ingredientsCtrl = TextEditingController(
        text: widget.f.ingredients.isNotEmpty
            ? jsonEncode(widget.f.ingredients.map((e) => e.toJson()).toList())
            : '[]');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    cpCtrl.dispose();
    meCtrl.dispose();
    ingredientsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Feed Formula')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: cpCtrl,
                decoration: const InputDecoration(
                    labelText: 'Crude Protein Target (%)')),
            TextField(
                controller: meCtrl,
                decoration: const InputDecoration(
                    labelText: 'Metabolisable Energy Target (MJ/kg)')),
            const SizedBox(height: 8),
            const Text('Ingredients (JSON list of {name,percent})'),
            SizedBox(
                height: 200,
                child: TextField(
                    controller: ingredientsCtrl,
                    maxLines: null,
                    expands: true)),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: () {
                  List<FeedIngredient> ing = [];
                  try {
                    final decoded =
                        jsonDecode(ingredientsCtrl.text) as List<dynamic>;
                    ing = decoded
                        .map((e) => FeedIngredient.fromJson(
                            Map<String, dynamic>.from(e)))
                        .toList();
                  } catch (_) {}
                  final updated = FeedFormulation(
                      id: widget.f.id,
                      name: nameCtrl.text,
                      ingredients: ing,
                      crudeProteinTarget: double.tryParse(cpCtrl.text) ?? 0.0,
                      metabolisableEnergyTarget:
                          double.tryParse(meCtrl.text) ?? 0.0);
                  Navigator.pop(context, updated);
                },
                child: const Text('Save'))
          ]),
        ),
      ),
    );
  }
}
