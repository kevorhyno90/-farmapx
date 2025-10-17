import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/animal.dart';

class LivestockPage extends StatefulWidget {
  const LivestockPage({super.key});

  @override
  State<LivestockPage> createState() => _LivestockPageState();
}

class _LivestockPageState extends State<LivestockPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _selectedSpecies;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final filteredAnimals = _getFilteredAnimals(app.animals);
    
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(app),
          _buildSearchAndFilters(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(app),
                _buildAnimalListTab(filteredAnimals, app),
                _buildHealthStatusTab(filteredAnimals),
                _buildReportsTab(app),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAnimalDialog(app),
        icon: const Icon(Icons.add),
        label: const Text('Add Livestock'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }

  Widget _buildHeader(AppState app) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.agriculture, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Livestock Management',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Professional livestock tracking',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Total Animals', '${app.animals.length}', Icons.pets),
              const SizedBox(width: 12),
              _buildStatCard('Active', '${app.animals.where((a) => a.species.isNotEmpty).length}', Icons.check_circle),
              const SizedBox(width: 12),
              _buildStatCard('Species', '${_getUniqueSpecies(app.animals).length}', Icons.category),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey[50],
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search animals...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All Species', null),
                _buildFilterChip('Cattle', 'Cattle'),
                _buildFilterChip('Sheep', 'Sheep'),
                _buildFilterChip('Goats', 'Goats'),
                _buildFilterChip('Pigs', 'Pigs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? species) {
    final isSelected = _selectedSpecies == species;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedSpecies = selected ? species : null);
        },
        selectedColor: Colors.blue[100],
        checkmarkColor: Colors.blue[700],
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.blue[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.blue[700],
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        tabs: const [
          Tab(icon: Icon(Icons.dashboard, size: 20), text: 'Overview'),
          Tab(icon: Icon(Icons.list, size: 20), text: 'Animals'),
          Tab(icon: Icon(Icons.health_and_safety, size: 20), text: 'Health'),
          Tab(icon: Icon(Icons.analytics), text: 'Reports'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AppState app) {
    final species = _getSpeciesBreakdown(app.animals);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Livestock Overview',
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
              children: species.entries.map((entry) {
                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getSpeciesIcon(entry.key),
                          size: 48,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${entry.value}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalListTab(List<Animal> animals, AppState app) {
    if (animals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No animals found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first livestock to get started',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(
                _getSpeciesIcon(animal.species),
                color: Colors.blue[700],
              ),
            ),
            title: Text(
              animal.tag,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${animal.species} • ${animal.breed}'),
                Text(
                  'ID: ${animal.id.substring(0, 8)}...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
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
                  value: 'health',
                  child: Row(
                    children: [
                      Icon(Icons.health_and_safety),
                      SizedBox(width: 8),
                      Text('Health Records'),
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
                  case 'edit':
                    _showEditAnimalDialog(animal, app);
                    break;
                  case 'health':
                    _showHealthRecordsDialog(animal);
                    break;
                  case 'delete':
                    _showDeleteConfirmation(animal, app);
                    break;
                }
              },
            ),
            onTap: () => _showAnimalDetails(animal),
          ),
        );
      },
    );
  }

  Widget _buildHealthStatusTab(List<Animal> animals) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Status Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[600], size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '${animals.length}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Text('Healthy'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[600], size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                        Text('Needs Attention'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.local_hospital, color: Colors.red[600], size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '0',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        Text('Treatment'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Health Activities',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medical_services, 
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No health records yet',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Add health record functionality
                              },
                              child: const Text('Add Health Record'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab(AppState app) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Livestock Reports & Analytics',
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
                _buildReportCard(
                  'Population Report',
                  'View detailed population statistics',
                  Icons.bar_chart,
                  Colors.blue,
                ),
                _buildReportCard(
                  'Health Summary',
                  'Health status and vaccination records',
                  Icons.health_and_safety,
                  Colors.green,
                ),
                _buildReportCard(
                  'Breeding Report',
                  'Reproduction and breeding statistics',
                  Icons.family_restroom,
                  Colors.purple,
                ),
                _buildReportCard(
                  'Financial Report',
                  'Cost analysis and revenue tracking',
                  Icons.monetization_on,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String description, IconData icon, MaterialColor color) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          // Navigate to specific report
        },
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

  List<Animal> _getFilteredAnimals(List<Animal> animals) {
    return animals.where((animal) {
      final matchesSearch = _searchQuery.isEmpty ||
          animal.tag.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          animal.species.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          animal.breed.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesSpecies = _selectedSpecies == null || animal.species == _selectedSpecies;
      
      return matchesSearch && matchesSpecies;
    }).toList();
  }

  Map<String, int> _getSpeciesBreakdown(List<Animal> animals) {
    final breakdown = <String, int>{};
    for (final animal in animals) {
      final species = animal.species.isEmpty ? 'Unknown' : animal.species;
      breakdown[species] = (breakdown[species] ?? 0) + 1;
    }
    return breakdown;
  }

  Set<String> _getUniqueSpecies(List<Animal> animals) {
    return animals.map((a) => a.species).where((s) => s.isNotEmpty).toSet();
  }

  IconData _getSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'cattle':
        return Icons.agriculture;
      case 'sheep':
        return Icons.pets;
      case 'goats':
        return Icons.pets;
      case 'pigs':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }

  void _showAddAnimalDialog(AppState app) {
    final formKey = GlobalKey<FormState>();
    String tag = '';
    String species = 'Cattle';
    String breed = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Livestock'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tag/ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Please enter a tag' : null,
                onSaved: (value) => tag = value ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: species,
                decoration: const InputDecoration(
                  labelText: 'Species',
                  border: OutlineInputBorder(),
                ),
                items: ['Cattle', 'Sheep', 'Goats', 'Pigs'].map((s) => 
                  DropdownMenuItem(value: s, child: Text(s))
                ).toList(),
                onChanged: (value) => species = value ?? 'Cattle',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => breed = value ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                formKey.currentState?.save();
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final newAnimal = Animal(
                  id: id,
                  tag: tag,
                  species: species,
                  breed: breed,
                );
                await app.addAnimal(newAnimal);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditAnimalDialog(Animal animal, AppState app) {
    final formKey = GlobalKey<FormState>();
    String tag = animal.tag;
    String species = animal.species;
    String breed = animal.breed;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Livestock'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: tag,
                decoration: const InputDecoration(
                  labelText: 'Tag/ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Please enter a tag' : null,
                onSaved: (value) => tag = value ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: species.isEmpty ? 'Cattle' : species,
                decoration: const InputDecoration(
                  labelText: 'Species',
                  border: OutlineInputBorder(),
                ),
                items: ['Cattle', 'Sheep', 'Goats', 'Pigs'].map((s) => 
                  DropdownMenuItem(value: s, child: Text(s))
                ).toList(),
                onChanged: (value) => species = value ?? 'Cattle',
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: breed,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => breed = value ?? '',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                formKey.currentState?.save();
                final updatedAnimal = Animal(
                  id: animal.id,
                  tag: tag,
                  species: species,
                  breed: breed,
                );
                // Update functionality coming soon
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Update functionality coming soon!')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Animal animal, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Livestock'),
        content: Text('Are you sure you want to delete ${animal.tag}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              app.deleteAnimal(animal.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAnimalDetails(Animal animal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(animal.tag),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Species: ${animal.species}'),
            Text('Breed: ${animal.breed}'),
            Text('ID: ${animal.id}'),
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

  void _showHealthRecordsDialog(Animal animal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Health Records - ${animal.tag}'),
        content: const Text('Health record management coming soon!'),
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
