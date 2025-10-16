import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/formulation_optimizer.dart';
import '../services/ingredient_database.dart';
import '../services/requirements_database.dart';
import '../models/feed_ingredient.dart';
import '../models/nutritional_requirements.dart';

class AdvancedFormulationPage extends StatefulWidget {
  const AdvancedFormulationPage({Key? key}) : super(key: key);

  @override
  State<AdvancedFormulationPage> createState() => _AdvancedFormulationPageState();
}

class _AdvancedFormulationPageState extends State<AdvancedFormulationPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Animal parameters
  AnimalSpecies _selectedSpecies = AnimalSpecies.cattle;
  ProductionStage _selectedStage = ProductionStage.grower;
  String? _selectedSubType;
  double _liveWeight = 500.0;
  double? _dailyGain;
  double? _milkProduction;
  double? _eggProduction;

  // Formulation parameters
  double _targetWeight = 1000.0; // kg (1 ton)
  String _objective = 'minimize_cost';
  
  // Selected ingredients
  Set<String> _selectedIngredients = {};
  Map<String, double> _ingredientLimits = {};
  
  // Results
  FormulationResult? _lastResult;
  bool _isOptimizing = false;
  
  // Custom constraints
  List<FormulationConstraint> _customConstraints = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    IngredientDatabase.initialize();
    RequirementsDatabase.initialize();
    _initializeDefaultIngredients();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeDefaultIngredients() {
    // Pre-select common ingredients based on species
    switch (_selectedSpecies) {
      case AnimalSpecies.cattle:
        _selectedIngredients = {
          'corn_grain',
          'soybean_meal_48',
          'alfalfa_hay',
          'corn_silage',
          'wheat_bran',
          'limestone',
          'dicalcium_phosphate',
          'salt',
        };
        break;
      case AnimalSpecies.swine:
        _selectedIngredients = {
          'corn_grain',
          'soybean_meal_48',
          'wheat_grain',
          'fish_meal',
          'soybean_oil',
          'lysine_hcl',
          'dl_methionine',
          'dicalcium_phosphate',
          'limestone',
          'salt',
        };
        break;
      case AnimalSpecies.poultry:
        _selectedIngredients = {
          'corn_grain',
          'soybean_meal_48',
          'wheat_grain',
          'corn_gluten_meal',
          'soybean_oil',
          'lysine_hcl',
          'dl_methionine',
          'l_threonine',
          'limestone',
          'dicalcium_phosphate',
          'salt',
        };
        break;
      default:
        _selectedIngredients = {
          'corn_grain',
          'soybean_meal_48',
          'wheat_bran',
          'limestone',
          'salt',
        };
    }

    // Set default limits
    _ingredientLimits = {
      'corn_grain': 60.0,
      'soybean_meal_48': 25.0,
      'wheat_grain': 40.0,
      'soybean_oil': 5.0,
      'limestone': 2.0,
      'dicalcium_phosphate': 2.0,
      'salt': 0.5,
      'lysine_hcl': 0.5,
      'dl_methionine': 0.3,
      'l_threonine': 0.2,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Feed Formulation'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Animal', icon: Icon(Icons.pets)),
            Tab(text: 'Ingredients', icon: Icon(Icons.grain)),
            Tab(text: 'Constraints', icon: Icon(Icons.tune)),
            Tab(text: 'Results', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAnimalTab(),
          _buildIngredientsTab(),
          _buildConstraintsTab(),
          _buildResultsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isOptimizing ? null : _optimizeFormulation,
        backgroundColor: Colors.green[700],
        label: _isOptimizing
            ? const Text('Optimizing...')
            : const Text('Optimize'),
        icon: _isOptimizing
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildAnimalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Animal Parameters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AnimalSpecies>(
                    value: _selectedSpecies,
                    decoration: const InputDecoration(
                      labelText: 'Species',
                      border: OutlineInputBorder(),
                    ),
                    items: AnimalSpecies.values.map((species) {
                      return DropdownMenuItem(
                        value: species,
                        child: Text(_getSpeciesDisplayName(species)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecies = value!;
                        _initializeDefaultIngredients();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ProductionStage>(
                    value: _selectedStage,
                    decoration: const InputDecoration(
                      labelText: 'Production Stage',
                      border: OutlineInputBorder(),
                    ),
                    items: ProductionStage.values.map((stage) {
                      return DropdownMenuItem(
                        value: stage,
                        child: Text(_getStageDisplayName(stage)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStage = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedSpecies == AnimalSpecies.poultry)
                    DropdownButtonFormField<String>(
                      value: _selectedSubType,
                      decoration: const InputDecoration(
                        labelText: 'Poultry Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'broiler', child: Text('Broiler')),
                        DropdownMenuItem(value: 'layer', child: Text('Layer')),
                        DropdownMenuItem(value: 'breeder', child: Text('Breeder')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSubType = value;
                        });
                      },
                    ),
                  if (_selectedSpecies == AnimalSpecies.swine)
                    DropdownButtonFormField<String>(
                      value: _selectedSubType,
                      decoration: const InputDecoration(
                        labelText: 'Swine Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'piglet', child: Text('Piglet')),
                        DropdownMenuItem(value: 'grower', child: Text('Grower')),
                        DropdownMenuItem(value: 'finisher', child: Text('Finisher')),
                        DropdownMenuItem(value: 'sow', child: Text('Sow')),
                        DropdownMenuItem(value: 'boar', child: Text('Boar')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSubType = value;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _liveWeight.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Live Weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _liveWeight = double.tryParse(value) ?? _liveWeight;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedStage == ProductionStage.grower ||
                      _selectedStage == ProductionStage.finisher)
                    TextFormField(
                      initialValue: _dailyGain?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Target Daily Gain (kg/day)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _dailyGain = double.tryParse(value);
                      },
                    ),
                  if (_selectedStage == ProductionStage.lactation)
                    TextFormField(
                      initialValue: _milkProduction?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Milk Production (kg/day)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _milkProduction = double.tryParse(value);
                      },
                    ),
                  if (_selectedSpecies == AnimalSpecies.poultry &&
                      _selectedSubType == 'layer')
                    TextFormField(
                      initialValue: _eggProduction?.toString() ?? '',
                      decoration: const InputDecoration(
                        labelText: 'Egg Production (eggs/day)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _eggProduction = double.tryParse(value);
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Formulation Parameters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _targetWeight.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Target Batch Size (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _targetWeight = double.tryParse(value) ?? _targetWeight;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _objective,
                    decoration: const InputDecoration(
                      labelText: 'Optimization Objective',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'minimize_cost',
                        child: Text('Minimize Cost'),
                      ),
                      DropdownMenuItem(
                        value: 'maximize_nutrition',
                        child: Text('Maximize Nutrition'),
                      ),
                      DropdownMenuItem(
                        value: 'balance_cost_nutrition',
                        child: Text('Balance Cost & Nutrition'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _objective = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsTab() {
    final allIngredients = IngredientDatabase.getAllIngredients();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Available Ingredients',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        '${_selectedIngredients.length} selected',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...allIngredients.map((ingredient) {
                    final isSelected = _selectedIngredients.contains(ingredient.id);
                    final limit = _ingredientLimits[ingredient.id] ?? ingredient.maxInclusionRate;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedIngredients.add(ingredient.id);
                            } else {
                              _selectedIngredients.remove(ingredient.id);
                              _ingredientLimits.remove(ingredient.id);
                            }
                          });
                        },
                        title: Text(ingredient.commonName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CP: ${ingredient.nutritionalProfile.crudeProtein?.toStringAsFixed(1) ?? 'N/A'}% | '
                              'ME: ${ingredient.nutritionalProfile.metabolizableEnergy?.toInt() ?? 'N/A'} kcal/kg',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            Text(
                              '\$${ingredient.currentPrice.toStringAsFixed(0)}/${ingredient.unit}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Max: ', style: TextStyle(fontSize: 12)),
                                  Expanded(
                                    child: Slider(
                                      value: limit,
                                      min: 0.0,
                                      max: 100.0,
                                      divisions: 100,
                                      label: '${limit.toStringAsFixed(1)}%',
                                      onChanged: (value) {
                                        setState(() {
                                          _ingredientLimits[ingredient.id] = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    '${limit.toStringAsFixed(1)}%',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(ingredient.category),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getCategoryIcon(ingredient.category),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConstraintsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nutritional Constraints',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Constraints will be automatically generated based on NRC requirements for the selected animal parameters. You can add custom constraints below.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _addCustomConstraint,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Custom Constraint'),
                  ),
                  const SizedBox(height: 16),
                  if (_customConstraints.isNotEmpty) ...[
                    const Text(
                      'Custom Constraints:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._customConstraints.asMap().entries.map((entry) {
                      final index = entry.key;
                      final constraint = entry.value;
                      return Card(
                        child: ListTile(
                          title: Text(constraint.nutrient),
                          subtitle: Text(
                            'Min: ${constraint.minimum?.toStringAsFixed(2) ?? 'N/A'} | '
                            'Max: ${constraint.maximum?.toStringAsFixed(2) ?? 'N/A'} ${constraint.unit}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _customConstraints.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    if (_lastResult == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No optimization results yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Configure your parameters and click Optimize',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultSummary(),
          const SizedBox(height: 16),
          _buildFormulationComposition(),
          const SizedBox(height: 16),
          _buildNutritionalAnalysis(),
          if (_lastResult!.constraintViolations.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildConstraintViolations(),
          ],
          if (_lastResult!.warnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildWarnings(),
          ],
        ],
      ),
    );
  }

  Widget _buildResultSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Optimization Results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Chip(
                  label: Text(_lastResult!.status.toUpperCase()),
                  backgroundColor: _getStatusColor(_lastResult!.status),
                  labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Cost',
                    '\$${_lastResult!.totalCost.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Cost per Ton',
                    '\$${_lastResult!.costPerTon.toStringAsFixed(0)}',
                    Icons.trending_up,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Feasibility',
                    '${_lastResult!.feasibilityScore.toStringAsFixed(1)}%',
                    Icons.check_circle,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Ingredients',
                    '${_lastResult!.ingredientPercentages.length}',
                    Icons.grain,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulationComposition() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feed Composition',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._lastResult!.ingredientPercentages.entries.map((entry) {
              final ingredient = IngredientDatabase.getIngredientById(entry.key);
              if (ingredient == null) return Container();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(ingredient.category),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          _getCategoryIcon(ingredient.category),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ingredient.commonName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '\$${ingredient.currentPrice.toStringAsFixed(0)}/${ingredient.unit}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${entry.value.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutritional Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._lastResult!.nutritionalProfile.entries.map((entry) {
              final nutrient = entry.key.replaceAll('_', ' ').toUpperCase();
              final value = entry.value;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(nutrient),
                    Text(
                      value.toStringAsFixed(2),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildConstraintViolations() {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Constraint Violations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._lastResult!.constraintViolations.map((violation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• $violation',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildWarnings() {
    return Card(
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Warnings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._lastResult!.warnings.map((warning) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• $warning',
                  style: const TextStyle(color: Colors.orange),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _optimizeFormulation() async {
    setState(() {
      _isOptimizing = true;
    });

    try {
      // Get selected ingredients
      final availableIngredients = IngredientDatabase.getAllIngredients()
          .where((ing) => _selectedIngredients.contains(ing.id))
          .toList();

      if (availableIngredients.isEmpty) {
        throw Exception('No ingredients selected');
      }

      // Create animal requirements
      final animalRequirements = AnimalRequirements(
        species: _selectedSpecies,
        stage: _selectedStage,
        subType: _selectedSubType,
        liveWeight: _liveWeight,
        dailyGain: _dailyGain,
        milkProduction: _milkProduction,
        eggProduction: _eggProduction,
        requirements: [],
      );

      // Generate constraints
      final constraints = FormulationOptimizer.generateDefaultConstraints(animalRequirements);
      constraints.addAll(_customConstraints);

      // Run optimization
      final result = FormulationOptimizer.optimizeFormulation(
        availableIngredients: availableIngredients,
        animalRequirements: animalRequirements,
        constraints: constraints,
        ingredientLimits: _ingredientLimits,
        objective: _objective,
        targetWeight: _targetWeight,
      );

      setState(() {
        _lastResult = result;
        _isOptimizing = false;
      });

      // Switch to results tab
      _tabController.animateTo(3);

      // Show success snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Optimization completed: ${result.status}'),
            backgroundColor: _getStatusColor(result.status),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isOptimizing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Optimization failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addCustomConstraint() {
    showDialog(
      context: context,
      builder: (context) => CustomConstraintDialog(
        onConstraintAdded: (constraint) {
          setState(() {
            _customConstraints.add(constraint);
          });
        },
      ),
    );
  }

  String _getSpeciesDisplayName(AnimalSpecies species) {
    switch (species) {
      case AnimalSpecies.cattle:
        return 'Cattle';
      case AnimalSpecies.swine:
        return 'Swine';
      case AnimalSpecies.poultry:
        return 'Poultry';
      case AnimalSpecies.sheep:
        return 'Sheep';
      case AnimalSpecies.goat:
        return 'Goat';
      case AnimalSpecies.horses:
        return 'Horses';
      case AnimalSpecies.fish:
        return 'Fish';
      case AnimalSpecies.rabbits:
        return 'Rabbits';
    }
  }

  String _getStageDisplayName(ProductionStage stage) {
    switch (stage) {
      case ProductionStage.starter:
        return 'Starter';
      case ProductionStage.grower:
        return 'Grower';
      case ProductionStage.finisher:
        return 'Finisher';
      case ProductionStage.maintenance:
        return 'Maintenance';
      case ProductionStage.breeding:
        return 'Breeding';
      case ProductionStage.lactation:
        return 'Lactation';
      case ProductionStage.gestation:
        return 'Gestation';
      case ProductionStage.layer:
        return 'Layer';
      case ProductionStage.broiler:
        return 'Broiler';
      case ProductionStage.replacement:
        return 'Replacement';
    }
  }

  String _getCategoryIcon(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.cereal_grains:
        return '🌾';
      case IngredientCategory.protein_meals:
        return '🫘';
      case IngredientCategory.fats_oils:
        return '🫒';
      case IngredientCategory.forages:
        return '🌿';
      case IngredientCategory.by_products:
        return '♻️';
      case IngredientCategory.minerals:
        return '⛰️';
      case IngredientCategory.vitamins:
        return '💊';
      case IngredientCategory.additives:
        return '🧪';
      case IngredientCategory.premixes:
        return '🧬';
    }
  }

  Color _getCategoryColor(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.cereal_grains:
        return Colors.amber[100]!;
      case IngredientCategory.protein_meals:
        return Colors.red[100]!;
      case IngredientCategory.fats_oils:
        return Colors.yellow[100]!;
      case IngredientCategory.forages:
        return Colors.green[100]!;
      case IngredientCategory.by_products:
        return Colors.brown[100]!;
      case IngredientCategory.minerals:
        return Colors.grey[200]!;
      case IngredientCategory.vitamins:
        return Colors.purple[100]!;
      case IngredientCategory.additives:
        return Colors.blue[100]!;
      case IngredientCategory.premixes:
        return Colors.teal[100]!;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'optimal':
        return Colors.green;
      case 'suboptimal':
        return Colors.orange;
      case 'infeasible':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class CustomConstraintDialog extends StatefulWidget {
  final Function(FormulationConstraint) onConstraintAdded;

  const CustomConstraintDialog({Key? key, required this.onConstraintAdded}) : super(key: key);

  @override
  State<CustomConstraintDialog> createState() => _CustomConstraintDialogState();
}

class _CustomConstraintDialogState extends State<CustomConstraintDialog> {
  final _formKey = GlobalKey<FormState>();
  String _nutrient = 'crude_protein';
  double? _minimum;
  double? _maximum;
  String _unit = '%';
  bool _isHard = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Custom Constraint'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _nutrient,
              decoration: const InputDecoration(
                labelText: 'Nutrient',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'crude_protein', child: Text('Crude Protein')),
                DropdownMenuItem(value: 'crude_fat', child: Text('Crude Fat')),
                DropdownMenuItem(value: 'crude_fiber', child: Text('Crude Fiber')),
                DropdownMenuItem(value: 'ash', child: Text('Ash')),
                DropdownMenuItem(value: 'calcium', child: Text('Calcium')),
                DropdownMenuItem(value: 'phosphorus', child: Text('Phosphorus')),
                DropdownMenuItem(value: 'lysine', child: Text('Lysine')),
                DropdownMenuItem(value: 'methionine', child: Text('Methionine')),
                DropdownMenuItem(value: 'metabolizable_energy', child: Text('Metabolizable Energy')),
              ],
              onChanged: (value) {
                setState(() {
                  _nutrient = value!;
                  _unit = value == 'metabolizable_energy' ? 'kcal/kg' : '%';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Minimum Value',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _minimum = double.tryParse(value);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Maximum Value (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _maximum = double.tryParse(value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _unit,
              decoration: const InputDecoration(
                labelText: 'Unit',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '%', child: Text('%')),
                DropdownMenuItem(value: 'kcal/kg', child: Text('kcal/kg')),
                DropdownMenuItem(value: 'g/kg', child: Text('g/kg')),
              ],
              onChanged: (value) {
                setState(() {
                  _unit = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _isHard,
              onChanged: (value) {
                setState(() {
                  _isHard = value!;
                });
              },
              title: const Text('Hard Constraint'),
              subtitle: const Text('Must be satisfied exactly'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_minimum != null) {
              final constraint = FormulationConstraint(
                nutrient: _nutrient,
                minimum: _minimum,
                maximum: _maximum,
                unit: _unit,
                isHard: _isHard,
                penalty: _isHard ? 100.0 : 10.0,
              );
              widget.onConstraintAdded(constraint);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}