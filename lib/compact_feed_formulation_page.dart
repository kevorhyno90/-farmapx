import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/app_state.dart';
import '../services/ingredient_database.dart';
import '../models/feed_formulation.dart' hide FeedIngredient;
import '../models/feed_ingredient.dart' as FeedIng;
import '../widgets/ingredient_component_table.dart';

class CompactFeedFormulationPage extends StatefulWidget {
  const CompactFeedFormulationPage({super.key});

  @override
  State<CompactFeedFormulationPage> createState() => _CompactFeedFormulationPageState();
}

class _CompactFeedFormulationPageState extends State<CompactFeedFormulationPage> {
  int _selectedIndex = 0;
  final List<FormulaIngredient> _selectedIngredients = [];
  String _searchQuery = '';
  FeedIng.IngredientCategory? _selectedCategory;
  AnimalSpecies _targetSpecies = AnimalSpecies.cattle;
  ProductionStage _targetStage = ProductionStage.grower;
  Set<String> _expandedIngredients = {};

  List<FeedIng.FeedIngredient> get _availableIngredients {
    var ingredients = IngredientDatabase.getAllIngredients();
    
    if (_searchQuery.isNotEmpty) {
      ingredients = ingredients.where((ing) => 
        ing.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        ing.commonName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    if (_selectedCategory != null) {
      ingredients = ingredients.where((ing) => ing.category == _selectedCategory).toList();
    }
    
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Compact Header
          _buildCompactHeader(),
          // Main Content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildIngredientsView(),
                _buildFormulationView(),
                _buildComponentTableView(),
                _buildNutritionView(),
                _buildSummaryView(),
              ],
            ),
          ),
          // Bottom Navigation
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[700],
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Feed Formulator', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${_targetSpecies.name.toUpperCase()} - ${_targetStage.name}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                _buildSpeciesSelector(),
              ],
            ),
            SizedBox(height: 8),
            _buildQuickStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeciesSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<AnimalSpecies>(
        value: _targetSpecies,
        dropdownColor: Colors.green[800],
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        style: TextStyle(color: Colors.white, fontSize: 12),
        items: AnimalSpecies.values.map((species) => DropdownMenuItem(
          value: species,
          child: Text(species.name.toUpperCase()),
        )).toList(),
        onChanged: (value) => setState(() => _targetSpecies = value!),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatChip('Ingredients', '${_selectedIngredients.length}', Icons.grain),
        SizedBox(width: 8),
        _buildStatChip('Total %', '${_selectedIngredients.fold(0.0, (sum, ing) => sum + ing.percentage).toStringAsFixed(1)}', Icons.percent),
        SizedBox(width: 8),
        _buildStatChip('Cost/kg', '\$${_calculateCostPerKg().toStringAsFixed(2)}', Icons.attach_money),
      ],
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text('$label: $value', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildIngredientsView() {
    return Column(
      children: [
        // Search and Filters
        _buildSearchAndFilters(),
        // Ingredients Grid
        Expanded(
          child: _buildIngredientsGrid(),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [
          // Enhanced Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ingredients...',
                    prefixIcon: Icon(Icons.search, color: Colors.green[600]),
                    suffixIcon: _searchQuery.isNotEmpty 
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.green.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.green.shade600, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: IconButton(
                  icon: Icon(Icons.tune, color: Colors.green[700]),
                  onPressed: _showAdvancedFilters,
                  tooltip: 'Advanced Filters',
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          // Quick Category Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip('All', null),
                _buildCategoryChip('Grains', FeedIng.IngredientCategory.cereal_grains),
                _buildCategoryChip('Protein', FeedIng.IngredientCategory.protein_meals),
                _buildCategoryChip('Forages', FeedIng.IngredientCategory.forages),
                _buildCategoryChip('By-products', FeedIng.IngredientCategory.by_products),
                _buildCategoryChip('Additives', FeedIng.IngredientCategory.additives),
              ],
            ),
          ),
          // Results Count
          if (_searchQuery.isNotEmpty || _selectedCategory != null)
            Container(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                '${_availableIngredients.length} ingredients found',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, FeedIng.IngredientCategory? category) {
    bool isSelected = _selectedCategory == category;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => setState(() => _selectedCategory = selected ? category : null),
        selectedColor: Colors.green[100],
        checkmarkColor: Colors.green[700],
      ),
    );
  }

  void _toggleIngredientExpansion(String ingredientId) {
    setState(() {
      if (_expandedIngredients.contains(ingredientId)) {
        _expandedIngredients.remove(ingredientId);
      } else {
        _expandedIngredients.add(ingredientId);
      }
    });
  }

  Widget _buildDetailedComposition(FeedIng.FeedIngredient ingredient) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCompositionSection('Basic Information', [
            _buildInfoRow('Name', ingredient.name),
            _buildInfoRow('Category', ingredient.category.toString().split('.').last.replaceAll('_', ' ').toUpperCase()),
            _buildInfoRow('Processing', ingredient.processing.toString().split('.').last.replaceAll('_', ' ').toUpperCase()),
            _buildInfoRow('Price', '\$${ingredient.currentPrice.toStringAsFixed(0)}/${ingredient.unit}'),
            _buildInfoRow('Availability', '${ingredient.availabilityScore.toStringAsFixed(0)}%'),
            _buildInfoRow('Palatability', '${ingredient.palatabilityScore.toStringAsFixed(0)}%'),
            _buildInfoRow('Digestibility', '${ingredient.digestibilityScore.toStringAsFixed(0)}%'),
          ]),
          
          SizedBox(height: 12),
          
          _buildCompositionSection('Nutritional Profile', [
            _buildInfoRow('Dry Matter', '${ingredient.nutritionalProfile.dryMatter.toStringAsFixed(1)}%'),
            _buildInfoRow('Crude Protein', '${ingredient.nutritionalProfile.crudeProtein.toStringAsFixed(1)}%'),
            _buildInfoRow('Digestible Protein', '${ingredient.nutritionalProfile.digestibleProtein.toStringAsFixed(1)}%'),
            _buildInfoRow('ME', '${(ingredient.nutritionalProfile.metabolizableEnergy/1000).toStringAsFixed(1)} MJ/kg'),
            _buildInfoRow('Crude Fat', '${ingredient.nutritionalProfile.crudeFat.toStringAsFixed(1)}%'),
            _buildInfoRow('NDF', '${ingredient.nutritionalProfile.ndf.toStringAsFixed(1)}%'),
            _buildInfoRow('ADF', '${ingredient.nutritionalProfile.adf.toStringAsFixed(1)}%'),
            _buildInfoRow('Ash', '${ingredient.nutritionalProfile.ash.toStringAsFixed(1)}%'),
          ]),
          
          SizedBox(height: 12),
          
          _buildCompositionSection('Minerals (g/kg)', [
            _buildInfoRow('Calcium', '${ingredient.nutritionalProfile.minerals.calcium.toStringAsFixed(2)}'),
            _buildInfoRow('Phosphorus', '${ingredient.nutritionalProfile.minerals.phosphorus.toStringAsFixed(2)}'),
            _buildInfoRow('Potassium', '${ingredient.nutritionalProfile.minerals.potassium.toStringAsFixed(2)}'),
            _buildInfoRow('Magnesium', '${ingredient.nutritionalProfile.minerals.magnesium.toStringAsFixed(2)}'),
            _buildInfoRow('Sodium', '${ingredient.nutritionalProfile.minerals.sodium.toStringAsFixed(2)}'),
            _buildInfoRow('Sulfur', '${ingredient.nutritionalProfile.minerals.sulfur.toStringAsFixed(2)}'),
          ]),

          if (ingredient.nutritionalProfile.aminoAcids.lysine > 0 || 
              ingredient.nutritionalProfile.aminoAcids.methionine > 0 ||
              ingredient.nutritionalProfile.aminoAcids.threonine > 0) ...[
            SizedBox(height: 12),
            _buildCompositionSection('Amino Acids (%)', [
              if (ingredient.nutritionalProfile.aminoAcids.lysine > 0) 
                _buildInfoRow('Lysine', '${ingredient.nutritionalProfile.aminoAcids.lysine.toStringAsFixed(2)}'),
              if (ingredient.nutritionalProfile.aminoAcids.methionine > 0) 
                _buildInfoRow('Methionine', '${ingredient.nutritionalProfile.aminoAcids.methionine.toStringAsFixed(2)}'),
              if (ingredient.nutritionalProfile.aminoAcids.threonine > 0) 
                _buildInfoRow('Threonine', '${ingredient.nutritionalProfile.aminoAcids.threonine.toStringAsFixed(2)}'),
              if (ingredient.nutritionalProfile.aminoAcids.tryptophan > 0) 
                _buildInfoRow('Tryptophan', '${ingredient.nutritionalProfile.aminoAcids.tryptophan.toStringAsFixed(2)}'),
            ]),
          ],

          SizedBox(height: 12),
          
          _buildCompositionSection('Usage Information', [
            _buildInfoRow('Max Inclusion', '${ingredient.maxInclusionRate.toStringAsFixed(1)}%'),
            _buildInfoRow('Suitable Species', ingredient.suitableSpecies.join(', ')),
            _buildInfoRow('Storage', ingredient.storageRequirements),
            _buildInfoRow('Shelf Life', '${ingredient.shelfLifeDays} days'),
            if (ingredient.restrictions.isNotEmpty)
              _buildInfoRow('Restrictions', ingredient.restrictions.join(', ')),
          ]),
        ],
      ),
    );
  }

  Widget _buildCompositionSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue[800]),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[700])),
          Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Advanced Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildFilterSection('Protein Content (%)', 0, 50, (value) {}),
                    _buildFilterSection('Energy (kcal/kg)', 1000, 5000, (value) {}),
                    _buildFilterSection('Price (\$/ton)', 100, 1000, (value) {}),
                    _buildFilterSection('Fiber Content (%)', 0, 80, (value) {}),
                    SizedBox(height: 20),
                    Text('Suitable Species', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: ['Cattle', 'Swine', 'Poultry', 'Sheep', 'Goats']
                          .map((species) => FilterChip(
                                label: Text(species),
                                selected: false,
                                onSelected: (selected) {},
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Reset'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, double min, double max, Function(RangeValues) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        RangeSlider(
          values: RangeValues(min, max),
          min: min,
          max: max,
          divisions: 20,
          labels: RangeLabels('${min.toInt()}', '${max.toInt()}'),
          onChanged: onChanged,
          activeColor: Colors.green[600],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildIngredientsGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: _availableIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = _availableIngredients[index];
        return _buildIngredientCard(ingredient);
      },
    );
  }

  Widget _buildIngredientCard(FeedIng.FeedIngredient ingredient) {
    bool isSelected = _selectedIngredients.any((ing) => ing.ingredientId == ingredient.id);
    bool isExpanded = _expandedIngredients.contains(ingredient.id);
    
    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected ? Colors.green[50] : Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleIngredient(ingredient),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(ingredient.category),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(_getCategoryIcon(ingredient.category), size: 16, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ingredient.commonName.isNotEmpty ? ingredient.commonName : ingredient.name,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (ingredient.scientificName.isNotEmpty)
                              Text(
                                ingredient.scientificName,
                                style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, size: 20),
                        onPressed: () => _toggleIngredientExpansion(ingredient.id),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                      if (isSelected) Icon(Icons.check_circle, color: Colors.green, size: 16),
                    ],
                  ),
                  SizedBox(height: 4),
                  _buildMiniNutritionInfo(ingredient),
                  Row(
                    children: [
                      Text('\$${ingredient.currentPrice.toStringAsFixed(0)}/t', 
                           style: TextStyle(fontSize: 10, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                      Spacer(),
                      if (isSelected) 
                        Text('${_getIngredientPercentage(ingredient.id).toStringAsFixed(1)}%',
                             style: TextStyle(fontSize: 10, color: Colors.green[700], fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) _buildDetailedComposition(ingredient),
        ],
      ),
    );
  }

  Widget _buildMiniNutritionInfo(FeedIng.FeedIngredient ingredient) {
    return Column(
      children: [
        Row(
          children: [
            _buildMiniStat('CP', '${ingredient.nutritionalProfile.crudeProtein.toStringAsFixed(1)}%'),
            _buildMiniStat('ME', '${(ingredient.nutritionalProfile.metabolizableEnergy/1000).toStringAsFixed(1)}'),
          ],
        ),
        SizedBox(height: 2),
        Row(
          children: [
            _buildMiniStat('Fat', '${ingredient.nutritionalProfile.crudeFat.toStringAsFixed(1)}%'),
            _buildMiniStat('Fiber', '${ingredient.nutritionalProfile.ndf.toStringAsFixed(1)}%'),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Expanded(
      child: Text('$label: $value', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
    );
  }

  Widget _buildFormulationView() {
    return Column(
      children: [
        // Formula Controls
        _buildFormulaControls(),
        // Selected Ingredients List
        Expanded(
          child: _buildSelectedIngredientsList(),
        ),
      ],
    );
  }

  Widget _buildFormulaControls() {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _optimizeFormulation,
                  icon: Icon(Icons.auto_fix_high),
                  label: Text('Optimize'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearFormulation,
                  icon: Icon(Icons.clear),
                  label: Text('Clear'),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<ProductionStage>(
                  value: _targetStage,
                  decoration: InputDecoration(
                    labelText: 'Stage',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ProductionStage.values.map((stage) => DropdownMenuItem(
                    value: stage,
                    child: Text(stage.name),
                  )).toList(),
                  onChanged: (value) => setState(() => _targetStage = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedIngredientsList() {
    if (_selectedIngredients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grain, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text('No ingredients selected', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            SizedBox(height: 8),
            Text('Go to Ingredients tab to add ingredients', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: _selectedIngredients.length,
      itemBuilder: (context, index) {
        final formulaIngredient = _selectedIngredients[index];
        final ingredient = IngredientDatabase.getIngredientById(formulaIngredient.ingredientId);
        return _buildSelectedIngredientCard(formulaIngredient, ingredient!, index);
      },
    );
  }

  Widget _buildSelectedIngredientCard(FormulaIngredient formulaIngredient, FeedIng.FeedIngredient ingredient, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(ingredient.category),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(_getCategoryIcon(ingredient.category), size: 18, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ingredient.commonName.isNotEmpty ? ingredient.commonName : ingredient.name,
                           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${formulaIngredient.percentage.toStringAsFixed(1)}% - \$${ingredient.currentPrice.toStringAsFixed(0)}/t',
                           style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _removeIngredient(index),
                  icon: Icon(Icons.delete, color: Colors.red[400]),
                  iconSize: 20,
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: formulaIngredient.percentage,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${formulaIngredient.percentage.toStringAsFixed(1)}%',
                    onChanged: (value) => _updateIngredientPercentage(index, value),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: TextEditingController(text: formulaIngredient.percentage.toStringAsFixed(1)),
                    decoration: InputDecoration(
                      suffix: Text('%'),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    style: TextStyle(fontSize: 12),
                    onSubmitted: (value) => _updateIngredientPercentage(index, double.tryParse(value) ?? 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buildNutritionSummaryCards(),
          SizedBox(height: 16),
          _buildDetailedNutritionTable(),
        ],
      ),
    );
  }

  Widget _buildNutritionSummaryCards() {
    final nutrition = _calculateFormulationNutrition();
    
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: [
        _buildNutritionCard('Protein', '${nutrition['crudeProtein']?.toStringAsFixed(1) ?? '0'}%', Icons.fitness_center, Colors.blue),
        _buildNutritionCard('Energy', '${((nutrition['metabolizableEnergy'] ?? 0)/1000).toStringAsFixed(1)} MJ/kg', Icons.flash_on, Colors.orange),
        _buildNutritionCard('Fat', '${nutrition['etherExtract']?.toStringAsFixed(1) ?? '0'}%', Icons.opacity, Colors.yellow[700]!),
        _buildNutritionCard('Fiber', '${nutrition['crudefiber']?.toStringAsFixed(1) ?? '0'}%', Icons.grass, Colors.green),
      ],
    );
  }

  Widget _buildNutritionCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedNutritionTable() {
    final nutrition = _calculateFormulationNutrition();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detailed Nutrition Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _buildNutritionRow('Dry Matter', '${nutrition['dryMatter']?.toStringAsFixed(1) ?? '0'}%'),
            _buildNutritionRow('Crude Protein', '${nutrition['crudeProtein']?.toStringAsFixed(1) ?? '0'}%'),
            _buildNutritionRow('Ether Extract', '${nutrition['etherExtract']?.toStringAsFixed(1) ?? '0'}%'),
            _buildNutritionRow('Crude Fiber', '${nutrition['crudefiber']?.toStringAsFixed(1) ?? '0'}%'),
            _buildNutritionRow('Ash', '${nutrition['ash']?.toStringAsFixed(1) ?? '0'}%'),
            _buildNutritionRow('ME', '${nutrition['metabolizableEnergy']?.toStringAsFixed(0) ?? '0'} kcal/kg'),
            Divider(),
            Text('Minerals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            _buildNutritionRow('Calcium', '${nutrition['calcium']?.toStringAsFixed(2) ?? '0'}%'),
            _buildNutritionRow('Phosphorus', '${nutrition['phosphorus']?.toStringAsFixed(2) ?? '0'}%'),
            _buildNutritionRow('Potassium', '${nutrition['potassium']?.toStringAsFixed(2) ?? '0'}%'),
            _buildNutritionRow('Sodium', '${nutrition['sodium']?.toStringAsFixed(2) ?? '0'}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String nutrient, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(nutrient, style: TextStyle(fontSize: 12)),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSummaryView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buildCostBreakdown(),
          SizedBox(height: 16),
          _buildFormulationChart(),
          SizedBox(height: 16),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown() {
    double totalCost = _calculateTotalCost();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cost Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ..._selectedIngredients.map((ing) {
              final ingredient = IngredientDatabase.getIngredientById(ing.ingredientId)!;
              final cost = (ingredient.currentPrice * ing.percentage / 100);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ingredient.commonName, style: TextStyle(fontSize: 12)),
                    Text('\$${cost.toStringAsFixed(2)}/t', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ),
              );
            }).toList(),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Cost', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('\$${totalCost.toStringAsFixed(2)}/t', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulationChart() {
    if (_selectedIngredients.isEmpty) return SizedBox();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Formulation Composition', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _selectedIngredients.asMap().entries.map((entry) {
                    final ingredient = IngredientDatabase.getIngredientById(entry.value.ingredientId)!;
                    return PieChartSectionData(
                      value: entry.value.percentage,
                      title: '${entry.value.percentage.toStringAsFixed(1)}%',
                      color: _getCategoryColor(ingredient.category),
                      radius: 60,
                      titleStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    List<String> recommendations = _generateRecommendations();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommendations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ...recommendations.map((rec) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, size: 16, color: Colors.amber),
                  SizedBox(width: 8),
                  Expanded(child: Text(rec, style: TextStyle(fontSize: 12))),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentTableView() {
    return const IngredientComponentTable();
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.grain), label: 'Ingredients'),
        BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Formulation'),
        BottomNavigationBarItem(icon: Icon(Icons.table_chart), label: 'Components'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Nutrition'),
        BottomNavigationBarItem(icon: Icon(Icons.summarize), label: 'Summary'),
      ],
    );
  }

  // Helper Methods
  void _toggleIngredient(FeedIng.FeedIngredient ingredient) {
    setState(() {
      final existingIndex = _selectedIngredients.indexWhere((ing) => ing.ingredientId == ingredient.id);
      if (existingIndex >= 0) {
        _selectedIngredients.removeAt(existingIndex);
      } else {
        _selectedIngredients.add(FormulaIngredient(
          ingredientId: ingredient.id,
          percentage: 10.0,
        ));
      }
    });
  }

  double _getIngredientPercentage(String ingredientId) {
    final ingredient = _selectedIngredients.firstWhere(
      (ing) => ing.ingredientId == ingredientId,
      orElse: () => FormulaIngredient(ingredientId: '', percentage: 0),
    );
    return ingredient.percentage;
  }

  void _updateIngredientPercentage(int index, double percentage) {
    setState(() {
      _selectedIngredients[index] = FormulaIngredient(
        ingredientId: _selectedIngredients[index].ingredientId,
        percentage: percentage.clamp(0, 100),
      );
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _selectedIngredients.removeAt(index);
    });
  }

  void _optimizeFormulation() {
    // Basic optimization - distribute evenly
    if (_selectedIngredients.isNotEmpty) {
      double basePercentage = 100.0 / _selectedIngredients.length;
      setState(() {
        for (int i = 0; i < _selectedIngredients.length; i++) {
          _selectedIngredients[i] = FormulaIngredient(
            ingredientId: _selectedIngredients[i].ingredientId,
            percentage: basePercentage,
          );
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Formulation optimized! Ingredients distributed evenly.')),
      );
    }
  }

  void _clearFormulation() {
    setState(() {
      _selectedIngredients.clear();
    });
  }

  Map<String, double> _calculateFormulationNutrition() {
    if (_selectedIngredients.isEmpty) return {};
    
    Map<String, double> totalNutrition = {};
    double totalWeight = _selectedIngredients.fold(0, (sum, ing) => sum + ing.percentage);
    
    if (totalWeight == 0) return {};
    
    for (final formulaIng in _selectedIngredients) {
      final ingredient = IngredientDatabase.getIngredientById(formulaIng.ingredientId);
      if (ingredient != null) {
        final weight = formulaIng.percentage / totalWeight;
        
        totalNutrition['dryMatter'] = (totalNutrition['dryMatter'] ?? 0) + 
          (ingredient.nutritionalProfile.dryMatter * weight);
        totalNutrition['crudeProtein'] = (totalNutrition['crudeProtein'] ?? 0) + 
          (ingredient.nutritionalProfile.crudeProtein * weight);
        totalNutrition['etherExtract'] = (totalNutrition['etherExtract'] ?? 0) + 
          (ingredient.nutritionalProfile.crudeFat * weight);
        totalNutrition['crudefiber'] = (totalNutrition['crudefiber'] ?? 0) + 
          (ingredient.nutritionalProfile.adf * weight);
        totalNutrition['ash'] = (totalNutrition['ash'] ?? 0) + 
          (ingredient.nutritionalProfile.ash * weight);
        totalNutrition['metabolizableEnergy'] = (totalNutrition['metabolizableEnergy'] ?? 0) + 
          (ingredient.nutritionalProfile.metabolizableEnergy * weight);
        totalNutrition['calcium'] = (totalNutrition['calcium'] ?? 0) + 
          (ingredient.nutritionalProfile.minerals.calcium * weight);
        totalNutrition['phosphorus'] = (totalNutrition['phosphorus'] ?? 0) + 
          (ingredient.nutritionalProfile.minerals.phosphorus * weight);
        totalNutrition['potassium'] = (totalNutrition['potassium'] ?? 0) + 
          (ingredient.nutritionalProfile.minerals.potassium * weight);
        totalNutrition['sodium'] = (totalNutrition['sodium'] ?? 0) + 
          (ingredient.nutritionalProfile.minerals.sodium * weight);
      }
    }
    
    return totalNutrition;
  }

  double _calculateTotalCost() {
    double totalCost = 0;
    for (final ing in _selectedIngredients) {
      final ingredient = IngredientDatabase.getIngredientById(ing.ingredientId);
      if (ingredient != null) {
        totalCost += (ingredient.currentPrice * ing.percentage / 100);
      }
    }
    return totalCost;
  }

  double _calculateCostPerKg() {
    return _calculateTotalCost() / 1000; // Convert from per ton to per kg
  }

  List<String> _generateRecommendations() {
    List<String> recommendations = [];
    final nutrition = _calculateFormulationNutrition();
    
    if (_selectedIngredients.isEmpty) {
      recommendations.add('Add ingredients to start formulation');
      return recommendations;
    }
    
    double totalPercentage = _selectedIngredients.fold(0, (sum, ing) => sum + ing.percentage);
    if (totalPercentage < 95) {
      recommendations.add('Total percentage is ${totalPercentage.toStringAsFixed(1)}% - add more ingredients');
    } else if (totalPercentage > 105) {
      recommendations.add('Total percentage is ${totalPercentage.toStringAsFixed(1)}% - reduce some ingredients');
    }
    
    double protein = nutrition['crudeProtein'] ?? 0;
    if (protein < 12) {
      recommendations.add('Protein level is low (${protein.toStringAsFixed(1)}%) - add protein sources');
    } else if (protein > 25) {
      recommendations.add('Protein level is high (${protein.toStringAsFixed(1)}%) - may be expensive');
    }
    
    double energy = nutrition['metabolizableEnergy'] ?? 0;
    if (energy < 2000) {
      recommendations.add('Energy level is low - add energy sources like grains or fats');
    }
    
    if (recommendations.isEmpty) {
      recommendations.add('Formulation looks good! Consider optimizing for cost.');
    }
    
    return recommendations;
  }

  Color _getCategoryColor(FeedIng.IngredientCategory category) {
    switch (category) {
      case FeedIng.IngredientCategory.cereal_grains: return Colors.amber;
      case FeedIng.IngredientCategory.protein_meals: return Colors.red;
      case FeedIng.IngredientCategory.fats_oils: return Colors.orange;
      case FeedIng.IngredientCategory.forages: return Colors.green;
      case FeedIng.IngredientCategory.by_products: return Colors.brown;
      case FeedIng.IngredientCategory.minerals: return Colors.grey;
      case FeedIng.IngredientCategory.vitamins: return Colors.purple;
      case FeedIng.IngredientCategory.additives: return Colors.blue;
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(FeedIng.IngredientCategory category) {
    switch (category) {
      case FeedIng.IngredientCategory.cereal_grains: return Icons.grain;
      case FeedIng.IngredientCategory.protein_meals: return Icons.fitness_center;
      case FeedIng.IngredientCategory.fats_oils: return Icons.opacity;
      case FeedIng.IngredientCategory.forages: return Icons.grass;
      case FeedIng.IngredientCategory.by_products: return Icons.recycling;
      case FeedIng.IngredientCategory.minerals: return Icons.diamond;
      case FeedIng.IngredientCategory.vitamins: return Icons.medical_services;
      case FeedIng.IngredientCategory.additives: return Icons.science;
      default: return Icons.category;
    }
  }
}