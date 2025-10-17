// Comprehensive Feed Formulation System - Similar to Rumen 8
enum AnimalSpecies { cattle, swine, poultry, sheep, goats, horses, fish, rabbits }
enum ProductionStage { starter, grower, finisher, lactating, dry, breeding, maintenance }
enum FeedForm { mash, pellet, crumble, liquid, block, cake }
enum IngredientType { cereal, protein, fat, mineral, vitamin, additive, roughage, byproduct }
enum ProcessingMethod { none, grinding, pelleting, extrusion, flaking, steaming }

class NutritionalProfile {
  final double dryMatter; // %
  final double crudeProtein; // %
  final double crudefiber; // %
  final double etherExtract; // % (fat)
  final double ash; // %
  final double nitrogen; // %
  final double phosphorus; // %
  final double calcium; // %
  final double potassium; // %
  final double sodium; // %
  final double magnesium; // %
  final double sulfur; // %
  final double iron; // ppm
  final double zinc; // ppm
  final double copper; // ppm
  final double manganese; // ppm
  final double selenium; // ppm
  final double iodine; // ppm
  final double cobalt; // ppm
  final double vitaminA; // IU/kg
  final double vitaminD; // IU/kg
  final double vitaminE; // IU/kg
  final double vitaminK; // mg/kg
  final double thiamine; // mg/kg (B1)
  final double riboflavin; // mg/kg (B2)
  final double niacin; // mg/kg (B3)
  final double pantothenicAcid; // mg/kg (B5)
  final double pyridoxine; // mg/kg (B6)
  final double biotin; // mg/kg (B7)
  final double folicAcid; // mg/kg (B9)
  final double cobalamin; // mg/kg (B12)
  final double vitaminC; // mg/kg
  final double choline; // mg/kg
  final double metabolizableEnergy; // kcal/kg
  final double netEnergy; // kcal/kg
  final double digestibleEnergy; // kcal/kg
  final double tdn; // % Total Digestible Nutrients
  final double ndf; // % Neutral Detergent Fiber
  final double adf; // % Acid Detergent Fiber
  final double lignin; // %
  final double starch; // %
  final double sugar; // %
  final double lysine; // %
  final double methionine; // %
  final double cystine; // %
  final double threonine; // %
  final double tryptophan; // %
  final double arginine; // %
  final double histidine; // %
  final double isoleucine; // %
  final double leucine; // %
  final double phenylalanine; // %
  final double tyrosine; // %
  final double valine; // %

  const NutritionalProfile({
    this.dryMatter = 0.0,
    this.crudeProtein = 0.0,
    this.crudefiber = 0.0,
    this.etherExtract = 0.0,
    this.ash = 0.0,
    this.nitrogen = 0.0,
    this.phosphorus = 0.0,
    this.calcium = 0.0,
    this.potassium = 0.0,
    this.sodium = 0.0,
    this.magnesium = 0.0,
    this.sulfur = 0.0,
    this.iron = 0.0,
    this.zinc = 0.0,
    this.copper = 0.0,
    this.manganese = 0.0,
    this.selenium = 0.0,
    this.iodine = 0.0,
    this.cobalt = 0.0,
    this.vitaminA = 0.0,
    this.vitaminD = 0.0,
    this.vitaminE = 0.0,
    this.vitaminK = 0.0,
    this.thiamine = 0.0,
    this.riboflavin = 0.0,
    this.niacin = 0.0,
    this.pantothenicAcid = 0.0,
    this.pyridoxine = 0.0,
    this.biotin = 0.0,
    this.folicAcid = 0.0,
    this.cobalamin = 0.0,
    this.vitaminC = 0.0,
    this.choline = 0.0,
    this.metabolizableEnergy = 0.0,
    this.netEnergy = 0.0,
    this.digestibleEnergy = 0.0,
    this.tdn = 0.0,
    this.ndf = 0.0,
    this.adf = 0.0,
    this.lignin = 0.0,
    this.starch = 0.0,
    this.sugar = 0.0,
    this.lysine = 0.0,
    this.methionine = 0.0,
    this.cystine = 0.0,
    this.threonine = 0.0,
    this.tryptophan = 0.0,
    this.arginine = 0.0,
    this.histidine = 0.0,
    this.isoleucine = 0.0,
    this.leucine = 0.0,
    this.phenylalanine = 0.0,
    this.tyrosine = 0.0,
    this.valine = 0.0,
  });

  // Calculate amino acid balance score
  double get aminoAcidScore {
    final essentialAA = [lysine, methionine, threonine, tryptophan, arginine, histidine, isoleucine, leucine, phenylalanine, valine];
    return essentialAA.fold(0.0, (sum, aa) => sum + aa) / essentialAA.length;
  }

  // Calculate protein quality index
  double get proteinQualityIndex {
    if (crudeProtein == 0) return 0.0;
    return (aminoAcidScore * 100) / crudeProtein;
  }
}

class AntiNutritionalFactors {
  final double tannins; // %
  final double phytates; // %
  final double trypsinInhibitor; // TIU/mg
  final double lectins; // HU/mg
  final double aflatoxins; // ppb
  final double gossypol; // ppm
  final double glucosinolates; // µmol/g
  final double alkaloids; // %
  final double saponins; // %
  final double oxalates; // %

  const AntiNutritionalFactors({
    this.tannins = 0.0,
    this.phytates = 0.0,
    this.trypsinInhibitor = 0.0,
    this.lectins = 0.0,
    this.aflatoxins = 0.0,
    this.gossypol = 0.0,
    this.glucosinolates = 0.0,
    this.alkaloids = 0.0,
    this.saponins = 0.0,
    this.oxalates = 0.0,
  });

  // Calculate safety index (0-100, higher is safer)
  double get safetyIndex {
    double penalty = 0.0;
    if (aflatoxins > 20) penalty += 30; // Critical
    if (gossypol > 100) penalty += 20;
    if (tannins > 5) penalty += 15;
    if (phytates > 3) penalty += 10;
    if (trypsinInhibitor > 10) penalty += 15;
    if (glucosinolates > 30) penalty += 10;
    return (100 - penalty).clamp(0, 100);
  }
}

class FeedIngredient {
  final String id;
  final String name;
  final String commonName;
  final String scientificName;
  final IngredientType type;
  final NutritionalProfile nutrition;
  final AntiNutritionalFactors antiNutritionals;
  final double costPerKg;
  final double bulkDensity; // kg/m³
  final double moistureContent; // %
  final bool organic;
  final bool gmoFree;
  final String origin; // Country/region
  final String supplier;
  final DateTime? expiryDate;
  final double palatabilityIndex; // 0-100
  final double digestibilityCoefficient; // 0-1
  final ProcessingMethod processingRequired;
  final List<String> compatibleSpecies;
  final double minimumInclusion; // %
  final double maximumInclusion; // %
  final String storageRequirements;
  final List<String> nutritionalBenefits;
  final List<String> limitations;
  final Map<String, double> seasonalPriceVariation;

  // Legacy compatibility
  double get amount => 0.0;

  const FeedIngredient({
    required this.id,
    required this.name,
    this.commonName = '',
    this.scientificName = '',
    this.type = IngredientType.cereal,
    this.nutrition = const NutritionalProfile(),
    this.antiNutritionals = const AntiNutritionalFactors(),
    this.costPerKg = 0.0,
    this.bulkDensity = 0.0,
    this.moistureContent = 0.0,
    this.organic = false,
    this.gmoFree = false,
    this.origin = '',
    this.supplier = '',
    this.expiryDate,
    this.palatabilityIndex = 100.0,
    this.digestibilityCoefficient = 1.0,
    this.processingRequired = ProcessingMethod.none,
    this.compatibleSpecies = const [],
    this.minimumInclusion = 0.0,
    this.maximumInclusion = 100.0,
    this.storageRequirements = '',
    this.nutritionalBenefits = const [],
    this.limitations = const [],
    this.seasonalPriceVariation = const {},
  });

  // Legacy compatibility methods
  Map<String, dynamic> toJson() => {
    'name': name,
    'percent': amount,
    'id': id,
    'type': type.name,
    'costPerKg': costPerKg,
  };

  static FeedIngredient fromJson(Map<String, dynamic> m) => FeedIngredient(
    id: m['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    name: (m['name'] as String?) ?? '',
    costPerKg: (m['costPerKg'] as num?)?.toDouble() ?? 0.0,
  );

  // Calculate effective cost considering palatability and digestibility
  double get effectiveCost {
    return costPerKg / (palatabilityIndex / 100 * digestibilityCoefficient);
  }

  // Check if ingredient is suitable for species
  bool isSuitableFor(AnimalSpecies species) {
    if (compatibleSpecies.isEmpty) return true;
    return compatibleSpecies.contains(species.name);
  }
}

class NutritionalRequirements {
  final AnimalSpecies species;
  final ProductionStage stage;
  final double bodyWeight; // kg
  final double dailyGain; // kg/day
  final double milkYield; // kg/day for lactating
  final double fatContent; // % milk fat
  final double proteinContent; // % milk protein
  final Map<String, double> requirements; // nutrient -> amount

  const NutritionalRequirements({
    required this.species,
    required this.stage,
    this.bodyWeight = 0.0,
    this.dailyGain = 0.0,
    this.milkYield = 0.0,
    this.fatContent = 0.0,
    this.proteinContent = 0.0,
    this.requirements = const {},
  });

  // Get requirement for specific nutrient
  double getRequirement(String nutrient) {
    return requirements[nutrient] ?? 0.0;
  }

  // Calculate energy requirements based on production
  double get energyRequirement {
    double maintenance = bodyWeight * 1.4; // Base maintenance ME (MJ/day)
    double growth = dailyGain * 20; // Growth energy
    double lactation = milkYield * 5.0; // Lactation energy
    return maintenance + growth + lactation;
  }
}

class FormulationConstraint {
  final String nutrient;
  final double minimum;
  final double maximum;
  final String unit;
  final int priority; // 1-10, 10 being highest priority

  const FormulationConstraint({
    required this.nutrient,
    this.minimum = 0.0,
    this.maximum = double.infinity,
    this.unit = '%',
    this.priority = 5,
  });
}

class FormulaIngredient {
  final String ingredientId;
  final double percentage;
  final double cost;
  final bool locked; // Cannot be changed by optimizer

  const FormulaIngredient({
    required this.ingredientId,
    required this.percentage,
    this.cost = 0.0,
    this.locked = false,
  });
}

class FeedFormulation {
  final String id;
  final String name;
  final String description;
  final AnimalSpecies targetSpecies;
  final ProductionStage targetStage;
  final FeedForm form;
  final List<FormulaIngredient> ingredients;
  final List<FormulationConstraint> constraints;
  final NutritionalRequirements requirements;
  final double targetCost;
  final DateTime createdDate;
  final DateTime? lastModified;
  final String formulatedBy;
  final bool approved;
  final String approvedBy;
  final DateTime? approvalDate;
  final String batchNumber;
  final double batchSize; // kg
  final Map<String, double> calculatedNutrition;
  final double totalCost;
  final double costPerKg;
  final int qualityScore; // 0-100
  final List<String> warnings;
  final List<String> recommendations;
  final String notes;

  // Legacy compatibility
  double get crudeProteinTarget => calculatedNutrition['crudeProtein'] ?? 0.0;
  double get metabolisableEnergyTarget => calculatedNutrition['metabolizableEnergy'] ?? 0.0;

  FeedFormulation({
    required this.id,
    required this.name,
    this.description = '',
    this.targetSpecies = AnimalSpecies.cattle,
    this.targetStage = ProductionStage.grower,
    this.form = FeedForm.mash,
    this.ingredients = const [],
    this.constraints = const [],
    this.requirements = const NutritionalRequirements(
      species: AnimalSpecies.cattle,
      stage: ProductionStage.grower,
    ),
    this.targetCost = 0.0,
    DateTime? createdDate,
    this.lastModified,
    this.formulatedBy = '',
    this.approved = false,
    this.approvedBy = '',
    this.approvalDate,
    this.batchNumber = '',
    this.batchSize = 0.0,
    this.calculatedNutrition = const {},
    this.totalCost = 0.0,
    this.costPerKg = 0.0,
    this.qualityScore = 0,
    this.warnings = const [],
    this.recommendations = const [],
    this.notes = '',
  }) : createdDate = createdDate ?? DateTime.now();

  // Calculate nutritional profile of the complete formula
  NutritionalProfile calculateNutritionalProfile(Map<String, FeedIngredient> ingredientDatabase) {
    if (ingredients.isEmpty) return const NutritionalProfile();

    double totalPercentage = ingredients.fold(0.0, (sum, ing) => sum + ing.percentage);
    if (totalPercentage == 0) return const NutritionalProfile();

    double crudeProtein = 0.0, crudefiber = 0.0, etherExtract = 0.0;
    double calcium = 0.0, phosphorus = 0.0, lysine = 0.0, methionine = 0.0;
    double metabolizableEnergy = 0.0;

    for (final ingredient in ingredients) {
      final feedIngredient = ingredientDatabase[ingredient.ingredientId];
      if (feedIngredient != null) {
        final weight = ingredient.percentage / 100;
        crudeProtein += feedIngredient.nutrition.crudeProtein * weight;
        crudefiber += feedIngredient.nutrition.crudefiber * weight;
        etherExtract += feedIngredient.nutrition.etherExtract * weight;
        calcium += feedIngredient.nutrition.calcium * weight;
        phosphorus += feedIngredient.nutrition.phosphorus * weight;
        lysine += feedIngredient.nutrition.lysine * weight;
        methionine += feedIngredient.nutrition.methionine * weight;
        metabolizableEnergy += feedIngredient.nutrition.metabolizableEnergy * weight;
      }
    }

    return NutritionalProfile(
      crudeProtein: crudeProtein,
      crudefiber: crudefiber,
      etherExtract: etherExtract,
      calcium: calcium,
      phosphorus: phosphorus,
      lysine: lysine,
      methionine: methionine,
      metabolizableEnergy: metabolizableEnergy,
    );
  }

  // Check if formulation meets all constraints
  bool meetsConstraints(Map<String, FeedIngredient> ingredientDatabase) {
    final nutrition = calculateNutritionalProfile(ingredientDatabase);
    
    for (final constraint in constraints) {
      double value = 0.0;
      switch (constraint.nutrient.toLowerCase()) {
        case 'protein':
        case 'crudeprotein':
          value = nutrition.crudeProtein;
          break;
        case 'fiber':
        case 'crudefiber':
          value = nutrition.crudefiber;
          break;
        case 'fat':
        case 'etherextract':
          value = nutrition.etherExtract;
          break;
        case 'calcium':
          value = nutrition.calcium;
          break;
        case 'phosphorus':
          value = nutrition.phosphorus;
          break;
        case 'lysine':
          value = nutrition.lysine;
          break;
        case 'methionine':
          value = nutrition.methionine;
          break;
        case 'energy':
        case 'metabolizableenergy':
          value = nutrition.metabolizableEnergy;
          break;
      }
      
      if (value < constraint.minimum || value > constraint.maximum) {
        return false;
      }
    }
    
    return true;
  }

  // Calculate formulation quality score
  int calculateQualityScore(Map<String, FeedIngredient> ingredientDatabase) {
    int score = 100;
    
    // Check constraint compliance
    if (!meetsConstraints(ingredientDatabase)) score -= 30;
    
    // Check ingredient percentages sum to 100
    double totalPercentage = ingredients.fold(0.0, (sum, ing) => sum + ing.percentage);
    if ((totalPercentage - 100.0).abs() > 1.0) score -= 20;
    
    // Check for ingredient compatibility
    for (final ingredient in ingredients) {
      final feedIngredient = ingredientDatabase[ingredient.ingredientId];
      if (feedIngredient != null) {
        if (!feedIngredient.isSuitableFor(targetSpecies)) score -= 15;
        if (ingredient.percentage < feedIngredient.minimumInclusion) score -= 10;
        if (ingredient.percentage > feedIngredient.maximumInclusion) score -= 10;
        if (feedIngredient.antiNutritionals.safetyIndex < 70) score -= 5;
      }
    }
    
    return score.clamp(0, 100);
  }

  // Generate feed tag/label
  Map<String, dynamic> generateFeedTag(Map<String, FeedIngredient> ingredientDatabase) {
    final nutrition = calculateNutritionalProfile(ingredientDatabase);
    
    return {
      'feedName': name,
      'species': targetSpecies.name,
      'stage': targetStage.name,
      'form': form.name,
      'crudeProtein': nutrition.crudeProtein.toStringAsFixed(1),
      'crudefiber': nutrition.crudefiber.toStringAsFixed(1),
      'fat': nutrition.etherExtract.toStringAsFixed(1),
      'calcium': nutrition.calcium.toStringAsFixed(2),
      'phosphorus': nutrition.phosphorus.toStringAsFixed(2),
      'metabolizableEnergy': nutrition.metabolizableEnergy.toStringAsFixed(0),
      'batchNumber': batchNumber,
      'manufacturingDate': DateTime.now().toIso8601String().split('T')[0],
      'expiryDate': DateTime.now().add(const Duration(days: 180)).toIso8601String().split('T')[0],
      'ingredients': ingredients.map((ing) {
        final feedIng = ingredientDatabase[ing.ingredientId];
        return '${feedIng?.name ?? ing.ingredientId} (${ing.percentage.toStringAsFixed(1)}%)';
      }).join(', '),
    };
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'targetSpecies': targetSpecies.name,
    'targetStage': targetStage.name,
    'form': form.name,
    'ingredients': ingredients.map((ing) => {
      'ingredientId': ing.ingredientId,
      'percentage': ing.percentage,
    }).toList(),
    'targetCost': targetCost,
    'createdDate': createdDate.toIso8601String(),
    'lastModified': lastModified?.toIso8601String(),
    'formulatedBy': formulatedBy,
    'approved': approved,
    'approvedBy': approvedBy,
    'approvalDate': approvalDate?.toIso8601String(),
    'batchNumber': batchNumber,
    'batchSize': batchSize,
    'calculatedNutrition': calculatedNutrition,
    'totalCost': totalCost,
    'costPerKg': costPerKg,
    'qualityScore': qualityScore,
    'warnings': warnings,
    'recommendations': recommendations,
    'notes': notes,
  };

  static FeedFormulation fromJson(Map<String, dynamic> json) => FeedFormulation(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    targetSpecies: AnimalSpecies.values.firstWhere(
      (species) => species.name == json['targetSpecies'], 
      orElse: () => AnimalSpecies.cattle
    ),
    targetStage: ProductionStage.values.firstWhere(
      (stage) => stage.name == json['targetStage'], 
      orElse: () => ProductionStage.grower
    ),
    form: FeedForm.values.firstWhere(
      (form) => form.name == json['form'], 
      orElse: () => FeedForm.mash
    ),
    ingredients: (json['ingredients'] as List<dynamic>?)
        ?.map((ingJson) => FormulaIngredient(
              ingredientId: ingJson['ingredientId'] ?? '',
              percentage: (ingJson['percentage'] as num?)?.toDouble() ?? 0.0,
            ))
        .toList() ?? [],
    targetCost: (json['targetCost'] as num?)?.toDouble() ?? 0.0,
    createdDate: json['createdDate'] != null 
        ? DateTime.parse(json['createdDate']) 
        : DateTime.now(),
    lastModified: json['lastModified'] != null 
        ? DateTime.parse(json['lastModified']) 
        : null,
    formulatedBy: json['formulatedBy'] ?? '',
    approved: json['approved'] ?? false,
    approvedBy: json['approvedBy'] ?? '',
    approvalDate: json['approvalDate'] != null 
        ? DateTime.parse(json['approvalDate']) 
        : null,
    batchNumber: json['batchNumber'] ?? '',
    batchSize: (json['batchSize'] as num?)?.toDouble() ?? 0.0,
    calculatedNutrition: Map<String, double>.from(json['calculatedNutrition'] ?? {}),
    totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
    costPerKg: (json['costPerKg'] as num?)?.toDouble() ?? 0.0,
    qualityScore: json['qualityScore'] ?? 0,
    warnings: List<String>.from(json['warnings'] ?? []),
    recommendations: List<String>.from(json['recommendations'] ?? []),
    notes: json['notes'] ?? '',
  );
}
