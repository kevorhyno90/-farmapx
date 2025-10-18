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
import 'quality_assurance_page.dart';
import 'feed_cost_management_page.dart';
import 'fields_page.dart';
import 'finance_page.dart';
import 'inventory_page.dart';
import 'livestock_page.dart';
import 'poultry_page.dart';
import 'reports_page.dart';
import 'shell_page.dart';
import 'enhanced_shell_page.dart';
import 'tasks_page.dart';
import 'transactions_page.dart';

import 'services/simple_sample_data_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final s = AppState();
        // Initialize with simple sample data
        ProfessionalSampleDataService.populateAllSampleData(s);
        return s;
 
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
  initialRoute: '/shell',
      routes: {
        '/dashboard': (context) => const DashboardPage(),
        '/animals': (context) => const AnimalsPage(),
        '/calf': (context) => const CalfPage(),
        '/crops': (context) => const CropsPage(),
        '/employees': (context) => const EmployeesPage(),
        '/feed_formulation': (context) => const FeedFormulationPage(),
        '/feed-formulation': (context) => const FeedFormulationPage(),
        '/quality-assurance': (context) => const QualityAssurancePage(),
        '/cost-management': (context) => const FeedCostManagementPage(),
        '/fields': (context) => const FieldsPage(),
        '/finance': (context) => const FinancePage(),
        '/inventory': (context) => const InventoryPage(),
        '/livestock': (context) => const LivestockPage(),
        '/poultry': (context) => const PoultryPage(),
        '/reports': (context) => const ReportsPage(),
        '/shell': (context) => const EnhancedShellPage(),
        '/tasks': (context) => const TasksPage(),
        '/transactions': (context) => const TransactionsPage(),
      },
    );
  }
}
