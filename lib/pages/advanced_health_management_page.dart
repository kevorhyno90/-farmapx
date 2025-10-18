import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/comprehensive_animal_record.dart';

class AdvancedHealthManagementPage extends StatefulWidget {
  const AdvancedHealthManagementPage({super.key});

  @override
  State<AdvancedHealthManagementPage> createState() => _AdvancedHealthManagementPageState();
}

class _AdvancedHealthManagementPageState extends State<AdvancedHealthManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedAnimalId = '';
  String _filterStatus = 'all';
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
                _buildHealthOverviewTab(app),
                _buildVaccinationTab(app),
                _buildTreatmentTab(app),
                _buildExaminationTab(app),
                _buildDiseaseTrackingTab(app),
                _buildHealthReportsTab(app),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHealthRecordDialog(app),
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.health_and_safety, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Advanced Health Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Comprehensive veterinary care tracking',
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
        labelColor: Colors.green[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.green[700],
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(icon: Icon(Icons.dashboard, size: 18), text: 'Overview'),
          Tab(icon: Icon(Icons.vaccines, size: 18), text: 'Vaccinations'),
          Tab(icon: Icon(Icons.medication, size: 18), text: 'Treatments'),
          Tab(icon: Icon(Icons.medical_services, size: 18), text: 'Examinations'),
          Tab(icon: Icon(Icons.coronavirus, size: 18), text: 'Disease Tracking'),
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
              value: _filterStatus,
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
                DropdownMenuItem(value: 'healthy', child: Text('Healthy')),
                DropdownMenuItem(value: 'sick', child: Text('Sick')),
                DropdownMenuItem(value: 'treatment', child: Text('Under Treatment')),
                DropdownMenuItem(value: 'quarantine', child: Text('Quarantine')),
              ],
              onChanged: (value) => setState(() => _filterStatus = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthOverviewTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Overview Dashboard',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Health Statistics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _buildHealthStatCard('Healthy Animals', '${app.animals.length}', Icons.favorite, Colors.green, '95%'),
              _buildHealthStatCard('Under Treatment', '3', Icons.medication, Colors.orange, '5%'),
              _buildHealthStatCard('Vaccinations Due', '7', Icons.vaccines, Colors.blue, 'This Week'),
              _buildHealthStatCard('Health Alerts', '2', Icons.warning, Colors.red, 'Urgent'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Recent Health Events',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getRecentHealthEvents().length,
            itemBuilder: (context, index) {
              final event = _getRecentHealthEvents()[index];
              return _buildHealthEventCard(event);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStatCard(String title, String value, IconData icon, MaterialColor color, String subtitle) {
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

  Widget _buildHealthEventCard(Map<String, dynamic> event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: event['color'][100],
          child: Icon(event['icon'], color: event['color'][700], size: 16),
        ),
        title: Text(
          event['title'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${event['animal']} • ${event['date']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right, size: 18),
          onPressed: () => _showHealthEventDetails(event),
        ),
      ),
    );
  }

  Widget _buildVaccinationTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddVaccinationDialog(),
                  icon: Icon(Icons.vaccines, size: 16),
                  label: Text('Schedule Vaccination', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showVaccinationSchedule(),
                icon: Icon(Icons.calendar_today, size: 16),
                label: Text('Schedule', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
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
            itemCount: _getVaccinationRecords().length,
            itemBuilder: (context, index) {
              final vaccination = _getVaccinationRecords()[index];
              return _buildVaccinationCard(vaccination);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVaccinationCard(Map<String, dynamic> vaccination) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: vaccination['status'] == 'completed' ? Colors.green[100] : Colors.orange[100],
          child: Icon(
            vaccination['status'] == 'completed' ? Icons.check : Icons.schedule,
            color: vaccination['status'] == 'completed' ? Colors.green[700] : Colors.orange[700],
            size: 16,
          ),
        ),
        title: Text(
          vaccination['vaccine'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${vaccination['animal']} • ${vaccination['date']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manufacturer: ${vaccination['manufacturer']}', style: TextStyle(fontSize: 11)),
                    Text('Batch: ${vaccination['batch']}', style: TextStyle(fontSize: 11)),
                    Text('Administered by: ${vaccination['vet']}', style: TextStyle(fontSize: 11)),
                    if (vaccination['nextDue'] != null)
                      Text('Next due: ${vaccination['nextDue']}', 
                           style: TextStyle(fontSize: 11, color: Colors.blue[700], fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, size: 16),
                    onPressed: () => _editVaccination(vaccination),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, size: 16, color: Colors.red),
                    onPressed: () => _deleteVaccination(vaccination),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: () => _showAddTreatmentDialog(),
            icon: Icon(Icons.medication, size: 16),
            label: Text('Add Treatment', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getTreatmentRecords().length,
            itemBuilder: (context, index) {
              final treatment = _getTreatmentRecords()[index];
              return _buildTreatmentCard(treatment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentCard(Map<String, dynamic> treatment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: treatment['status'] == 'active' ? Colors.blue[100] : Colors.grey[100],
          child: Icon(
            treatment['status'] == 'active' ? Icons.medication : Icons.check_circle,
            color: treatment['status'] == 'active' ? Colors.blue[700] : Colors.grey[700],
            size: 16,
          ),
        ),
        title: Text(
          treatment['medication'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${treatment['animal']} • ${treatment['startDate']} - ${treatment['endDate'] ?? 'Ongoing'}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dosage: ${treatment['dosage']}', style: TextStyle(fontSize: 11)),
                    Text('Frequency: ${treatment['frequency']}', style: TextStyle(fontSize: 11)),
                    Text('Route: ${treatment['route']}', style: TextStyle(fontSize: 11)),
                    Text('Prescribed by: ${treatment['prescriber']}', style: TextStyle(fontSize: 11)),
                    Text('Reason: ${treatment['reason']}', style: TextStyle(fontSize: 11)),
                    if (treatment['sideEffects'].isNotEmpty)
                      Text('Side effects: ${treatment['sideEffects'].join(', ')}', 
                           style: TextStyle(fontSize: 11, color: Colors.orange[700])),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, size: 16),
                    onPressed: () => _editTreatment(treatment),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, size: 16, color: Colors.red),
                    onPressed: () => _deleteTreatment(treatment),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExaminationTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: () => _showAddExaminationDialog(),
            icon: Icon(Icons.medical_services, size: 16),
            label: Text('Record Examination', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getExaminationRecords().length,
            itemBuilder: (context, index) {
              final exam = _getExaminationRecords()[index];
              return _buildExaminationCard(exam);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExaminationCard(Map<String, dynamic> exam) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.teal[100],
          child: Icon(Icons.medical_services, color: Colors.teal[700], size: 16),
        ),
        title: Text(
          exam['purpose'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${exam['animal']} • ${exam['date']} • Dr. ${exam['veterinarian']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Clinic: ${exam['clinic']}', style: TextStyle(fontSize: 11)),
              const SizedBox(height: 4),
              Text('Vital Signs:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              Text('• Temperature: ${exam['temperature']}°C', style: TextStyle(fontSize: 11)),
              Text('• Heart Rate: ${exam['heartRate']} bpm', style: TextStyle(fontSize: 11)),
              Text('• Weight: ${exam['weight']} kg', style: TextStyle(fontSize: 11)),
              Text('• Body Condition: ${exam['bodyCondition']}', style: TextStyle(fontSize: 11)),
              const SizedBox(height: 4),
              Text('Assessment: ${exam['assessment']}', style: TextStyle(fontSize: 11)),
              if (exam['recommendations'].isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Recommendations:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ...exam['recommendations'].map<Widget>((rec) => 
                  Text('• $rec', style: TextStyle(fontSize: 11))).toList(),
              ],
              if (exam['nextExam'] != null) ...[
                const SizedBox(height: 4),
                Text('Next exam: ${exam['nextExam']}', 
                     style: TextStyle(fontSize: 11, color: Colors.blue[700], fontWeight: FontWeight.w600)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseTrackingTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disease Surveillance & Tracking',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Disease alerts
          Card(
            color: Colors.red[50],
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Active Disease Alerts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Respiratory infection detected in Barn A (2 animals affected)',
                    style: TextStyle(fontSize: 12, color: Colors.red[600]),
                  ),
                  Text(
                    '• Mastitis case in cow B-127 requires isolation',
                    style: TextStyle(fontSize: 12, color: Colors.red[600]),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Disease Reports',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getDiseaseReports().length,
            itemBuilder: (context, index) {
              final report = _getDiseaseReports()[index];
              return _buildDiseaseReportCard(report);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseReportCard(Map<String, dynamic> report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: report['severity'] == 'high' ? Colors.red[100] : 
                          report['severity'] == 'medium' ? Colors.orange[100] : Colors.yellow[100],
          child: Icon(
            Icons.coronavirus,
            color: report['severity'] == 'high' ? Colors.red[700] : 
                   report['severity'] == 'medium' ? Colors.orange[700] : Colors.yellow[700],
            size: 16,
          ),
        ),
        title: Text(
          report['disease'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${report['affectedAnimals']} animals • ${report['date']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Symptoms: ${report['symptoms']}', style: TextStyle(fontSize: 11)),
              Text('Treatment: ${report['treatment']}', style: TextStyle(fontSize: 11)),
              Text('Status: ${report['status']}', style: TextStyle(fontSize: 11)),
              Text('Veterinarian: ${report['veterinarian']}', style: TextStyle(fontSize: 11)),
              if (report['quarantine'])
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'QUARANTINE ACTIVE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthReportsTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Analytics & Reports',
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
              _buildReportCard('Monthly Health Report', Icons.calendar_month, Colors.blue),
              _buildReportCard('Vaccination Schedule', Icons.vaccines, Colors.green),
              _buildReportCard('Treatment Costs', Icons.monetization_on, Colors.orange),
              _buildReportCard('Disease Trends', Icons.trending_up, Colors.red),
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
        onTap: () => _generateReport(title),
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
  List<Map<String, dynamic>> _getRecentHealthEvents() {
    return [
      {
        'title': 'Vaccination completed',
        'animal': 'Cow B-127',
        'date': '2 hours ago',
        'icon': Icons.vaccines,
        'color': Colors.green,
      },
      {
        'title': 'Health examination',
        'animal': 'Bull A-45',
        'date': '1 day ago',
        'icon': Icons.medical_services,
        'color': Colors.blue,
      },
      {
        'title': 'Treatment started',
        'animal': 'Heifer C-89',
        'date': '3 days ago',
        'icon': Icons.medication,
        'color': Colors.orange,
      },
    ];
  }

  List<Map<String, dynamic>> _getVaccinationRecords() {
    return [
      {
        'vaccine': 'Bovine Respiratory Complex',
        'animal': 'Cow B-127',
        'date': 'Oct 15, 2025',
        'status': 'completed',
        'manufacturer': 'Zoetis',
        'batch': 'BRC2025-A',
        'vet': 'Dr. Sarah Johnson',
        'nextDue': 'Apr 15, 2026',
      },
      {
        'vaccine': 'Foot & Mouth Disease',
        'animal': 'Bull A-45',
        'date': 'Oct 20, 2025',
        'status': 'scheduled',
        'manufacturer': 'Merck',
        'batch': 'FMD2025-B',
        'vet': 'Dr. Mike Wilson',
        'nextDue': null,
      },
    ];
  }

  List<Map<String, dynamic>> _getTreatmentRecords() {
    return [
      {
        'medication': 'Oxytetracycline',
        'animal': 'Heifer C-89',
        'startDate': 'Oct 12, 2025',
        'endDate': 'Oct 17, 2025',
        'status': 'active',
        'dosage': '5mg/kg',
        'frequency': 'Twice daily',
        'route': 'Intramuscular',
        'prescriber': 'Dr. Sarah Johnson',
        'reason': 'Respiratory infection',
        'sideEffects': [],
      },
      {
        'medication': 'Dexamethasone',
        'animal': 'Cow B-127',
        'startDate': 'Oct 10, 2025',
        'endDate': 'Oct 12, 2025',
        'status': 'completed',
        'dosage': '0.5mg/kg',
        'frequency': 'Once daily',
        'route': 'Intravenous',
        'prescriber': 'Dr. Mike Wilson',
        'reason': 'Inflammatory condition',
        'sideEffects': ['Mild swelling at injection site'],
      },
    ];
  }

  List<Map<String, dynamic>> _getExaminationRecords() {
    return [
      {
        'purpose': 'Routine health check',
        'animal': 'Bull A-45',
        'date': 'Oct 16, 2025',
        'veterinarian': 'Sarah Johnson',
        'clinic': 'Valley Veterinary Services',
        'temperature': 38.5,
        'heartRate': 72,
        'weight': 650,
        'bodyCondition': 'Good (7/10)',
        'assessment': 'Animal in excellent health. All vital signs normal.',
        'recommendations': [
          'Continue current feeding program',
          'Schedule next examination in 6 months',
          'Monitor weight gain',
        ],
        'nextExam': 'Apr 16, 2026',
      },
    ];
  }

  List<Map<String, dynamic>> _getDiseaseReports() {
    return [
      {
        'disease': 'Respiratory Infection',
        'affectedAnimals': 2,
        'date': 'Oct 14, 2025',
        'severity': 'medium',
        'symptoms': 'Coughing, nasal discharge, fever',
        'treatment': 'Antibiotic therapy, isolation',
        'status': 'Under treatment',
        'veterinarian': 'Dr. Sarah Johnson',
        'quarantine': true,
      },
      {
        'disease': 'Mastitis',
        'affectedAnimals': 1,
        'date': 'Oct 12, 2025',
        'severity': 'high',
        'symptoms': 'Swollen udder, abnormal milk',
        'treatment': 'Intramammary antibiotics',
        'status': 'Resolved',
        'veterinarian': 'Dr. Mike Wilson',
        'quarantine': false,
      },
    ];
  }

  // Dialog methods
  void _showAddHealthRecordDialog(AppState app) {
    // Implementation for adding health records
  }

  void _showAddVaccinationDialog() {
    // Implementation for scheduling vaccinations
  }

  void _showVaccinationSchedule() {
    // Implementation for vaccination schedule view
  }

  void _showAddTreatmentDialog() {
    // Implementation for adding treatments
  }

  void _showAddExaminationDialog() {
    // Implementation for recording examinations
  }

  void _showHealthEventDetails(Map<String, dynamic> event) {
    // Implementation for showing event details
  }

  void _editVaccination(Map<String, dynamic> vaccination) {
    // Implementation for editing vaccination records
  }

  void _deleteVaccination(Map<String, dynamic> vaccination) {
    // Implementation for deleting vaccination records
  }

  void _editTreatment(Map<String, dynamic> treatment) {
    // Implementation for editing treatment records
  }

  void _deleteTreatment(Map<String, dynamic> treatment) {
    // Implementation for deleting treatment records
  }

  void _generateReport(String reportType) {
    // Implementation for generating health reports
  }
}