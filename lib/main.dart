import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'services/simple_sample_data_service.dart';
import 'design/xfarm_theme.dart';
import 'dashboard_page.dart';
import 'animals_page.dart';
import 'calf_page.dart';
import 'crops_page.dart';
import 'employees_page.dart';
import 'feed_formulation_page.dart';
import 'quality_assurance_page.dart';
import 'feed_cost_management_page.dart';
import 'fields_page.dart';
import 'finance_page.dart';
import 'inventory_page.dart';
import 'livestock_page.dart';
import 'poultry_page.dart';
import 'reports_page.dart';
import 'enhanced_shell_page.dart';
import 'tasks_page.dart';
import 'transactions_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final s = AppState();
        // Initialize with simple sample data
        SimpleSampleDataService.populateAllSampleData(s);
        return s;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XFarm - Professional Agricultural Management',
      theme: XFarmTheme.xfarmTheme,
      debugShowCheckedModeBanner: false,
      home: const EnhancedShellPage(),
    );
  }
}