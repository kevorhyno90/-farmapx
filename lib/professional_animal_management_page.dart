import 'package:flutter/material.dart';
import '../models/professional_animal_models.dart';
import '../services/professional_animal_service.dart';

class ProfessionalAnimalManagementPage extends StatefulWidget {
  const ProfessionalAnimalManagementPage({super.key});

  @override
  State<ProfessionalAnimalManagementPage> createState() => _ProfessionalAnimalManagementPageState();
}

class _ProfessionalAnimalManagementPageState extends State<ProfessionalAnimalManagementPage> {
  int _selectedIndex = 0;
  String _searchQuery = '';
  String? _selectedSpecies;
  AnimalStatus? _selectedStatus;
  List<AnimalProfile> _animals = [];
  List<AnimalProfile> _filteredAnimals = [];

  @override
  void initState() {
    super.initState();
    ProfessionalAnimalService.initialize();
    _loadAnimals();
  }

  void _loadAnimals() {
    setState(() {
      _animals = ProfessionalAnimalService.getAllAnimals();
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredAnimals = _animals.where((animal) {
        final matchesSearch = _searchQuery.isEmpty || 
          animal.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          animal.identificationNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          animal.breed.toLowerCase().contains(_searchQuery.toLowerCase());
        
        final matchesSpecies = _selectedSpecies == null || animal.species == _selectedSpecies;
        final matchesStatus = _selectedStatus == null || animal.status == _selectedStatus;
        
        return matchesSearch && matchesSpecies && matchesStatus;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildNavigationTabs(),
          _buildSearchAndFilters(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildAnimalOverview(),
                _buildAnimalList(),
                _buildHealthManagement(),
                _buildBreedingManagement(),
                _buildProductionTracking(),
                _buildReportsAnalytics(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 ? FloatingActionButton.extended(
        onPressed: _showAddAnimalDialog,
        icon: Icon(Icons.add),
        label: Text('Add Animal'),
        backgroundColor: Colors.green[600],
      ) : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(6),
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
              Icon(Icons.pets, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Animal Management',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Comprehensive veterinary-grade animal care system',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalAnimals = _animals.length;
    final speciesCounts = ProfessionalAnimalService.getAnimalCountBySpecies();
    final attentionNeeded = ProfessionalAnimalService.getAnimalsRequiringAttention().length;

    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Animals', totalAnimals.toString(), Icons.pets)),
        SizedBox(width: 12),
        Expanded(child: _buildStatCard('Species', speciesCounts.length.toString(), Icons.category)),
        SizedBox(width: 12),
        Expanded(child: _buildStatCard('Need Attention', attentionNeeded.toString(), Icons.warning, 
          color: attentionNeeded > 0 ? Colors.orange : Colors.green)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color? color}) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Icon(icon, color: color ?? Colors.white, size: 16),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
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
      {'title': 'Animals', 'icon': Icons.pets},
      {'title': 'Health', 'icon': Icons.medical_services},
      {'title': 'Breeding', 'icon': Icons.favorite},
      {'title': 'Production', 'icon': Icons.analytics},
      {'title': 'Reports', 'icon': Icons.assessment},
    ];

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
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
                      color: isSelected ? Colors.green[600]! : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      color: isSelected ? Colors.green[600] : Colors.grey[600],
                      size: 16,
                    ),
                    SizedBox(height: 2),
                    Text(
                      tab['title'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.green[600] : Colors.grey[600],
                        fontSize: 11,
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

  Widget _buildAnimalOverview() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCards(),
          SizedBox(height: 6),
          _buildSpeciesBreakdown(),
          SizedBox(height: 6),
          _buildRecentActivity(),
          SizedBox(height: 6),
          _buildUpcomingTasks(),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    final statusCounts = ProfessionalAnimalService.getAnimalCountByStatus();
    final totalValue = ProfessionalAnimalService.getTotalAnimalValue();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.0,
      children: [
        _buildOverviewCard(
          'Active Animals',
          '${statusCounts[AnimalStatus.active] ?? 0}',
          Icons.pets,
          Colors.green,
        ),
        _buildOverviewCard(
          'Pregnant',
          '${statusCounts[AnimalStatus.pregnant] ?? 0}',
          Icons.pregnant_woman,
          Colors.blue,
        ),
        _buildOverviewCard(
          'Lactating',
          '${statusCounts[AnimalStatus.lactating] ?? 0}',
          Icons.water_drop,
          Colors.cyan,
        ),
        _buildOverviewCard(
          'Total Value',
          '\$${totalValue.toStringAsFixed(0)}',
          Icons.monetization_on,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: color),
            SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 7,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesBreakdown() {
    final speciesCounts = ProfessionalAnimalService.getAnimalCountBySpecies();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Species Breakdown',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...speciesCounts.entries.map((entry) => 
              _buildSpeciesRow(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesRow(String species, int count) {
    final total = _animals.length;
    final percentage = total > 0 ? (count / total * 100) : 0.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(species, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.green[400]),
            ),
          ),
          SizedBox(width: 12),
          Text(
            '$count (${percentage.toStringAsFixed(1)}%)',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildActivityItem('Health Check', 'Thor - Breeding soundness exam', '2 days ago'),
            _buildActivityItem('Vaccination', 'Bella - Annual vaccination', '1 month ago'),
            _buildActivityItem('Breeding', 'Luna - Natural mating recorded', '4 months ago'),
            _buildActivityItem('Production', 'RIR Flock - Daily egg collection', 'Yesterday'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String type, String description, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green[400],
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ),
                Text(description, style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTasks() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildTaskItem('Vaccination Due', 'Annual boosters for 12 animals', 'In 5 days', Colors.orange),
            _buildTaskItem('Pregnancy Check', 'Luna - Ultrasound examination', 'In 2 weeks', Colors.blue),
            _buildTaskItem('Weaning', 'Rosie\'s piglets ready for weaning', 'In 3 weeks', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String task, String description, String due, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              due,
              style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalList() {
    return Column(
      children: [
        _buildSearchAndFilters(),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _filteredAnimals.length,
            itemBuilder: (context, index) {
              final animal = _filteredAnimals[index];
              return _buildAnimalCard(animal);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search animals by name, ID, or breed...',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedSpecies,
                  onChanged: (value) {
                    _selectedSpecies = value;
                    _applyFilters();
                  },
                  decoration: InputDecoration(
                    labelText: 'Species',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  style: TextStyle(fontSize: 14),
                  items: ['All', 'Cattle', 'Goat', 'Pig', 'Poultry']
                    .map((species) => DropdownMenuItem(
                      value: species == 'All' ? null : species,
                      child: Text(species, style: TextStyle(fontSize: 14)),
                    )).toList(),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<AnimalStatus>(
                  initialValue: _selectedStatus,
                  onChanged: (value) {
                    _selectedStatus = value;
                    _applyFilters();
                  },
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  style: TextStyle(fontSize: 14),
                  items: [null, ...AnimalStatus.values]
                    .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(
                        status?.toString().split('.').last.toUpperCase() ?? 'All',
                        style: TextStyle(fontSize: 14),
                      ),
                    )).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalCard(AnimalProfile animal) {
    return Card(
      margin: EdgeInsets.only(bottom: 4),
      elevation: 1,
      child: InkWell(
        onTap: () => _showAnimalDetails(animal),
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: _getSpeciesColor(animal.species),
                    child: Text(
                      animal.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${animal.breed} ${animal.species} • ${animal.identificationNumber}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(animal.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      animal.status.toString().split('.').last.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(animal.status),
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildAnimalInfoChip('Age', animal.ageString, Icons.calendar_today),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildAnimalInfoChip('Weight', '${animal.currentWeight.toStringAsFixed(0)} kg', Icons.scale),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildAnimalInfoChip('Location', animal.currentLocation, Icons.location_on),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalInfoChip(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSpeciesColor(String species) {
    switch (species.toLowerCase()) {
      case 'cattle': return Colors.brown;
      case 'goat': return Colors.amber;
      case 'pig': return Colors.pink;
      case 'poultry': return Colors.orange;
      default: return Colors.grey;
    }
  }

  Color _getStatusColor(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.active: return Colors.green;
      case AnimalStatus.pregnant: return Colors.blue;
      case AnimalStatus.lactating: return Colors.cyan;
      case AnimalStatus.sick: return Colors.red;
      case AnimalStatus.quarantine: return Colors.orange;
      case AnimalStatus.sold: return Colors.grey;
      case AnimalStatus.deceased: return Colors.black;
      default: return Colors.grey;
    }
  }

  void _showAnimalDetails(AnimalProfile animal) {
    showDialog(
      context: context,
      builder: (context) => AnimalDetailsDialog(animal: animal),
    );
  }

  void _showAddAnimalDialog() {
    showDialog(
      context: context,
      builder: (context) => AddAnimalDialog(
        onAnimalAdded: (animal) {
          ProfessionalAnimalService.addAnimal(animal);
          _loadAnimals();
        },
      ),
    );
  }

  // Placeholder methods for other tabs
  Widget _buildHealthManagement() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Health Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Comprehensive health tracking and veterinary records',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBreedingManagement() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Breeding Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Genetics, breeding programs, and reproductive tracking',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductionTracking() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Production Tracking',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Milk, eggs, meat production and performance analytics',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportsAnalytics() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Reports & Analytics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Comprehensive reporting and business intelligence',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Animal Details Dialog
class AnimalDetailsDialog extends StatelessWidget {
  final AnimalProfile animal;

  const AnimalDetailsDialog({required this.animal, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 700,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _getSpeciesColor(animal.species),
                  child: Text(
                    animal.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        animal.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${animal.breed} ${animal.species}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailSection('Basic Information', [
                      _buildDetailRow('ID', animal.identificationNumber),
                      _buildDetailRow('Gender', animal.gender),
                      _buildDetailRow('Birth Date', '${animal.birthDate.day}/${animal.birthDate.month}/${animal.birthDate.year}'),
                      _buildDetailRow('Age', animal.ageString),
                      _buildDetailRow('Birth Weight', '${animal.birthWeight} kg'),
                      _buildDetailRow('Current Weight', '${animal.currentWeight.toStringAsFixed(1)} kg'),
                      _buildDetailRow('Location', animal.currentLocation),
                      _buildDetailRow('Status', animal.status.toString().split('.').last.toUpperCase()),
                    ]),
                    SizedBox(height: 20),
                    _buildDetailSection('Health Records', [
                      Text(
                        '${animal.healthRecords.length} records',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ]),
                    SizedBox(height: 20),
                    _buildDetailSection('Production Records', [
                      Text(
                        '${animal.productionRecords.length} records',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ]),
                    if (animal.notes.isNotEmpty) ...[
                      SizedBox(height: 20),
                      _buildDetailSection('Notes', [
                        Text(animal.notes),
                      ]),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Show edit dialog
                  },
                  child: Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getSpeciesColor(String species) {
    switch (species.toLowerCase()) {
      case 'cattle': return Colors.brown;
      case 'goat': return Colors.amber;
      case 'pig': return Colors.pink;
      case 'poultry': return Colors.orange;
      default: return Colors.grey;
    }
  }
}

// Add Animal Dialog
class AddAnimalDialog extends StatefulWidget {
  final Function(AnimalProfile) onAnimalAdded;

  const AddAnimalDialog({required this.onAnimalAdded, super.key});

  @override
  State<AddAnimalDialog> createState() => _AddAnimalDialogState();
}

class _AddAnimalDialogState extends State<AddAnimalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _identificationController = TextEditingController();
  final _birthWeightController = TextEditingController();
  final _acquisitionCostController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSpecies = 'Cattle';
  String _selectedBreed = 'Holstein Friesian';
  String _selectedGender = 'Female';
  String _selectedIdType = 'Ear Tag';
  String _selectedOrigin = 'Born on Farm';
  AnimalStatus _selectedStatus = AnimalStatus.active;
  DateTime _birthDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _acquisitionDate = DateTime.now();

  final Map<String, List<String>> _breedsBySpecies = {
    'Cattle': ['Holstein Friesian', 'Angus', 'Hereford', 'Jersey', 'Charolais', 'Brahman'],
    'Goat': ['Boer', 'Nubian', 'Saanen', 'Toggenburg', 'Alpine', 'LaMancha'],
    'Pig': ['Yorkshire', 'Landrace', 'Duroc', 'Hampshire', 'Chester White', 'Berkshire'],
    'Poultry': ['Rhode Island Red', 'Leghorn', 'Plymouth Rock', 'Wyandotte', 'Australorp', 'Buff Orpington'],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _identificationController.dispose();
    _birthWeightController.dispose();
    _acquisitionCostController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: BoxConstraints(maxHeight: 700),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Animal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedSpecies,
                              onChanged: (value) => setState(() {
                                _selectedSpecies = value!;
                                _selectedBreed = _breedsBySpecies[value]!.first;
                              }),
                              decoration: InputDecoration(
                                labelText: 'Species',
                                border: OutlineInputBorder(),
                              ),
                              items: _breedsBySpecies.keys.map((species) => 
                                DropdownMenuItem(value: species, child: Text(species))).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedBreed,
                              onChanged: (value) => setState(() => _selectedBreed = value!),
                              decoration: InputDecoration(
                                labelText: 'Breed',
                                border: OutlineInputBorder(),
                              ),
                              items: _breedsBySpecies[_selectedSpecies]!.map((breed) => 
                                DropdownMenuItem(value: breed, child: Text(breed))).toList(),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedGender,
                              onChanged: (value) => setState(() => _selectedGender = value!),
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(),
                              ),
                              items: ['Male', 'Female'].map((gender) => 
                                DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _identificationController,
                              decoration: InputDecoration(
                                labelText: 'ID Number *',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value?.isEmpty == true ? 'Required' : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedIdType,
                              onChanged: (value) => setState(() => _selectedIdType = value!),
                              decoration: InputDecoration(
                                labelText: 'ID Type',
                                border: OutlineInputBorder(),
                              ),
                              items: ['Ear Tag', 'Microchip', 'Tattoo', 'Ear Notch', 'Wing Band']
                                .map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _birthWeightController,
                              decoration: InputDecoration(
                                labelText: 'Birth Weight (kg)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                labelText: 'Current Location',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedOrigin,
                              onChanged: (value) => setState(() => _selectedOrigin = value!),
                              decoration: InputDecoration(
                                labelText: 'Origin',
                                border: OutlineInputBorder(),
                              ),
                              items: ['Born on Farm', 'Purchased', 'Gift', 'Trade']
                                .map((origin) => DropdownMenuItem(value: origin, child: Text(origin))).toList(),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _acquisitionCostController,
                              decoration: InputDecoration(
                                labelText: 'Acquisition Cost',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<AnimalStatus>(
                        value: _selectedStatus,
                        onChanged: (value) => setState(() => _selectedStatus = value!),
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: AnimalStatus.values.map((status) => 
                          DropdownMenuItem(
                            value: status, 
                            child: Text(status.toString().split('.').last.toUpperCase())
                          )).toList(),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveAnimal,
                  child: Text('Save Animal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveAnimal() {
    if (_formKey.currentState!.validate()) {
      final animal = AnimalProfile(
        id: 'animal_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        species: _selectedSpecies,
        breed: _selectedBreed,
        gender: _selectedGender,
        birthDate: _birthDate,
        birthWeight: double.tryParse(_birthWeightController.text) ?? 0.0,
        identificationNumber: _identificationController.text,
        identificationType: _selectedIdType,
        origin: _selectedOrigin,
        acquisitionDate: _acquisitionDate,
        acquisitionCost: double.tryParse(_acquisitionCostController.text) ?? 0.0,
        currentLocation: _locationController.text,
        status: _selectedStatus,
        notes: _notesController.text,
        lastUpdated: DateTime.now(),
      );

      widget.onAnimalAdded(animal);
      Navigator.of(context).pop();
    }
  }
}