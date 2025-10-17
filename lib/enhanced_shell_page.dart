import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'animals_page.dart';
import 'livestock_page.dart';
import 'calf_page.dart';
import 'poultry_page.dart';
import 'crops_page.dart';
import 'fields_page.dart';
import 'inventory_page.dart';
import 'compact_feed_formulation_page.dart';
import 'feed_formulation_page.dart';
import 'advanced_formulation_page.dart';
import 'ingredient_management_page.dart';
import 'feed_cost_management_page.dart';
import 'quality_assurance_page.dart';
import 'finance_page.dart';
import 'transactions_page.dart';
import 'tasks_page.dart';
import 'reports_page.dart';
import 'employees_page.dart';
import 'professional_animal_management_page.dart';

class EnhancedShellPage extends StatefulWidget {
  const EnhancedShellPage({Key? key}) : super(key: key);

  @override
  State<EnhancedShellPage> createState() => _EnhancedShellPageState();
}

class _EnhancedShellPageState extends State<EnhancedShellPage> {
  String _selectedModule = 'Dashboard';
  String _selectedSubModule = '';
  Widget? _currentPage;

  final Map<String, List<Map<String, dynamic>>> _moduleStructure = {
    'Dashboard': [],
    'Animals & Livestock': [
      {'name': 'Professional Management', 'page': () => const ProfessionalAnimalManagementPage(), 'icon': Icons.medical_services},
      {'name': 'Basic Animals View', 'page': () => const AnimalsPage(), 'icon': Icons.pets},
      {'name': 'Basic Livestock View', 'page': () => const LivestockPage(), 'icon': Icons.agriculture},
      {'name': 'Calf Management', 'page': () => const CalfPage(), 'icon': Icons.child_care},
      {'name': 'Poultry Management', 'page': () => const PoultryPage(), 'icon': Icons.flutter_dash},
    ],
    'Crops & Fields': [
      {'name': 'Crop Management', 'page': () => const CropsPage(), 'icon': Icons.agriculture},
      {'name': 'Field Management', 'page': () => const FieldsPage(), 'icon': Icons.landscape},
    ],
    'Feed & Nutrition': [
      {'name': 'Compact Formulation', 'page': () => const CompactFeedFormulationPage(), 'icon': Icons.science},
      {'name': 'Feed Formulation', 'page': () => const FeedFormulationPage(), 'icon': Icons.biotech},
      {'name': 'Advanced Formulation', 'page': () => const AdvancedFormulationPage(), 'icon': Icons.psychology},
      {'name': 'Ingredient Management', 'page': () => const IngredientManagementPage(), 'icon': Icons.inventory_2},
      {'name': 'Feed Cost Management', 'page': () => const FeedCostManagementPage(), 'icon': Icons.monetization_on},
      {'name': 'Quality Assurance', 'page': () => const QualityAssurancePage(), 'icon': Icons.verified},
    ],
    'Inventory & Stock': [
      {'name': 'Inventory Management', 'page': () => const InventoryPage(), 'icon': Icons.inventory},
    ],
    'Finance & Accounting': [
      {'name': 'Financial Overview', 'page': () => const FinancePage(), 'icon': Icons.account_balance},
      {'name': 'Transactions', 'page': () => const TransactionsPage(), 'icon': Icons.receipt_long},
    ],
    'Operations & HR': [
      {'name': 'Task Management', 'page': () => const TasksPage(), 'icon': Icons.task_alt},
      {'name': 'Employee Management', 'page': () => const EmployeesPage(), 'icon': Icons.people},
    ],
    'Reports & Analytics': [
      {'name': 'Reports & Analytics', 'page': () => const ReportsPage(), 'icon': Icons.analytics},
    ],
  };

  @override
  void initState() {
    super.initState();
    _currentPage = const DashboardPage();
  }

  Widget _buildModuleDropdown(String moduleName) {
    final subModules = _moduleStructure[moduleName] ?? [];
    final isSelected = _selectedModule == moduleName;
    
    if (subModules.isEmpty) {
      // Single module without dropdown
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[600] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ] : [],
        ),
        child: TextButton(
          onPressed: () => _selectModule(moduleName, ''),
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: isSelected ? Colors.white : Colors.grey[800],
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            moduleName, 
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green[600] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
          width: 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ] : [],
      ),
      child: PopupMenuButton<String>(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                moduleName,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: isSelected ? Colors.white : Colors.grey[800],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_drop_down,
                color: isSelected ? Colors.white : Colors.grey[700],
                size: 20,
              ),
            ],
          ),
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        itemBuilder: (context) => subModules.map((subModule) {
          return PopupMenuItem<String>(
            value: subModule['name'],
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      subModule['icon'], 
                      size: 18, 
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      subModule['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        onSelected: (subModuleName) => _selectModule(moduleName, subModuleName),
      ),
    );
  }

  void _selectModule(String moduleName, String subModuleName) {
    setState(() {
      _selectedModule = moduleName;
      _selectedSubModule = subModuleName;
      
      if (moduleName == 'Dashboard') {
        _currentPage = const DashboardPage();
      } else if (moduleName == 'Animals & Livestock' && subModuleName.isEmpty) {
        // Automatically load Professional Management for Animals & Livestock
        _selectedSubModule = 'Professional Management';
        _currentPage = const ProfessionalAnimalManagementPage();
      } else if (subModuleName.isNotEmpty) {
        final subModules = _moduleStructure[moduleName] ?? [];
        final selectedSubModule = subModules.firstWhere(
          (sub) => sub['name'] == subModuleName,
          orElse: () => subModules.first,
        );
        _currentPage = selectedSubModule['page']();
      } else if (_moduleStructure[moduleName]?.isNotEmpty == true) {
        // Default to first sub-module if no specific one selected
        final firstSubModule = _moduleStructure[moduleName]!.first;
        _selectedSubModule = firstSubModule['name'];
        _currentPage = firstSubModule['page']();
      }
    });
  }

  String get _currentTitle {
    if (_selectedModule == 'Dashboard') return 'Overview & Analytics';
    if (_selectedSubModule.isNotEmpty) return _selectedSubModule;
    if (_moduleStructure[_selectedModule]?.isNotEmpty == true) {
      return '${_moduleStructure[_selectedModule]!.length} modules available';
    }
    return _selectedModule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.agriculture, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Farm Management Pro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  _currentTitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.3),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[50]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
                bottom: BorderSide(color: Colors.grey[300]!, width: 2),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _moduleStructure.keys
                    .map((module) => _buildModuleDropdown(module))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _currentPage ?? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
      ),
    );
  }
}