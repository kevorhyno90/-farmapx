import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'services/app_state.dart';
import 'models/animal.dart';
import 'models/inventory_item.dart';
import 'design/xfarm_theme.dart';
import 'widgets/xfarm_components.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final currency = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      backgroundColor: XFarmTheme.lightBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(XFarmTheme.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // XFarm Agricultural Header
            _buildFarmHeader(),
            const SizedBox(height: XFarmTheme.spacingXLarge),
            
            // Farm Statistics Overview
            _buildQuickStatsSection(app, currency),
            const SizedBox(height: XFarmTheme.spacingXLarge),
            
            // Agricultural Analytics
            Row(
              children: [
                Expanded(child: _buildFinancialChart(app)),
                const SizedBox(width: XFarmTheme.spacingMedium),
                Expanded(child: _buildInventoryStatusChart(app)),
              ],
            ),
            const SizedBox(height: XFarmTheme.spacingXLarge),
            
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
        onPressed: () => _showQuickAddDialog(context, app),
      ),
    );
  }

  Widget _buildFarmHeader() {
    return XFarmCard(
      gradient: XFarmTheme.farmGradient,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(XFarmTheme.spacingMedium),
            decoration: BoxDecoration(
              color: XFarmTheme.lightText.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(XFarmTheme.radiusMedium),
            ),
            child: Icon(
              XFarmIcons.farm,
              color: XFarmTheme.lightText,
              size: 48,
            ),
          ),
          const SizedBox(width: XFarmTheme.spacingLarge),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Farm Dashboard',
                  style: XFarmTheme.farmHeadingLarge.copyWith(
                    color: XFarmTheme.lightText,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: XFarmTheme.spacingTiny),
                Text(
                  'Monitor your agricultural operations in real-time',
                  style: XFarmTheme.farmBodyLarge.copyWith(
                    color: XFarmTheme.lightText.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: XFarmTheme.spacingSmall),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: XFarmTheme.spacingSmall,
                        vertical: XFarmTheme.spacingTiny,
                      ),
                      decoration: BoxDecoration(
                        color: XFarmTheme.lightText.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            XFarmIcons.weather,
                            color: XFarmTheme.lightText,
                            size: 16,
                          ),
                          const SizedBox(width: XFarmTheme.spacingTiny),
                          Text(
                            '23°C',
                            style: XFarmTheme.farmLabelSmall.copyWith(
                              color: XFarmTheme.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: XFarmTheme.spacingSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: XFarmTheme.spacingSmall,
                        vertical: XFarmTheme.spacingTiny,
                      ),
                      decoration: BoxDecoration(
                        color: XFarmTheme.lightText.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            XFarmIcons.calendar,
                            color: XFarmTheme.lightText,
                            size: 16,
                          ),
                          const SizedBox(width: XFarmTheme.spacingTiny),
                          Text(
                            'Today',
                            style: XFarmTheme.farmLabelSmall.copyWith(
                              color: XFarmTheme.lightText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(XFarmTheme.spacingSmall),
            decoration: BoxDecoration(
              color: XFarmTheme.lightText.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
            ),
            child: Icon(
              Icons.refresh,
              color: XFarmTheme.lightText,
              size: 24,
            ),
          ),
        ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              XFarmIcons.analytics,
              color: XFarmTheme.primaryGreen,
              size: 24,
            ),
            const SizedBox(width: XFarmTheme.spacingSmall),
            Text(
              'Farm Statistics',
              style: XFarmTheme.farmHeadingMedium,
            ),
          ],
        ),
        const SizedBox(height: XFarmTheme.spacingMedium),
        Row(
          children: [
            Expanded(
              child: XFarmStatCard(
                title: 'Livestock Count',
                value: totalAnimals.toString(),
                icon: XFarmIcons.livestock,
                iconColor: XFarmTheme.farmBlue,
                showTrend: true,
                trendValue: 8.5,
              ),
            ),
            const SizedBox(width: XFarmTheme.spacingMedium),
            Expanded(
              child: XFarmStatCard(
                title: 'Monthly Revenue',
                value: currency.format(totalRevenue),
                icon: XFarmIcons.money,
                iconColor: XFarmTheme.healthyGreen,
                showTrend: true,
                trendValue: 12.3,
              ),
            ),
            const SizedBox(width: XFarmTheme.spacingMedium),
            Expanded(
              child: XFarmStatCard(
                title: 'Operating Costs',
                value: currency.format(totalExpenses),
                icon: Icons.trending_down,
                iconColor: XFarmTheme.cropOrange,
                showTrend: true,
                trendValue: -3.2,
              ),
            ),
            const SizedBox(width: XFarmTheme.spacingMedium),
            Expanded(
              child: XFarmStatCard(
                title: 'Inventory Alerts',
                value: lowStockItems.toString(),
                icon: XFarmIcons.storage,
                iconColor: lowStockItems > 0 ? XFarmTheme.warningAmber : XFarmTheme.healthyGreen,
                subtitle: lowStockItems > 0 ? 'Items need restocking' : 'All supplies sufficient',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialChart(AppState app) {
    final income = app.transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = app.transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);

    return XFarmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(XFarmTheme.spacingSmall),
                decoration: BoxDecoration(
                  gradient: XFarmTheme.farmGradient,
                  borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                ),
                child: Icon(
                  XFarmIcons.money,
                  color: XFarmTheme.lightText,
                  size: 20,
                ),
              ),
              const SizedBox(width: XFarmTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Financial Health',
                      style: XFarmTheme.farmHeadingSmall,
                    ),
                    Text(
                      'Income vs Expenses Overview',
                      style: XFarmTheme.farmBodySmall.copyWith(
                        color: XFarmTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: XFarmTheme.spacingLarge),
          SizedBox(
            height: 120,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: XFarmTheme.healthyGreen,
                    value: income,
                    title: 'Revenue\n\$${income.toStringAsFixed(0)}',
                    radius: 90,
                    titleStyle: XFarmTheme.farmLabelMedium.copyWith(
                      color: XFarmTheme.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PieChartSectionData(
                    color: XFarmTheme.cropOrange,
                    value: expenses,
                    title: 'Costs\n\$${expenses.toStringAsFixed(0)}',
                    radius: 90,
                    titleStyle: XFarmTheme.farmLabelMedium.copyWith(
                      color: XFarmTheme.lightText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: XFarmTheme.spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem('Revenue', XFarmTheme.healthyGreen),
              _buildLegendItem('Operating Costs', XFarmTheme.cropOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: XFarmTheme.spacingTiny),
        Text(
          label,
          style: XFarmTheme.farmBodySmall,
        ),
      ],
    );
  }

  Widget _buildInventoryStatusChart(AppState app) {
    final inStock = app.inventory.where((i) => i.status == InventoryStatus.in_stock).length;
    final lowStock = app.inventory.where((i) => i.status == InventoryStatus.low_stock).length;
    final outOfStock = app.inventory.where((i) => i.status == InventoryStatus.out_of_stock).length;

    return XFarmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(XFarmTheme.spacingSmall),
                decoration: BoxDecoration(
                  gradient: XFarmTheme.skyGradient,
                  borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                ),
                child: Icon(
                  XFarmIcons.storage,
                  color: XFarmTheme.lightText,
                  size: 20,
                ),
              ),
              const SizedBox(width: XFarmTheme.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory Status',
                      style: XFarmTheme.farmHeadingSmall,
                    ),
                    Text(
                      'Current stock levels',
                      style: XFarmTheme.farmBodySmall.copyWith(
                        color: XFarmTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: XFarmTheme.spacingLarge),
          SizedBox(
            height: 120,
            child: BarChart(
              BarChartData(
                maxY: (inStock + lowStock + outOfStock).toDouble() + 5,
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: inStock.toDouble(),
                        color: XFarmTheme.healthyGreen,
                        width: 20,
                        borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: lowStock.toDouble(),
                        color: XFarmTheme.warningAmber,
                        width: 20,
                        borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: outOfStock.toDouble(),
                        color: XFarmTheme.criticalRed,
                        width: 20,
                        borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
                      ),
                    ],
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['In Stock', 'Low Stock', 'Out of Stock'];
                        return Text(
                          titles[value.toInt()],
                          style: XFarmTheme.farmBodySmall,
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
    );
  }
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
