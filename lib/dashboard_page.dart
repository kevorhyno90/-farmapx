import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Widget _buildDrawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // close drawer
        Navigator.pushNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Farm Management', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            _buildDrawerItem(context, 'Animals', '/animals'),
            _buildDrawerItem(context, 'Inventory', '/inventory'),
            _buildDrawerItem(context, 'Poultry', '/poultry'),
            _buildDrawerItem(context, 'Calves', '/calf'),
            _buildDrawerItem(context, 'Crops', '/crops'),
            _buildDrawerItem(context, 'Fields', '/fields'),
            _buildDrawerItem(context, 'Feed Formulation', '/feed_formulation'),
            _buildDrawerItem(context, 'Finance', '/finance'),
            _buildDrawerItem(context, 'Tasks', '/tasks'),
            _buildDrawerItem(context, 'Transactions', '/transactions'),
            _buildDrawerItem(context, 'Reports', '/reports'),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard — KPIs and charts go here', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Use the menu (top-left) to navigate to different sections of the app.'),
          ],
        ),
      ),
    );
  }
}
