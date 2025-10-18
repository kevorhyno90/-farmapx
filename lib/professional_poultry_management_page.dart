import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/app_state.dart';
import '../models/poultry.dart';

class ProfessionalPoultryManagementPage extends StatefulWidget {
  const ProfessionalPoultryManagementPage({super.key});

  @override
  State<ProfessionalPoultryManagementPage> createState() => _ProfessionalPoultryManagementPageState();
}

class _ProfessionalPoultryManagementPageState extends State<ProfessionalPoultryManagementPage> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _selectedSpecies;
  String? _selectedPurpose;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(app),
          _buildNavigationTabs(),
          _buildSearchAndFilters(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildOverview(app),
                _buildPoultryList(app),
                _buildHealthManagement(app),
                _buildEggProduction(app),
                _buildFeedManagement(app),
                _buildReports(app),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 ? FloatingActionButton.extended(
        onPressed: () => _showAddPoultryDialog(context, app),
        icon: const Icon(Icons.add),
        label: const Text('Add Bird'),
        backgroundColor: Colors.orange[600],
      ) : null,
    );
  }

  Widget _buildHeader(AppState app) {
    final totalBirds = app.poultry.length;
    final layingHens = app.poultry.where((p) => p.purpose == 'Egg Production').length;
    final broilers = app.poultry.where((p) => p.purpose == 'Meat Production').length;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange[700]!, Colors.orange[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flutter_dash, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Poultry Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Comprehensive poultry production and health management',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Birds', totalBirds.toString(), Icons.flutter_dash)),
              const SizedBox(width: 4),
              Expanded(child: _buildStatCard('Layers', layingHens.toString(), Icons.egg)),
              const SizedBox(width: 4),
              Expanded(child: _buildStatCard('Broilers', broilers.toString(), Icons.restaurant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTabs() {
    final tabs = [
      {'title': 'Overview', 'icon': Icons.dashboard},
      {'title': 'Birds', 'icon': Icons.flutter_dash},
      {'title': 'Health', 'icon': Icons.medical_services},
      {'title': 'Eggs', 'icon': Icons.egg_alt},
      {'title': 'Feed', 'icon': Icons.restaurant},
      {'title': 'Reports', 'icon': Icons.assessment},
    ];

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedIndex == index;

          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedIndex = index),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.orange[600]! : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      color: isSelected ? Colors.orange[600] : Colors.grey[600],
                      size: 12,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      tab['title'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.orange[600] : Colors.grey[600],
                        fontSize: 8,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 32,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search poultry...',
                  prefixIcon: Icon(Icons.search, size: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                style: const TextStyle(fontSize: 12),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: _selectedSpecies,
                hint: Text('Species', style: TextStyle(fontSize: 10)),
                items: [
                  DropdownMenuItem(value: null, child: Text('All', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Chicken', child: Text('Chicken', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Duck', child: Text('Duck', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Turkey', child: Text('Turkey', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Goose', child: Text('Goose', style: TextStyle(fontSize: 10))),
                ],
                onChanged: (value) => setState(() => _selectedSpecies = value),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: _selectedPurpose,
                hint: Text('Purpose', style: TextStyle(fontSize: 10)),
                items: [
                  DropdownMenuItem(value: null, child: Text('All', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Egg Production', child: Text('Layers', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Meat Production', child: Text('Broilers', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Breeding', child: Text('Breeding', style: TextStyle(fontSize: 10))),
                ],
                onChanged: (value) => setState(() => _selectedPurpose = value),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCards(app),
          const SizedBox(height: 8),
          _buildProductionMetrics(app),
          const SizedBox(height: 8),
          _buildRecentActivity(app),
          const SizedBox(height: 8),
          _buildUpcomingTasks(app),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(AppState app) {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Daily Eggs',
            '247 eggs',
            Icons.egg_alt,
            Colors.amber[600]!,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildOverviewCard(
            'Laying Rate',
            '87.5%',
            Icons.trending_up,
            Colors.green[600]!,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildOverviewCard(
            'Mortality',
            '0.2%',
            Icons.favorite,
            Colors.red[600]!,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 8,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductionMetrics(AppState app) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Production Metrics',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem('Feed Conversion', '2.1:1', Icons.restaurant),
                ),
                Expanded(
                  child: _buildMetricItem('Avg Weight', '1.8 kg', Icons.scale),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem('Egg Weight', '58.2g', Icons.egg),
                ),
                Expanded(
                  child: _buildMetricItem('Hatch Rate', '92%', Icons.child_care),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.orange[600]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 8, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPoultryList(AppState app) {
    final filteredPoultry = app.poultry.where((bird) {
      final matchesSearch = _searchQuery.isEmpty ||
          bird.tag.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          bird.species.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSpecies = _selectedSpecies == null || bird.species == _selectedSpecies;
      final matchesPurpose = _selectedPurpose == null || bird.purpose == _selectedPurpose;
      return matchesSearch && matchesSpecies && matchesPurpose;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredPoultry.length,
      itemBuilder: (context, index) {
        final bird = filteredPoultry[index];
        return _buildPoultryCard(bird, app);
      },
    );
  }

  Widget _buildPoultryCard(Poultry bird, AppState app) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getSpeciesColor(bird.species).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getSpeciesIcon(bird.species),
                color: _getSpeciesColor(bird.species),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bird.tag,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    '${bird.species} • ${bird.breed}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                  Text(
                    '${bird.sex} • Born: ${bird.dob}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getPurposeColor(bird.purpose).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                bird.purpose,
                style: TextStyle(
                  color: _getPurposeColor(bird.purpose),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.edit, size: 16),
                    title: Text('Edit', style: TextStyle(fontSize: 12)),
                    dense: true,
                  ),
                  onTap: () => _showEditPoultryDialog(context, bird, app),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.egg, size: 16),
                    title: Text('Production', style: TextStyle(fontSize: 12)),
                    dense: true,
                  ),
                  onTap: () => _showProductionDialog(context, bird),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.medical_services, size: 16),
                    title: Text('Health', style: TextStyle(fontSize: 12)),
                    dense: true,
                  ),
                  onTap: () => _showHealthDialog(context, bird),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.delete, size: 16, color: Colors.red),
                    title: Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red)),
                    dense: true,
                  ),
                  onTap: () => _showDeleteDialog(context, bird, app),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSpeciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'chicken':
        return Icons.flutter_dash;
      case 'duck':
        return Icons.pets;
      case 'turkey':
        return Icons.flutter_dash;
      case 'goose':
        return Icons.pets;
      default:
        return Icons.flutter_dash;
    }
  }

  Color _getSpeciesColor(String species) {
    switch (species.toLowerCase()) {
      case 'chicken':
        return Colors.orange;
      case 'duck':
        return Colors.blue;
      case 'turkey':
        return Colors.brown;
      case 'goose':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  Color _getPurposeColor(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'egg production':
        return Colors.amber;
      case 'meat production':
        return Colors.red;
      case 'breeding':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildHealthManagement(AppState app) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Health Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Vaccination programs, disease monitoring, and health protocols',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEggProduction(AppState app) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.egg_alt, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Egg Production',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Daily egg collection, laying rates, and production analytics',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedManagement(AppState app) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Feed Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Feed formulation, consumption tracking, and nutrition optimization',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReports(AppState app) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Reports & Analytics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Production reports, financial analysis, and performance metrics',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(AppState app) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildActivityItem('Eggs collected', '247 eggs', '2 hours ago'),
            _buildActivityItem('Feed distributed', 'Layer feed', '4 hours ago'),
            _buildActivityItem('Health check', 'Broiler batch A', '6 hours ago'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String details, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6, color: Colors.orange[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$activity - $details',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 8, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTasks(AppState app) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Tasks',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildTaskItem('Vaccination', 'Broiler batch B', 'Tomorrow'),
            _buildTaskItem('Egg collection', 'Layer house 1', 'Daily'),
            _buildTaskItem('Health inspection', 'All houses', 'Next week'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String task, String location, String schedule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 12, color: Colors.orange[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$task - $location',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Text(
            schedule,
            style: TextStyle(fontSize: 8, color: Colors.orange[600]),
          ),
        ],
      ),
    );
  }

  void _showAddPoultryDialog(BuildContext context, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Bird'),
        content: Text('Add poultry dialog would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditPoultryDialog(BuildContext context, Poultry bird, AppState app) {
    // Implementation for edit poultry dialog
  }

  void _showProductionDialog(BuildContext context, Poultry bird) {
    // Implementation for production dialog
  }

  void _showHealthDialog(BuildContext context, Poultry bird) {
    // Implementation for health dialog
  }

  void _showDeleteDialog(BuildContext context, Poultry bird, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Bird'),
        content: Text('Are you sure you want to delete ${bird.tag}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              app.deletePoultry(bird.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}