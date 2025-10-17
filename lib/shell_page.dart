import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'livestock_page.dart';
import 'crops_page.dart';
import 'inventory_page.dart';
import 'feed_formulation_page.dart';
import 'finance_page.dart';
import 'tasks_page.dart';
import 'reports_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({Key? key}) : super(key: key);

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _selectedIndex = 0;
  final List<Widget?> _pages = List.filled(9, null); // Cache pages

  Widget _getPage(int index) {
    // Cache pages after first load to improve performance
    if (_pages[index] != null) return _pages[index]!;

    switch (index) {
      case 0:
        return _pages[0] = const DashboardPage();
      case 1:
        return _pages[1] = const LivestockPage();
      case 2:
        return _pages[2] = const CropsPage();
      case 3:
        return _pages[3] = const InventoryPage();
      case 4:
        return _pages[4] = const FeedFormulationPage();
      case 5:
        return _pages[5] = const FinancePage();
      case 6:
        return _pages[6] = const TasksPage();
      case 7:
        return _pages[7] = const ReportsPage();
      case 8:
        return _pages[8] = _buildSettingsPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  Widget _buildSettingsPage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Settings', style: TextStyle(fontSize: 24)),
          SizedBox(height: 8),
          Text('Coming Soon', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(9, (index) {
          // Only build the current page and cache it
          if (index == _selectedIndex || _pages[index] != null) {
            return _getPage(index);
          }
          return const SizedBox.shrink(); // Empty placeholder
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Livestock'),
          BottomNavigationBarItem(icon: Icon(Icons.agriculture), label: 'Crops'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventory'),
          BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Finance'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
