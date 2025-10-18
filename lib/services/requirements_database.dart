import '../models/nutritional_requirements.dart';

class RequirementsDatabase {
  static final Map<String, AnimalRequirements> _requirements = {};
  
  static void initialize() {
    _initializePoultryRequirements();
    _initializeSwineRequirements();
    _initializeCattleRequirements();
    _initializeSheepGoatRequirements();
  }

  static List<AnimalRequirements> getAllRequirements() {
    return _requirements.values.toList();
  }

  static List<AnimalRequirements> getRequirementsBySpecies(AnimalSpecies species) {
    return _requirements.values
        .where((req) => req.species == species)
        .toList();
  }

  static AnimalRequirements? getRequirements(
    AnimalSpecies species,
    ProductionStage stage, {
    String? subType,
    double? liveWeight,
  }) {
    final key = _generateKey(species, stage, subType, liveWeight);
    return _requirements[key] ?? _findClosestMatch(species, stage, subType, liveWeight);
  }

  static String _generateKey(
    AnimalSpecies species,
    ProductionStage stage,
    String? subType,
    double? liveWeight,
  ) {
    final baseKey = '${species.toString()}_${stage.toString()}';
    if (subType != null) {
      return '${baseKey}_$subType';
    }
    if (liveWeight != null) {
      return '${baseKey}_${liveWeight.round()}kg';
    }
    return baseKey;
  }

  static AnimalRequirements? _findClosestMatch(
    AnimalSpecies species,
    ProductionStage stage,
    String? subType,
    double? liveWeight,
  ) {
    // Find the closest match based on species and stage
    final candidates = _requirements.values
        .where((req) => req.species == species && req.stage == stage)
        .toList();
    
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.first;
    
    // If multiple candidates, find closest by weight
    if (liveWeight != null) {
      candidates.sort((a, b) => 
        (a.liveWeight - liveWeight).abs().compareTo((b.liveWeight - liveWeight).abs())
      );
    }
    
    return candidates.first;
  }

  static void _initializePoultryRequirements() {
    // Broiler Starter (0-3 weeks, 0.05-0.5 kg)
    _requirements['poultry_starter_broiler'] = AnimalRequirements(
      species: AnimalSpecies.poultry,
      stage: ProductionStage.starter,
      subType: 'broiler',
      liveWeight: 0.25,
      dailyGain: 0.05,
      description: 'Broiler starter feed (0-3 weeks)',
      source: 'NRC 1994, Broiler Nutrition',
      requirements: const [
  const NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3000,
          maximum: 3200,
          unit: 'kcal/kg',
          isCritical: true,
          description: 'High energy for rapid growth',
        ),
  const NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 22.0,
          maximum: 24.0,
          unit: '%',
          isCritical: true,
          description: 'High protein for muscle development',
        ),
  const NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 1.35,
          unit: '%',
          isCritical: true,
          description: 'Essential amino acid for growth',
        ),
  const NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.50,
          unit: '%',
          isCritical: true,
          description: 'Limiting amino acid in corn-soy diets',
        ),
  const NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 1.0,
          maximum: 1.2,
          unit: '%',
          description: 'Bone development',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.45,
          unit: '%',
          description: 'Bone development and metabolism',
        ),
        NutritionalRequirement(
          nutrient: 'sodium',
          minimum: 0.20,
          maximum: 0.25,
          unit: '%',
          description: 'Electrolyte balance',
        ),
      ],
    );

    // Broiler Grower (3-6 weeks, 0.5-2.0 kg)
    _requirements['poultry_grower_broiler'] = AnimalRequirements(
      species: AnimalSpecies.poultry,
      stage: ProductionStage.grower,
      subType: 'broiler',
      liveWeight: 1.2,
      dailyGain: 0.07,
      description: 'Broiler grower feed (3-6 weeks)',
      source: 'NRC 1994, Broiler Nutrition',
      requirements: const [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3100,
          maximum: 3300,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 19.0,
          maximum: 21.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 1.18,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.46,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.90,
          maximum: 1.1,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.35,
          unit: '%',
        ),
      ],
    );

    // Broiler Finisher (6+ weeks, 2.0+ kg)
    _requirements['poultry_finisher_broiler'] = AnimalRequirements(
      species: AnimalSpecies.poultry,
      stage: ProductionStage.finisher,
      subType: 'broiler',
      liveWeight: 2.5,
      dailyGain: 0.08,
      description: 'Broiler finisher feed (6+ weeks)',
      source: 'NRC 1994, Broiler Nutrition',
      requirements: const [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3150,
          maximum: 3350,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 18.0,
          maximum: 20.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 1.09,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.42,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.80,
          maximum: 1.0,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.30,
          unit: '%',
        ),
      ],
    );

    // Layer Pullet (0-18 weeks)
    _requirements['poultry_grower_layer'] = AnimalRequirements(
      species: AnimalSpecies.poultry,
      stage: ProductionStage.grower,
      subType: 'layer',
      liveWeight: 1.2,
      dailyGain: 0.012,
      description: 'Layer pullet grower feed (0-18 weeks)',
      source: 'NRC 1994, Layer Nutrition',
      requirements: const [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2800,
          maximum: 3000,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 16.0,
          maximum: 18.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 0.85,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.38,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.90,
          maximum: 1.1,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.35,
          unit: '%',
        ),
      ],
    );

    // Layer Production (18+ weeks)
    _requirements['poultry_layer_layer'] = AnimalRequirements(
      species: AnimalSpecies.poultry,
      stage: ProductionStage.layer,
      subType: 'layer',
      liveWeight: 1.8,
      eggProduction: 0.85, // eggs per day
      description: 'Layer production feed (18+ weeks)',
      source: 'NRC 1994, Layer Nutrition',
      requirements: const [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2750,
          maximum: 2900,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 16.0,
          maximum: 18.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 0.78,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.38,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 3.8,
          maximum: 4.2,
          unit: '%',
          isCritical: true,
          description: 'High calcium for eggshell formation',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.32,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'linoleic_acid',
          minimum: 1.0,
          unit: '%',
          description: 'Essential fatty acid for egg production',
        ),
      ],
    );
  }

  static void _initializeSwineRequirements() {
    // Piglet Starter (5-10 kg)
    _requirements['swine_starter_piglet'] = AnimalRequirements(
      species: AnimalSpecies.swine,
      stage: ProductionStage.starter,
      subType: 'piglet',
      liveWeight: 7.5,
      dailyGain: 0.45,
      description: 'Piglet starter feed (5-10 kg)',
      source: 'NRC 2012, Swine Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3400,
          maximum: 3500,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 22.0,
          maximum: 25.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 1.45,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.43,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.80,
          maximum: 1.0,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.40,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'crude_fat',
          minimum: 6.0,
          unit: '%',
          description: 'High fat for energy density',
        ),
      ],
    );

    // Grower Pig (10-50 kg)
    _requirements['swine_grower_grower'] = AnimalRequirements(
      species: AnimalSpecies.swine,
      stage: ProductionStage.grower,
      subType: 'grower',
      liveWeight: 30.0,
      dailyGain: 0.75,
      description: 'Grower pig feed (10-50 kg)',
      source: 'NRC 2012, Swine Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3300,
          maximum: 3400,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 18.0,
          maximum: 20.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 1.15,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.35,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.70,
          maximum: 0.90,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.32,
          unit: '%',
        ),
      ],
    );

    // Finisher Pig (50-120 kg)
    _requirements['swine_finisher_finisher'] = AnimalRequirements(
      species: AnimalSpecies.swine,
      stage: ProductionStage.finisher,
      subType: 'finisher',
      liveWeight: 85.0,
      dailyGain: 0.85,
      description: 'Finisher pig feed (50-120 kg)',
      source: 'NRC 2012, Swine Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3300,
          maximum: 3400,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 15.0,
          maximum: 17.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 0.95,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'methionine',
          minimum: 0.29,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.60,
          maximum: 0.80,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.28,
          unit: '%',
        ),
      ],
    );

    // Gestating Sow
    _requirements['swine_gestation_sow'] = AnimalRequirements(
      species: AnimalSpecies.swine,
      stage: ProductionStage.gestation,
      subType: 'sow',
      liveWeight: 200.0,
      description: 'Gestating sow feed',
      source: 'NRC 2012, Swine Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3300,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 13.0,
          maximum: 15.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 0.75,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.75,
          maximum: 0.90,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.35,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'crude_fiber',
          minimum: 6.0,
          maximum: 8.0,
          unit: '%',
          description: 'Fiber for gut health and satiety',
        ),
      ],
    );

    // Lactating Sow
    _requirements['swine_lactation_sow'] = AnimalRequirements(
      species: AnimalSpecies.swine,
      stage: ProductionStage.lactation,
      subType: 'sow',
      liveWeight: 180.0,
      description: 'Lactating sow feed',
      source: 'NRC 2012, Swine Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 3400,
          unit: 'kcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 18.0,
          maximum: 20.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'lysine',
          minimum: 1.00,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.85,
          maximum: 1.0,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'available_phosphorus',
          minimum: 0.45,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'crude_fat',
          minimum: 5.0,
          unit: '%',
          description: 'High energy density for milk production',
        ),
      ],
    );
  }

  static void _initializeCattleRequirements() {
    // Dairy Calf Starter (0-3 months)
    _requirements['cattle_starter_calf'] = AnimalRequirements(
      species: AnimalSpecies.cattle,
      stage: ProductionStage.starter,
      subType: 'calf',
      liveWeight: 75.0,
      dailyGain: 0.8,
      description: 'Dairy calf starter feed (0-3 months)',
      source: 'NRC 2001, Dairy Cattle Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.9,
          maximum: 3.1,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 18.0,
          maximum: 20.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'adf',
          minimum: 15.0,
          maximum: 20.0,
          unit: '%',
          description: 'Minimum fiber for rumen development',
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.70,
          maximum: 1.0,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.45,
          unit: '%',
        ),
      ],
    );

    // Growing Heifer (3-15 months)
    _requirements['cattle_grower_heifer'] = AnimalRequirements(
      species: AnimalSpecies.cattle,
      stage: ProductionStage.grower,
      subType: 'heifer',
      liveWeight: 300.0,
      dailyGain: 0.7,
      description: 'Growing heifer feed (3-15 months)',
      source: 'NRC 2001, Dairy Cattle Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.4,
          maximum: 2.7,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 14.0,
          maximum: 16.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'ndf',
          minimum: 28.0,
          maximum: 35.0,
          unit: '%',
          description: 'Neutral detergent fiber for rumen health',
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.60,
          maximum: 0.80,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.35,
          unit: '%',
        ),
      ],
    );

    // Lactating Dairy Cow
    _requirements['cattle_lactation_dairy'] = AnimalRequirements(
      species: AnimalSpecies.cattle,
      stage: ProductionStage.lactation,
      subType: 'dairy_cow',
      liveWeight: 650.0,
      milkProduction: 35.0, // kg/day
      description: 'Lactating dairy cow feed (35 kg milk/day)',
      source: 'NRC 2001, Dairy Cattle Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.6,
          maximum: 2.8,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 16.0,
          maximum: 18.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'ndf',
          minimum: 25.0,
          maximum: 33.0,
          unit: '%',
          description: 'Fiber for rumen health and fat test',
        ),
        NutritionalRequirement(
          nutrient: 'adf',
          minimum: 19.0,
          maximum: 25.0,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.70,
          maximum: 1.0,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.40,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'rumen_undegradable_protein',
          minimum: 36.0,
          unit: '% of CP',
          description: 'Bypass protein for milk production',
        ),
      ],
    );

    // Beef Finishing Cattle
    _requirements['cattle_finisher_beef'] = AnimalRequirements(
      species: AnimalSpecies.cattle,
      stage: ProductionStage.finisher,
      subType: 'steer',
      liveWeight: 500.0,
      dailyGain: 1.4,
      description: 'Beef finishing cattle feed',
      source: 'NRC 2000, Beef Cattle Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.8,
          maximum: 3.0,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 12.0,
          maximum: 14.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'ndf',
          minimum: 20.0,
          maximum: 28.0,
          unit: '%',
          description: 'Minimum fiber to prevent acidosis',
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.60,
          maximum: 0.80,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.30,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'potassium',
          minimum: 0.60,
          unit: '%',
        ),
      ],
    );
  }

  static void _initializeSheepGoatRequirements() {
    // Growing Lambs/Kids
    _requirements['sheep_grower_lamb'] = AnimalRequirements(
      species: AnimalSpecies.sheep,
      stage: ProductionStage.grower,
      subType: 'lamb',
      liveWeight: 35.0,
      dailyGain: 0.25,
      description: 'Growing lamb feed',
      source: 'NRC 2007, Small Ruminant Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.7,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 16.0,
          maximum: 18.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.60,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.35,
          unit: '%',
        ),
      ],
    );

    // Lactating Ewes/Does
    _requirements['sheep_lactation_ewe'] = AnimalRequirements(
      species: AnimalSpecies.sheep,
      stage: ProductionStage.lactation,
      subType: 'ewe',
      liveWeight: 65.0,
      milkProduction: 1.5, // kg/day
      description: 'Lactating ewe feed',
      source: 'NRC 2007, Small Ruminant Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.6,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 14.0,
          maximum: 16.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.60,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.40,
          unit: '%',
        ),
      ],
    );

    // Growing Goat Kids
    _requirements['goat_grower_kid'] = AnimalRequirements(
      species: AnimalSpecies.goat,
      stage: ProductionStage.grower,
      subType: 'kid',
      liveWeight: 25.0,
      dailyGain: 0.20,
      description: 'Growing goat kid feed',
      source: 'NRC 2007, Small Ruminant Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.8,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 16.0,
          maximum: 18.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.60,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.35,
          unit: '%',
        ),
      ],
    );

    // Lactating Does
    _requirements['goat_lactation_doe'] = AnimalRequirements(
      species: AnimalSpecies.goat,
      stage: ProductionStage.lactation,
      subType: 'doe',
      liveWeight: 55.0,
      milkProduction: 3.0, // kg/day
      description: 'Lactating doe feed',
      source: 'NRC 2007, Small Ruminant Nutrition',
      requirements: [
        NutritionalRequirement(
          nutrient: 'metabolizable_energy',
          minimum: 2.7,
          unit: 'Mcal/kg',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'crude_protein',
          minimum: 16.0,
          maximum: 18.0,
          unit: '%',
          isCritical: true,
        ),
        NutritionalRequirement(
          nutrient: 'calcium',
          minimum: 0.70,
          unit: '%',
        ),
        NutritionalRequirement(
          nutrient: 'phosphorus',
          minimum: 0.45,
          unit: '%',
        ),
      ],
    );
  }
}