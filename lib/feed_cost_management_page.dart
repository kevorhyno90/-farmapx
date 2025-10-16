import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class FeedCostManagementPage extends StatefulWidget {
  const FeedCostManagementPage({Key? key}) : super(key: key);

  @override
  State<FeedCostManagementPage> createState() => _FeedCostManagementPageState();
}

class _FeedCostManagementPageState extends State<FeedCostManagementPage> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Cost data
  List<CostAnalysis> _costAnalyses = [];
  List<PriceHistory> _priceHistories = [];
  List<SupplierQuote> _supplierQuotes = [];
  Map<String, double> _currentPrices = {};
  
  // Filters
  String _selectedPeriod = 'month';
  String _selectedCurrency = 'USD';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCostData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadCostData() {
    _costAnalyses = _generateSampleCostAnalyses();
    _priceHistories = _generateSamplePriceHistories();
    _supplierQuotes = _generateSampleSupplierQuotes();
    _currentPrices = _generateCurrentPrices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Cost Management'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Cost Analysis', icon: Icon(Icons.analytics)),
            Tab(text: 'Price Trends', icon: Icon(Icons.trending_up)),
            Tab(text: 'Suppliers', icon: Icon(Icons.business)),
            Tab(text: 'Budgets', icon: Icon(Icons.account_balance_wallet)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCostAnalysisTab(),
          _buildPriceTrendsTab(),
          _buildSuppliersTab(),
          _buildBudgetsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateCostReport,
        backgroundColor: Colors.orange[700],
        label: const Text('Cost Report'),
        icon: const Icon(Icons.assessment),
      ),
    );
  }

  Widget _buildCostAnalysisTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCostOverview(),
          const SizedBox(height: 16),
          _buildCostBreakdownChart(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildCostAnalysisList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCostOverview() {
    final totalCost = _costAnalyses.fold<double>(0, (sum, analysis) => sum + analysis.totalCost);
    final avgCostPerTon = _costAnalyses.isNotEmpty ? totalCost / _costAnalyses.length : 0;
    final lowestCost = _costAnalyses.isEmpty ? 0 : _costAnalyses.map((a) => a.costPerTon).reduce(math.min);
    final highestCost = _costAnalyses.isEmpty ? 0 : _costAnalyses.map((a) => a.costPerTon).reduce(math.max);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Overview',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCostMetricCard(
                    'Total Cost',
                    '\$${totalCost.toStringAsFixed(0)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCostMetricCard(
                    'Avg Cost/Ton',
                    '\$${avgCostPerTon.toStringAsFixed(0)}',
                    Icons.trending_flat,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCostMetricCard(
                    'Lowest',
                    '\$${lowestCost.toStringAsFixed(0)}',
                    Icons.trending_down,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCostMetricCard(
                    'Highest',
                    '\$${highestCost.toStringAsFixed(0)}',
                    Icons.trending_up,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
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

  Widget _buildCostBreakdownChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cost Breakdown by Category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final categoryTotals = <String, double>{};
    
    for (final analysis in _costAnalyses) {
      for (final component in analysis.costComponents) {
        categoryTotals[component.category] = 
            (categoryTotals[component.category] ?? 0) + component.cost;
      }
    }

    final total = categoryTotals.values.fold<double>(0, (sum, cost) => sum + cost);
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    
    return categoryTotals.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final mapEntry = entry.value;
      final percentage = (mapEntry.value / total) * 100;
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: mapEntry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildCostAnalysisList() {
    return ListView.builder(
      itemCount: _costAnalyses.length,
      itemBuilder: (context, index) {
        final analysis = _costAnalyses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            leading: Icon(
              Icons.pie_chart,
              color: Colors.orange[700],
            ),
            title: Text(analysis.formulationName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cost per ton: \$${analysis.costPerTon.toStringAsFixed(2)}'),
                Text('Total cost: \$${analysis.totalCost.toStringAsFixed(2)}'),
                Text('Date: ${analysis.analysisDate.toString().split(' ')[0]}'),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cost Components:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...analysis.costComponents.map((component) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(component.category),
                            Text('\$${component.cost.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                    if (analysis.costDrivers.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Cost Drivers:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...analysis.costDrivers.map((driver) =>
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text('• $driver'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPriceTrendsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          _buildPriceTrendChart(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildPriceTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text('Period: '),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: _selectedPeriod,
              items: const [
                DropdownMenuItem(value: 'week', child: Text('Week')),
                DropdownMenuItem(value: 'month', child: Text('Month')),
                DropdownMenuItem(value: 'quarter', child: Text('Quarter')),
                DropdownMenuItem(value: 'year', child: Text('Year')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
            ),
            const SizedBox(width: 32),
            const Text('Currency: '),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: _selectedCurrency,
              items: const [
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                DropdownMenuItem(value: 'GBP', child: Text('GBP')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTrendChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Trends - Key Ingredients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.now().subtract(Duration(days: (30 - value).toInt()));
                          return Text('${date.month}/${date.day}');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: _buildLineChartData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> _buildLineChartData() {
    final ingredients = ['Corn', 'Soybean Meal', 'Wheat'];
    final colors = [Colors.blue, Colors.green, Colors.orange];
    
    return ingredients.asMap().entries.map((entry) {
      final index = entry.key;
      final ingredient = entry.value;
      
      return LineChartBarData(
        spots: List.generate(30, (i) {
          final basePrice = 300 + index * 100;
          final variation = math.sin(i * 0.2) * 50;
          return FlSpot(i.toDouble(), basePrice + variation);
        }),
        isCurved: true,
        color: colors[index],
        barWidth: 2,
        dotData: const FlDotData(show: false),
      );
    }).toList();
  }

  Widget _buildPriceTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Prices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _currentPrices.length,
                itemBuilder: (context, index) {
                  final entry = _currentPrices.entries.elementAt(index);
                  final change = (math.Random().nextDouble() - 0.5) * 10;
                  final isPositive = change > 0;
                  
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.grain),
                    ),
                    title: Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                    subtitle: Text('per metric ton'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${entry.value.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive ? Icons.trending_up : Icons.trending_down,
                              color: isPositive ? Colors.red : Colors.green,
                              size: 16,
                            ),
                            Text(
                              '${change.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: isPositive ? Colors.red : Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuppliersTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: _supplierQuotes.length,
        itemBuilder: (context, index) {
          final quote = _supplierQuotes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange[100],
                        child: Icon(Icons.business, color: Colors.orange[700]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quote.supplierName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              quote.ingredient,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${quote.pricePerTon.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'per ton',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuoteDetailChip('Qty: ${quote.quantity.toStringAsFixed(0)}T'),
                      const SizedBox(width: 8),
                      _buildQuoteDetailChip('Valid: ${quote.validUntil.toString().split(' ')[0]}'),
                      const SizedBox(width: 8),
                      _buildQuoteDetailChip(quote.paymentTerms),
                    ],
                  ),
                  if (quote.notes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Notes: ${quote.notes}',
                      style: TextStyle(color: Colors.grey[600]),
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

  Widget _buildQuoteDetailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildBudgetsTab() {
    return const Center(
      child: Text('Budget management coming soon...'),
    );
  }

  void _generateCostReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cost Report'),
        content: const Text('Comprehensive cost report will be generated here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Sample data generators
  List<CostAnalysis> _generateSampleCostAnalyses() {
    return [
      CostAnalysis(
        id: '1',
        formulationName: 'Broiler Starter',
        analysisDate: DateTime.now(),
        totalCost: 1250.0,
        costPerTon: 625.0,
        costComponents: [
          CostComponent(category: 'Grains', cost: 400.0),
          CostComponent(category: 'Protein Meals', cost: 350.0),
          CostComponent(category: 'Fats & Oils', cost: 150.0),
          CostComponent(category: 'Additives', cost: 250.0),
          CostComponent(category: 'Processing', cost: 100.0),
        ],
        costDrivers: [
          'Soybean meal price increase (15%)',
          'Energy costs up due to processing',
          'Premium additives for performance',
        ],
      ),
      CostAnalysis(
        id: '2',
        formulationName: 'Cattle Grower',
        analysisDate: DateTime.now().subtract(const Duration(days: 1)),
        totalCost: 800.0,
        costPerTon: 400.0,
        costComponents: [
          CostComponent(category: 'Grains', cost: 300.0),
          CostComponent(category: 'Forages', cost: 250.0),
          CostComponent(category: 'Protein Meals', cost: 150.0),
          CostComponent(category: 'Minerals', cost: 75.0),
          CostComponent(category: 'Processing', cost: 25.0),
        ],
        costDrivers: [
          'Corn price stable',
          'Hay quality premium',
          'Efficient processing',
        ],
      ),
    ];
  }

  List<PriceHistory> _generateSamplePriceHistories() {
    return [
      PriceHistory(
        ingredient: 'Corn',
        prices: List.generate(30, (i) => 
          300 + math.sin(i * 0.1) * 20 + math.Random().nextDouble() * 10
        ),
        dates: List.generate(30, (i) => 
          DateTime.now().subtract(Duration(days: 29 - i))
        ),
      ),
    ];
  }

  List<SupplierQuote> _generateSampleSupplierQuotes() {
    return [
      SupplierQuote(
        id: '1',
        supplierName: 'AgriSource Inc.',
        ingredient: 'Corn Grain',
        pricePerTon: 285.0,
        quantity: 100.0,
        validUntil: DateTime.now().add(const Duration(days: 15)),
        paymentTerms: 'Net 30',
        notes: 'Premium grade, FOB delivery',
      ),
      SupplierQuote(
        id: '2',
        supplierName: 'ProFeed Supply',
        ingredient: 'Soybean Meal 48%',
        pricePerTon: 420.0,
        quantity: 50.0,
        validUntil: DateTime.now().add(const Duration(days: 10)),
        paymentTerms: 'Net 15',
        notes: 'High protein content, certified non-GMO',
      ),
    ];
  }

  Map<String, double> _generateCurrentPrices() {
    return {
      'corn_grain': 285.0,
      'soybean_meal_48': 420.0,
      'wheat_grain': 245.0,
      'soybean_oil': 650.0,
      'fish_meal': 1250.0,
      'alfalfa_hay': 180.0,
      'limestone': 45.0,
      'dicalcium_phosphate': 850.0,
    };
  }
}

// Data models for Cost Management
class CostAnalysis {
  final String id;
  final String formulationName;
  final DateTime analysisDate;
  final double totalCost;
  final double costPerTon;
  final List<CostComponent> costComponents;
  final List<String> costDrivers;

  CostAnalysis({
    required this.id,
    required this.formulationName,
    required this.analysisDate,
    required this.totalCost,
    required this.costPerTon,
    required this.costComponents,
    required this.costDrivers,
  });
}

class CostComponent {
  final String category;
  final double cost;

  CostComponent({
    required this.category,
    required this.cost,
  });
}

class PriceHistory {
  final String ingredient;
  final List<double> prices;
  final List<DateTime> dates;

  PriceHistory({
    required this.ingredient,
    required this.prices,
    required this.dates,
  });
}

class SupplierQuote {
  final String id;
  final String supplierName;
  final String ingredient;
  final double pricePerTon;
  final double quantity;
  final DateTime validUntil;
  final String paymentTerms;
  final String notes;

  SupplierQuote({
    required this.id,
    required this.supplierName,
    required this.ingredient,
    required this.pricePerTon,
    required this.quantity,
    required this.validUntil,
    required this.paymentTerms,
    required this.notes,
  });
}