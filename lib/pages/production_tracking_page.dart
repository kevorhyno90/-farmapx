import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/app_state.dart';
import '../models/comprehensive_animal_record.dart';

class ProductionTrackingPage extends StatefulWidget {
  const ProductionTrackingPage({super.key});

  @override
  State<ProductionTrackingPage> createState() => _ProductionTrackingPageState();
}

class _ProductionTrackingPageState extends State<ProductionTrackingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedProductionType = 'all';
  String _selectedPeriod = 'monthly';
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
                _buildProductionOverviewTab(app),
                _buildMilkProductionTab(app),
                _buildEggProductionTab(app),
                _buildMeatProductionTab(app),
                _buildFeedEfficiencyTab(app),
                _buildProductionReportsTab(app),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductionRecordDialog(app),
        backgroundColor: Colors.amber[600],
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[700]!, Colors.amber[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.trending_up, color: Colors.white, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Production Tracking & Analytics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Comprehensive production performance monitoring',
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
        labelColor: Colors.amber[700],
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Colors.amber[700],
        labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(icon: Icon(Icons.dashboard, size: 18), text: 'Overview'),
          Tab(icon: Icon(Icons.opacity, size: 18), text: 'Milk'),
          Tab(icon: Icon(Icons.egg, size: 18), text: 'Eggs'),
          Tab(icon: Icon(Icons.restaurant, size: 18), text: 'Meat'),
          Tab(icon: Icon(Icons.analytics, size: 18), text: 'Feed Efficiency'),
          Tab(icon: Icon(Icons.assessment, size: 18), text: 'Reports'),
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
              value: _selectedProductionType,
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
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'milk', child: Text('Milk')),
                DropdownMenuItem(value: 'eggs', child: Text('Eggs')),
                DropdownMenuItem(value: 'meat', child: Text('Meat')),
                DropdownMenuItem(value: 'wool', child: Text('Wool')),
              ],
              onChanged: (value) => setState(() => _selectedProductionType = value!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPeriod,
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
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
              ],
              onChanged: (value) => setState(() => _selectedPeriod = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductionOverviewTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Production Performance Dashboard',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Production Summary Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: [
              _buildProductionSummaryCard('Milk Production', '2,450L', Icons.opacity, Colors.blue, '+5.2%'),
              _buildProductionSummaryCard('Egg Production', '1,890', Icons.egg, Colors.orange, '+3.1%'),
              _buildProductionSummaryCard('Feed Efficiency', '1.42', Icons.analytics, Colors.green, '+0.8%'),
              _buildProductionSummaryCard('Revenue', '\$12,750', Icons.monetization_on, Colors.purple, '+7.5%'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Production Trends Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Production Trends',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: LineChart(_buildProductionTrendChart()),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Top Producers This Month',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getTopProducers().length,
            itemBuilder: (context, index) {
              final producer = _getTopProducers()[index];
              return _buildTopProducerCard(producer);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductionSummaryCard(String title, String value, IconData icon, MaterialColor color, String change) {
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
            Row(
              children: [
                Icon(Icons.trending_up, size: 12, color: Colors.green[600]),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProducerCard(Map<String, dynamic> producer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: producer['color'][100],
          child: Text(
            '${producer['rank']}',
            style: TextStyle(
              color: producer['color'][700],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          producer['name'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${producer['type']} • ${producer['production']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              producer['efficiency'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: producer['color'][700],
              ),
            ),
            Text(
              'Efficiency',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilkProductionTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddMilkRecordDialog(),
                  icon: Icon(Icons.opacity, size: 16),
                  label: Text('Record Milk', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showMilkQualityDialog(),
                icon: Icon(Icons.science, size: 16),
                label: Text('Quality Test', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
        ),
        
        // Milk production summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(child: _buildMilkStat('Today', '245L', Colors.blue)),
                  Expanded(child: _buildMilkStat('Week', '1,680L', Colors.green)),
                  Expanded(child: _buildMilkStat('Month', '7,350L', Colors.orange)),
                  Expanded(child: _buildMilkStat('Avg/Cow', '28.5L', Colors.purple)),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getMilkRecords().length,
            itemBuilder: (context, index) {
              final record = _getMilkRecords()[index];
              return _buildMilkRecordCard(record);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMilkStat(String title, String value, MaterialColor color) {
    return Column(
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
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMilkRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blue[100],
          child: Icon(Icons.opacity, color: Colors.blue[700], size: 16),
        ),
        title: Text(
          record['animal'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${record['date']} • ${record['quantity']}L • ${record['session']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity: ${record['quantity']}L', style: TextStyle(fontSize: 11)),
                    Text('Fat %: ${record['fatPercent']}', style: TextStyle(fontSize: 11)),
                    Text('Protein %: ${record['proteinPercent']}', style: TextStyle(fontSize: 11)),
                    Text('SCC: ${record['scc']}', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Session: ${record['session']}', style: TextStyle(fontSize: 11)),
                    Text('Duration: ${record['duration']} min', style: TextStyle(fontSize: 11)),
                    Text('Temperature: ${record['temperature']}°C', style: TextStyle(fontSize: 11)),
                    Text('Quality: ${record['quality']}', 
                         style: TextStyle(fontSize: 11, 
                                        color: record['quality'] == 'Grade A' ? Colors.green[700] : Colors.orange[700],
                                        fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEggProductionTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddEggRecordDialog(),
                  icon: Icon(Icons.egg, size: 16),
                  label: Text('Record Eggs', style: TextStyle(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showEggGradingDialog(),
                icon: Icon(Icons.grade, size: 16),
                label: Text('Egg Grading', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
        ),
        
        // Egg production summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(child: _buildEggStat('Today', '287', Colors.orange)),
                  Expanded(child: _buildEggStat('Week', '1,995', Colors.amber)),
                  Expanded(child: _buildEggStat('Month', '8,567', Colors.brown)),
                  Expanded(child: _buildEggStat('Avg/Bird', '0.82', Colors.red)),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getEggRecords().length,
            itemBuilder: (context, index) {
              final record = _getEggRecords()[index];
              return _buildEggRecordCard(record);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEggStat(String title, String value, MaterialColor color) {
    return Column(
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
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEggRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.orange[100],
          child: Icon(Icons.egg, color: Colors.orange[700], size: 16),
        ),
        title: Text(
          record['flock'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${record['date']} • ${record['quantity']} eggs • ${record['layRate']}%',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Eggs: ${record['quantity']}', style: TextStyle(fontSize: 11)),
                    Text('Grade A: ${record['gradeA']}', style: TextStyle(fontSize: 11)),
                    Text('Grade B: ${record['gradeB']}', style: TextStyle(fontSize: 11)),
                    Text('Cracked: ${record['cracked']}', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lay Rate: ${record['layRate']}%', style: TextStyle(fontSize: 11)),
                    Text('Avg Weight: ${record['avgWeight']}g', style: TextStyle(fontSize: 11)),
                    Text('Feed/Dozen: ${record['feedPerDozen']}kg', style: TextStyle(fontSize: 11)),
                    Text('Mortality: ${record['mortality']}', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeatProductionTab(AppState app) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: () => _showAddMeatRecordDialog(),
            icon: Icon(Icons.restaurant, size: 16),
            label: Text('Record Processing', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _getMeatRecords().length,
            itemBuilder: (context, index) {
              final record = _getMeatRecords()[index];
              return _buildMeatRecordCard(record);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMeatRecordCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        childrenPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.red[100],
          child: Icon(Icons.restaurant, color: Colors.red[700], size: 16),
        ),
        title: Text(
          record['animal'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${record['date']} • ${record['liveWeight']}kg live • ${record['carcassWeight']}kg carcass',
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
                        Text('Live Weight: ${record['liveWeight']}kg', style: TextStyle(fontSize: 11)),
                        Text('Carcass Weight: ${record['carcassWeight']}kg', style: TextStyle(fontSize: 11)),
                        Text('Dressing %: ${record['dressingPercent']}%', style: TextStyle(fontSize: 11)),
                        Text('Grade: ${record['grade']}', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Age: ${record['age']} months', style: TextStyle(fontSize: 11)),
                        Text('Feed Conversion: ${record['feedConversion']}', style: TextStyle(fontSize: 11)),
                        Text('Processing Cost: \$${record['processingCost']}', style: TextStyle(fontSize: 11)),
                        Text('Market Price: \$${record['marketPrice']}/kg', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedEfficiencyTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feed Conversion Analysis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Feed efficiency metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.0,
            children: [
              _buildEfficiencyMetric('Overall FCR', '1.42', Colors.green),
              _buildEfficiencyMetric('Feed Cost/kg Gain', '\$2.85', Colors.blue),
              _buildEfficiencyMetric('Daily Gain', '1.25kg', Colors.orange),
              _buildEfficiencyMetric('Feed Wastage', '3.2%', Colors.red),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Feed Conversion Records',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _getFeedConversionRecords().length,
            itemBuilder: (context, index) {
              final record = _getFeedConversionRecords()[index];
              return _buildFeedConversionCard(record);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEfficiencyMetric(String title, String value, MaterialColor color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color[700],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedConversionCard(Map<String, dynamic> record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: record['efficiency'] == 'Excellent' ? Colors.green[100] : 
                          record['efficiency'] == 'Good' ? Colors.blue[100] : Colors.orange[100],
          child: Icon(
            Icons.analytics,
            color: record['efficiency'] == 'Excellent' ? Colors.green[700] : 
                   record['efficiency'] == 'Good' ? Colors.blue[700] : Colors.orange[700],
            size: 16,
          ),
        ),
        title: Text(
          record['animal'],
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'FCR: ${record['fcr']} • Gain: ${record['weightGain']}kg • Period: ${record['period']}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        trailing: Text(
          record['efficiency'],
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: record['efficiency'] == 'Excellent' ? Colors.green[700] : 
                   record['efficiency'] == 'Good' ? Colors.blue[700] : Colors.orange[700],
          ),
        ),
      ),
    );
  }

  Widget _buildProductionReportsTab(AppState app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Production Analytics & Reports',
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
              _buildReportCard('Milk Production Report', Icons.opacity, Colors.blue),
              _buildReportCard('Egg Production Report', Icons.egg, Colors.orange),
              _buildReportCard('Feed Efficiency Report', Icons.analytics, Colors.green),
              _buildReportCard('Profitability Analysis', Icons.monetization_on, Colors.purple),
              _buildReportCard('Production Trends', Icons.trending_up, Colors.teal),
              _buildReportCard('Quality Analysis', Icons.grade, Colors.amber),
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
        onTap: () => _generateProductionReport(title),
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

  LineChartData _buildProductionTrendChart() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(1, 2100),
            FlSpot(2, 2300),
            FlSpot(3, 2450),
            FlSpot(4, 2200),
            FlSpot(5, 2600),
            FlSpot(6, 2750),
          ],
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }

  // Sample data methods
  List<Map<String, dynamic>> _getTopProducers() {
    return [
      {
        'rank': 1,
        'name': 'Princess Aurora B-127',
        'type': 'Milk Cow',
        'production': '35.2L/day',
        'efficiency': '95%',
        'color': Colors.blue,
      },
      {
        'rank': 2,
        'name': 'Flock House A',
        'type': 'Layer Hens',
        'production': '284 eggs/day',
        'efficiency': '92%',
        'color': Colors.orange,
      },
      {
        'rank': 3,
        'name': 'Thunder Bull A-89',
        'type': 'Beef Bull',
        'production': '1.8kg/day gain',
        'efficiency': '88%',
        'color': Colors.red,
      },
    ];
  }

  List<Map<String, dynamic>> _getMilkRecords() {
    return [
      {
        'animal': 'Princess Aurora B-127',
        'date': 'Oct 17, 2025',
        'quantity': 35.2,
        'session': 'Morning',
        'fatPercent': 3.8,
        'proteinPercent': 3.2,
        'scc': 125000,
        'duration': 8,
        'temperature': 4.2,
        'quality': 'Grade A',
      },
      {
        'animal': 'Queen Bella B-89',
        'date': 'Oct 17, 2025',
        'quantity': 28.7,
        'session': 'Evening',
        'fatPercent': 4.1,
        'proteinPercent': 3.4,
        'scc': 98000,
        'duration': 7,
        'temperature': 4.0,
        'quality': 'Grade A',
      },
    ];
  }

  List<Map<String, dynamic>> _getEggRecords() {
    return [
      {
        'flock': 'Layer House A',
        'date': 'Oct 17, 2025',
        'quantity': 284,
        'layRate': 89.2,
        'gradeA': 245,
        'gradeB': 32,
        'cracked': 7,
        'avgWeight': 62.5,
        'feedPerDozen': 1.8,
        'mortality': 0,
      },
      {
        'flock': 'Layer House B',
        'date': 'Oct 17, 2025',
        'quantity': 267,
        'layRate': 84.6,
        'gradeA': 221,
        'gradeB': 38,
        'cracked': 8,
        'avgWeight': 61.8,
        'feedPerDozen': 1.9,
        'mortality': 1,
      },
    ];
  }

  List<Map<String, dynamic>> _getMeatRecords() {
    return [
      {
        'animal': 'Beef Steer C-145',
        'date': 'Oct 15, 2025',
        'liveWeight': 650,
        'carcassWeight': 390,
        'dressingPercent': 60.0,
        'grade': 'Choice',
        'age': 18,
        'feedConversion': 6.2,
        'processingCost': 125,
        'marketPrice': 4.85,
      },
    ];
  }

  List<Map<String, dynamic>> _getFeedConversionRecords() {
    return [
      {
        'animal': 'Beef Steer C-145',
        'fcr': 1.42,
        'weightGain': 1.25,
        'period': '30 days',
        'efficiency': 'Excellent',
      },
      {
        'animal': 'Heifer A-67',
        'fcr': 1.65,
        'weightGain': 1.12,
        'period': '30 days',
        'efficiency': 'Good',
      },
      {
        'animal': 'Bull B-23',
        'fcr': 1.89,
        'weightGain': 0.98,
        'period': '30 days',
        'efficiency': 'Average',
      },
    ];
  }

  // Dialog methods
  void _showAddProductionRecordDialog(AppState app) {
    // Implementation for adding production records
  }

  void _showAddMilkRecordDialog() {
    // Implementation for recording milk production
  }

  void _showMilkQualityDialog() {
    // Implementation for milk quality testing
  }

  void _showAddEggRecordDialog() {
    // Implementation for recording egg production
  }

  void _showEggGradingDialog() {
    // Implementation for egg grading
  }

  void _showAddMeatRecordDialog() {
    // Implementation for recording meat production
  }

  void _generateProductionReport(String reportType) {
    // Implementation for generating production reports
  }
}