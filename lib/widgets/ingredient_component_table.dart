import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/ingredient_database.dart';
import '../models/feed_ingredient.dart';

class IngredientComponentTable extends StatefulWidget {
  const IngredientComponentTable({super.key});

  @override
  State<IngredientComponentTable> createState() => _IngredientComponentTableState();
}

class _IngredientComponentTableState extends State<IngredientComponentTable> {
  List<FeedIngredient> _ingredients = [];
  List<FeedIngredient> _filteredIngredients = [];
  String _searchQuery = '';
  IngredientCategory? _selectedCategory;
  final Set<String> _selectedColumns = {
    'name',
    'crudeProtein',
    'metabolizableEnergy',
    'crudeFat',
    'crudeFiber',
    'calcium',
    'phosphorus',
    'price'
  };

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  void _loadIngredients() {
    _ingredients = IngredientDatabase.getAllIngredients();
    _filteredIngredients = _ingredients;
    setState(() {});
  }

  void _filterIngredients() {
    _filteredIngredients = _ingredients.where((ingredient) {
      final matchesSearch = ingredient.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ingredient.commonName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == null || ingredient.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Components Table'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.view_column),
            onPressed: _showColumnSelector,
            tooltip: 'Select Columns',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportData,
            tooltip: 'Export Data',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          _buildColumnHeaders(),
          Expanded(
            child: _buildDataTable(),
          ),
          _buildSummaryBar(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ingredients...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterIngredients();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<IngredientCategory?>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem<IngredientCategory?>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ...IngredientCategory.values.map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryName(category)),
                    )),
                  ],
                  onChanged: (value) {
                    _selectedCategory = value;
                    _filterIngredients();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_filteredIngredients.length} of ${_ingredients.length} ingredients shown',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeaders() {
    return Container(
      height: 40,
      color: Colors.green.shade100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _getVisibleColumns().map((column) => _buildColumnHeader(column)).toList(),
        ),
      ),
    );
  }

  Widget _buildColumnHeader(String column) {
    return Container(
      width: _getColumnWidth(column),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        _getColumnDisplayName(column),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      child: Column(
        children: _filteredIngredients.map((ingredient) => _buildIngredientRow(ingredient)).toList(),
      ),
    );
  }

  Widget _buildIngredientRow(FeedIngredient ingredient) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _getVisibleColumns().map((column) => _buildDataCell(ingredient, column)).toList(),
        ),
      ),
    );
  }

  Widget _buildDataCell(FeedIngredient ingredient, String column) {
    final value = _getCellValue(ingredient, column);
    final color = _getCellColor(column, value);
    
    return Container(
      width: _getColumnWidth(column),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 11,
          fontWeight: column == 'name' ? FontWeight.w500 : FontWeight.normal,
        ),
        textAlign: column == 'name' ? TextAlign.left : TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSummaryBar() {
    final avgProtein = _filteredIngredients.isNotEmpty 
        ? _filteredIngredients.map((i) => i.nutritionalProfile.crudeProtein).reduce((a, b) => a + b) / _filteredIngredients.length
        : 0.0;
    
    final avgEnergy = _filteredIngredients.isNotEmpty 
        ? _filteredIngredients.map((i) => i.nutritionalProfile.metabolizableEnergy).reduce((a, b) => a + b) / _filteredIngredients.length
        : 0.0;
    
    final avgPrice = _filteredIngredients.isNotEmpty 
        ? _filteredIngredients.map((i) => i.currentPrice).reduce((a, b) => a + b) / _filteredIngredients.length
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.green.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Avg Protein', '${avgProtein.toStringAsFixed(1)}%'),
          _buildSummaryItem('Avg ME', '${avgEnergy.toStringAsFixed(0)} kcal/kg'),
          _buildSummaryItem('Avg Price', '\$${avgPrice.toStringAsFixed(0)}/ton'),
          _buildSummaryItem('Total Items', '${_filteredIngredients.length}'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
      ],
    );
  }

  List<String> _getVisibleColumns() {
    final allColumns = [
      'name', 'category', 'crudeProtein', 'digestibleProtein', 'metabolizableEnergy',
      'digestibleEnergy', 'crudeFat', 'ndf', 'adf', 'crudeFiber', 'ash',
      'calcium', 'phosphorus', 'magnesium', 'potassium', 'sodium',
      'lysine', 'methionine', 'threonine', 'price', 'availability'
    ];
    return allColumns.where((col) => _selectedColumns.contains(col)).toList();
  }

  double _getColumnWidth(String column) {
    switch (column) {
      case 'name':
        return 180;
      case 'category':
        return 120;
      case 'price':
        return 80;
      case 'availability':
        return 80;
      default:
        return 70;
    }
  }

  String _getColumnDisplayName(String column) {
    final names = {
      'name': 'Ingredient Name',
      'category': 'Category',
      'crudeProtein': 'CP %',
      'digestibleProtein': 'DP %',
      'metabolizableEnergy': 'ME kcal/kg',
      'digestibleEnergy': 'DE kcal/kg',
      'crudeFat': 'Fat %',
      'ndf': 'NDF %',
      'adf': 'ADF %',
      'crudeFiber': 'CF %',
      'ash': 'Ash %',
      'calcium': 'Ca %',
      'phosphorus': 'P %',
      'magnesium': 'Mg %',
      'potassium': 'K %',
      'sodium': 'Na %',
      'lysine': 'Lys %',
      'methionine': 'Met %',
      'threonine': 'Thr %',
      'price': 'Price \$/t',
      'availability': 'Avail %',
    };
    return names[column] ?? column;
  }

  String _getCellValue(FeedIngredient ingredient, String column) {
    switch (column) {
      case 'name':
        return ingredient.name;
      case 'category':
        return _getCategoryName(ingredient.category);
      case 'crudeProtein':
        return ingredient.nutritionalProfile.crudeProtein.toStringAsFixed(1);
      case 'digestibleProtein':
        final dp = ingredient.nutritionalProfile.digestibleProtein;
        return dp == null ? '-' : dp.toStringAsFixed(1);
      case 'metabolizableEnergy':
        return ingredient.nutritionalProfile.metabolizableEnergy.toStringAsFixed(0);
      case 'digestibleEnergy':
        final de = ingredient.nutritionalProfile.digestibleEnergy;
        return de == null ? '-' : de.toStringAsFixed(0);
      case 'crudeFat':
        return ingredient.nutritionalProfile.crudeFat.toStringAsFixed(1);
      case 'ndf':
        final ndfVal = ingredient.nutritionalProfile.ndf;
        return ndfVal == null ? '-' : ndfVal.toStringAsFixed(1);
      case 'adf':
        final adfVal = ingredient.nutritionalProfile.adf;
        return adfVal == null ? '-' : adfVal.toStringAsFixed(1);
      case 'crudeFiber':
        final cf = ingredient.nutritionalProfile.adf;
        return cf == null ? '-' : cf.toStringAsFixed(1);
      case 'ash':
        return ingredient.nutritionalProfile.ash.toStringAsFixed(1);
      case 'calcium':
        return ingredient.nutritionalProfile.minerals.calcium.toStringAsFixed(2);
      case 'phosphorus':
        return ingredient.nutritionalProfile.minerals.phosphorus.toStringAsFixed(2);
      case 'magnesium':
        return ingredient.nutritionalProfile.minerals.magnesium.toStringAsFixed(2);
      case 'potassium':
        return ingredient.nutritionalProfile.minerals.potassium.toStringAsFixed(2);
      case 'sodium':
        return ingredient.nutritionalProfile.minerals.sodium.toStringAsFixed(2);
      case 'lysine':
        final lys = ingredient.nutritionalProfile.aminoAcids?.lysine;
        return lys == null ? '-' : lys.toStringAsFixed(2);
      case 'methionine':
        final met = ingredient.nutritionalProfile.aminoAcids?.methionine;
        return met == null ? '-' : met.toStringAsFixed(2);
      case 'threonine':
        final thr = ingredient.nutritionalProfile.aminoAcids?.threonine;
        return thr == null ? '-' : thr.toStringAsFixed(2);
      case 'price':
        return ingredient.currentPrice.toStringAsFixed(0);
      case 'availability':
        return ingredient.availabilityScore.toStringAsFixed(0);
      default:
        return '-';
    }
  }

  Color? _getCellColor(String column, String value) {
    if (value == '-') return Colors.grey.shade100;
    
    try {
      final numValue = double.parse(value);
      switch (column) {
        case 'crudeProtein':
          if (numValue > 25) return Colors.green.shade100;
          if (numValue > 15) return Colors.yellow.shade100;
          return Colors.red.shade100;
        case 'metabolizableEnergy':
          if (numValue > 3000) return Colors.green.shade100;
          if (numValue > 2500) return Colors.yellow.shade100;
          return Colors.red.shade100;
        case 'availability':
          if (numValue > 80) return Colors.green.shade100;
          if (numValue > 60) return Colors.yellow.shade100;
          return Colors.red.shade100;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  String _getCategoryName(IngredientCategory category) {
    switch (category) {
      case IngredientCategory.cereal_grains:
        return 'Grains';
      case IngredientCategory.protein_meals:
        return 'Protein';
      case IngredientCategory.forages:
        return 'Forages';
      case IngredientCategory.fats_oils:
        return 'Fats';
      case IngredientCategory.minerals:
        return 'Minerals';
      case IngredientCategory.vitamins:
        return 'Vitamins';
      case IngredientCategory.additives:
        return 'Additives';
      case IngredientCategory.by_products:
        return 'By-products';
      case IngredientCategory.premixes:
        return 'Premixes';
    }
  }

  void _showColumnSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Columns to Display'),
        content: StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 300,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  'name', 'category', 'crudeProtein', 'digestibleProtein', 'metabolizableEnergy',
                  'digestibleEnergy', 'crudeFat', 'ndf', 'adf', 'crudeFiber', 'ash',
                  'calcium', 'phosphorus', 'magnesium', 'potassium', 'sodium',
                  'lysine', 'methionine', 'threonine', 'price', 'availability'
                ].map((column) => CheckboxListTile(
                  title: Text(_getColumnDisplayName(column)),
                  value: _selectedColumns.contains(column),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedColumns.add(column);
                      } else {
                        _selectedColumns.remove(column);
                      }
                    });
                  },
                )).toList(),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    final csvData = _generateCSV();
    Clipboard.setData(ClipboardData(text: csvData));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data copied to clipboard as CSV'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _generateCSV() {
    final headers = _getVisibleColumns().map(_getColumnDisplayName).join(',');
    final rows = _filteredIngredients.map((ingredient) {
      return _getVisibleColumns().map((column) => _getCellValue(ingredient, column)).join(',');
    }).join('\n');
    return '$headers\n$rows';
  }
}