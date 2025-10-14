import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/animal.dart';

class LivestockPage extends StatelessWidget {
  const LivestockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Livestock')),
      body: ListView.builder(
        itemCount: app.animals.length,
        itemBuilder: (context, idx) {
          final a = app.animals[idx];
          return ListTile(
            title: Text('${a.tag} — ${a.species}'),
            subtitle: Text('${a.breed}'),
            trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => app.deleteAnimal(a.id)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final newA = Animal(id: id, tag: 'TAG-$id');
          await app.addAnimal(newA);
        },
      ),
    );
  }
}
