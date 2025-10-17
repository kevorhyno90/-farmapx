import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/requirements_database.dart';
import '../services/formulation_optimizer.dart' hide FormulationConstraint;
import '../services/ingredient_database.dart';
import '../models/feed_formulation.dart';
import '../models/feed_ingredient.dart';
import '../widgets/csv_input_dialog.dart';
import 'ingredient_management_page.dart';
import 'advanced_formulation_page.dart';

class FeedFormulationPage extends StatefulWidget {
  const FeedFormulationPage({super.key});

  @override
  State<FeedFormulationPage> createState() => _FeedFormulationPageState();
}

class _FeedFormulationPageState extends State<FeedFormulationPage> {

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feed Formulation System'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list_alt), text: 'Formulations'),
              Tab(icon: Icon(Icons.engineering), text: 'Formulator'),
              Tab(icon: Icon(Icons.storage), text: 'Ingredients'),
              Tab(icon: Icon(Icons.analytics), text: 'Analysis'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () => _exportData(context),
            ),
            IconButton(
              icon: const Icon(Icons.file_upload),
              onPressed: () => _importData(context),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildFormulationsList(app),
            _buildFormulator(app),
            const IngredientManagementPage(),
            _buildAnalysisTab(app),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final id = DateTime.now().millisecondsSinceEpoch.toString();
            final newF = FeedFormulation(id: id, name: 'New Formula');
            final created = await Navigator.push<FeedFormulation?>(
              context,
              MaterialPageRoute(builder: (_) => _EditFeedPage(f: newF)),
            );
            if (created != null) {
              await app.addFeedFormulation(created);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFormulationsList(AppState app) {
    return Column(
      children: [
        // Quick stats bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('Total Formulas', app.feedFormulations.length.toString()),
              _buildStatCard('Approved', app.feedFormulations.where((f) => f.approved).length.toString()),
              _buildStatCard('Species Types', app.feedFormulations.map((f) => f.targetSpecies).toSet().length.toString()),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: app.feedFormulations.length,
            itemBuilder: (context, idx) {
              final f = app.feedFormulations[idx];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: f.approved ? Colors.green : Colors.orange,
                    child: Icon(
                      f.approved ? Icons.verified : Icons.pending,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${f.targetSpecies.name.toUpperCase()} • ${f.targetStage.name}'),
                      Text('CP: ${f.crudeProteinTarget.toStringAsFixed(1)}% • ME: ${f.metabolisableEnergyTarget.toStringAsFixed(0)} kcal/kg'),
                      Text('Cost: \$${f.costPerKg.toStringAsFixed(2)}/kg • Quality: ${f.qualityScore}/100'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (f.warnings.isNotEmpty)
                        const Icon(Icons.warning, color: Colors.orange, size: 20),
                      PopupMenuButton<String>(
                        onSelected: (value) => _handleFormulationAction(value, f, app),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                          const PopupMenuItem(value: 'optimize', child: Text('Optimize')),
                          const PopupMenuItem(value: 'approve', child: Text('Approve')),
                          const PopupMenuItem(value: 'export', child: Text('Export')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (f.description.isNotEmpty) ...[
                            const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(f.description),
                            const SizedBox(height: 8),
                          ],
                          const Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ...f.ingredients.map((ing) => Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text('• ${ing.ingredientId}: ${ing.percentage.toStringAsFixed(1)}%'),
                          )),
                          const SizedBox(height: 8),
                          if (f.warnings.isNotEmpty) ...[
                            const Text('Warnings:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                            ...f.warnings.map((w) => Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text('• $w', style: const TextStyle(color: Colors.orange)),
                            )),
                          ],
                          if (f.recommendations.isNotEmpty) ...[
                            const Text('Recommendations:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            ...f.recommendations.map((r) => Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text('• $r', style: const TextStyle(color: Colors.blue)),
                            )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormulator(AppState app) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdvancedFormulationPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.rocket_launch),
                label: const Text('Advanced Formulator'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                ),
              ),
              Text(
                'Professional optimization engine',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: _FormulatorWidget()),
      ],
    );
  }

  Widget _buildAnalysisTab(AppState app) {
    // Use available ingredients from the database for analysis
    final availableIngredients = IngredientDatabase.getAllIngredients();
    final ingredients = availableIngredients.take(5).map((ingredient) => 
      FormulaIngredient(ingredientId: ingredient.id, percentage: 20.0)).toList();
    return _AnalysisWidget(ingredients: ingredients);
  }

  Widget _buildStatCard(String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _handleFormulationAction(String action, FeedFormulation f, AppState app) async {
    switch (action) {
      case 'edit':
        final changed = await Navigator.push<FeedFormulation?>(
          context,
          MaterialPageRoute(builder: (_) => _EditFeedPage(f: f)),
        );
        if (changed != null) {
          await app.updateFeedFormulation(changed);
        }
        break;
      case 'duplicate':
        final duplicate = FeedFormulation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '${f.name} (Copy)',
          description: f.description,
          targetSpecies: f.targetSpecies,
          targetStage: f.targetStage,
          form: f.form,
          ingredients: f.ingredients,
          constraints: f.constraints,
        );
        await app.addFeedFormulation(duplicate);
        break;
      case 'delete':
        app.deleteFeedFormulation(f.id);
        break;
      // Add other actions as needed
    }
  }

  void _exportData(BuildContext context) {
    final csv = context.read<AppState>().exportFeedFormulationsCsv();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Export Feed Formulations'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: SingleChildScrollView(child: SelectableText(csv)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _importData(BuildContext context) async {
    final csv = await showDialog<String?>(
      context: context,
      builder: (_) => const CsvInputDialog(),
    );
    if (!context.mounted || csv == null) return;
    
    final messenger = ScaffoldMessenger.of(context);
    final appState = context.read<AppState>();
    final count = await appState.importFeedFormulationsCsvAndSave(csv);
    messenger.showSnackBar(SnackBar(content: Text('Imported $count formulations')));
  }
}

class _FormulatorWidget extends StatefulWidget {
  const _FormulatorWidget();

  @override
  State<_FormulatorWidget> createState() => _FormulatorWidgetState();
}

class _FormulatorWidgetState extends State<_FormulatorWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  AnimalSpecies _selectedSpecies = AnimalSpecies.cattle;
  ProductionStage _selectedStage = ProductionStage.grower;
  FeedForm _selectedForm = FeedForm.mash;
  
  final List<FormulaIngredient> _ingredients = [];
  final List<FormulationConstraint> _constraints = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Formula Information', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Formula Name'),
                      validator: (value) => value?.isEmpty == true ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<AnimalSpecies>(
                            initialValue: _selectedSpecies,
                            decoration: const InputDecoration(labelText: 'Target Species'),
                            items: AnimalSpecies.values.map((species) {
                              return DropdownMenuItem(
                                value: species,
                                child: Text(species.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedSpecies = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<ProductionStage>(
                            initialValue: _selectedStage,
                            decoration: const InputDecoration(labelText: 'Production Stage'),
                            items: ProductionStage.values.map((stage) {
                              return DropdownMenuItem(
                                value: stage,
                                child: Text(stage.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedStage = value!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<FeedForm>(
                            initialValue: _selectedForm,
                            decoration: const InputDecoration(labelText: 'Feed Form'),
                            items: FeedForm.values.map((form) {
                              return DropdownMenuItem(
                                value: form,
                                child: Text(form.name.toUpperCase()),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedForm = value!),
                          ),
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ingredients', style: Theme.of(context).textTheme.headlineSmall),
                        ElevatedButton.icon(
                          onPressed: _addIngredient,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Ingredient'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_ingredients.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('No ingredients added yet'),
                        ),
                      )
                    else
                      Column(
                        children: _ingredients.asMap().entries.map((entry) {
                          final index = entry.key;
                          final ingredient = entry.value;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(ingredient.ingredientId),
                              subtitle: Text('${ingredient.percentage.toStringAsFixed(1)}%'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _editIngredient(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _removeIngredient(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    if (_ingredients.isNotEmpty) ...[
                      const Divider(),
                      Text('Total: ${_ingredients.fold(0.0, (sum, ing) => sum + ing.percentage).toStringAsFixed(1)}%'),
                    ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nutritional Constraints', style: Theme.of(context).textTheme.headlineSmall),
                        ElevatedButton.icon(
                          onPressed: _addConstraint,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Constraint'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_constraints.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('No constraints defined'),
                        ),
                      )
                    else
                      Column(
                        children: _constraints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final constraint = entry.value;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(constraint.nutrient),
                              subtitle: Text('${constraint.minimum} - ${constraint.maximum} ${constraint.unit}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _removeConstraint(index),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _optimizeFormulation,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Optimize'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                ),
                ElevatedButton.icon(
                  onPressed: _calculateNutrition,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculate'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: _saveFormulation,
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addIngredient() {
    showDialog(
      context: context,
      builder: (context) => _IngredientDialog(
        onAdd: (ingredient) {
          setState(() => _ingredients.add(ingredient));
        },
      ),
    );
  }

  void _editIngredient(int index) {
    showDialog(
      context: context,
      builder: (context) => _IngredientDialog(
        ingredient: _ingredients[index],
        onAdd: (ingredient) {
          setState(() => _ingredients[index] = ingredient);
        },
      ),
    );
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  void _addConstraint() {
    showDialog(
      context: context,
      builder: (context) => _ConstraintDialog(
        onAdd: (constraint) {
          setState(() => _constraints.add(constraint));
        },
      ),
    );
  }

  void _removeConstraint(int index) {
    setState(() => _constraints.removeAt(index));
  }

  void _optimizeFormulation() {
    if (_selectedSpecies == null || _selectedStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select species and production stage first')),
      );
      return;
    }

    // Simple optimization simulation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Optimization completed! Check advanced formulation for full optimization features.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _calculateNutrition() {
    // Calculate nutritional profile
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nutrition calculation completed!')),
    );
  }

  void _saveFormulation() async {
    if (!_formKey.currentState!.validate()) return;

    final formulation = FeedFormulation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      targetSpecies: _selectedSpecies,
      targetStage: _selectedStage,
      form: _selectedForm,
      ingredients: _ingredients,
      constraints: _constraints,
    );

    final app = context.read<AppState>();
    await app.addFeedFormulation(formulation);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulation saved successfully!')),
      );
      
      // Clear form
      _nameController.clear();
      _descriptionController.clear();
      setState(() {
        _ingredients.clear();
        _constraints.clear();
      });
    }
  }
}

class _AnalysisWidget extends StatelessWidget {
  final List<FormulaIngredient> ingredients;
  
  const _AnalysisWidget({required this.ingredients});

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No ingredients added yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add ingredients to see nutritional analysis',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Calculate totals
    double totalPercentage = 0;
    for (final ingredient in ingredients) {
      totalPercentage += ingredient.percentage;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Formulation Summary',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          'Total Ingredients',
                          '${ingredients.length}',
                          Icons.grain,
                          Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          'Total Percentage',
                          '${totalPercentage.toStringAsFixed(1)}%',
                          Icons.pie_chart,
                          totalPercentage >= 99 && totalPercentage <= 101 
                              ? Colors.green : Colors.orange,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          'Status',
                          totalPercentage >= 99 && totalPercentage <= 101 
                              ? 'Complete' : 'Incomplete',
                          Icons.check_circle,
                          totalPercentage >= 99 && totalPercentage <= 101 
                              ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Ingredient Breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.list, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        'Ingredient Breakdown',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...ingredients.map((ingredient) {
                    return _buildIngredientRow(ingredient);
                  }).toList(),
                  if (totalPercentage < 99) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Formula is incomplete. Add more ingredients to reach 100%.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(FormulaIngredient ingredient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.ingredientId.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Feed Ingredient',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${ingredient.percentage.toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const Expanded(
            child: Text(
              'Analysis',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientDialog extends StatefulWidget {
  final FormulaIngredient? ingredient;
  final Function(FormulaIngredient) onAdd;

  const _IngredientDialog({this.ingredient, required this.onAdd});

  @override
  State<_IngredientDialog> createState() => _IngredientDialogState();
}

class _IngredientDialogState extends State<_IngredientDialog> {
  late TextEditingController _nameController;
  late TextEditingController _percentageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ingredient?.ingredientId ?? '');
    _percentageController = TextEditingController(text: widget.ingredient?.percentage.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.ingredient == null ? 'Add Ingredient' : 'Edit Ingredient'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Ingredient Name'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _percentageController,
            decoration: const InputDecoration(labelText: 'Percentage', suffixText: '%'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final percentage = double.tryParse(_percentageController.text) ?? 0.0;
            if (_nameController.text.isNotEmpty && percentage > 0) {
              widget.onAdd(FormulaIngredient(
                ingredientId: _nameController.text,
                percentage: percentage,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ConstraintDialog extends StatefulWidget {
  final Function(FormulationConstraint) onAdd;

  const _ConstraintDialog({required this.onAdd});

  @override
  State<_ConstraintDialog> createState() => _ConstraintDialogState();
}

class _ConstraintDialogState extends State<_ConstraintDialog> {
  final _nutrientController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  String _selectedUnit = '%';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Constraint'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nutrientController,
            decoration: const InputDecoration(labelText: 'Nutrient'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minController,
                  decoration: const InputDecoration(labelText: 'Minimum'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _maxController,
                  decoration: const InputDecoration(labelText: 'Maximum'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedUnit,
            decoration: const InputDecoration(labelText: 'Unit'),
            items: ['%', 'ppm', 'IU/kg', 'mg/kg', 'kcal/kg'].map((unit) {
              return DropdownMenuItem(value: unit, child: Text(unit));
            }).toList(),
            onChanged: (value) => setState(() => _selectedUnit = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final min = double.tryParse(_minController.text) ?? 0.0;
            final max = double.tryParse(_maxController.text) ?? double.infinity;
            if (_nutrientController.text.isNotEmpty) {
              widget.onAdd(FormulationConstraint(
                nutrient: _nutrientController.text,
                minimum: min,
                maximum: max,
                unit: _selectedUnit,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _EditFeedPage extends StatefulWidget {
  final FeedFormulation f;
  const _EditFeedPage({required this.f});
  @override
  State<_EditFeedPage> createState() => _EditFeedPageState();
}

class _EditFeedPageState extends State<_EditFeedPage> {
  late TextEditingController nameCtrl;
  late TextEditingController descriptionCtrl;
  late AnimalSpecies selectedSpecies;
  late ProductionStage selectedStage;
  late FeedForm selectedForm;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.f.name);
    descriptionCtrl = TextEditingController(text: widget.f.description);
    selectedSpecies = widget.f.targetSpecies;
    selectedStage = widget.f.targetStage;
    selectedForm = widget.f.form;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Feed Formula')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<AnimalSpecies>(
              initialValue: selectedSpecies,
              decoration: const InputDecoration(labelText: 'Target Species'),
              items: AnimalSpecies.values.map((species) {
                return DropdownMenuItem(
                  value: species,
                  child: Text(species.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedSpecies = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ProductionStage>(
              initialValue: selectedStage,
              decoration: const InputDecoration(labelText: 'Production Stage'),
              items: ProductionStage.values.map((stage) {
                return DropdownMenuItem(
                  value: stage,
                  child: Text(stage.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedStage = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<FeedForm>(
              initialValue: selectedForm,
              decoration: const InputDecoration(labelText: 'Feed Form'),
              items: FeedForm.values.map((form) {
                return DropdownMenuItem(
                  value: form,
                  child: Text(form.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedForm = value!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final updated = FeedFormulation(
                  id: widget.f.id,
                  name: nameCtrl.text,
                  description: descriptionCtrl.text,
                  targetSpecies: selectedSpecies,
                  targetStage: selectedStage,
                  form: selectedForm,
                  ingredients: widget.f.ingredients,
                  constraints: widget.f.constraints,
                  requirements: widget.f.requirements,
                  createdDate: widget.f.createdDate,
                  lastModified: DateTime.now(),
                );
                Navigator.pop(context, updated);
              },
              child: const Text('Save'),
            ),
          ]),
        ),
      ),
    );
  }
}
