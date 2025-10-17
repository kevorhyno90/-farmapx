import 'package:flutter/material.dart';
import '../models/nutritional_requirements.dart';

class QualityAssurancePage extends StatefulWidget {
  const QualityAssurancePage({Key? key}) : super(key: key);

  @override
  State<QualityAssurancePage> createState() => _QualityAssurancePageState();
}

class _QualityAssurancePageState extends State<QualityAssurancePage> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Quality check data
  List<QualityCheck> _qualityChecks = [];
  List<BatchReport> _batchReports = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadQualityData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadQualityData() {
    // Load sample quality data
    _qualityChecks = _generateSampleQualityChecks();
    _batchReports = _generateSampleBatchReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quality Assurance'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Quality Checks', icon: Icon(Icons.fact_check)),
            Tab(text: 'Batch Reports', icon: Icon(Icons.assessment)),
            Tab(text: 'Metrics', icon: Icon(Icons.analytics)),
            Tab(text: 'Certifications', icon: Icon(Icons.verified)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQualityChecksTab(),
          _buildBatchReportsTab(),
          _buildMetricsTab(),
          _buildCertificationsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _performQualityAudit,
        backgroundColor: Colors.blue[700],
        label: const Text('Run Audit'),
        icon: const Icon(Icons.assessment),
      ),
    );
  }

  Widget _buildQualityChecksTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildQualityOverview(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _qualityChecks.length,
              itemBuilder: (context, index) {
                final check = _qualityChecks[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    leading: _getQualityStatusIcon(check.status),
                    title: Text(check.checkName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Batch: ${check.batchId}'),
                        Text('Date: ${check.checkDate.toString().split(' ')[0]}'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(check.status.toUpperCase()),
                      backgroundColor: _getQualityStatusColor(check.status),
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Test Results:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ...check.testResults.entries.map((entry) =>
                              _buildTestResultRow(entry.key, entry.value, check.specifications[entry.key])
                            ),
                            if (check.notes.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Notes:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(check.notes),
                            ],
                            if (check.correctiveActions.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                'Corrective Actions:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              ...check.correctiveActions.map((action) =>
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text('• $action'),
                                )
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityOverview() {
    final totalChecks = _qualityChecks.length;
    final passedChecks = _qualityChecks.where((c) => c.status == 'passed').length;
    final failedChecks = _qualityChecks.where((c) => c.status == 'failed').length;
    final pendingChecks = _qualityChecks.where((c) => c.status == 'pending').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quality Overview',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQualityMetricCard(
                    'Total Checks',
                    totalChecks.toString(),
                    Icons.assignment,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQualityMetricCard(
                    'Passed',
                    passedChecks.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQualityMetricCard(
                    'Failed',
                    failedChecks.toString(),
                    Icons.error,
                    Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQualityMetricCard(
                    'Pending',
                    pendingChecks.toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: totalChecks > 0 ? passedChecks / totalChecks : 0,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Pass Rate: ${totalChecks > 0 ? (passedChecks / totalChecks * 100).toStringAsFixed(1) : 0}%',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestResultRow(String parameter, double result, QualitySpecification? spec) {
    bool isWithinSpec = true;
    Color statusColor = Colors.green;
    
    if (spec != null) {
      if (spec.minValue != null && result < spec.minValue!) {
        isWithinSpec = false;
        statusColor = Colors.red;
      } else if (spec.maxValue != null && result > spec.maxValue!) {
        isWithinSpec = false;
        statusColor = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(parameter.replaceAll('_', ' ').toUpperCase()),
          ),
          Expanded(
            flex: 2,
            child: Text(
              result.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              spec != null 
                ? '${spec.minValue?.toStringAsFixed(1) ?? ''} - ${spec.maxValue?.toStringAsFixed(1) ?? ''}'
                : 'N/A',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Icon(
            isWithinSpec ? Icons.check_circle : Icons.error,
            color: statusColor,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildBatchReportsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: _batchReports.length,
        itemBuilder: (context, index) {
          final report = _batchReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Batch ${report.batchId}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Chip(
                        label: Text(report.status.toUpperCase()),
                        backgroundColor: _getBatchStatusColor(report.status),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.pets, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${report.targetSpecies.name.toUpperCase()} - ${report.formulationName}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('Weight: ${report.actualWeight.toStringAsFixed(0)} kg'),
                      const SizedBox(width: 16),
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('Date: ${report.productionDate.toString().split(' ')[0]}'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Quality Metrics:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _buildQualityMetricsGrid(report.qualityMetrics),
                  if (report.deviations.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Deviations:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.orange[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...report.deviations.map((deviation) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, size: 16, color: Colors.orange),
                            const SizedBox(width: 8),
                            Expanded(child: Text(deviation)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQualityMetricsGrid(Map<String, double> metrics) {
    final entries = metrics.entries.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                entry.value.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Overall QA Metrics
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.dashboard, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Quality Metrics Dashboard',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Pass Rate', '94.2%', Icons.check_circle, Colors.green)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('Total Tests', '847', Icons.science, Colors.blue)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('Avg Score', '8.7/10', Icons.star, Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Failed Tests', '49', Icons.error, Colors.red)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('Pending', '12', Icons.hourglass_empty, Colors.amber)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('This Month', '156', Icons.calendar_today, Colors.purple)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Test Categories Performance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance by Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryPerformance('Nutritional Analysis', 96.5, Colors.green),
                  _buildCategoryPerformance('Physical Properties', 92.8, Colors.blue),
                  _buildCategoryPerformance('Contamination', 98.1, Colors.green),
                  _buildCategoryPerformance('Palatability', 89.3, Colors.orange),
                  _buildCategoryPerformance('Storage Quality', 94.7, Colors.green),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Monthly Trends
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Quality Trends',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    child: _buildTrendChart(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Top Issues
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top Quality Issues',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildIssueItem('Moisture content exceeding limits', 23, Colors.red),
                  _buildIssueItem('Protein variance in mixed feeds', 18, Colors.orange),
                  _buildIssueItem('Pellet durability below standard', 15, Colors.orange),
                  _buildIssueItem('Foreign material contamination', 11, Colors.red),
                  _buildIssueItem('Mycotoxin detection', 8, Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPerformance(String category, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(category),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    // Simple mock trend visualization
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 48, color: Colors.green),
            SizedBox(height: 8),
            Text('Quality trending upward', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            Text('94.2% average this quarter', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueItem(String issue, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.warning, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(issue)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Add Certification Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addCertification,
              icon: const Icon(Icons.add),
              label: const Text('Add Certification'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Active Certifications
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Active Certifications',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCertificationItem(
                    'ISO 22000:2018',
                    'Food Safety Management',
                    DateTime.now().add(const Duration(days: 180)),
                    Colors.green,
                    true,
                  ),
                  _buildCertificationItem(
                    'HACCP',
                    'Hazard Analysis Critical Control Points',
                    DateTime.now().add(const Duration(days: 90)),
                    Colors.green,
                    true,
                  ),
                  _buildCertificationItem(
                    'GMP+',
                    'Good Manufacturing Practice',
                    DateTime.now().add(const Duration(days: 45)),
                    Colors.orange,
                    true,
                  ),
                  _buildCertificationItem(
                    'Non-GMO Project',
                    'Non-GMO Verification',
                    DateTime.now().add(const Duration(days: 300)),
                    Colors.green,
                    true,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Expiring Soon
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Expiring Soon',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCertificationItem(
                    'GMP+',
                    'Good Manufacturing Practice',
                    DateTime.now().add(const Duration(days: 45)),
                    Colors.orange,
                    false,
                  ),
                  _buildCertificationItem(
                    'Organic Certification',
                    'USDA Organic Standards',
                    DateTime.now().add(const Duration(days: 30)),
                    Colors.red,
                    false,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Pending Renewals
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.hourglass_empty, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Pending Renewals',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRenewalItem('SQF', 'Under Review', Colors.blue),
                  _buildRenewalItem('BRC', 'Documents Submitted', Colors.blue),
                  _buildRenewalItem('Kosher', 'Audit Scheduled', Colors.orange),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationItem(String name, String description, DateTime expiry, Color statusColor, bool showActions) {
    final daysUntilExpiry = expiry.difference(DateTime.now()).inDays;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      'Expires in $daysUntilExpiry days',
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showActions) ...[
            Column(
              children: [
                IconButton(
                  onPressed: () => _renewCertification(name),
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  tooltip: 'Renew',
                ),
                IconButton(
                  onPressed: () => _viewCertificationDetails(name),
                  icon: const Icon(Icons.visibility, color: Colors.grey),
                  tooltip: 'View Details',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRenewalItem(String name, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  status,
                  style: TextStyle(color: statusColor),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _trackRenewal(name),
            style: ElevatedButton.styleFrom(
              backgroundColor: statusColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Track'),
          ),
        ],
      ),
    );
  }

  void _addCertification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Certification'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Certification Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiry Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Certification added successfully!')),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _renewCertification(String certName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Renewal process started for $certName')),
    );
  }

  void _viewCertificationDetails(String certName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(certName),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Certificate Details:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Issuing Body: International Standards Organization'),
            Text('• Certificate Number: ISO-2024-001234'),
            Text('• Scope: Feed Manufacturing & Distribution'),
            Text('• Last Audit: March 15, 2024'),
            Text('• Next Audit: March 15, 2025'),
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

  void _trackRenewal(String certName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tracking renewal progress for $certName')),
    );
  }

  Widget _getQualityStatusIcon(String status) {
    switch (status) {
      case 'passed':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'failed':
        return const Icon(Icons.error, color: Colors.red);
      case 'pending':
        return const Icon(Icons.pending, color: Colors.orange);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  Color _getQualityStatusColor(String status) {
    switch (status) {
      case 'passed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getBatchStatusColor(String status) {
    switch (status) {
      case 'released':
        return Colors.green;
      case 'quarantine':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _performQualityAudit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quality Audit'),
        content: const Text('Quality audit functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  List<QualityCheck> _generateSampleQualityChecks() {
    return [
      QualityCheck(
        id: '1',
        checkName: 'Proximate Analysis',
        batchId: 'B001',
        checkDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'passed',
        testResults: {
          'crude_protein': 18.5,
          'crude_fat': 4.2,
          'crude_fiber': 6.8,
          'ash': 7.1,
          'moisture': 12.3,
        },
        specifications: {
          'crude_protein': QualitySpecification(minValue: 18.0, maxValue: 20.0),
          'crude_fat': QualitySpecification(minValue: 3.5, maxValue: 5.0),
          'crude_fiber': QualitySpecification(maxValue: 8.0),
          'ash': QualitySpecification(maxValue: 8.0),
          'moisture': QualitySpecification(maxValue: 14.0),
        },
        notes: 'All parameters within specification',
        correctiveActions: [],
      ),
      QualityCheck(
        id: '2',
        checkName: 'Amino Acid Profile',
        batchId: 'B002',
        checkDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'failed',
        testResults: {
          'lysine': 0.95,
          'methionine': 0.28,
          'threonine': 0.65,
        },
        specifications: {
          'lysine': QualitySpecification(minValue: 1.0, maxValue: 1.3),
          'methionine': QualitySpecification(minValue: 0.30, maxValue: 0.40),
          'threonine': QualitySpecification(minValue: 0.70, maxValue: 0.90),
        },
        notes: 'Lysine and methionine below specification',
        correctiveActions: [
          'Increase synthetic lysine by 0.05%',
          'Add DL-methionine to reach target',
          'Retest batch after adjustments',
        ],
      ),
    ];
  }

  List<BatchReport> _generateSampleBatchReports() {
    return [
      BatchReport(
        batchId: 'B001',
        formulationName: 'Broiler Starter',
        targetSpecies: AnimalSpecies.poultry,
        productionDate: DateTime.now().subtract(const Duration(days: 1)),
        actualWeight: 1000.0,
        status: 'released',
        qualityMetrics: {
          'crude_protein': 22.5,
          'metabolizable_energy': 3200.0,
          'crude_fat': 6.8,
          'crude_fiber': 3.2,
        },
        deviations: [],
      ),
      BatchReport(
        batchId: 'B002',
        formulationName: 'Cattle Grower',
        targetSpecies: AnimalSpecies.cattle,
        productionDate: DateTime.now().subtract(const Duration(days: 2)),
        actualWeight: 2000.0,
        status: 'quarantine',
        qualityMetrics: {
          'crude_protein': 16.2,
          'metabolizable_energy': 2650.0,
          'crude_fat': 3.8,
          'crude_fiber': 18.5,
        },
        deviations: [
          'Crude protein 0.3% below target',
          'Pending microbiological test results',
        ],
      ),
    ];
  }
}

// Data models for Quality Assurance
class QualityCheck {
  final String id;
  final String checkName;
  final String batchId;
  final DateTime checkDate;
  final String status; // passed, failed, pending
  final Map<String, double> testResults;
  final Map<String, QualitySpecification> specifications;
  final String notes;
  final List<String> correctiveActions;

  QualityCheck({
    required this.id,
    required this.checkName,
    required this.batchId,
    required this.checkDate,
    required this.status,
    required this.testResults,
    required this.specifications,
    required this.notes,
    required this.correctiveActions,
  });
}

class QualitySpecification {
  final double? minValue;
  final double? maxValue;
  final String? unit;

  QualitySpecification({
    this.minValue,
    this.maxValue,
    this.unit,
  });
}

class BatchReport {
  final String batchId;
  final String formulationName;
  final AnimalSpecies targetSpecies;
  final DateTime productionDate;
  final double actualWeight;
  final String status; // released, quarantine, rejected
  final Map<String, double> qualityMetrics;
  final List<String> deviations;

  BatchReport({
    required this.batchId,
    required this.formulationName,
    required this.targetSpecies,
    required this.productionDate,
    required this.actualWeight,
    required this.status,
    required this.qualityMetrics,
    required this.deviations,
  });
}

class QualityMetrics {
  final double averageQuality;
  final double consistency;
  final double supplierRating;
  final DateTime lastUpdated;

  QualityMetrics({
    required this.averageQuality,
    required this.consistency,
    required this.supplierRating,
    required this.lastUpdated,
  });
}