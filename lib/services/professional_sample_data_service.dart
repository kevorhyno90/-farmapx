import 'package:flutter/material.dart';
import '../models/comprehensive_animal_record.dart';
import '../models/animal.dart';
import '../models/calf.dart';
import '../models/poultry.dart';
import '../models/transaction.dart';
import '../models/employee.dart';
import '../models/field.dart';
import '../models/crop_model.dart';
import '../models/inventory_item.dart';
import '../models/task_item.dart';
import '../models/feed_formulation.dart';
import '../models/report.dart';
import '../services/app_state.dart';

/// Professional sample data service for comprehensive animal management system
class ProfessionalSampleDataService {
  
  /// Initialize comprehensive sample data
  static Future<void> initializeSampleData(AppState appState) async {
    // Clear existing data
    await _clearExistingData(appState);
    
    // Create comprehensive animal records
    await _createComprehensiveAnimalRecords(appState);
    
    // Create sample transactions
    await _createSampleTransactions(appState);
    
    // Create sample employees
    await _createSampleEmployees(appState);
    
    // Create sample fields and crops
    await _createSampleFieldsAndCrops(appState);
    
    // Create sample inventory
    await _createSampleInventory(appState);
    
    // Create sample tasks
    await _createSampleTasks(appState);
    
    // Create sample feed formulations
    await _createSampleFeedFormulations(appState);
    
    // Create sample reports
    await _createSampleReports(appState);
  }

  static Future<void> _clearExistingData(AppState appState) async {
    // Clear existing data if needed
    // This would depend on the AppState implementation
  }

  static Future<void> _createComprehensiveAnimalRecords(AppState appState) async {
    final now = DateTime.now();
    
    // Sample Dairy Cows
    final dairyCows = [
      Animal(
        id: 'COW001',
        name: 'Bella',
        species: 'Bovine',
        breed: 'Holstein Friesian',
        age: 4,
        weight: 650.0,
        healthStatus: 'Excellent',
        lastCheckup: now.subtract(Duration(days: 30)),
        location: 'Pasture A',
        notes: 'High milk producer, excellent health record',
      ),
      Animal(
        id: 'COW002',
        name: 'Luna',
        species: 'Bovine',
        breed: 'Jersey',
        age: 3,
        weight: 450.0,
        healthStatus: 'Good',
        lastCheckup: now.subtract(Duration(days: 15)),
        location: 'Barn 1',
        notes: 'Currently pregnant, due in 2 months',
      ),
      Animal(
        id: 'COW003',
        name: 'Daisy',
        species: 'Bovine',
        breed: 'Guernsey',
        age: 5,
        weight: 580.0,
        healthStatus: 'Excellent',
        lastCheckup: now.subtract(Duration(days: 45)),
        location: 'Pasture B',
        notes: 'Top milk quality, genetic line champion',
      ),
    ];

    // Sample Beef Cattle
    final beefCattle = [
      Animal(
        id: 'BEEF001',
        name: 'Thunder',
        species: 'Bovine',
        breed: 'Angus',
        age: 2,
        weight: 750.0,
        healthStatus: 'Excellent',
        lastCheckup: now.subtract(Duration(days: 20)),
        location: 'Range 1',
        notes: 'Breeding bull, excellent genetics',
      ),
      Animal(
        id: 'BEEF002',
        name: 'Storm',
        species: 'Bovine',
        breed: 'Hereford',
        age: 3,
        weight: 680.0,
        healthStatus: 'Good',
        lastCheckup: now.subtract(Duration(days: 10)),
        location: 'Range 2',
        notes: 'Market ready in 6 months',
      ),
    ];

    // Sample Sheep
    final sheep = [
      Animal(
        id: 'SHEEP001',
        name: 'Woolly',
        species: 'Ovine',
        breed: 'Merino',
        age: 2,
        weight: 65.0,
        healthStatus: 'Excellent',
        lastCheckup: now.subtract(Duration(days: 25)),
        location: 'Sheep Pasture',
        notes: 'Superior wool quality, breeding ewe',
      ),
      Animal(
        id: 'SHEEP002',
        name: 'Fluffy',
        species: 'Ovine',
        breed: 'Romney',
        age: 1,
        weight: 45.0,
        healthStatus: 'Good',
        lastCheckup: now.subtract(Duration(days: 35)),
        location: 'Sheep Pasture',
        notes: 'Fast growing, excellent meat potential',
      ),
    ];

    // Add all animals to app state
    for (final animal in [...dairyCows, ...beefCattle, ...sheep]) {
      await appState.addAnimal(animal);
    }

    // Sample Calves
    final calves = [
      Calf(
        id: 'CALF001',
        name: 'Bambi',
        breed: 'Holstein',
        birthDate: now.subtract(Duration(days: 45)),
        motherId: 'COW001',
        gender: 'Female',
        birthWeight: 38.0,
        currentWeight: 65.0,
        healthStatus: 'Excellent',
        feedingSchedule: 'Milk replacer 3x daily',
        notes: 'Strong calf, excellent growth rate',
      ),
      Calf(
        id: 'CALF002',
        name: 'Buddy',
        breed: 'Jersey',
        birthDate: now.subtract(Duration(days: 60)),
        motherId: 'COW002',
        gender: 'Male',
        birthWeight: 28.0,
        currentWeight: 58.0,
        healthStatus: 'Good',
        feedingSchedule: 'Transitioning to solid feed',
        notes: 'Slower start but catching up well',
      ),
    ];

    for (final calf in calves) {
      await appState.addCalf(calf);
    }

    // Sample Poultry
    final poultryBirds = [
      Poultry(id: 'CHICK001', tag: 'CH001', species: 'Chicken', breed: 'Rhode Island Red', 
              dob: 'Adult', sex: 'Female', purpose: 'Egg Production'),
      Poultry(id: 'CHICK002', tag: 'CH002', species: 'Chicken', breed: 'Leghorn', 
              dob: 'Adult', sex: 'Female', purpose: 'Egg Production'),
      Poultry(id: 'CHICK003', tag: 'CH003', species: 'Chicken', breed: 'Broiler', 
              dob: '8 weeks', sex: 'Mixed', purpose: 'Meat Production'),
      Poultry(id: 'DUCK001', tag: 'DK001', species: 'Duck', breed: 'Pekin', 
              dob: 'Adult', sex: 'Female', purpose: 'Egg Production'),
      Poultry(id: 'GOOSE001', tag: 'GS001', species: 'Goose', breed: 'Embden', 
              dob: 'Adult', sex: 'Male', purpose: 'Breeding'),
    ];

    for (final bird in poultryBirds) {
      await appState.addPoultry(bird);
    }
  }

  static Future<void> _createSampleTransactions(AppState appState) async {
    final now = DateTime.now();
    
    final transactions = [
      // Income transactions
      TransactionModel(
        id: 'TXN001',
        type: TransactionType.income,
        amount: 2500.00,
        currency: 'USD',
        category: 'Milk Sales',
        subcategory: 'Dairy Cooperative',
        date: now.subtract(Duration(days: 1)),
        description: 'Weekly milk sales to local dairy cooperative',
      ),
      TransactionModel(
        id: 'TXN002',
        type: TransactionType.income,
        amount: 450.00,
        currency: 'USD',
        category: 'Egg Sales',
        subcategory: 'Farmers Market',
        date: now.subtract(Duration(days: 2)),
        description: 'Weekend farmers market egg sales',
      ),
      TransactionModel(
        id: 'TXN003',
        type: TransactionType.income,
        amount: 1200.00,
        currency: 'USD',
        category: 'Livestock Sales',
        subcategory: 'Calf Sale',
        date: now.subtract(Duration(days: 5)),
        description: 'Sale of weaned bull calf',
      ),
      
      // Expense transactions
      TransactionModel(
        id: 'TXN004',
        type: TransactionType.expense,
        amount: 850.00,
        currency: 'USD',
        category: 'Feed',
        subcategory: 'Cattle Feed',
        date: now.subtract(Duration(days: 3)),
        description: 'Monthly cattle feed supply',
      ),
      TransactionModel(
        id: 'TXN005',
        type: TransactionType.expense,
        amount: 350.00,
        currency: 'USD',
        category: 'Veterinary',
        subcategory: 'Health Check',
        date: now.subtract(Duration(days: 7)),
        description: 'Quarterly herd health inspection',
      ),
      TransactionModel(
        id: 'TXN006',
        type: TransactionType.expense,
        amount: 180.00,
        currency: 'USD',
        category: 'Equipment',
        subcategory: 'Maintenance',
        date: now.subtract(Duration(days: 4)),
        description: 'Milking equipment maintenance',
      ),
      TransactionModel(
        id: 'TXN007',
        type: TransactionType.expense,
        amount: 75.00,
        currency: 'USD',
        category: 'Utilities',
        subcategory: 'Electricity',
        date: now.subtract(Duration(days: 10)),
        description: 'Barn electricity bill',
      ),
      TransactionModel(
        id: 'TXN008',
        type: TransactionType.expense,
        amount: 220.00,
        currency: 'USD',
        category: 'Supplies',
        subcategory: 'Bedding',
        date: now.subtract(Duration(days: 6)),
        description: 'Fresh straw bedding for cattle',
      ),
    ];

    for (final transaction in transactions) {
      await appState.addTransaction(transaction);
    }
  }

  static Future<void> _createSampleEmployees(AppState appState) async {
    final employees = [
      Employee(
        id: 'EMP001',
        name: 'John Smith',
        position: 'Farm Manager',
        salary: 45000.0,
        hireDate: DateTime.now().subtract(Duration(days: 365)),
        phoneNumber: '+1-555-0101',
        email: 'john.smith@farm.com',
        address: '123 Farm Road, Rural County',
        emergencyContact: 'Jane Smith: +1-555-0102',
        skills: ['Livestock Management', 'Equipment Operation', 'Team Leadership'],
        certifications: ['Livestock Handler Certification', 'First Aid/CPR'],
        performance: 95.0,
        status: 'Active',
      ),
      Employee(
        id: 'EMP002',
        name: 'Maria Garcia',
        position: 'Dairy Technician',
        salary: 38000.0,
        hireDate: DateTime.now().subtract(Duration(days: 180)),
        phoneNumber: '+1-555-0103',
        email: 'maria.garcia@farm.com',
        address: '456 Village Lane, Rural County',
        emergencyContact: 'Carlos Garcia: +1-555-0104',
        skills: ['Milking Operations', 'Quality Control', 'Animal Health'],
        certifications: ['Dairy Quality Assurance', 'Animal Welfare'],
        performance: 92.0,
        status: 'Active',
      ),
      Employee(
        id: 'EMP003',
        name: 'Robert Johnson',
        position: 'Field Worker',
        salary: 32000.0,
        hireDate: DateTime.now().subtract(Duration(days: 90)),
        phoneNumber: '+1-555-0105',
        email: 'robert.johnson@farm.com',
        address: '789 Country Road, Rural County',
        emergencyContact: 'Lisa Johnson: +1-555-0106',
        skills: ['Crop Management', 'Equipment Maintenance', 'Irrigation'],
        certifications: ['Pesticide Application License'],
        performance: 88.0,
        status: 'Active',
      ),
    ];

    for (final employee in employees) {
      await appState.addEmployee(employee);
    }
  }

  static Future<void> _createSampleFieldsAndCrops(AppState appState) async {
    final fields = [
      FieldModel(
        id: 'FIELD001',
        name: 'North Pasture',
        areaHa: 25.5,
        soilType: 'Loamy Clay',
        description: 'Northern section of property. Irrigation: Sprinkler System. Current crop: Alfalfa. Last soil test: ${DateTime.now().subtract(Duration(days: 120)).toIso8601String()}',
      ),
      FieldModel(
        id: 'FIELD002',
        name: 'South Field',
        areaHa: 40.0,
        soilType: 'Sandy Loam',
        description: 'Southern section of property. Irrigation: Pivot Irrigation. Current crop: Corn. Last soil test: ${DateTime.now().subtract(Duration(days: 90)).toIso8601String()}',
      ),
      FieldModel(
        id: 'FIELD003',
        name: 'East Meadow',
        areaHa: 15.0,
        soilType: 'Clay Loam',
        description: 'Eastern boundary. Irrigation: Natural rainfall. Current crop: Mixed Grass. Last soil test: ${DateTime.now().subtract(Duration(days: 150)).toIso8601String()}',
      ),
    ];

    for (final field in fields) {
      await appState.addField(field);
    }

    final crops = [
      CropModel(
        id: 'CROP001',
        fieldId: 'FIELD001',
        cropName: 'Alfalfa',
        variety: 'Vernal',
        plantingDate: DateTime.now().subtract(Duration(days: 180)),
        expectedHarvestDate: DateTime.now().add(Duration(days: 30)),
        areaPlanted: 25.5,
        cropType: CropType.forage,
        currentStage: CropStage.planted,
        health: CropHealth.good,
        notes: 'High-quality forage for dairy cattle',
      ),
      CropModel(
        id: 'CROP002',
        fieldId: 'FIELD002',
        cropName: 'Corn',
        variety: 'Pioneer 1234',
        plantingDate: DateTime.now().subtract(Duration(days: 90)),
        expectedHarvestDate: DateTime.now().add(Duration(days: 60)),
        areaPlanted: 40.0,
        cropType: CropType.grain,
        currentStage: CropStage.planted,
        health: CropHealth.good,
        notes: 'Feed corn for livestock nutrition',
      ),
      CropModel(
        id: 'CROP003',
        fieldId: 'FIELD003',
        cropName: 'Mixed Grass',
        variety: 'Timothy/Clover Mix',
        plantingDate: DateTime.now().subtract(Duration(days: 200)),
        expectedHarvestDate: DateTime.now().add(Duration(days: 45)),
        areaPlanted: 15.0,
        cropType: CropType.forage,
        currentStage: CropStage.planted,
        health: CropHealth.good,
        notes: 'Pasture grass for rotational grazing',
      ),
    ];

    for (final crop in crops) {
      await appState.addCrop(crop);
    }
  }

  static Future<void> _createSampleInventory(AppState appState) async {
    final inventory = [
      InventoryItem(
        id: 'INV001',
        name: 'Dairy Feed Mix',
        category: InventoryCategory.feed,
        quantity: 2500.0,
        unit: 'kg',
        lastPurchasePrice: 0.45,
        storageLocation: 'Feed Storage Barn',
        expiryDate: DateTime.now().add(const Duration(days: 90)),
        reorderPoint: 500.0,
        description: 'High-protein dairy cattle feed',
      ),
      InventoryItem(
        id: 'INV002',
        name: 'Hay Bales',
        category: InventoryCategory.feed,
        quantity: 150.0,
        unit: 'bales',
        lastPurchasePrice: 8.50,
        storageLocation: 'Hay Storage',
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        reorderPoint: 25.0,
        description: 'Premium alfalfa hay bales',
      ),
      InventoryItem(
        id: 'INV003',
        name: 'Veterinary Supplies',
        category: InventoryCategory.medical,
        quantity: 1.0,
        unit: 'kit',
        lastPurchasePrice: 125.00,
        storageLocation: 'Medical Cabinet',
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        reorderPoint: 1.0,
        description: 'Basic veterinary first aid supplies',
      ),
      InventoryItem(
        id: 'INV004',
        name: 'Milking Equipment Cleanser',
        category: InventoryCategory.maintenance,
        quantity: 25.0,
        unit: 'liters',
        lastPurchasePrice: 12.00,
        storageLocation: 'Milking Parlor Storage',
        expiryDate: DateTime.now().add(const Duration(days: 730)),
        reorderPoint: 5.0,
        description: 'Sanitizing solution for milking equipment',
      ),
      InventoryItem(
        id: 'INV005',
        name: 'Bedding Straw',
        category: InventoryCategory.feed,
        quantity: 100.0,
        unit: 'bales',
        lastPurchasePrice: 4.25,
        storageLocation: 'Bedding Storage',
        expiryDate: null,
        reorderPoint: 20.0,
        description: 'Clean wheat straw for animal bedding',
      ),
    ];

    for (final item in inventory) {
      await appState.addInventoryItem(item);
    }
  }

  static Future<void> _createSampleTasks(AppState appState) async {
    final now = DateTime.now();
    
    final tasks = [
      TaskItem(id: 'TASK001', title: 'Morning Milking', status: 'Pending', assignedTo: 'Maria Garcia'),
      TaskItem(id: 'TASK002', title: 'Pasture Rotation', status: 'Pending', assignedTo: 'John Smith'),
      TaskItem(id: 'TASK003', title: 'Equipment Maintenance', status: 'Pending', assignedTo: 'Robert Johnson'),
      TaskItem(id: 'TASK004', title: 'Health Check - Cattle', status: 'Pending', assignedTo: 'John Smith'),
      TaskItem(id: 'TASK005', title: 'Feed Inventory Check', status: 'Pending', assignedTo: 'Maria Garcia'),
    ];

    for (final task in tasks) {
      await appState.addTask(task);
    }
  }

  static Future<void> _createSampleFeedFormulations(AppState appState) async {
    // Create simple, minimal FeedFormulation samples to match the model's constructor
    final feedFormulations = [
      FeedFormulation(id: 'FEED001', name: 'High Production Dairy Mix'),
      FeedFormulation(id: 'FEED002', name: 'Calf Starter Feed'),
      FeedFormulation(id: 'FEED003', name: 'Layer Poultry Feed'),
    ];

    for (final formulation in feedFormulations) {
      await appState.addFeedFormulation(formulation);
    }
  }

  static Future<void> _createSampleReports(AppState appState) async {
    final now = DateTime.now();
    
    final reports = [
      ReportMeta(
        id: 'RPT001',
        name: 'Monthly Milk Production Report',
        generatedAt: now.subtract(const Duration(days: 1)).toIso8601String(),
      ),
      ReportMeta(
        id: 'RPT002',
        name: 'Financial Performance - Q3',
        generatedAt: now.subtract(const Duration(days: 5)).toIso8601String(),
      ),
      ReportMeta(
        id: 'RPT003',
        name: 'Herd Health Summary',
        generatedAt: now.subtract(const Duration(days: 7)).toIso8601String(),
      ),
      ReportMeta(
        id: 'RPT004',
        name: 'Feed Efficiency Analysis',
        generatedAt: now.subtract(const Duration(days: 10)).toIso8601String(),
      ),
    ];

    for (final report in reports) {
      await appState.addReport(report);
    }
  }
}

// Extension methods for AppState to support adding sample data
extension AppStateExtensions on AppState {
  Future<void> addAnimal(Animal animal) async {
    // This would need to be implemented in the actual AppState class
    // For now, we'll assume these methods exist
  }
  
  Future<void> addCalf(Calf calf) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addPoultry(Poultry poultry) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addEmployee(Employee employee) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addField(FieldModel field) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addCrop(CropModel crop) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addInventoryItem(InventoryItem item) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addTask(TaskItem task) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addFeedFormulation(FeedFormulation formulation) async {
    // Implementation depends on AppState structure
  }
  
  Future<void> addReport(ReportMeta report) async {
    // Implementation depends on AppState structure
  }
}