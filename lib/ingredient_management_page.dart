import 'package:flutter/material.dart';
import '../models/feed_ingredient.dart';
import '../services/ingredient_database.dart';

class IngredientManagementPage extends StatefulWidget {
  const IngredientManagementPage({Key? key}) : super(key: key);

  @override
  State<IngredientManagementPage> createState() => _IngredientManagementPageState();
}

class _IngredientManagementPageState extends State<IngredientManagementPage> with TickerProviderStateMixin {
  String _searchQuery = '';
  IngredientCategory? _selectedCategory;
  String _sortBy = 'name';
  bool _sortAscending = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    IngredientDatabase.initialize();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<FeedIngredient> get filteredIngredients {
    List<FeedIngredient> ingredients = IngredientDatabase.getAllIngredients();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      ingredients = IngredientDatabase.searchIngredients(_searchQuery);
    }

    // Apply category filter
    if (_selectedCategory != null) {
      ingredients = ingredients
          .where((ingredient) => ingredient.category == _selectedCategory)
          .toList();
    }

    // Apply sorting
    ingredients.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'protein':
          comparison = (a.nutritionalProfile.crudeProtein ?? 0)
              .compareTo(b.nutritionalProfile.crudeProtein ?? 0);
          break;
        case 'energy':
          comparison = (a.nutritionalProfile.metabolizableEnergy ?? 0)
              .compareTo(b.nutritionalProfile.metabolizableEnergy ?? 0);
          break;
        case 'price':
          comparison = a.currentPrice.compareTo(b.currentPrice);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Ingredient Database'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Browse', icon: Icon(Icons.grid_view)),
            Tab(text: 'Search', icon: Icon(Icons.search)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseTab(),
          _buildSearchTab(),
          _buildAnalyticsTab(),
        ],
      ),
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        _buildFilterBar(),
        Expanded(
          child: _buildIngredientGrid(),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        _buildSearchBar(),
        _buildCategoryChips(),
        _buildSortOptions(),
        Expanded(
          child: _buildIngredientList(),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return _buildAnalyticsDashboard();
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<IngredientCategory?>(
              value: _selectedCategory,
              hint: const Text('All Categories'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: [
                const DropdownMenuItem<IngredientCategory?>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...IngredientCategory.values.map((category) {
                  return DropdownMenuItem<IngredientCategory>(
                    value: category,
                    child: Text(_getCategoryDisplayName(category)),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
            },
            items: const [
              DropdownMenuItem(value: 'name', child: Text('Name')),
              DropdownMenuItem(value: 'protein', child: Text('Protein')),
              DropdownMenuItem(value: 'energy', child: Text('Energy')),
              DropdownMenuItem(value: 'price', child: Text('Price')),
            ],
          ),
          IconButton(
            icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search ingredients...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedCategory == null,
            onSelected: (selected) {
              setState(() {
                _selectedCategory = null;
              });
            },
          ),
          const SizedBox(width: 8),
          ...IngredientCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_getCategoryDisplayName(category)),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = selected ? category : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('Sort by: '),
          DropdownButton<String>(
            value: _sortBy,
            underline: Container(),
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
            },
            items: const [
              DropdownMenuItem(value: 'name', child: Text('Name')),
              DropdownMenuItem(value: 'protein', child: Text('Protein %')),
              DropdownMenuItem(value: 'energy', child: Text('ME kcal/kg')),
              DropdownMenuItem(value: 'price', child: Text('Price')),
            ],
          ),
          IconButton(
            icon: Icon(_sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientGrid() {
    final ingredients = filteredIngredients;
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return _buildIngredientCard(ingredients[index]);
      },
    );
  }

  Widget _buildIngredientList() {
    final ingredients = filteredIngredients;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return _buildIngredientListTile(ingredients[index]);
      },
    );
  }

  Widget _buildIngredientCard(FeedIngredient ingredient) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showIngredientDetails(ingredient),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: _getCategoryColor(ingredient.category),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _getCategoryIcon(ingredient.category),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ingredient.commonName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                ingredient.name,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (ingredient.nutritionalProfile.crudeProtein != null)
                _buildNutrientRow('CP', '${ingredient.nutritionalProfile.crudeProtein!.toStringAsFixed(1)}%'),
              if (ingredient.nutritionalProfile.metabolizableEnergy != null)
                _buildNutrientRow('ME', '${ingredient.nutritionalProfile.metabolizableEnergy!.toInt()} kcal'),
              const SizedBox(height: 4),
              Text(
                '\$${ingredient.currentPrice.toStringAsFixed(0)}/${ingredient.unit}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientListTile(FeedIngredient ingredient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(ingredient.category),
          child: Text(
            _getCategoryIcon(ingredient.category),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(ingredient.commonName),
        subtitle: Text(ingredient.name),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${ingredient.currentPrice.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            Text(
              '/${ingredient.unit}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        onTap: () => _showIngredientDetails(ingredient),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsDashboard() {
    final allIngredients = IngredientDatabase.getAllIngredients();
    final categoryStats = <IngredientCategory, int>{};
    
    for (final ingredient in allIngredients) {
      categoryStats[ingredient.category] = (categoryStats[ingredient.category] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Database Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildStatsCard('Total Ingredients', allIngredients.length.toString()),
          const SizedBox(height: 16),
          _buildCategoryStatistics(categoryStats),
          const SizedBox(height: 20),
          _buildPriceRangeAnalysis(allIngredients),
          const SizedBox(height: 20),
          _buildNutritionalOverview(allIngredients),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green[700], size: 32),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryStatistics(Map<IngredientCategory, int> categoryStats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredients by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...categoryStats.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(entry.key),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          _getCategoryIcon(entry.key),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_getCategoryDisplayName(entry.key)),
                    ),
                    Text(
                      '${entry.value}',
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

  Widget _buildPriceRangeAnalysis(List<FeedIngredient> ingredients) {
    final prices = ingredients.map((i) => i.currentPrice).toList()..sort();
    final minPrice = prices.isNotEmpty ? prices.first : 0.0;
    final maxPrice = prices.isNotEmpty ? prices.last : 0.0;
    final avgPrice = prices.isNotEmpty 
        ? prices.reduce((a, b) => a + b) / prices.length 
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPriceStatCard('Min Price', '\$${minPrice.toStringAsFixed(0)}'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriceStatCard('Max Price', '\$${maxPrice.toStringAsFixed(0)}'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriceStatCard('Avg Price', '\$${avgPrice.toStringAsFixed(0)}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalOverview(List<FeedIngredient> ingredients) {
    final proteinIngredients = ingredients
        .where((i) => (i.nutritionalProfile.crudeProtein ?? 0) > 20)
        .length;
    final energyIngredients = ingredients
        .where((i) => (i.nutritionalProfile.metabolizableEnergy ?? 0) > 3000)
        .length;
    final fiberIngredients = ingredients
        .where((i) => (i.nutritionalProfile.ndf ?? 0) > 30)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutritional Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildNutritionalStat('High Protein (>20%)', proteinIngredients, Colors.red),
            _buildNutritionalStat('High Energy (>3000 kcal)', energyIngredients, Colors.orange),
            _buildNutritionalStat('High Fiber (>30% NDF)', fiberIngredients, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionalStat(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            '$count',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showIngredientDetails(FeedIngredient ingredient) {
    showDialog(
      context: context,
      builder: (context) => IngredientDetailDialog(ingredient: ingredient),
    );
  }

  String _getCategoryDisplayName(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.cereal_grains:
        return 'Cereal Grains';
      case IngredientCategory.protein_meals:
        return 'Protein Meals';
      case IngredientCategory.fats_oils:
        return 'Fats & Oils';
      case IngredientCategory.forages:
        return 'Forages';
      case IngredientCategory.by_products:
        return 'By-Products';
      case IngredientCategory.minerals:
        return 'Minerals';
      case IngredientCategory.vitamins:
        return 'Vitamins';
      case IngredientCategory.additives:
        return 'Additives';
      case IngredientCategory.premixes:
        return 'Premixes';
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
}

class IngredientDetailDialog extends StatelessWidget {
  final FeedIngredient ingredient;

  const IngredientDetailDialog({Key? key, required this.ingredient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(ingredient.category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCategoryIcon(ingredient.category),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.commonName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ingredient.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (ingredient.scientificName.isNotEmpty)
                        Text(
                          ingredient.scientificName,
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Nutrition'),
                        Tab(text: 'Amino Acids'),
                        Tab(text: 'Minerals'),
                        Tab(text: 'Details'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildNutritionTab(),
                          _buildAminoAcidsTab(),
                          _buildMineralsTab(),
                          _buildDetailsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionTab() {
    final nutrition = ingredient.nutritionalProfile;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildNutritionRow('Dry Matter', nutrition.dryMatter, '%'),
          _buildNutritionRow('Crude Protein', nutrition.crudeProtein, '%'),
          _buildNutritionRow('Digestible Protein', nutrition.digestibleProtein, '%'),
          _buildNutritionRow('Crude Fat', nutrition.crudeFat, '%'),
          _buildNutritionRow('Crude Starch', nutrition.crudeStarch, '%'),
          _buildNutritionRow('NDF', nutrition.ndf, '%'),
          _buildNutritionRow('ADF', nutrition.adf, '%'),
          _buildNutritionRow('Ash', nutrition.ash, '%'),
          _buildNutritionRow('TDN', nutrition.tdn, '%'),
          _buildNutritionRow('NFC', nutrition.nfc, '%'),
          const Divider(),
          _buildNutritionRow('Crude Energy', nutrition.crudeEnergy, 'kcal/kg'),
          _buildNutritionRow('Digestible Energy', nutrition.digestibleEnergy, 'kcal/kg'),
          _buildNutritionRow('Metabolizable Energy', nutrition.metabolizableEnergy, 'kcal/kg'),
          _buildNutritionRow('Net Energy', nutrition.netEnergy, 'kcal/kg'),
        ],
      ),
    );
  }

  Widget _buildAminoAcidsTab() {
    final aminoAcids = ingredient.nutritionalProfile.aminoAcids;
    if (aminoAcids == null) {
      return const Center(child: Text('No amino acid data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildNutritionRow('Lysine', aminoAcids.lysine, '%'),
          _buildNutritionRow('Methionine', aminoAcids.methionine, '%'),
          _buildNutritionRow('Cystine', aminoAcids.cystine, '%'),
          _buildNutritionRow('Threonine', aminoAcids.threonine, '%'),
          _buildNutritionRow('Tryptophan', aminoAcids.tryptophan, '%'),
          _buildNutritionRow('Arginine', aminoAcids.arginine, '%'),
          _buildNutritionRow('Leucine', aminoAcids.leucine, '%'),
          _buildNutritionRow('Isoleucine', aminoAcids.isoleucine, '%'),
          _buildNutritionRow('Valine', aminoAcids.valine, '%'),
          _buildNutritionRow('Phenylalanine', aminoAcids.phenylalanine, '%'),
          _buildNutritionRow('Histidine', aminoAcids.histidine, '%'),
        ],
      ),
    );
  }

  Widget _buildMineralsTab() {
    final minerals = ingredient.nutritionalProfile.minerals;
    if (minerals == null) {
      return const Center(child: Text('No mineral data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildNutritionRow('Calcium', minerals.calcium, '%'),
          _buildNutritionRow('Phosphorus', minerals.phosphorus, '%'),
          _buildNutritionRow('Available Phosphorus', minerals.availablePhosphorus, '%'),
          _buildNutritionRow('Potassium', minerals.potassium, '%'),
          _buildNutritionRow('Sodium', minerals.sodium, '%'),
          _buildNutritionRow('Magnesium', minerals.magnesium, '%'),
          _buildNutritionRow('Chloride', minerals.chloride, '%'),
          const Divider(),
          _buildNutritionRow('Iron', minerals.iron, 'mg/kg'),
          _buildNutritionRow('Zinc', minerals.zinc, 'mg/kg'),
          _buildNutritionRow('Copper', minerals.copper, 'mg/kg'),
          _buildNutritionRow('Manganese', minerals.manganese, 'mg/kg'),
          _buildNutritionRow('Selenium', minerals.selenium, 'mg/kg'),
          _buildNutritionRow('Iodine', minerals.iodine, 'mg/kg'),
          _buildNutritionRow('Cobalt', minerals.cobalt, 'mg/kg'),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Price', '\$${ingredient.currentPrice.toStringAsFixed(2)}/${ingredient.unit}'),
          _buildDetailRow('Availability Score', '${ingredient.availabilityScore.toStringAsFixed(0)}%'),
          _buildDetailRow('Palatability Score', '${ingredient.palatabilityScore.toStringAsFixed(0)}%'),
          _buildDetailRow('Digestibility Score', '${ingredient.digestibilityScore.toStringAsFixed(0)}%'),
          _buildDetailRow('Max Inclusion Rate', '${ingredient.maxInclusionRate.toStringAsFixed(1)}%'),
          _buildDetailRow('Processing Method', ingredient.processing.toString().split('.').last),
          const SizedBox(height: 16),
          const Text(
            'Suitable Species',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ingredient.suitableSpecies.map((species) {
              return Chip(label: Text(species));
            }).toList(),
          ),
          if (ingredient.restrictions.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Restrictions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...ingredient.restrictions.map((restriction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(restriction)),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 16),
          const Text(
            'Storage Requirements',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(ingredient.storageRequirements),
          const SizedBox(height: 16),
          _buildDetailRow('Shelf Life', '${ingredient.shelfLifeDays} days'),
          if (ingredient.certification != null)
            _buildDetailRow('Certification', ingredient.certification!),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, double? value, String unit) {
    if (value == null) return Container();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${value.toStringAsFixed(2)} $unit'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
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
}