import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../models/poultry.dart';
import '../models/animal.dart';
import '../models/calf.dart';
import '../models/crop_model.dart';
import '../models/feed_formulation.dart';
import '../models/inventory_item.dart';
import '../models/task_item.dart';
import '../models/employee.dart';
import '../models/field.dart';
import '../models/report.dart';

class AppState extends ChangeNotifier {
  // In-memory stores
  final List<TransactionModel> _transactions = [];
  final List<Poultry> _poultry = [];
  final List<Animal> _animals = [];
  final List<Calf> _calves = [];
  final List<CropModel> _crops = [];
  final List<FeedFormulation> _feedFormulations = [];
  final List<InventoryItem> _inventory = [];
  final List<TaskItem> _tasks = [];
  final List<Employee> _employees = [];
  final List<FieldModel> _fields = [];
  final List<ReportMeta> _reports = [];

  // Expose as unmodifiable lists
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  List<Poultry> get poultry => List.unmodifiable(_poultry);
  List<Animal> get animals => List.unmodifiable(_animals);
  List<Calf> get calves => List.unmodifiable(_calves);
  List<CropModel> get crops => List.unmodifiable(_crops);
  List<FeedFormulation> get feedFormulations => List.unmodifiable(_feedFormulations);
  List<InventoryItem> get inventoryItems => List.unmodifiable(_inventory);
  List<TaskItem> get tasks => List.unmodifiable(_tasks);
  List<Employee> get employees => List.unmodifiable(_employees);
  List<FieldModel> get fields => List.unmodifiable(_fields);
  List<ReportMeta> get reports => List.unmodifiable(_reports);
  
  // Alias getters expected by UI
  List<InventoryItem> get inventory => inventoryItems;
  List<TaskItem> get taskItems => tasks;

  // Transactions
  String exportTransactionsCsv() {
    final rows = ['id,type,amount,currency,category,subcategory,date,description'];
    for (final t in _transactions) {
      rows.add('${t.id},${t.type.name},${t.amount},${t.currency},${t.category},${t.subcategory},${t.date.toIso8601String()},${t.description}');
    }
    return rows.join('\n');
  }

  Future<int> importTransactionsCsvAndSave(String csv) async {
    final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
    var count = 0;
    for (var i = 1; i < lines.length; i++) {
      final parts = lines[i].split(',');
      if (parts.length >= 5) {
        _transactions.add(TransactionModel(
          id: parts[0], 
          type: TransactionType.values.firstWhere((e) => e.name == parts[1], orElse: () => TransactionType.expense), 
          amount: double.tryParse(parts[2]) ?? 0.0, 
          currency: parts[3], 
          category: parts[4],
          subcategory: parts.length > 5 ? parts[5] : '',
          date: parts.length > 6 ? DateTime.tryParse(parts[6]) : null,
          description: parts.length > 7 ? parts[7] : '',
        ));
        count++;
      }
    }
    notifyListeners();
    return count;
  }

  Future<void> addTransaction(TransactionModel t) async {
    _transactions.add(t);
    notifyListeners();
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Poultry
  String exportPoultryCsv() => _poultry.isEmpty
      ? 'id,tag,species,breed,dob,sex,purpose'
      : 'id,tag,species,breed,dob,sex,purpose\n${_poultry.map((p) => '${p.id},${p.tag},${p.species},${p.breed},${p.dob},${p.sex},${p.purpose}').join('\n')}';

  Future<int> importPoultryCsvAndSave(String csv) async {
    final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
    var count = 0;
    for (var i = 1; i < lines.length; i++) {
      final p = lines[i].split(',');
      if (p.isNotEmpty) {
        _poultry.add(Poultry(id: p[0], tag: p.length > 1 ? p[1] : ''));
        count++;
      }
    }
    notifyListeners();
    return count;
  }

  Future<void> addPoultry(Poultry p) async {
    _poultry.add(p);
    notifyListeners();
  }

  Future<void> updatePoultry(Poultry p) async {
    final idx = _poultry.indexWhere((e) => e.id == p.id);
    if (idx >= 0) _poultry[idx] = p;
    notifyListeners();
  }

  void deletePoultry(String id) {
    _poultry.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Animals
  String exportAnimalsCsv() => _animals.isEmpty
      ? 'id,tag,species,breed'
      : 'id,tag,species,breed\n${_animals.map((a) => '${a.id},${a.tag},${a.species},${a.breed}').join('\n')}';

  Future<int> importAnimalsCsvAndSave(String csv) async {
    final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
    var count = 0;
    for (var i = 1; i < lines.length; i++) {
      final p = lines[i].split(',');
      if (p.isNotEmpty) {
        _animals.add(Animal(id: p[0], tag: p.length > 1 ? p[1] : ''));
        count++;
      }
    }
    notifyListeners();
    return count;
  }

  Future<void> addAnimal(Animal a) async {
    _animals.add(a);
    notifyListeners();
  }

  void deleteAnimal(String id) {
    _animals.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // Calves (similar to animals)
  Future<void> addCalf(Calf c) async {
    _calves.add(c);
    notifyListeners();
  }

  Future<void> updateCalf(Calf c) async {
    final idx = _calves.indexWhere((e) => e.id == c.id);
    if (idx >= 0) _calves[idx] = c;
    notifyListeners();
  }

  void deleteCalf(String id) {
    _calves.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // CSV helpers (aliases) to match UI method names
  String exportCalvesCsv() => _calves.isEmpty
      ? 'id,tag,damId,sireId,dob,sex,status'
      : 'id,tag,damId,sireId,dob,sex,status\n${_calves.map((c) => '${c.id},${c.tag},${c.damId},${c.sireId},${c.dob},${c.sex},${c.status}').join('\n')}';

  Future<int> importCalvesCsvAndSave(String csv) async {
    final lines = csv.split('\n').where((l) => l.trim().isNotEmpty).toList();
    var count = 0;
    for (var i = 1; i < lines.length; i++) {
      final p = lines[i].split(',');
      if (p.isNotEmpty) {
        _calves.add(Calf(id: p[0], tag: p.length > 1 ? p[1] : '', damId: p.length > 2 ? p[2] : '', sireId: p.length > 3 ? p[3] : '', dob: p.length > 4 ? p[4] : '', sex: p.length > 5 ? p[5] : '', status: p.length > 6 ? p[6] : ''));
        count++;
      }
    }
    notifyListeners();
    return count;
  }

  String exportCropsCsv() => _crops.isEmpty
      ? 'id,fieldId,cropName,plantingDate'
      : 'id,fieldId,cropName,plantingDate\n${_crops.map((c) => '${c.id},${c.fieldId},${c.cropName},${c.plantingDate.toIso8601String()}').join('\n')}';
  Future<int> importCropsCsvAndSave(String csv) async => 0;

  String exportInventoryCsv() => _inventory.isEmpty
      ? 'id,sku,name,category,unit,quantity'
      : 'id,sku,name,category,unit,quantity\n${_inventory.map((i) => '${i.id},${i.sku},${i.name},${i.category},${i.unit},${i.quantity}').join('\n')}';
  Future<int> importInventoryCsvAndSave(String csv) async => 0;

  String exportTasksCsv() => _tasks.isEmpty
      ? 'id,title,done,status,assignedTo'
      : 'id,title,done,status,assignedTo\n${_tasks.map((t) => '${t.id},${t.title},${t.done},${t.status},${t.assignedTo}').join('\n')}';
  Future<int> importTasksCsvAndSave(String csv) async => 0;

  String exportEmployeesCsv() => '';
  Future<int> importEmployeesCsvAndSave(String csv) async => 0;
  String exportFeedFormulationsCsv() {
    if (_feedFormulations.isEmpty) {
      return 'id,name,description,targetSpecies,targetStage,form,ingredients,targetCost,createdDate,formulatedBy,approved,batchNumber,batchSize,totalCost,costPerKg,qualityScore,notes';
    }
    final rows = ['id,name,description,targetSpecies,targetStage,form,ingredients,targetCost,createdDate,formulatedBy,approved,batchNumber,batchSize,totalCost,costPerKg,qualityScore,notes'];
    for (final f in _feedFormulations) {
      final ingredientsStr = f.ingredients.map((ing) => '${ing.ingredientId}:${ing.percentage}').join(';');
      rows.add('${f.id},"${f.name}","${f.description}",${f.targetSpecies.name},${f.targetStage.name},${f.form.name},"$ingredientsStr",${f.targetCost},${f.createdDate.toIso8601String()},"${f.formulatedBy}",${f.approved},"${f.batchNumber}",${f.batchSize},${f.totalCost},${f.costPerKg},${f.qualityScore},"${f.notes}"');
    }
    return rows.join('\n');
  }

  Future<int> importFeedFormulationsCsvAndSave(String csv) async {
    final lines = csv.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.length <= 1) return 0;

    int imported = 0;

    for (int i = 1; i < lines.length; i++) {
      try {
        final parts = _parseCsvLine(lines[i]);
        if (parts.length >= 17) {
          // Parse ingredients
          final ingredientsStr = parts[6].replaceAll('"', '');
          final ingredients = ingredientsStr.split(';')
              .where((ing) => ing.contains(':'))
              .map((ing) {
                final pair = ing.split(':');
                return FormulaIngredient(
                  ingredientId: pair[0],
                  percentage: double.tryParse(pair[1]) ?? 0.0,
                );
              }).toList();

          final formulation = FeedFormulation(
            id: parts[0],
            name: parts[1].replaceAll('"', ''),
            description: parts[2].replaceAll('"', ''),
            targetSpecies: AnimalSpecies.values.firstWhere(
              (species) => species.name == parts[3], 
              orElse: () => AnimalSpecies.cattle
            ),
            targetStage: ProductionStage.values.firstWhere(
              (stage) => stage.name == parts[4], 
              orElse: () => ProductionStage.grower
            ),
            form: FeedForm.values.firstWhere(
              (form) => form.name == parts[5], 
              orElse: () => FeedForm.mash
            ),
            ingredients: ingredients,
            targetCost: double.tryParse(parts[7]) ?? 0.0,
            createdDate: DateTime.tryParse(parts[8]) ?? DateTime.now(),
            formulatedBy: parts[9].replaceAll('"', ''),
            approved: parts[10].toLowerCase() == 'true',
            batchNumber: parts[11].replaceAll('"', ''),
            batchSize: double.tryParse(parts[12]) ?? 0.0,
            totalCost: double.tryParse(parts[13]) ?? 0.0,
            costPerKg: double.tryParse(parts[14]) ?? 0.0,
            qualityScore: int.tryParse(parts[15]) ?? 0,
            notes: parts[16].replaceAll('"', ''),
          );

          await addFeedFormulation(formulation);
          imported++;
        }
      } catch (e) {
        // Skip malformed lines
        debugPrint('Error parsing feed formulation line ${i + 1}: $e');
      }
    }
    return imported;
  }

  // Helper method to parse CSV lines considering quoted fields
  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    bool inQuotes = false;
    String current = '';
    
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current);
        current = '';
      } else {
        current += char;
      }
    }
    result.add(current);
    return result;
  }
  String exportFieldsCsv() => '';
  Future<int> importFieldsCsvAndSave(String csv) async => 0;
  String exportReportsCsv() => '';
  Future<int> importReportsCsvAndSave(String csv) async => 0;

  // Employees
  Future<void> addEmployee(Employee e) async {
    _employees.add(e);
    notifyListeners();
  }

  void deleteEmployee(String id) {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // Fields
  Future<void> addField(FieldModel f) async {
    _fields.add(f);
    notifyListeners();
  }

  void deleteField(String id) {
    _fields.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  Future<void> addCrop(CropModel c) async {
    _crops.add(c);
    notifyListeners();
  }

  Future<void> updateCrop(CropModel c) async {
    final idx = _crops.indexWhere((e) => e.id == c.id);
    if (idx >= 0) _crops[idx] = c;
    notifyListeners();
  }

  Future<void> deleteCrop(String id) async {
    _crops.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> addReport(ReportMeta r) async {
    _reports.add(r);
    notifyListeners();
  }

  // Feed formulations
  Future<void> addFeedFormulation(FeedFormulation f) async {
    _feedFormulations.add(f);
    notifyListeners();
  }

  Future<void> updateFeedFormulation(FeedFormulation f) async {
    final idx = _feedFormulations.indexWhere((e) => e.id == f.id);
    if (idx >= 0) _feedFormulations[idx] = f;
    notifyListeners();
  }

  void deleteFeedFormulation(String id) {
    _feedFormulations.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  // Inventory
  Future<void> addInventoryItem(InventoryItem it) async {
    _inventory.add(it);
    notifyListeners();
  }

  Future<void> updateInventoryItem(InventoryItem it) async {
    final idx = _inventory.indexWhere((e) => e.id == it.id);
    if (idx >= 0) _inventory[idx] = it;
    notifyListeners();
  }

  void deleteInventoryItem(String id) {
    _inventory.removeWhere((it) => it.id == id);
    notifyListeners();
  }

  // Aliases matching UI naming
  Future<void> updateInventory(InventoryItem it) async => updateInventoryItem(it);
  Future<void> deleteInventory(String id) async => deleteInventoryItem(id);
  Future<void> addInventory(InventoryItem it) async => addInventoryItem(it);

  // Tasks
  Future<void> addTask(TaskItem t) async {
    _tasks.add(t);
    notifyListeners();
  }

  Future<void> updateTask(TaskItem t) async {
    final idx = _tasks.indexWhere((e) => e.id == t.id);
    if (idx >= 0) _tasks[idx] = t;
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
