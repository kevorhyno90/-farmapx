import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/app_state.dart';
import 'models/animal.dart';
import 'models/poultry.dart';
import 'models/inventory_item.dart';
import 'models/task_item.dart';
import 'models/transaction.dart';
import 'models/calf.dart';
import 'models/crop_model.dart';
import 'models/employee.dart';
import 'models/field.dart';
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
import 'poultry_page.dart';
import 'reports_page.dart';
import 'shell_page.dart';
import 'tasks_page.dart';
import 'transactions_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final s = AppState();
        // Seed with small sample data for development/testing
        s.addAnimal(Animal(id: 'a1', tag: 'A-100', species: 'Cow', breed: 'Friesian'));
        s.addAnimal(Animal(id: 'a2', tag: 'A-101', species: 'Cow', breed: 'Jersey'));
        s.addPoultry(Poultry(id: 'p1', tag: 'P-200', species: 'Chicken', breed: 'Leghorn', dob: '2023-01-01'));
  s.addInventoryItem(InventoryItem(id: 'i1', name: 'Feed Bag', sku: 'FD-01', category: 'Feed', unit: 'kg', quantity: 50));
  s.addInventoryItem(InventoryItem(id: 'i2', name: 'Vaccine Bottle', sku: 'HC-01', category: 'Health', unit: 'pcs', quantity: 10));
  s.addInventoryItem(InventoryItem(id: 'i3', name: 'Fertilizer', sku: 'FG-02', category: 'Fertilizer', unit: 'kg', quantity: 200));
        s.addTask(TaskItem(id: 't1', title: 'Inspect fences', done: false, status: 'open', assignedTo: 'Sam'));
        s.addTransaction(TransactionModel(id: 'tr1', type: 'expense', amount: 120.5, currency: 'USD', category: 'Supplies', date: '2025-10-16'));
        s.addCalf(Calf(id: 'c1', tag: 'C-300', damId: 'a1', sireId: '', dob: '2025-02-01', sex: 'F', status: 'healthy'));
  s.addCalf(Calf(id: 'c2', tag: 'C-301', damId: 'a2', sireId: '', dob: '2025-03-03', sex: 'M', status: 'weaning'));
        s.addCrop(CropModel(id: 'cr1', fieldId: 'f1', crop: 'Maize', plantingDate: '2025-09-01'));
  s.addCrop(CropModel(id: 'cr2', fieldId: 'f1', crop: 'Beans', plantingDate: '2025-10-01'));
        s.addEmployee(Employee(id: 'e1', name: 'Alice', role: 'Manager'));
  s.addEmployee(Employee(id: 'e2', name: 'Bob', role: 'Farmhand'));
  s.addEmployee(Employee(id: 'e3', name: 'Clara', role: 'Veterinarian'));
        s.addField(FieldModel(id: 'f1', name: 'North Field', description: 'Irrigated', areaHa: 2.5, soilType: 'Loam'));
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
      title: 'Farm Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
  initialRoute: '/dashboard',
      routes: {
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
