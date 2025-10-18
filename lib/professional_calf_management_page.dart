import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/app_state.dart';
import '../models/calf.dart';

class ProfessionalCalfManagementPage extends StatefulWidget {
  const ProfessionalCalfManagementPage({super.key});

  @override
  State<ProfessionalCalfManagementPage> createState() => _ProfessionalCalfManagementPageState();
}

class _ProfessionalCalfManagementPageState extends State<ProfessionalCalfManagementPage> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _selectedStatus;

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
                _buildCalfList(app),
                _buildHealthManagement(app),
                _buildGrowthTracking(app),
                _buildFeedingManagement(app),
                _buildReports(app),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 ? FloatingActionButton.extended(
        onPressed: () => _showAddCalfDialog(context, app),
        icon: const Icon(Icons.add),
        label: const Text('Add Calf'),
        backgroundColor: Colors.blue[600],
      ) : null,
    );
  }

  Widget _buildHeader(AppState app) {
    final totalCalves = app.calves.length;
    final healthyCalves = app.calves.where((c) => c.status == 'Healthy').length;
    final weanedCalves = app.calves.where((c) => c.status == 'Weaned').length;
    
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[700]!, Colors.amber[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.child_care, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Calf Management',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Comprehensive calf care and development tracking',
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
              Expanded(child: _buildStatCard('Total Calves', totalCalves.toString(), Icons.child_care)),
              const SizedBox(width: 4),
              Expanded(child: _buildStatCard('Healthy', healthyCalves.toString(), Icons.health_and_safety)),
              const SizedBox(width: 4),
              Expanded(child: _buildStatCard('Weaned', weanedCalves.toString(), Icons.agriculture)),
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
      {'title': 'Calves', 'icon': Icons.child_care},
      {'title': 'Health', 'icon': Icons.medical_services},
      {'title': 'Growth', 'icon': Icons.trending_up},
      {'title': 'Feeding', 'icon': Icons.restaurant},
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
                      color: isSelected ? Colors.amber[600]! : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      color: isSelected ? Colors.amber[600] : Colors.grey[600],
                      size: 12,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      tab['title'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.amber[600] : Colors.grey[600],
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
                  hintText: 'Search calves...',
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
                value: _selectedStatus,
                hint: Text('Status', style: TextStyle(fontSize: 10)),
                items: [
                  DropdownMenuItem(value: null, child: Text('All', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Healthy', child: Text('Healthy', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Sick', child: Text('Sick', style: TextStyle(fontSize: 10))),
                  DropdownMenuItem(value: 'Weaned', child: Text('Weaned', style: TextStyle(fontSize: 10))),
                ],
                onChanged: (value) => setState(() => _selectedStatus = value),
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
            'Birth Rate',
            '${app.calves.length} born this month',
            Icons.child_care,
            Colors.green[600]!,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildOverviewCard(
            'Mortality Rate',
            '0.5% (Excellent)',
            Icons.favorite,
            Colors.red[600]!,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildOverviewCard(
            'Avg Weight',
            '45.2 kg',
            Icons.scale,
            Colors.blue[600]!,
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

  Widget _buildCalfList(AppState app) {
    final filteredCalves = app.calves.where((calf) {
      final matchesSearch = _searchQuery.isEmpty ||
          calf.tag.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == null || calf.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: filteredCalves.length,
      itemBuilder: (context, index) {
        final calf = filteredCalves[index];
        return _buildCalfCard(calf, app);
      },
    );
  }

  Widget _buildCalfCard(Calf calf, AppState app) {
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
                color: _getStatusColor(calf.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.child_care,
                color: _getStatusColor(calf.status),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    calf.tag,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    '${calf.sex} • Born: ${calf.dob}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                  Text(
                    'Dam: ${calf.damId} • Sire: ${calf.sireId}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(calf.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                calf.status,
                style: TextStyle(
                  color: _getStatusColor(calf.status),
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
                  onTap: () => _showEditCalfDialog(context, calf, app),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.medical_services, size: 16),
                    title: Text('Health Record', style: TextStyle(fontSize: 12)),
                    dense: true,
                  ),
                  onTap: () => _showHealthDialog(context, calf),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.delete, size: 16, color: Colors.red),
                    title: Text('Delete', style: TextStyle(fontSize: 12, color: Colors.red)),
                    dense: true,
                  ),
                  onTap: () => _showDeleteDialog(context, calf, app),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Colors.green;
      case 'sick':
        return Colors.red;
      case 'weaned':
        return Colors.blue;
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
            'Vaccination schedules, treatments, and health monitoring',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthTracking(AppState app) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.trending_up, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Growth Tracking',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Weight monitoring, growth charts, and development milestones',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedingManagement(AppState app) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Feeding Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Milk feeding schedules, weaning protocols, and nutrition tracking',
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
            'Growth reports, health summaries, and performance analytics',
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
            _buildActivityItem('New calf born', 'Calf-2024-001', '2 hours ago'),
            _buildActivityItem('Vaccination completed', 'Calf-2024-002', '4 hours ago'),
            _buildActivityItem('Weight recorded', 'Calf-2024-003', '6 hours ago'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String calfTag, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.circle, size: 6, color: Colors.amber[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$activity - $calfTag',
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
            _buildTaskItem('Vaccination due', 'Calf-2024-001', 'Tomorrow'),
            _buildTaskItem('Weaning assessment', 'Calf-2024-002', 'In 3 days'),
            _buildTaskItem('Health checkup', 'Calf-2024-003', 'Next week'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String task, String calfTag, String dueDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 12, color: Colors.orange[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$task - $calfTag',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Text(
            dueDate,
            style: TextStyle(fontSize: 8, color: Colors.orange[600]),
          ),
        ],
      ),
    );
  }

  void _showAddCalfDialog(BuildContext context, AppState app) {
    // Implementation for add calf dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Calf'),
        content: Text('Add calf dialog would be implemented here'),
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

  void _showEditCalfDialog(BuildContext context, Calf calf, AppState app) {
    // Implementation for edit calf dialog
  }

  void _showHealthDialog(BuildContext context, Calf calf) {
    // Implementation for health dialog
  }

  void _showDeleteDialog(BuildContext context, Calf calf, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Calf'),
        content: Text('Are you sure you want to delete ${calf.tag}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              app.deleteCalf(calf.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}