import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'models/animal.dart';
import 'models/poultry.dart';
import 'models/inventory_item.dart';
import 'models/task_item.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Drawer helper removed; navigation handled via top AppBar buttons

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          TextButton(onPressed: () => Navigator.pushNamed(context, '/animals'), child: const Text('Animals', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/inventory'), child: const Text('Inventory', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/poultry'), child: const Text('Poultry', style: TextStyle(color: Colors.white))),
          TextButton(onPressed: () => Navigator.pushNamed(context, '/crops'), child: const Text('Crops', style: TextStyle(color: Colors.white))),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Close session',
            onPressed: () {
              // Since login was removed, just navigate back to dashboard (refresh)
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: const Text('Animals'),
              subtitle: Text('${app.animals.length} records'),
              leading: const Icon(Icons.pets),
              onTap: () => Navigator.pushNamed(context, '/animals'),
            ),
            ListTile(
              title: const Text('Livestock'),
              subtitle: Text('${app.animals.length} records'),
              leading: const Icon(Icons.grass),
              onTap: () => Navigator.pushNamed(context, '/livestock'),
            ),
            ListTile(
              title: const Text('Poultry'),
              subtitle: Text('${app.poultry.length} records'),
              leading: const Icon(Icons.bug_report),
              onTap: () => Navigator.pushNamed(context, '/poultry'),
            ),
            ListTile(
              title: const Text('Inventory'),
              subtitle: Text('${app.inventory.length} items'),
              leading: const Icon(Icons.inventory),
              onTap: () => Navigator.pushNamed(context, '/inventory'),
            ),
            ListTile(
              title: const Text('Calves'),
              subtitle: Text('${app.calves.length} records'),
              leading: const Icon(Icons.child_care),
              onTap: () => Navigator.pushNamed(context, '/calf'),
            ),
            ListTile(
              title: const Text('Crops'),
              subtitle: Text('${app.crops.length} records'),
              leading: const Icon(Icons.grass),
              onTap: () => Navigator.pushNamed(context, '/crops'),
            ),
            ListTile(
              title: const Text('Fields'),
              subtitle: Text('${app.fields.length} records'),
              leading: const Icon(Icons.landscape),
              onTap: () => Navigator.pushNamed(context, '/fields'),
            ),
            ListTile(
              title: const Text('Feed Formulation'),
              subtitle: Text('${app.feedFormulations.length} formulas'),
              leading: const Icon(Icons.food_bank),
              onTap: () => Navigator.pushNamed(context, '/feed_formulation'),
            ),
            ListTile(
              title: const Text('Tasks'),
              subtitle: Text('${app.tasks.length} tasks'),
              leading: const Icon(Icons.task),
              onTap: () => Navigator.pushNamed(context, '/tasks'),
            ),
            ListTile(
              title: const Text('Transactions'),
              subtitle: Text('${app.transactions.length} records'),
              leading: const Icon(Icons.attach_money),
              onTap: () => Navigator.pushNamed(context, '/transactions'),
            ),
            ListTile(
              title: const Text('Employees'),
              subtitle: Text('${app.employees.length} people'),
              leading: const Icon(Icons.people),
              onTap: () => Navigator.pushNamed(context, '/employees'),
            ),
            ListTile(
              title: const Text('Reports'),
              subtitle: Text('${app.reports.length} reports'),
              leading: const Icon(Icons.insert_chart),
              onTap: () => Navigator.pushNamed(context, '/reports'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.playlist_add),
        label: const Text('Seed data'),
        onPressed: () async {
          final s = context.read<AppState>();
          // Add a couple of items to ensure pages show content
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          await s.addAnimal(Animal(id: 's_a_$id', tag: 'S-$id'));
          await s.addPoultry(Poultry(id: 's_p_$id', tag: 'SP-$id'));
          await s.addInventoryItem(InventoryItem(id: 's_i_$id', name: 'Seed Item $id'));
          await s.addTask(TaskItem(id: 's_t_$id', title: 'Seed task $id'));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seeded some sample data')));
        },
      ),
    );
  }
}
