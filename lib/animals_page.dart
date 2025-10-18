import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/animal.dart';
import '../widgets/csv_input_dialog.dart';
import 'widgets/section_scaffold.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(app),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(app),
                _buildAllAnimalsTab(app),
                _buildManagementTab(app),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppState app) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[700]!, Colors.purple[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pets, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Animals Overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Complete farm animal management dashboard',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStatCard('Total Animals', '${app.animals.length}', Icons.pets, Colors.white),
              const SizedBox(width: 8),
              _buildStatCard('Calves', '${app.calves.length}', Icons.child_care, Colors.white),
              const SizedBox(width: 8),
              _buildStatCard('Poultry', '${app.poultry.length}', Icons.flutter_dash, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.purple[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.purple[700],
        tabs: const [
          Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
          Tab(icon: Icon(Icons.list_alt), text: 'All Animals'),
          Tab(icon: Icon(Icons.settings), text: 'Management'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Farm Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Enhanced KPI Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(Icons.pets, size: 28, color: Colors.purple[600]),
                        const SizedBox(height: 6),
                        Text(
                          '${app.animals.length}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                          ),
                        ),
                        Text('Livestock', style: TextStyle(fontSize: 12)),
                        if (app.animals.isNotEmpty)
                          Text(
                            '${_getSpeciesCount(app.animals)} species',
                            style: TextStyle(color: Colors.grey[600], fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(Icons.child_care, size: 28, color: Colors.orange[600]),
                        const SizedBox(height: 6),
                        Text(
                          '${app.calves.length}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                        Text('Calves', style: TextStyle(fontSize: 12)),
                        Text(
                          'Young stock',
                          style: TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(Icons.flutter_dash, size: 28, color: Colors.blue[600]),
                        const SizedBox(height: 6),
                        Text(
                          '${app.poultry.length}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        Text('Poultry', style: TextStyle(fontSize: 12)),
                        Text(
                          'Birds',
                          style: TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Icon(Icons.trending_up, size: 28, color: Colors.green[600]),
                        const SizedBox(height: 6),
                        Text(
                          '${app.animals.length + app.calves.length + app.poultry.length}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Text('Total', style: TextStyle(fontSize: 12)),
                        Text(
                          'All animals',
                          style: TextStyle(color: Colors.grey[600], fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.0,
            children: [
              _buildActionCard(
                'Add Livestock',
                Icons.add_circle,
                Colors.blue,
                () => _showAddAnimalDialog(app),
              ),
              _buildActionCard(
                'Health Check',
                Icons.health_and_safety,
                Colors.green,
                () => _showHealthDialog(),
              ),
              _buildActionCard(
                'Feed Records',
                Icons.restaurant,
                Colors.orange,
                () => _showFeedDialog(),
              ),
              _buildActionCard(
                'Reports',
                Icons.analytics,
                Colors.purple,
                () => _showReportsDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, MaterialColor color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: color[600]),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: color[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllAnimalsTab(AppState app) {
    final allAnimals = <Map<String, dynamic>>[];
    
    // Add livestock
    for (final animal in app.animals) {
      allAnimals.add({
        'type': 'Livestock',
        'data': animal,
        'icon': Icons.agriculture,
        'color': Colors.blue,
      });
    }
    
    // Add calves
    for (final calf in app.calves) {
      allAnimals.add({
        'type': 'Calf',
        'data': calf,
        'icon': Icons.child_care,
        'color': Colors.orange,
      });
    }
    
    // Add poultry
    for (final bird in app.poultry) {
      allAnimals.add({
        'type': 'Poultry',
        'data': bird,
        'icon': Icons.flutter_dash,
        'color': Colors.purple,
      });
    }

    if (allAnimals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No animals yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add your first animal to get started',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showAddAnimalDialog(app),
              icon: const Icon(Icons.add),
              label: const Text('Add Animal'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: allAnimals.length,
      itemBuilder: (context, index) {
        final item = allAnimals[index];
        final type = item['type'] as String;
        final data = item['data'];
        final icon = item['icon'] as IconData;
        final color = item['color'] as MaterialColor;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: color[100],
              child: Icon(icon, color: color[700], size: 18),
            ),
            title: Text(
              _getAnimalTitle(type, data),
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              _getAnimalSubtitle(type, data),
              style: TextStyle(fontSize: 12),
            ),
            trailing: PopupMenuButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _showAnimalDetails(type, data);
                    break;
                  case 'edit':
                    _showEditDialog(type, data, app);
                    break;
                  case 'delete':
                    _showDeleteDialog(type, data, app);
                    break;
                }
              },
            ),
            onTap: () => _showAnimalDetails(type, data),
          ),
        );
      },
    );
  }

  Widget _buildManagementTab(AppState app) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Management Tools',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildManagementCard(
                  'Import Data',
                  'Import animal data from CSV',
                  Icons.upload_file,
                  Colors.blue,
                  () => _showImportDialog(app),
                ),
                _buildManagementCard(
                  'Export Data',
                  'Export all animal data',
                  Icons.download,
                  Colors.green,
                  () => _showExportDialog(),
                ),
                _buildManagementCard(
                  'Bulk Operations',
                  'Perform bulk actions',
                  Icons.checklist,
                  Colors.orange,
                  () => _showBulkDialog(),
                ),
                _buildManagementCard(
                  'Settings',
                  'Configure system settings',
                  Icons.settings,
                  Colors.purple,
                  () => _showSettingsDialog(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard(String title, String description, IconData icon, 
      MaterialColor color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color[600]),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSpeciesCount(List<Animal> animals) {
    return animals.map((a) => a.species).where((s) => s.isNotEmpty).toSet().length;
  }

  String _getAnimalTitle(String type, dynamic data) {
    switch (type) {
      case 'Livestock':
        return data.tag ?? 'Unknown';
      case 'Calf':
        return data.tag ?? 'Unknown';
      case 'Poultry':
        return data.tag ?? 'Unknown';
      default:
        return 'Unknown';
    }
  }

  String _getAnimalSubtitle(String type, dynamic data) {
    switch (type) {
      case 'Livestock':
        return '${data.species} • ${data.breed}';
      case 'Calf':
        return 'Calf • ${data.breed ?? 'Unknown breed'}';
      case 'Poultry':
        return 'Poultry • ${data.breed ?? 'Unknown breed'}';
      default:
        return 'Unknown type';
    }
  }

  void _showAddAnimalDialog(AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Animal'),
        content: const Text('Choose animal type to add'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addLivestock(app);
            },
            child: const Text('Livestock'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addCalf(app);
            },
            child: const Text('Calf'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addPoultry(app);
            },
            child: const Text('Poultry'),
          ),
        ],
      ),
    );
  }

  void _addLivestock(AppState app) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newAnimal = Animal(
      id: id,
      tag: 'LST-$id',
      species: 'Cattle',
      breed: 'Holstein',
    );
    await app.addAnimal(newAnimal);
  }

  void _addCalf(AppState app) async {
    // This would add a calf - implementation depends on your Calf model
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calf management coming soon!')),
    );
  }

  void _addPoultry(AppState app) async {
    // This would add poultry - implementation depends on your Poultry model
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Poultry management coming soon!')),
    );
  }

  void _showHealthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Management'),
        content: const Text('Health tracking system coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Feed Records'),
        content: const Text('Feed tracking system coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reports'),
        content: const Text('Reporting system coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAnimalDetails(String type, dynamic data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getAnimalTitle(type, data)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: $type'),
            Text('Details: ${_getAnimalSubtitle(type, data)}'),
            if (data.id != null) Text('ID: ${data.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String type, dynamic data, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $type'),
        content: Text('Edit functionality for $type coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String type, dynamic data, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete $type'),
        content: Text('Are you sure you want to delete ${_getAnimalTitle(type, data)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (type == 'Livestock') {
                app.deleteAnimal(data.id);
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$type deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(AppState app) async {
    final csv = await showDialog<String?>(
      context: context,
      builder: (_) => const CsvInputDialog(),
    );
    if (csv != null && csv.isNotEmpty) {
      // Handle CSV import
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV import functionality coming soon!')),
      );
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBulkDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Operations'),
        content: const Text('Bulk operations coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Settings panel coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
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


