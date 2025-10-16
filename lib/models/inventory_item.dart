enum InventoryCategory {
  feed, seeds, fertilizer, pesticides, equipment, medical, fuel, packaging, office, maintenance, tools
}

enum InventoryStatus { in_stock, low_stock, out_of_stock, expired, damaged }

class InventoryTransaction {
  final String id;
  final DateTime date;
  final String type; // purchase, sale, usage, adjustment, waste, transfer
  final double quantity;
  final double? unitCost;
  final String? supplierId;
  final String? reference; // invoice, order number
  final String? notes;
  final String? employeeId;

  InventoryTransaction({
    required this.id,
    required this.date,
    required this.type,
    required this.quantity,
    this.unitCost,
    this.supplierId,
    this.reference,
    this.notes,
    this.employeeId,
  });
}

class InventoryItem {
  final String id;
  final String name;
  final String sku;
  final String barcode;
  final InventoryCategory category;
  final String subcategory;
  final String unit;
  final double quantity;
  final double minStockLevel;
  final double maxStockLevel;
  final double reorderPoint;
  final double reorderQuantity;
  final String? preferredSupplierId;
  final double lastPurchasePrice;
  final DateTime? lastPurchaseDate;
  final DateTime? expiryDate;
  final String? batchNumber;
  final String storageLocation;
  final String? storageConditions; // temperature, humidity requirements
  final List<InventoryTransaction> transactions;
  final String? description;
  final String? manufacturer;
  final String? safetyInstructions;
  final bool isActive;
  final bool trackBatches;
  final bool trackExpiry;

  InventoryItem({
    required this.id,
    required this.name,
    this.sku = '',
    this.barcode = '',
    this.category = InventoryCategory.feed,
    this.subcategory = '',
    this.unit = '',
    this.quantity = 0,
    this.minStockLevel = 0,
    this.maxStockLevel = 0,
    this.reorderPoint = 0,
    this.reorderQuantity = 0,
    this.preferredSupplierId,
    this.lastPurchasePrice = 0,
    this.lastPurchaseDate,
    this.expiryDate,
    this.batchNumber,
    this.storageLocation = '',
    this.storageConditions,
    List<InventoryTransaction>? transactions,
    this.description,
    this.manufacturer,
    this.safetyInstructions,
    this.isActive = true,
    this.trackBatches = false,
    this.trackExpiry = false,
  }) : transactions = transactions ?? [];

  // Calculated properties
  InventoryStatus get status {
    if (!isActive) return InventoryStatus.damaged;
    if (quantity <= 0) return InventoryStatus.out_of_stock;
    if (quantity <= reorderPoint) return InventoryStatus.low_stock;
    
    // Check expiry
    if (trackExpiry && expiryDate != null) {
      final daysToExpiry = expiryDate!.difference(DateTime.now()).inDays;
      if (daysToExpiry <= 0) return InventoryStatus.expired;
      if (daysToExpiry <= 30) return InventoryStatus.low_stock; // Expiring soon
    }
    
    return InventoryStatus.in_stock;
  }

  bool get needsReorder => quantity <= reorderPoint;
  
  int? get daysToExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  bool get isExpired => daysToExpiry != null && daysToExpiry! <= 0;
  bool get isExpiringSoon => daysToExpiry != null && daysToExpiry! <= 30 && daysToExpiry! > 0;

  double get averageCost {
    final purchases = transactions.where((t) => 
      t.type == 'purchase' && t.unitCost != null).toList();
    
    if (purchases.isEmpty) return lastPurchasePrice;
    
    final totalCost = purchases.fold(0.0, (sum, t) => sum + (t.unitCost! * t.quantity));
    final totalQuantity = purchases.fold(0.0, (sum, t) => sum + t.quantity);
    
    return totalQuantity > 0 ? totalCost / totalQuantity : lastPurchasePrice;
  }

  double get currentValue => quantity * averageCost;

  double get monthlyUsage {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    final usageTransactions = transactions.where((t) =>
      (t.type == 'usage' || t.type == 'sale') &&
      t.date.isAfter(thirtyDaysAgo)).toList();
    
    return usageTransactions.fold(0.0, (sum, t) => sum + t.quantity);
  }

  InventoryItem copyWith({
    String? name,
    String? sku,
    String? barcode,
    InventoryCategory? category,
    String? subcategory,
    String? unit,
    double? quantity,
    double? minStockLevel,
    double? maxStockLevel,
    double? reorderPoint,
    double? reorderQuantity,
    String? preferredSupplierId,
    double? lastPurchasePrice,
    DateTime? lastPurchaseDate,
    DateTime? expiryDate,
    String? batchNumber,
    String? storageLocation,
    String? storageConditions,
    List<InventoryTransaction>? transactions,
    String? description,
    String? manufacturer,
    String? safetyInstructions,
    bool? isActive,
    bool? trackBatches,
    bool? trackExpiry,
  }) {
    return InventoryItem(
      id: id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      maxStockLevel: maxStockLevel ?? this.maxStockLevel,
      reorderPoint: reorderPoint ?? this.reorderPoint,
      reorderQuantity: reorderQuantity ?? this.reorderQuantity,
      preferredSupplierId: preferredSupplierId ?? this.preferredSupplierId,
      lastPurchasePrice: lastPurchasePrice ?? this.lastPurchasePrice,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNumber: batchNumber ?? this.batchNumber,
      storageLocation: storageLocation ?? this.storageLocation,
      storageConditions: storageConditions ?? this.storageConditions,
      transactions: transactions ?? this.transactions,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      safetyInstructions: safetyInstructions ?? this.safetyInstructions,
      isActive: isActive ?? this.isActive,
      trackBatches: trackBatches ?? this.trackBatches,
      trackExpiry: trackExpiry ?? this.trackExpiry,
    );
  }
}
