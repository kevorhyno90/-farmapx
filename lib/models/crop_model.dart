enum CropStage { planning, planted, germinated, vegetative, flowering, maturity, harvested, failed }
enum CropHealth { excellent, good, fair, poor, critical }
enum CropType { grain, vegetable, fruit, forage, fiber, oil, sugar, spice, medicinal }

class CropActivity {
  final String id;
  final DateTime date;
  final String type; // planting, watering, fertilizing, spraying, weeding, harvesting
  final String description;
  final double? quantity;
  final String? unit;
  final double? cost;
  final String? employeeId;
  final String? notes;

  CropActivity({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    this.quantity,
    this.unit,
    this.cost,
    this.employeeId,
    this.notes,
  });
}

class PestActivity {
  final String id;
  final DateTime date;
  final String pestType; // insect, disease, weed
  final String pestName;
  final String severity; // low, medium, high, critical
  final String treatment;
  final String? pesticide;
  final double? quantity;
  final String? unit;
  final double? cost;
  final String? notes;

  PestActivity({
    required this.id,
    required this.date,
    required this.pestType,
    required this.pestName,
    required this.severity,
    required this.treatment,
    this.pesticide,
    this.quantity,
    this.unit,
    this.cost,
    this.notes,
  });
}

class HarvestRecord {
  final String id;
  final DateTime date;
  final double quantity;
  final String unit; // kg, tons, bags, etc.
  final String quality; // Grade A, B, C
  final double? pricePerUnit;
  final double? totalRevenue;
  final String? buyer;
  final String? storageLocation;
  final String? notes;

  HarvestRecord({
    required this.id,
    required this.date,
    required this.quantity,
    required this.unit,
    this.quality = '',
    this.pricePerUnit,
    this.totalRevenue,
    this.buyer,
    this.storageLocation,
    this.notes,
  });
}

class CropModel {
  final String id;
  final String fieldId;
  final String cropName;
  final String variety;
  final CropType cropType;
  final DateTime plantingDate;
  final DateTime? expectedHarvestDate;
  final DateTime? actualHarvestDate;
  final CropStage currentStage;
  final CropHealth health;
  final double areaPlanted; // in hectares
  final int plantPopulation; // plants per hectare
  final String seedSource;
  final double seedCost;
  final String plantingMethod; // direct seeding, transplanting, etc.
  final double rowSpacing; // in cm
  final double plantSpacing; // in cm
  final String irrigationMethod; // drip, sprinkler, flood, rain-fed
  final List<CropActivity> activities;
  final List<PestActivity> pestActivities;
  final List<HarvestRecord> harvestRecords;
  final String? notes;
  final bool isOrganic;
  final String? certificationBody;

  CropModel({
    required this.id,
    required this.fieldId,
    required this.cropName,
    this.variety = '',
    this.cropType = CropType.grain,
    required this.plantingDate,
    this.expectedHarvestDate,
    this.actualHarvestDate,
    this.currentStage = CropStage.planning,
    this.health = CropHealth.good,
    this.areaPlanted = 0.0,
    this.plantPopulation = 0,
    this.seedSource = '',
    this.seedCost = 0.0,
    this.plantingMethod = '',
    this.rowSpacing = 0.0,
    this.plantSpacing = 0.0,
    this.irrigationMethod = '',
    List<CropActivity>? activities,
    List<PestActivity>? pestActivities,
    List<HarvestRecord>? harvestRecords,
    this.notes,
    this.isOrganic = false,
    this.certificationBody,
  }) :
    activities = activities ?? [],
    pestActivities = pestActivities ?? [],
    harvestRecords = harvestRecords ?? [];

  // Calculated properties
  int get daysFromPlanting => DateTime.now().difference(plantingDate).inDays;

  int? get daysToHarvest {
    if (expectedHarvestDate == null) return null;
    final diff = expectedHarvestDate!.difference(DateTime.now()).inDays;
    return diff > 0 ? diff : 0;
  }

  double get totalHarvested {
    return harvestRecords.fold(0.0, (sum, record) => sum + record.quantity);
  }

  double get totalRevenue {
    return harvestRecords.fold(0.0, (sum, record) => sum + (record.totalRevenue ?? 0.0));
  }

  double get totalCosts {
    double activityCosts = activities.fold(0.0, (sum, activity) => sum + (activity.cost ?? 0.0));
    double pestCosts = pestActivities.fold(0.0, (sum, pest) => sum + (pest.cost ?? 0.0));
    return seedCost + activityCosts + pestCosts;
  }

  double get profitMargin => totalRevenue - totalCosts;

  double get yieldPerHectare {
    if (areaPlanted == 0) return 0.0;
    return totalHarvested / areaPlanted;
  }

  bool get isHarvested => currentStage == CropStage.harvested;
  bool get isActive => !isHarvested && currentStage != CropStage.failed;

  CropModel copyWith({
    String? fieldId,
    String? cropName,
    String? variety,
    CropType? cropType,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    DateTime? actualHarvestDate,
    CropStage? currentStage,
    CropHealth? health,
    double? areaPlanted,
    int? plantPopulation,
    String? seedSource,
    double? seedCost,
    String? plantingMethod,
    double? rowSpacing,
    double? plantSpacing,
    String? irrigationMethod,
    List<CropActivity>? activities,
    List<PestActivity>? pestActivities,
    List<HarvestRecord>? harvestRecords,
    String? notes,
    bool? isOrganic,
    String? certificationBody,
  }) {
    return CropModel(
      id: id,
      fieldId: fieldId ?? this.fieldId,
      cropName: cropName ?? this.cropName,
      variety: variety ?? this.variety,
      cropType: cropType ?? this.cropType,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      actualHarvestDate: actualHarvestDate ?? this.actualHarvestDate,
      currentStage: currentStage ?? this.currentStage,
      health: health ?? this.health,
      areaPlanted: areaPlanted ?? this.areaPlanted,
      plantPopulation: plantPopulation ?? this.plantPopulation,
      seedSource: seedSource ?? this.seedSource,
      seedCost: seedCost ?? this.seedCost,
      plantingMethod: plantingMethod ?? this.plantingMethod,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      plantSpacing: plantSpacing ?? this.plantSpacing,
      irrigationMethod: irrigationMethod ?? this.irrigationMethod,
      activities: activities ?? this.activities,
      pestActivities: pestActivities ?? this.pestActivities,
      harvestRecords: harvestRecords ?? this.harvestRecords,
      notes: notes ?? this.notes,
      isOrganic: isOrganic ?? this.isOrganic,
      certificationBody: certificationBody ?? this.certificationBody,
    );
  }
}
