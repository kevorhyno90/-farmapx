import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'services/app_state.dart';
import 'models/animal.dart';
import 'models/inventory_item.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final currency = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Dashboard'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/animals'),
            child: const Text('Animals', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/inventory'),
            child: const Text('Inventory', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/crops'),
            child: const Text('Crops', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/finance'),
            child: const Text('Finance', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Dashboard',
            onPressed: () {
              // Trigger rebuild - the provider will handle this
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Row
            _buildQuickStatsSection(app, currency),
            const SizedBox(height: 12),
            
            // Charts Row
            Row(
              children: [
                Expanded(child: _buildFinancialChart(app)),
                const SizedBox(width: 8),
                Expanded(child: _buildInventoryStatusChart(app)),
              ],
            ),
            const SizedBox(height: 12),
            
            // Animal Health and Production
            Row(
              children: [
                Expanded(child: _buildAnimalHealthChart(app)),
                const SizedBox(width: 8),
                Expanded(child: _buildProductionMetrics(app, currency)),
              ],
            ),
            const SizedBox(height: 12),
            
            // Recent Activities and Alerts
            Row(
              children: [
                Expanded(child: _buildRecentActivities(app)),
                const SizedBox(width: 8),
                Expanded(child: _buildAlertsSection(app)),
              ],
            ),
            const SizedBox(height: 12),
            
            // Navigation Cards
            _buildNavigationSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
        onPressed: () => _showQuickAddDialog(context, app),
      ),
    );
  }

  Widget _buildQuickStatsSection(AppState app, NumberFormat currency) {
    final totalAnimals = app.animals.length;
    final totalRevenue = app.transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpenses = app.transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final lowStockItems = app.inventory
        .where((item) => item.status == InventoryStatus.low_stock || item.status == InventoryStatus.out_of_stock)
        .length;

    return Row(
      children: [
        Expanded(child: _buildStatCard(
          'Total Animals', 
          totalAnimals.toString(),
          Icons.pets,
          Colors.blue.shade600,
        )),
        const SizedBox(width: 6),
        Expanded(child: _buildStatCard(
          'Monthly Revenue', 
          currency.format(totalRevenue),
          Icons.trending_up,
          Colors.green.shade600,
        )),
        const SizedBox(width: 6),
        Expanded(child: _buildStatCard(
          'Monthly Expenses', 
          currency.format(totalExpenses),
          Icons.trending_down,
          Colors.red.shade600,
        )),
        const SizedBox(width: 6),
        Expanded(child: _buildStatCard(
          'Low Stock Items', 
          lowStockItems.toString(),
          Icons.warning,
          lowStockItems > 0 ? Colors.orange.shade600 : Colors.grey.shade600,
        )),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
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
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialChart(AppState app) {
    final income = app.transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = app.transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Overview',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 100,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.green.shade600,
                      value: income,
                      title: 'Income\n\$${income.toStringAsFixed(0)}',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.red.shade600,
                      value: expenses,
                      title: 'Expenses\n\$${expenses.toStringAsFixed(0)}',
                      radius: 80,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryStatusChart(AppState app) {
    final inStock = app.inventory.where((i) => i.status == InventoryStatus.in_stock).length;
    final lowStock = app.inventory.where((i) => i.status == InventoryStatus.low_stock).length;
    final outOfStock = app.inventory.where((i) => i.status == InventoryStatus.out_of_stock).length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: inStock.toDouble(),
                          color: Colors.green.shade600,
                          width: 40,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: lowStock.toDouble(),
                          color: Colors.orange.shade600,
                          width: 40,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: outOfStock.toDouble(),
                          color: Colors.red.shade600,
                          width: 40,
                        ),
                      ],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0: return const Text('In Stock');
                            case 1: return const Text('Low Stock');
                            case 2: return const Text('Out of Stock');
                            default: return const Text('');
                          }
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalHealthChart(AppState app) {
    final healthy = app.animals.where((a) => a.healthStatus == HealthStatus.healthy).length;
    final sick = app.animals.where((a) => a.healthStatus == HealthStatus.sick).length;
    final recovering = app.animals.where((a) => a.healthStatus == HealthStatus.recovering).length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Animal Health Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHealthIndicator('Healthy', healthy, Colors.green.shade600),
                _buildHealthIndicator('Sick', sick, Colors.red.shade600),
                _buildHealthIndicator('Recovering', recovering, Colors.orange.shade600),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthIndicator(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildProductionMetrics(AppState app, NumberFormat currency) {
    final totalMilkProduction = app.animals
        .where((a) => a.isLactating)
        .fold(0.0, (sum, a) => sum + (a.averageDailyMilk ?? 0.0));
    
    final activeCrops = app.crops.where((c) => c.isActive).length;
    final totalCropArea = app.crops.fold(0.0, (sum, c) => sum + c.areaPlanted);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Production Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMetricRow('Daily Milk Production', '${totalMilkProduction.toStringAsFixed(1)} L'),
            _buildMetricRow('Active Crops', activeCrops.toString()),
            _buildMetricRow('Total Crop Area', '${totalCropArea.toStringAsFixed(1)} ha'),
            _buildMetricRow('Active Employees', app.employees.where((e) => e.isActive).length.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(AppState app) {
    final recentTransactions = app.transactions.take(5).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...recentTransactions.map((transaction) => ListTile(
              dense: true,
              leading: Icon(
                transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: transaction.isIncome ? Colors.green : Colors.red,
              ),
              title: Text(transaction.description.isNotEmpty ? transaction.description : transaction.category),
              subtitle: Text(DateFormat('MMM dd').format(transaction.date)),
              trailing: Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transaction.isIncome ? Colors.green : Colors.red,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(AppState app) {
    final alerts = <String>[];
    
    // Check for low stock items
    final lowStockItems = app.inventory.where((item) => item.needsReorder).toList();
    if (lowStockItems.isNotEmpty) {
      alerts.add('${lowStockItems.length} items need reordering');
    }
    
    // Check for expiring items
    final expiringItems = app.inventory.where((item) => item.isExpiringSoon).toList();
    if (expiringItems.isNotEmpty) {
      alerts.add('${expiringItems.length} items expiring soon');
    }
    
    // Check for sick animals
    final sickAnimals = app.animals.where((a) => a.healthStatus != HealthStatus.healthy).toList();
    if (sickAnimals.isNotEmpty) {
      alerts.add('${sickAnimals.length} animals need attention');
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alerts & Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (alerts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No alerts at this time',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...alerts.map((alert) => ListTile(
                dense: true,
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text(alert),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Navigation',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildNavigationCard(context, 'Animals', Icons.pets, '/animals'),
            _buildNavigationCard(context, 'Crops', Icons.grass, '/crops'),
            _buildNavigationCard(context, 'Inventory', Icons.inventory, '/inventory'),
            _buildNavigationCard(context, 'Finance', Icons.attach_money, '/finance'),
            _buildNavigationCard(context, 'Employees', Icons.people, '/employees'),
            _buildNavigationCard(context, 'Tasks', Icons.task, '/tasks'),
            _buildNavigationCard(context, 'Reports', Icons.insert_chart, '/reports'),
            _buildNavigationCard(context, 'Fields', Icons.landscape, '/fields'),
            _buildNavigationCard(context, 'Feed Formulation', Icons.science, '/feed-formulation'),
            _buildNavigationCard(context, 'Quality Assurance', Icons.verified, '/quality-assurance'),
            _buildNavigationCard(context, 'Cost Management', Icons.analytics, '/cost-management'),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.green.shade700),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickAddDialog(BuildContext context, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Add'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Add Animal'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/animals');
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Add Inventory Item'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/inventory');
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Add Transaction'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/transactions');
              },
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Add Task'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/tasks');
              },
            ),
          ],
        ),
      ),
    );
  }
}
