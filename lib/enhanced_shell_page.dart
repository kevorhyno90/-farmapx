import 'package:flutter/material.dart';
import 'design/xfarm_theme.dart';
import 'widgets/xfarm_components.dart';
import 'dashboard_page.dart';
import 'crops_page.dart';
import 'fields_page.dart';
import 'inventory_page.dart';
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
import 'professional_calf_management_page.dart';
import 'professional_poultry_management_page.dart';

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
    'Professional Animals': [
      {'name': 'Comprehensive Management', 'page': () => const ProfessionalAnimalManagementPage(), 'icon': Icons.medical_services},
      {'name': 'Calf Management', 'page': () => const ProfessionalCalfManagementPage(), 'icon': Icons.child_care},
      {'name': 'Poultry Management', 'page': () => const ProfessionalPoultryManagementPage(), 'icon': Icons.flutter_dash},
    ],
    'Crops & Fields': [
      {'name': 'Crop Management', 'page': () => const CropsPage(), 'icon': Icons.agriculture},
      {'name': 'Field Management', 'page': () => const FieldsPage(), 'icon': Icons.landscape},
    ],
    'Feed & Nutrition': [
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

  Widget _buildFarmModuleChip(String moduleName, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectModule(moduleName),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: XFarmTheme.spacingLarge,
          vertical: XFarmTheme.spacingMedium,
        ),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? XFarmTheme.farmGradient
              : null,
          color: isSelected 
              ? null 
              : XFarmTheme.cardBackground,
          borderRadius: BorderRadius.circular(XFarmTheme.radiusLarge),
          border: Border.all(
            color: isSelected 
                ? XFarmTheme.primaryGreen 
                : XFarmTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
              ? XFarmTheme.farmElevatedShadow
              : XFarmTheme.farmCardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getModuleIcon(moduleName),
              size: 20,
              color: isSelected 
                  ? XFarmTheme.lightText 
                  : XFarmTheme.primaryGreen,
            ),
            const SizedBox(width: XFarmTheme.spacingSmall),
            Text(
              moduleName,
              style: XFarmTheme.farmLabelLarge.copyWith(
                color: isSelected 
                    ? XFarmTheme.lightText 
                    : XFarmTheme.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmSubModuleChip(Map<String, dynamic> subModule, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectSubModule(subModule['name'], subModule['page']),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: XFarmTheme.spacingMedium,
          vertical: XFarmTheme.spacingSmall,
        ),
        decoration: BoxDecoration(
          gradient: isSelected 
              ? XFarmTheme.skyGradient
              : null,
          color: isSelected 
              ? null 
              : XFarmTheme.cardBackground,
          borderRadius: BorderRadius.circular(XFarmTheme.radiusMedium),
          border: Border.all(
            color: isSelected 
                ? XFarmTheme.farmBlue 
                : XFarmTheme.borderColor,
            width: 1,
          ),
          boxShadow: isSelected 
              ? XFarmTheme.farmCardShadow
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected 
                    ? XFarmTheme.lightText.withValues(alpha: 0.2)
                    : XFarmTheme.farmBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
              ),
              child: Icon(
                subModule['icon'],
                size: 16,
                color: isSelected 
                    ? XFarmTheme.lightText 
                    : XFarmTheme.farmBlue,
              ),
            ),
            const SizedBox(width: XFarmTheme.spacingSmall),
            Text(
              subModule['name'],
              style: XFarmTheme.farmLabelMedium.copyWith(
                color: isSelected 
                    ? XFarmTheme.lightText 
                    : XFarmTheme.primaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getModuleIcon(String moduleName) {
    switch (moduleName) {
      case 'Dashboard':
        return XFarmIcons.analytics;
      case 'Professional Animals':
        return XFarmIcons.livestock;
      case 'Crops & Fields':
        return XFarmIcons.crops;
      case 'Feed & Nutrition':
        return XFarmIcons.feed;
      case 'Inventory & Stock':
        return XFarmIcons.storage;
      case 'Finance & Accounting':
        return XFarmIcons.money;
      case 'Operations & HR':
        return XFarmIcons.calendar;
      case 'Reports & Analytics':
        return XFarmIcons.analytics;
      default:
        return XFarmIcons.farm;
    }
  }

  Widget _buildCurrentPage() {
    return Container(
      padding: const EdgeInsets.all(XFarmTheme.spacingMedium),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            XFarmTheme.lightBackground,
            XFarmTheme.cardBackground,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: _currentPage ?? Center(
        child: XFarmCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                XFarmIcons.farm,
                size: 64,
                color: XFarmTheme.primaryGreen.withValues(alpha: 0.5),
              ),
              const SizedBox(height: XFarmTheme.spacingMedium),
              Text(
                'Select a module to begin',
                style: XFarmTheme.farmHeadingSmall.copyWith(
                  color: XFarmTheme.secondaryText,
                ),
              ),
              const SizedBox(height: XFarmTheme.spacingSmall),
              Text(
                'Choose from the navigation above to access your farm management tools',
                style: XFarmTheme.farmBodyMedium.copyWith(
                  color: XFarmTheme.hintText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectModule(String moduleName) {
    setState(() {
      _selectedModule = moduleName;
      _selectedSubModule = '';
      
      if (moduleName == 'Dashboard') {
        _currentPage = const DashboardPage();
      } else if (_moduleStructure[moduleName]?.isNotEmpty == true) {
        // Don't auto-select first submodule, let user choose
        _currentPage = null;
      } else {
        _currentPage = const DashboardPage(); // Fallback
      }
    });
  }

  void _selectSubModule(String subModuleName, Widget Function() pageBuilder) {
    setState(() {
      _selectedSubModule = subModuleName;
      _currentPage = pageBuilder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XFarmTheme.lightBackground,
      appBar: XFarmAppBar(
        title: 'XFarm',
        subtitle: 'Agricultural Management Platform',
        gradient: XFarmTheme.farmGradient,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: XFarmTheme.spacingSmall),
            padding: const EdgeInsets.all(XFarmTheme.spacingSmall),
            decoration: BoxDecoration(
              color: XFarmTheme.lightText.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: XFarmTheme.lightText,
              size: 24,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: XFarmTheme.spacingMedium),
            padding: const EdgeInsets.all(XFarmTheme.spacingSmall),
            decoration: BoxDecoration(
              color: XFarmTheme.lightText.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(XFarmTheme.radiusSmall),
            ),
            child: Icon(
              Icons.account_circle_outlined,
              color: XFarmTheme.lightText,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // XFarm Agricultural Navigation
          Container(
            decoration: BoxDecoration(
              color: XFarmTheme.cardBackground,
              border: Border(
                bottom: BorderSide(
                  color: XFarmTheme.borderColor,
                  width: 1,
                ),
              ),
              boxShadow: const [
                BoxShadow(
                  color: XFarmTheme.shadowColor,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: XFarmTheme.spacingMedium,
                vertical: XFarmTheme.spacingMedium,
              ),
              child: Row(
                children: _moduleStructure.keys.map((module) {
                  final isSelected = _selectedModule == module;
                  return Padding(
                    padding: const EdgeInsets.only(right: XFarmTheme.spacingMedium),
                    child: _buildFarmModuleChip(module, isSelected),
                  );
                }).toList(),
              ),
            ),
          ),
          // Agricultural Submodules
          if (_moduleStructure[_selectedModule]?.isNotEmpty == true)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    XFarmTheme.lightGreen,
                    XFarmTheme.cardBackground,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: XFarmTheme.borderColor,
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: XFarmTheme.spacingMedium,
                vertical: XFarmTheme.spacingMedium,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _moduleStructure[_selectedModule]!.map((subModule) {
                    final isSelected = _selectedSubModule == subModule['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: XFarmTheme.spacingMedium),
                      child: _buildFarmSubModuleChip(subModule, isSelected),
                    );
                  }).toList(),
                ),
              ),
            ),
          // Farm Content Area
          Expanded(
            child: _buildCurrentPage(),
          ),
        ],
      ),
    );
  }
}