import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'animals_page.dart';
import 'calf_page.dart';
import 'crops_page.dart';
import 'dashboard_page.dart';
import 'employees_page.dart';
import 'feed_formulation_page.dart';
import 'fields_page.dart';
import 'finance_page.dart';
import 'inventory_page.dart';
import 'livestock_page.dart';
import 'login_page.dart';
import 'poultry_page.dart';
import 'reports_page.dart';
import 'shell_page.dart';
import 'tasks_page.dart';
import 'transactions_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/animals': (context) => const AnimalsPage(),
        '/calf': (context) => const CalfPage(),
        '/crops': (context) => const CropsPage(),
        '/employees': (context) => const EmployeesPage(),
        '/feed_formulation': (context) => const FeedFormulationPage(),
        '/fields': (context) => const FieldsPage(),
        '/finance': (context) => const FinancePage(),
        '/inventory': (context) => const InventoryPage(),
        '/livestock': (context) => const LivestockPage(),
        '/poultry': (context) => const PoultryPage(),
        '/reports': (context) => const ReportsPage(),
        '/shell': (context) => const ShellPage(),
        '/tasks': (context) => const TasksPage(),
        '/transactions': (context) => const TransactionsPage(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'animals_page.dart';
import 'calf_page.dart';
import 'crops_page.dart';
import 'dashboard_page.dart';
import 'employees_page.dart';
import 'feed_formulation_page.dart';
import 'fields_page.dart';
import 'finance_page.dart';
import 'inventory_page.dart';
import 'livestock_page.dart';
import 'login_page.dart';
import 'poultry_page.dart';
import 'reports_page.dart';
import 'shell_page.dart';
import 'tasks_page.dart';
import 'transactions_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/animals': (context) => const AnimalsPage(),
        '/calf': (context) => const CalfPage(),
        '/crops': (context) => const CropsPage(),
        '/employees': (context) => const EmployeesPage(),
        '/feed_formulation': (context) => const FeedFormulationPage(),
        '/fields': (context) => const FieldsPage(),
        '/finance': (context) => const FinancePage(),
        '/inventory': (context) => const InventoryPage(),
        '/livestock': (context) => const LivestockPage(),
        '/poultry': (context) => const PoultryPage(),
        '/reports': (context) => const ReportsPage(),
        '/shell': (context) => const ShellPage(),
        '/tasks': (context) => const TasksPage(),
        '/transactions': (context) => const TransactionsPage(),
      },
    );
  }
}
