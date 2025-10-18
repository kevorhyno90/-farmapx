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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // XFarm Header
            _buildXFarmHeader(),
            const SizedBox(height: 24),
            
            // Quick Stats Section
            _buildQuickStatsSection(app, currency),
            const SizedBox(height: 24),
            
            // Charts Row
            Row(
              children: [
                Expanded(child: _buildFinancialChart(app)),
                const SizedBox(width: 16),
                Expanded(child: _buildInventoryStatusChart(app)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Recent Activities
            _buildRecentActivities(app),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: XFarmTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Quick Add', style: TextStyle(color: Colors.white)),
        onPressed: () => _showQuickAddDialog(context, app),
      ),
    );
  }

  Widget _buildXFarmHeader() {
    return XFarmCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: XFarmTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.agriculture,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'XFarm Dashboard',
                  style: XFarmTheme.farmHeadingMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Professional Agricultural Management',
                  style: XFarmTheme.farmBodyMedium.copyWith(
                    color: XFarmTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          XFarmButton(
            text: 'Refresh',
            icon: Icons.refresh,
            type: XFarmButtonType.secondary,
            size: XFarmButtonSize.small,
            onPressed: () {
              // Trigger rebuild
            },
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
        Text(
          'Farm Overview',
          style: XFarmTheme.farmHeadingMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: XFarmStatCard(
                title: 'Total Animals',
                value: totalAnimals.toString(),
                icon: Icons.pets,
                iconColor: XFarmTheme.farmBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: XFarmStatCard(
                title: 'Monthly Revenue',
                value: currency.format(totalRevenue),
                icon: Icons.trending_up,
                iconColor: XFarmTheme.earthGreen,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: XFarmStatCard(
                title: 'Monthly Expenses',
                value: currency.format(totalExpenses),
                icon: Icons.trending_down,
                iconColor: XFarmTheme.criticalRed,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: XFarmStatCard(
                title: 'Low Stock Items',
                value: lowStockItems.toString(),
                icon: Icons.warning,
                iconColor: lowStockItems > 0 ? XFarmTheme.sunYellow : XFarmTheme.secondaryText,
                subtitle: lowStockItems > 0 ? 'Needs attention' : 'All good',
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
          Text(
            'Financial Overview',
            style: XFarmTheme.farmHeadingSmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: XFarmTheme.earthGreen,
                    value: income,
                    title: 'Income\n\$${income.toStringAsFixed(0)}',
                    radius: 90,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: XFarmTheme.criticalRed,
                    value: expenses,
                    title: 'Expenses\n\$${expenses.toStringAsFixed(0)}',
                    radius: 90,
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
          Text(
            'Inventory Status',
            style: XFarmTheme.farmHeadingSmall,
          ),
          const SizedBox(height: 16),
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
                        color: XFarmTheme.earthGreen,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: lowStock.toDouble(),
                        color: XFarmTheme.sunYellow,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
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
                        borderRadius: BorderRadius.circular(4),
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

  Widget _buildRecentActivities(AppState app) {
    return XFarmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activities',
            style: XFarmTheme.farmHeadingSmall,
          ),
          const SizedBox(height: 16),
          if (app.animals.isEmpty)
            Center(
              child: Text(
                'No recent activities',
                style: XFarmTheme.farmBodyMedium.copyWith(
                  color: XFarmTheme.secondaryText,
                ),
              ),
            )
          else
            Column(
              children: app.animals.take(3).map((animal) {
                return XFarmListTile(
                  title: animal.tag,
                  subtitle: 'Animal ID: ${animal.id}',
                  leading: Icons.pets,
                  leadingColor: XFarmTheme.farmBlue,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  void _showQuickAddDialog(BuildContext context, AppState app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Quick Add',
          style: XFarmTheme.farmHeadingSmall,
        ),
        content: const Text('What would you like to add?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}