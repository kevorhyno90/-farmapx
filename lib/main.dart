import 'package:flutter/material.dart';

void main() {
  runApp(const FarmApxApp());
}

class FarmApxApp extends StatelessWidget {
  const FarmApxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmApx',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'FarmApx - Farm Management'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    CropsPage(),
    LivestockPage(),
    InventoryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.agriculture, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'FarmApx',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grass),
              title: const Text('Crops'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Livestock'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventory'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Farm Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardCard(
                  context,
                  'Total Crops',
                  '12',
                  Icons.grass,
                  Colors.green,
                ),
                _buildDashboardCard(
                  context,
                  'Livestock',
                  '45',
                  Icons.pets,
                  Colors.brown,
                ),
                _buildDashboardCard(
                  context,
                  'Inventory Items',
                  '78',
                  Icons.inventory,
                  Colors.blue,
                ),
                _buildDashboardCard(
                  context,
                  'Tasks Pending',
                  '5',
                  Icons.task,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              count,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CropsPage extends StatelessWidget {
  const CropsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crops Management',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildCropCard('Wheat', 'Field A', 'Growing', Colors.amber),
                _buildCropCard('Corn', 'Field B', 'Harvesting', Colors.yellow),
                _buildCropCard('Soybeans', 'Field C', 'Planted', Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropCard(String name, String field, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.grass, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text('$field - Status: $status'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class LivestockPage extends StatelessWidget {
  const LivestockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Livestock Management',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildLivestockCard('Cattle', '25', Icons.pets, Colors.brown),
                _buildLivestockCard('Chickens', '150', Icons.egg, Colors.orange),
                _buildLivestockCard('Pigs', '10', Icons.pets, Colors.pink),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivestockCard(String type, String count, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(type),
        subtitle: Text('Total: $count animals'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inventory Management',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildInventoryCard('Seeds', '500 kg', Icons.eco, Colors.green),
                _buildInventoryCard('Fertilizer', '200 kg', Icons.science, Colors.blue),
                _buildInventoryCard('Tools', '45 items', Icons.build, Colors.grey),
                _buildInventoryCard('Feed', '300 kg', Icons.breakfast_dining, Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(String item, String quantity, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(item),
        subtitle: Text('Available: $quantity'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
