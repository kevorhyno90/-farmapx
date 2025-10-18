import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/comprehensive_animal_record.dart';

class BreedingGeneticsManagementPage extends StatefulWidget {
  const BreedingGeneticsManagementPage({super.key});

  @override
  State<BreedingGeneticsManagementPage> createState() => _BreedingGeneticsManagementPageState();
}

class _BreedingGeneticsManagementPageState extends State<BreedingGeneticsManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
          _buildHeader(),
          _buildTabBar(),
          _buildFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBreedingOverviewTab(app),
                _buildLineageTrackingTab(app),
                _buildArtificialInseminationTab(app),
                _buildPregnancyManagementTab(app),
                _buildGeneticAnalysisTab(app),
                _buildBreedingReportsTab(app),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBreedingRecordDialog(app),
        backgroundColor: Colors.pink[600],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[700]!, Colors.pink[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.favorite, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Breeding & Genetics Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Advanced genetic tracking and breeding programs',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.pink[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.pink[700],
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(icon: Icon(Icons.dashboard, size: 18), text: 'Overview'),
          Tab(icon: Icon(Icons.account_tree, size: 18), text: 'Lineage'),
          Tab(icon: Icon(Icons.science, size: 18), text: 'AI Program'),
          Tab(icon: Icon(Icons.pregnant_woman, size: 18), text: 'Pregnancy'),
          Tab(icon: Icon(Icons.dna, size: 18), text: 'Genetics'),
          Tab(icon: Icon(Icons.analytics, size: 18), text: 'Reports'),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search animals...',
                prefixIcon: Icon(Icons.search, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              style: TextStyle(fontSize: 12),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                isDense: true,
              ),
              style: TextStyle(fontSize: 12, color: Colors.black87),
              items: [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'breeding', child: Text('Breeding')),
                DropdownMenuItem(value: 'pregnant', child: Text('Pregnant')),
                DropdownMenuItem(value: 'calved', child: Text('Recently Calved')),
                DropdownMenuItem(value: 'open', child: Text('Open')),
              ],
              onChanged: (value) => setState(() => _selectedFilter = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedingOverviewTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breeding Program Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Breeding Statistics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _buildBreedingStatCard('Breeding Females', '45', Icons.female, Colors.pink, 'Active'),
              _buildBreedingStatCard('Pregnant Animals', '12', Icons.pregnant_woman, Colors.purple, '27%'),
              _buildBreedingStatCard('AI Services', '8', Icons.science, Colors.blue, 'This Month'),
              _buildBreedingStatCard('Calving Due', '3', Icons.child_care, Colors.orange, 'Next 30 Days'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Recent Breeding Activities',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getRecentBreedingActivities().length,
            itemBuilder: (context, index) {
              final activity = _getRecentBreedingActivities()[index];
              return _buildBreedingActivityCard(activity);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBreedingStatCard(String title, String value, IconData icon, MaterialColor color, String subtitle) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreedingActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: activity['color'][100],
          child: Icon(activity['icon'], color: activity['color'][700], size: 16),
        ),
        title: Text(
          activity['title'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${activity['animal']} • ${activity['date']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right, size: 18),
          onPressed: () => _showBreedingDetails(activity),
        ),
      ),
    );
  }

  Widget _buildLineageTrackingTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showLineageTreeView(),
                  icon: Icon(Icons.account_tree, size: 16),
                  label: Text('View Family Tree', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showGeneticReportDialog(),
                icon: Icon(Icons.dna, size: 16),
                label: Text('Genetic Report', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getLineageRecords().length,
            itemBuilder: (context, index) {
              final record = _getLineageRecords()[index];
              return _buildLineageCard(record);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLineageCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.brown[100],
          child: Icon(Icons.account_tree, color: Colors.brown[700], size: 16),
        ),
        title: Text(
          record['name'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${record['breed']} • ${record['age']} • Gen ${record['generation']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pedigree Information:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sire: ${record['sire']}', style: TextStyle(fontSize: 11)),
                        Text('Dam: ${record['dam']}', style: TextStyle(fontSize: 11)),
                        Text('Genetic Line: ${record['geneticLine']}', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Offspring: ${record['offspring']}', style: TextStyle(fontSize: 11)),
                        Text('Genetic Value: ${record['geneticValue']}', style: TextStyle(fontSize: 11)),
                        Text('Inbreeding: ${record['inbreeding']}%', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Genetic Traits:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Wrap(
                spacing: 4,
                children: record['traits'].map<Widget>((trait) => 
                  Chip(
                    label: Text(trait, style: TextStyle(fontSize: 10)),
                    backgroundColor: Colors.blue[100],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArtificialInseminationTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAIServiceDialog(),
                  icon: Icon(Icons.science, size: 16),
                  label: Text('Record AI Service', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showSemenInventory(),
                icon: Icon(Icons.inventory, size: 16),
                label: Text('Semen Inventory', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getAIRecords().length,
            itemBuilder: (context, index) {
              final ai = _getAIRecords()[index];
              return _buildAICard(ai);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAICard(Map<String, dynamic> ai) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: ai['status'] == 'confirmed' ? Colors.green[100] : Colors.blue[100],
          child: Icon(
            ai['status'] == 'confirmed' ? Icons.check_circle : Icons.science,
            color: ai['status'] == 'confirmed' ? Colors.green[700] : Colors.blue[700],
            size: 16,
          ),
        ),
        title: Text(
          'AI Service - ${ai['animal']}',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${ai['date']} • ${ai['bull']} • ${ai['technician']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bull: ${ai['bull']}', style: TextStyle(fontSize: 11)),
                        Text('Semen Batch: ${ai['semenBatch']}', style: TextStyle(fontSize: 11)),
                        Text('Technician: ${ai['technician']}', style: TextStyle(fontSize: 11)),
                        Text('Method: ${ai['method']}', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expected Calving: ${ai['expectedCalving']}', style: TextStyle(fontSize: 11)),
                        Text('Pregnancy Check: ${ai['pregnancyCheck']}', style: TextStyle(fontSize: 11)),
                        Text('Status: ${ai['status']}', 
                             style: TextStyle(fontSize: 11, 
                                            color: ai['status'] == 'confirmed' ? Colors.green[700] : Colors.blue[700],
                                            fontWeight: FontWeight.w600)),
                        if (ai['notes'].isNotEmpty)
                          Text('Notes: ${ai['notes']}', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              if (ai['status'] == 'confirmed')
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'PREGNANCY CONFIRMED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPregnancyManagementTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showPregnancyCheckDialog(),
                  icon: Icon(Icons.pregnant_woman, size: 16),
                  label: Text('Pregnancy Check', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showCalvingCalendar(),
                icon: Icon(Icons.calendar_today, size: 16),
                label: Text('Calving Calendar', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getPregnancyRecords().length,
            itemBuilder: (context, index) {
              final pregnancy = _getPregnancyRecords()[index];
              return _buildPregnancyCard(pregnancy);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPregnancyCard(Map<String, dynamic> pregnancy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: pregnancy['status'] == 'pregnant' ? Colors.pink[100] : Colors.grey[100],
          child: Icon(
            pregnancy['status'] == 'pregnant' ? Icons.pregnant_woman : Icons.child_care,
            color: pregnancy['status'] == 'pregnant' ? Colors.pink[700] : Colors.grey[700],
            size: 16,
          ),
        ),
        title: Text(
          pregnancy['animal'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Due: ${pregnancy['dueDate']} • Day ${pregnancy['gestationDay']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Breeding Date: ${pregnancy['breedingDate']}', style: TextStyle(fontSize: 11)),
                        Text('Confirmation: ${pregnancy['confirmation']}', style: TextStyle(fontSize: 11)),
                        Text('Method: ${pregnancy['confirmationMethod']}', style: TextStyle(fontSize: 11)),
                        Text('Bull: ${pregnancy['bull']}', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gestation: ${pregnancy['gestationDay']} days', style: TextStyle(fontSize: 11)),
                        Text('Expected Calving: ${pregnancy['dueDate']}', style: TextStyle(fontSize: 11)),
                        Text('Body Condition: ${pregnancy['bodyCondition']}', style: TextStyle(fontSize: 11)),
                        Text('Last Check: ${pregnancy['lastCheck']}', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Pregnancy Checkups:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ...pregnancy['checkups'].map<Widget>((checkup) => 
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text('• ${checkup['date']}: ${checkup['result']} (${checkup['method']})', 
                               style: TextStyle(fontSize: 11)),
                )).toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneticAnalysisTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Genetic Analysis & Performance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Genetic diversity metrics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Herd Genetic Diversity',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGeneticMetric('Inbreeding Coefficient', '3.2%', Colors.green),
                      ),
                      Expanded(
                        child: _buildGeneticMetric('Genetic Diversity Index', '0.87', Colors.blue),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGeneticMetric('Effective Population', '45', Colors.orange),
                      ),
                      Expanded(
                        child: _buildGeneticMetric('Genetic Trends', '+2.3%', Colors.purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Top Genetic Performers',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getTopGeneticPerformers().length,
            itemBuilder: (context, index) {
              final performer = _getTopGeneticPerformers()[index];
              return _buildGeneticPerformerCard(performer);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGeneticMetric(String title, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color[200]!),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color[700],
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: color[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGeneticPerformerCard(Map<String, dynamic> performer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.amber[100],
          child: Icon(Icons.star, color: Colors.amber[700], size: 16),
        ),
        title: Text(
          performer['name'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Genetic Merit: ${performer['geneticMerit']} • Offspring: ${performer['offspring']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        trailing: Text(
          'Rank #${performer['rank']}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.amber[700],
          ),
        ),
      ),
    );
  }

  Widget _buildBreedingReportsTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breeding Performance Reports',
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
            childAspectRatio: 1.5,
            children: [
              _buildReportCard('Conception Rates', Icons.trending_up, Colors.green),
              _buildReportCard('Genetic Progress', Icons.dna, Colors.purple),
              _buildReportCard('Breeding Efficiency', Icons.speed, Colors.blue),
              _buildReportCard('Lineage Reports', Icons.account_tree, Colors.brown),
              _buildReportCard('AI Success Rates', Icons.science, Colors.teal),
              _buildReportCard('Calving Reports', Icons.child_care, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, IconData icon, MaterialColor color) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _generateBreedingReport(title),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color[600]),
              const SizedBox(height: 8),
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

  // Sample data methods
  List<Map<String, dynamic>> _getRecentBreedingActivities() {
    return [
      {
        'title': 'AI Service completed',
        'animal': 'Cow B-127',
        'date': '2 hours ago',
        'icon': Icons.science,
        'color': Colors.blue,
      },
      {
        'title': 'Pregnancy confirmed',
        'animal': 'Heifer A-89',
        'date': '1 day ago',
        'icon': Icons.pregnant_woman,
        'color': Colors.pink,
      },
      {
        'title': 'Calf born',
        'animal': 'Cow C-45',
        'date': '3 days ago',
        'icon': Icons.child_care,
        'color': Colors.orange,
      },
    ];
  }

  List<Map<String, dynamic>> _getLineageRecords() {
    return [
      {
        'name': 'Princess Aurora B-127',
        'breed': 'Holstein',
        'age': '4 years',
        'generation': 3,
        'sire': 'Champion Zeus A-45',
        'dam': 'Queen Bella B-89',
        'geneticLine': 'Elite Milk Line A',
        'offspring': 2,
        'geneticValue': 'High (+135)',
        'inbreeding': 2.1,
        'traits': ['High Milk Production', 'Disease Resistance', 'Fertility'],
      },
      {
        'name': 'Thunder Storm A-89',
        'breed': 'Holstein',
        'age': '5 years',
        'generation': 2,
        'sire': 'Lightning Bolt A-12',
        'dam': 'Storm Cloud B-67',
        'geneticLine': 'Elite Milk Line A',
        'offspring': 8,
        'geneticValue': 'Superior (+187)',
        'inbreeding': 1.8,
        'traits': ['Superior Genetics', 'High Fertility', 'Longevity'],
      },
    ];
  }

  List<Map<String, dynamic>> _getAIRecords() {
    return [
      {
        'animal': 'Cow B-127',
        'date': 'Oct 15, 2025',
        'bull': 'Champion Thunder A-456',
        'semenBatch': 'THU2025-A47',
        'technician': 'Dr. Sarah Johnson',
        'method': 'Cervical AI',
        'expectedCalving': 'Jul 22, 2026',
        'pregnancyCheck': 'Nov 15, 2025',
        'status': 'pending',
        'notes': 'First service, good timing',
      },
      {
        'animal': 'Heifer A-89',
        'date': 'Oct 1, 2025',
        'bull': 'Elite Storm B-789',
        'semenBatch': 'ELI2025-B23',
        'technician': 'Dr. Mike Wilson',
        'method': 'Timed AI',
        'expectedCalving': 'Jul 8, 2026',
        'pregnancyCheck': 'Nov 1, 2025',
        'status': 'confirmed',
        'notes': 'Pregnancy confirmed via ultrasound',
      },
    ];
  }

  List<Map<String, dynamic>> _getPregnancyRecords() {
    return [
      {
        'animal': 'Heifer A-89',
        'breedingDate': 'Oct 1, 2025',
        'confirmation': 'Oct 30, 2025',
        'confirmationMethod': 'Ultrasound',
        'dueDate': 'Jul 8, 2026',
        'gestationDay': 45,
        'status': 'pregnant',
        'bull': 'Elite Storm B-789',
        'bodyCondition': 'Good (6/10)',
        'lastCheck': 'Nov 10, 2025',
        'checkups': [
          {
            'date': 'Oct 30, 2025',
            'method': 'Ultrasound',
            'result': 'Positive - Single calf',
          },
          {
            'date': 'Nov 10, 2025',
            'method': 'Rectal palpation',
            'result': 'Normal development',
          },
        ],
      },
    ];
  }

  List<Map<String, dynamic>> _getTopGeneticPerformers() {
    return [
      {
        'name': 'Champion Thunder A-456',
        'geneticMerit': '+187',
        'offspring': 45,
        'rank': 1,
      },
      {
        'name': 'Elite Storm B-789',
        'geneticMerit': '+165',
        'offspring': 32,
        'rank': 2,
      },
      {
        'name': 'Royal Prince C-123',
        'geneticMerit': '+142',
        'offspring': 28,
        'rank': 3,
      },
    ];
  }

  // Dialog and action methods
  void _showAddBreedingRecordDialog(AppState app) {
    // Implementation for adding breeding records
  }

  void _showBreedingDetails(Map<String, dynamic> activity) {
    // Implementation for showing breeding activity details
  }

  void _showLineageTreeView() {
    // Implementation for lineage tree visualization
  }

  void _showGeneticReportDialog() {
    // Implementation for genetic reports
  }

  void _showAIServiceDialog() {
    // Implementation for AI service recording
  }

  void _showSemenInventory() {
    // Implementation for semen inventory management
  }

  void _showPregnancyCheckDialog() {
    // Implementation for pregnancy check recording
  }

  void _showCalvingCalendar() {
    // Implementation for calving calendar view
  }

  void _generateBreedingReport(String reportType) {
    // Implementation for generating breeding reports
  }
}