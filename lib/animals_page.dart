import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
// model types accessed via AppState; no direct import needed here
import '../widgets/csv_input_dialog.dart';
import 'widgets/section_scaffold.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  Widget _overview(BuildContext context, AppState app) {
    // Simple KPI cards
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 12, runSpacing: 12, children: [
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text('Animals', style: Theme.of(context).textTheme.titleMedium), Text('${app.animals.length}', style: Theme.of(context).textTheme.headlineMedium)]))),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text('Calves', style: Theme.of(context).textTheme.titleMedium), Text('${app.calves.length}', style: Theme.of(context).textTheme.headlineMedium)]))),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text('Poultry', style: Theme.of(context).textTheme.titleMedium), Text('${app.poultry.length}', style: Theme.of(context).textTheme.headlineMedium)]))),
        ])
      ]),
    );
  }

  Widget _list(BuildContext context, AppState app) {
    return ListView.builder(
      itemCount: app.animals.length,
      itemBuilder: (context, idx) {
        final a = app.animals[idx];
        return ListTile(
          title: Text(a.tag),
          subtitle: Text('${a.species} • ${a.breed}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.visibility), onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: Text(a.tag), content: Text('Species: ${a.species}\nBreed: ${a.breed}'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]))),
            IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteAnimal(a.id)),
          ]),
        );
      },
    );
  }

  Widget _csv(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // capture needed objects synchronously to avoid using BuildContext across async gaps
          final appState = context.read<AppState>();
          final messenger = ScaffoldMessenger.of(context);
          final csv = await showDialog<String?>(context: context, builder: (_) => const CsvInputDialog());
          if (csv == null || csv.isEmpty) return;
          final count = await appState.importAnimalsCsvAndSave(csv);
          if (!context.mounted) return;
          messenger.showSnackBar(SnackBar(content: Text('Imported $count animals')));
        },
        child: const Text('Import CSV'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return SectionScaffold(
      title: 'Animals',
      subsections: const ['Overview', 'List', 'CSV'],
      builder: (ctx, sub) {
        if (sub == 'Overview') return _overview(ctx, app);
        if (sub == 'List') return _list(ctx, app);
        return _csv(ctx);
      },
    );
  }
}
