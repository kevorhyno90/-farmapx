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
        // Seed with sample data for development/testing
        
        // Animals with enhanced data
        s.addAnimal(Animal(
          id: 'a1', 
          tag: 'A-100', 
          species: 'Cow', 
          breed: 'Friesian',
          gender: AnimalGender.female,
          dateOfBirth: DateTime(2020, 3, 15),
          status: AnimalStatus.lactating,
          healthStatus: HealthStatus.healthy,
          purchasePrice: 1500.0,
          location: 'Barn A',
        ));
        
        s.addAnimal(Animal(
          id: 'a2', 
          tag: 'A-101', 
          species: 'Cow', 
          breed: 'Jersey',
          gender: AnimalGender.female,
          dateOfBirth: DateTime(2019, 8, 22),
          status: AnimalStatus.pregnant,
          healthStatus: HealthStatus.healthy,
          purchasePrice: 1200.0,
          location: 'Pasture 1',
        ));
        
        // Poultry
        s.addPoultry(Poultry(
          id: 'p1', 
          tag: 'P-200', 
          species: 'Chicken', 
          breed: 'Leghorn', 
          dob: '2023-01-01'
        ));
        
        // Enhanced Inventory Items
        s.addInventoryItem(InventoryItem(
          id: 'i1', 
          name: 'Feed Bag', 
          sku: 'FD-01', 
          category: InventoryCategory.feed, 
          unit: 'kg', 
          quantity: 50,
          minStockLevel: 10,
          reorderPoint: 15,
          lastPurchasePrice: 25.50,
          storageLocation: 'Feed Store A',
        ));
        
        s.addInventoryItem(InventoryItem(
          id: 'i2', 
          name: 'Vaccine Bottle', 
          sku: 'HC-01', 
          category: InventoryCategory.medical, 
          unit: 'pcs', 
          quantity: 10,
          minStockLevel: 3,
          reorderPoint: 5,
          lastPurchasePrice: 45.0,
          storageLocation: 'Medical Cabinet',
          trackExpiry: true,
          expiryDate: DateTime.now().add(const Duration(days: 180)),
        ));
        
        s.addInventoryItem(InventoryItem(
          id: 'i3', 
          name: 'Fertilizer', 
          sku: 'FG-02', 
          category: InventoryCategory.fertilizer, 
          unit: 'kg', 
          quantity: 200,
          minStockLevel: 50,
          reorderPoint: 75,
          lastPurchasePrice: 2.25,
          storageLocation: 'Chemical Store',
        ));
        
        // Tasks
        s.addTask(TaskItem(
          id: 't1', 
          title: 'Inspect fences', 
          done: false, 
          status: 'open', 
          assignedTo: 'Sam'
        ));
        
        // Enhanced Transactions
        s.addTransaction(TransactionModel(
          id: 'tr1', 
          type: TransactionType.expense, 
          amount: 120.5, 
          currency: 'USD', 
          category: 'Feed',
          subcategory: 'Cattle Feed',
          description: 'Monthly feed supply',
          paymentMethod: PaymentMethod.bank_transfer,
          animalId: 'a1',
        ));
        
        s.addTransaction(TransactionModel(
          id: 'tr2', 
          type: TransactionType.income, 
          amount: 850.0, 
          currency: 'USD', 
          category: 'Milk Sales',
          description: 'Weekly milk delivery',
          paymentMethod: PaymentMethod.check,
        ));
        
        // Calves
        s.addCalf(Calf(
          id: 'c1', 
          tag: 'C-300', 
          damId: 'a1', 
          sireId: '', 
          dob: '2025-02-01', 
          sex: 'F', 
          status: 'healthy'
        ));
        
        s.addCalf(Calf(
          id: 'c2', 
          tag: 'C-301', 
          damId: 'a2', 
          sireId: '', 
          dob: '2025-03-03', 
          sex: 'M', 
          status: 'weaning'
        ));
        
        // Enhanced Crops
        s.addCrop(CropModel(
          id: 'cr1', 
          fieldId: 'f1', 
          cropName: 'Maize',
          variety: 'Pioneer 1234',
          cropType: CropType.grain,
          plantingDate: DateTime(2025, 9, 1),
          expectedHarvestDate: DateTime(2026, 1, 15),
          currentStage: CropStage.vegetative,
          areaPlanted: 2.5,
          seedCost: 350.0,
        ));
        
        s.addCrop(CropModel(
          id: 'cr2', 
          fieldId: 'f2', 
          cropName: 'Beans',
          variety: 'Navy Beans',
          cropType: CropType.grain,
          plantingDate: DateTime(2025, 10, 1),
          expectedHarvestDate: DateTime(2026, 2, 1),
          currentStage: CropStage.planted,
          areaPlanted: 1.0,
          seedCost: 150.0,
        ));
        
        // Enhanced Employees
        s.addEmployee(Employee(
          id: 'e1', 
          firstName: 'Alice', 
          lastName: 'Johnson',
          role: 'Farm Manager',
          department: 'Management',
          hourlyRate: 25.0,
          hireDate: DateTime(2020, 1, 15),
          email: 'alice.johnson@farm.com',
          phone: '+1-555-0101',
        ));
        
        s.addEmployee(Employee(
          id: 'e2', 
          firstName: 'Bob', 
          lastName: 'Smith',
          role: 'Farmhand',
          department: 'Operations',
          hourlyRate: 18.0,
          hireDate: DateTime(2022, 6, 1),
          email: 'bob.smith@farm.com',
          phone: '+1-555-0102',
        ));
        
        s.addEmployee(Employee(
          id: 'e3', 
          firstName: 'Clara', 
          lastName: 'Martinez',
          role: 'Veterinarian',
          department: 'Health',
          hourlyRate: 45.0,
          employmentType: EmploymentType.part_time,
          hireDate: DateTime(2021, 3, 10),
          email: 'clara.martinez@farm.com',
          phone: '+1-555-0103',
        ));
        
        // Fields
        s.addField(FieldModel(
          id: 'f1', 
          name: 'North Field', 
          description: 'Main irrigated field for grain crops', 
          areaHa: 2.5, 
          soilType: 'Loam'
        ));
        
        s.addField(FieldModel(
          id: 'f2', 
          name: 'East Pasture', 
          description: 'Grazing area for cattle', 
          areaHa: 1.8, 
          soilType: 'Clay Loam'
        ));
        
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
