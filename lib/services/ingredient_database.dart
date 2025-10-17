import '../models/feed_ingredient.dart';

class IngredientDatabase {
  static final Map<String, FeedIngredient> _ingredients = {};
  
  static void initialize() {
    _initializeCerealGrains();
    _initializeProteinMeals();
    _initializeFatsOils();
    _initializeForages();
    _initializeByProducts();
    _initializeMinerals();
    _initializeVitamins();
    _initializeAdditives();
    _initializeSpecialtyIngredients();
    _initializeRootTubers();
    _initializeLegumes();
    _initializeOilseeds();
    _initializeFiberSources();
    _initializeAnimalProteins();
    _initializePremixes();
  }

  static List<FeedIngredient> getAllIngredients() {
    return _ingredients.values.toList();
  }

  static List<FeedIngredient> getIngredientsByCategory(IngredientCategory category) {
    return _ingredients.values
        .where((ingredient) => ingredient.category == category)
        .toList();
  }

  static List<FeedIngredient> searchIngredients(String query) {
    final lowerQuery = query.toLowerCase();
    return _ingredients.values
        .where((ingredient) =>
            ingredient.name.toLowerCase().contains(lowerQuery) ||
            ingredient.commonName.toLowerCase().contains(lowerQuery) ||
            ingredient.scientificName.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static FeedIngredient? getIngredientById(String id) {
    return _ingredients[id];
  }

  static void addOrUpdateIngredient(FeedIngredient ingredient) {
    _ingredients[ingredient.id] = ingredient;
  }

  static void _initializeCerealGrains() {
    // Corn (Maize)
    _ingredients['corn_grain'] = FeedIngredient(
      id: 'corn_grain',
      name: 'Corn, Grain',
      commonName: 'Corn',
      scientificName: 'Zea mays',
      category: IngredientCategory.cereal_grains,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 8.5,
        digestibleProtein: 7.5,
        crudeEnergy: 3350,
        metabolizableEnergy: 3150,
        digestibleEnergy: 3400,
        netEnergy: 2200,
        crudeFat: 3.8,
        crudeStarch: 63.0,
        ndf: 11.0,
        adf: 3.0,
        ash: 1.3,
        tdn: 88.0,
        nfc: 74.0,
        aminoAcids: AminoAcidProfile(
          lysine: 0.26,
          methionine: 0.19,
          cystine: 0.17,
          threonine: 0.31,
          tryptophan: 0.07,
          arginine: 0.44,
          leucine: 1.05,
          isoleucine: 0.31,
          valine: 0.43,
        ),
        minerals: MineralProfile(
          calcium: 0.03,
          phosphorus: 0.28,
          availablePhosphorus: 0.09,
          potassium: 0.37,
          sodium: 0.01,
          magnesium: 0.12,
          iron: 30.0,
          zinc: 20.0,
          copper: 3.0,
          manganese: 5.0,
        ),
      ),
      currentPrice: 280.0,
      unit: 'ton',
      availabilityScore: 95.0,
      palatabilityScore: 90.0,
      digestibilityScore: 88.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 70.0,
      storageRequirements: 'Cool, dry place. Max 14% moisture',
      shelfLifeDays: 365,
    );

    // Wheat
    _ingredients['wheat_grain'] = FeedIngredient(
      id: 'wheat_grain',
      name: 'Wheat, Grain',
      commonName: 'Wheat',
      scientificName: 'Triticum aestivum',
      category: IngredientCategory.cereal_grains,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 13.2,
        digestibleProtein: 11.8,
        crudeEnergy: 3500,
        metabolizableEnergy: 3200,
        digestibleEnergy: 3450,
        netEnergy: 2300,
        crudeFat: 2.0,
        crudeStarch: 58.0,
        ndf: 12.0,
        adf: 4.0,
        ash: 1.8,
        tdn: 87.0,
        nfc: 72.0,
        aminoAcids: AminoAcidProfile(
          lysine: 0.37,
          methionine: 0.23,
          cystine: 0.33,
          threonine: 0.39,
          tryptophan: 0.16,
          arginine: 0.61,
          leucine: 0.91,
          isoleucine: 0.48,
          valine: 0.58,
        ),
        minerals: MineralProfile(
          calcium: 0.05,
          phosphorus: 0.39,
          availablePhosphorus: 0.12,
          potassium: 0.45,
          sodium: 0.01,
          magnesium: 0.13,
          iron: 35.0,
          zinc: 30.0,
          copper: 5.0,
          manganese: 40.0,
        ),
      ),
      currentPrice: 320.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 85.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 60.0,
      storageRequirements: 'Cool, dry place. Max 13% moisture',
      shelfLifeDays: 365,
    );

    // Barley
    _ingredients['barley_grain'] = FeedIngredient(
      id: 'barley_grain',
      name: 'Barley, Grain',
      commonName: 'Barley',
      scientificName: 'Hordeum vulgare',
      category: IngredientCategory.cereal_grains,
      processing: ProcessingMethod.rolled,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 11.5,
        digestibleProtein: 10.2,
        crudeEnergy: 3300,
        metabolizableEnergy: 2950,
        digestibleEnergy: 3150,
        netEnergy: 2100,
        crudeFat: 2.1,
        crudeStarch: 52.0,
        ndf: 18.0,
        adf: 6.0,
        ash: 2.5,
        tdn: 82.0,
        nfc: 67.0,
        aminoAcids: AminoAcidProfile(
          lysine: 0.41,
          methionine: 0.18,
          cystine: 0.25,
          threonine: 0.38,
          tryptophan: 0.14,
          arginine: 0.56,
          leucine: 0.78,
          isoleucine: 0.40,
          valine: 0.55,
        ),
        minerals: MineralProfile(
          calcium: 0.05,
          phosphorus: 0.34,
          availablePhosphorus: 0.10,
          potassium: 0.52,
          sodium: 0.01,
          magnesium: 0.12,
          iron: 45.0,
          zinc: 25.0,
          copper: 6.0,
          manganese: 15.0,
        ),
      ),
      currentPrice: 300.0,
      unit: 'ton',
      availabilityScore: 80.0,
      palatabilityScore: 75.0,
      digestibilityScore: 75.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 50.0,
      restrictions: ['High fiber - limit in poultry diets'],
      storageRequirements: 'Cool, dry place. Max 14% moisture',
      shelfLifeDays: 365,
    );

    // Sorghum
    _ingredients['sorghum_grain'] = FeedIngredient(
      id: 'sorghum_grain',
      name: 'Sorghum, Grain',
      commonName: 'Milo',
      scientificName: 'Sorghum bicolor',
      category: IngredientCategory.cereal_grains,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 11.0,
        digestibleProtein: 9.5,
        crudeEnergy: 3300,
        metabolizableEnergy: 3050,
        digestibleEnergy: 3200,
        netEnergy: 2150,
        crudeFat: 3.2,
        crudeStarch: 60.0,
        ndf: 12.0,
        adf: 4.0,
        ash: 1.6,
        tdn: 85.0,
        nfc: 71.0,
        aminoAcids: AminoAcidProfile(
          lysine: 0.24,
          methionine: 0.16,
          cystine: 0.15,
          threonine: 0.32,
          tryptophan: 0.11,
          arginine: 0.37,
          leucine: 1.35,
          isoleucine: 0.45,
          valine: 0.53,
        ),
        minerals: MineralProfile(
          calcium: 0.04,
          phosphorus: 0.31,
          availablePhosphorus: 0.08,
          potassium: 0.36,
          sodium: 0.01,
          magnesium: 0.16,
          iron: 40.0,
          zinc: 18.0,
          copper: 4.0,
          manganese: 8.0,
        ),
      ),
      currentPrice: 270.0,
      unit: 'ton',
      availabilityScore: 75.0,
      palatabilityScore: 80.0,
      digestibilityScore: 82.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 65.0,
      storageRequirements: 'Cool, dry place. Max 14% moisture',
      shelfLifeDays: 365,
    );
  }

  static void _initializeProteinMeals() {
    // Soybean Meal
    _ingredients['soybean_meal_48'] = FeedIngredient(
      id: 'soybean_meal_48',
      name: 'Soybean Meal, 48% CP',
      commonName: 'Soybean Meal',
      scientificName: 'Glycine max',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 48.0,
        digestibleProtein: 43.2,
        crudeEnergy: 2230,
        metabolizableEnergy: 2440,
        digestibleEnergy: 3210,
        netEnergy: 1780,
        crudeFat: 1.5,
        crudeStarch: 4.0,
        ndf: 7.0,
        adf: 4.0,
        ash: 6.2,
        tdn: 84.0,
        nfc: 34.0,
        aminoAcids: AminoAcidProfile(
          lysine: 3.18,
          methionine: 0.69,
          cystine: 0.72,
          threonine: 1.99,
          tryptophan: 0.68,
          arginine: 3.70,
          leucine: 3.82,
          isoleucine: 2.26,
          valine: 2.35,
          phenylalanine: 2.54,
          histidine: 1.31,
        ),
        minerals: MineralProfile(
          calcium: 0.29,
          phosphorus: 0.65,
          availablePhosphorus: 0.22,
          potassium: 2.10,
          sodium: 0.02,
          magnesium: 0.27,
          iron: 120.0,
          zinc: 45.0,
          copper: 15.0,
          manganese: 25.0,
        ),
      ),
      currentPrice: 450.0,
      unit: 'ton',
      availabilityScore: 95.0,
      palatabilityScore: 90.0,
      digestibilityScore: 92.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 30.0,
      storageRequirements: 'Cool, dry place. Avoid moisture',
      shelfLifeDays: 180,
    );

    // Canola Meal
    _ingredients['canola_meal'] = FeedIngredient(
      id: 'canola_meal',
      name: 'Canola Meal',
      commonName: 'Rapeseed Meal',
      scientificName: 'Brassica napus',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 38.0,
        digestibleProtein: 32.3,
        crudeEnergy: 1900,
        metabolizableEnergy: 2050,
        digestibleEnergy: 2850,
        netEnergy: 1450,
        crudeFat: 3.5,
        crudeStarch: 3.0,
        ndf: 25.0,
        adf: 18.0,
        ash: 7.0,
        tdn: 75.0,
        nfc: 26.0,
        aminoAcids: AminoAcidProfile(
          lysine: 2.11,
          methionine: 0.74,
          cystine: 1.10,
          threonine: 1.67,
          tryptophan: 0.52,
          arginine: 2.28,
          leucine: 2.77,
          isoleucine: 1.52,
          valine: 1.90,
        ),
        minerals: MineralProfile(
          calcium: 0.68,
          phosphorus: 1.06,
          availablePhosphorus: 0.35,
          potassium: 1.23,
          sodium: 0.07,
          magnesium: 0.53,
          iron: 180.0,
          zinc: 60.0,
          copper: 8.0,
          manganese: 55.0,
        ),
      ),
      currentPrice: 380.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 75.0,
      digestibilityScore: 80.0,
      suitableSpecies: ['cattle', 'swine', 'sheep', 'goat'],
      restrictions: ['Limit in poultry due to fiber content'],
      maxInclusionRate: 15.0,
      storageRequirements: 'Cool, dry place. Monitor for mold',
      shelfLifeDays: 120,
    );

    // Fish Meal
    _ingredients['fish_meal'] = FeedIngredient(
      id: 'fish_meal',
      name: 'Fish Meal, Menhaden',
      commonName: 'Fish Meal',
      scientificName: 'Brevoortia tyrannus',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 92.0,
        crudeProtein: 60.0,
        digestibleProtein: 55.8,
        crudeEnergy: 2800,
        metabolizableEnergy: 2850,
        digestibleEnergy: 3200,
        netEnergy: 2100,
        crudeFat: 9.0,
        crudeStarch: 0.0,
        ndf: 0.0,
        adf: 0.0,
        ash: 17.0,
        tdn: 75.0,
        nfc: 14.0,
        aminoAcids: AminoAcidProfile(
          lysine: 4.83,
          methionine: 1.76,
          cystine: 0.55,
          threonine: 2.65,
          tryptophan: 0.70,
          arginine: 3.58,
          leucine: 4.60,
          isoleucine: 2.75,
          valine: 3.20,
          phenylalanine: 2.45,
          histidine: 1.54,
        ),
        minerals: MineralProfile(
          calcium: 5.02,
          phosphorus: 2.90,
          availablePhosphorus: 2.32,
          potassium: 0.95,
          sodium: 1.12,
          magnesium: 0.19,
          iron: 350.0,
          zinc: 180.0,
          copper: 15.0,
          manganese: 45.0,
        ),
      ),
      currentPrice: 1200.0,
      unit: 'ton',
      availabilityScore: 70.0,
      palatabilityScore: 85.0,
      digestibilityScore: 95.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 8.0,
      storageRequirements: 'Cool, dry place. Monitor for rancidity',
      shelfLifeDays: 90,
      certification: 'ETHOXYQUIN free',
    );
  }

  static void _initializeFatsOils() {
    // Soybean Oil
    _ingredients['soybean_oil'] = FeedIngredient(
      id: 'soybean_oil',
      name: 'Soybean Oil',
      commonName: 'Soy Oil',
      scientificName: 'Glycine max',
      category: IngredientCategory.fats_oils,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        crudeEnergy: 8800,
        metabolizableEnergy: 8600,
        digestibleEnergy: 8900,
        netEnergy: 6400,
        crudeFat: 99.0,
        ash: 0.0,
      ),
      currentPrice: 800.0,
      unit: 'ton',
      availabilityScore: 90.0,
      palatabilityScore: 95.0,
      digestibilityScore: 95.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 6.0,
      storageRequirements: 'Cool, dark place. Prevent oxidation',
      shelfLifeDays: 180,
    );

    // Animal Fat
    _ingredients['animal_fat'] = FeedIngredient(
      id: 'animal_fat',
      name: 'Animal Fat, Poultry',
      commonName: 'Poultry Fat',
      category: IngredientCategory.fats_oils,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        crudeEnergy: 8650,
        metabolizableEnergy: 8400,
        digestibleEnergy: 8700,
        netEnergy: 6200,
        crudeFat: 99.0,
        ash: 0.0,
      ),
      currentPrice: 650.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 90.0,
      digestibilityScore: 90.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 5.0,
      storageRequirements: 'Cool place. Add antioxidants',
      shelfLifeDays: 120,
    );
  }

  static void _initializeForages() {
    // Alfalfa Hay
    _ingredients['alfalfa_hay'] = FeedIngredient(
      id: 'alfalfa_hay',
      name: 'Alfalfa Hay, Mid Bloom',
      commonName: 'Alfalfa',
      scientificName: 'Medicago sativa',
      category: IngredientCategory.forages,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 17.0,
        digestibleProtein: 12.8,
        crudeEnergy: 1650,
        metabolizableEnergy: 2200,
        digestibleEnergy: 2500,
        netEnergy: 1250,
        crudeFat: 2.5,
        ndf: 45.0,
        adf: 35.0,
        ash: 8.5,
        tdn: 58.0,
        minerals: MineralProfile(
          calcium: 1.38,
          phosphorus: 0.24,
          potassium: 2.30,
          magnesium: 0.30,
        ),
      ),
      currentPrice: 180.0,
      unit: 'ton',
      availabilityScore: 80.0,
      palatabilityScore: 85.0,
      digestibilityScore: 65.0,
      suitableSpecies: ['cattle', 'sheep', 'goat'],
      maxInclusionRate: 100.0,
      storageRequirements: 'Dry storage. Monitor for mold',
      shelfLifeDays: 730,
    );

    // Corn Silage
    _ingredients['corn_silage'] = FeedIngredient(
      id: 'corn_silage',
      name: 'Corn Silage, Normal',
      commonName: 'Corn Silage',
      scientificName: 'Zea mays',
      category: IngredientCategory.forages,
      processing: ProcessingMethod.fermented,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 33.0,
        crudeProtein: 8.0,
        digestibleProtein: 5.6,
        crudeEnergy: 1550,
        metabolizableEnergy: 2350,
        digestibleEnergy: 2650,
        netEnergy: 1600,
        crudeFat: 3.0,
        ndf: 42.0,
        adf: 25.0,
        ash: 4.0,
        tdn: 68.0,
        minerals: MineralProfile(
          calcium: 0.26,
          phosphorus: 0.20,
          potassium: 1.15,
          magnesium: 0.18,
        ),
      ),
      currentPrice: 45.0,
      unit: 'ton',
      availabilityScore: 90.0,
      palatabilityScore: 90.0,
      digestibilityScore: 75.0,
      suitableSpecies: ['cattle', 'sheep', 'goat'],
      maxInclusionRate: 100.0,
      storageRequirements: 'Proper ensiling. Anaerobic conditions',
      shelfLifeDays: 365,
    );
  }

  static void _initializeByProducts() {
    // Wheat Bran
    _ingredients['wheat_bran'] = FeedIngredient(
      id: 'wheat_bran',
      name: 'Wheat Bran',
      commonName: 'Bran',
      scientificName: 'Triticum aestivum',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 16.0,
        digestibleProtein: 12.8,
        crudeEnergy: 1750,
        metabolizableEnergy: 1900,
        digestibleEnergy: 2650,
        netEnergy: 1350,
        crudeFat: 4.0,
        ndf: 42.0,
        adf: 12.0,
        ash: 5.8,
        tdn: 66.0,
        minerals: MineralProfile(
          calcium: 0.13,
          phosphorus: 1.18,
          availablePhosphorus: 0.59,
          potassium: 1.16,
          magnesium: 0.52,
        ),
      ),
      currentPrice: 200.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 75.0,
      digestibilityScore: 70.0,
      suitableSpecies: ['cattle', 'swine', 'sheep', 'goat'],
      maxInclusionRate: 20.0,
      storageRequirements: 'Dry storage. Monitor for insects',
      shelfLifeDays: 180,
    );

    // Corn Gluten Meal
    _ingredients['corn_gluten_meal'] = FeedIngredient(
      id: 'corn_gluten_meal',
      name: 'Corn Gluten Meal',
      commonName: 'CGM',
      scientificName: 'Zea mays',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 60.0,
        digestibleProtein: 52.8,
        crudeEnergy: 2900,
        metabolizableEnergy: 3500,
        digestibleEnergy: 3800,
        netEnergy: 2600,
        crudeFat: 2.5,
        ndf: 8.0,
        adf: 4.0,
        ash: 1.5,
        tdn: 85.0,
        aminoAcids: AminoAcidProfile(
          lysine: 1.05,
          methionine: 1.48,
          cystine: 1.05,
          threonine: 2.40,
          tryptophan: 0.24,
          arginine: 2.16,
          leucine: 11.88,
          isoleucine: 2.76,
          valine: 3.12,
        ),
        minerals: MineralProfile(
          calcium: 0.05,
          phosphorus: 0.48,
          availablePhosphorus: 0.15,
          potassium: 0.28,
          sodium: 0.80,
          magnesium: 0.15,
        ),
      ),
      currentPrice: 550.0,
      unit: 'ton',
      availabilityScore: 75.0,
      palatabilityScore: 80.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['cattle', 'swine', 'poultry'],
      maxInclusionRate: 15.0,
      storageRequirements: 'Dry storage. High palatability',
      shelfLifeDays: 365,
    );
  }

  static void _initializeMinerals() {
    // Limestone
    _ingredients['limestone'] = FeedIngredient(
      id: 'limestone',
      name: 'Limestone, Ground',
      commonName: 'Calcium Carbonate',
      category: IngredientCategory.minerals,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        minerals: MineralProfile(
          calcium: 38.0,
          phosphorus: 0.0,
        ),
      ),
      currentPrice: 120.0,
      unit: 'ton',
      availabilityScore: 100.0,
      palatabilityScore: 70.0,
      digestibilityScore: 90.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 2.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 3650,
    );

    // Dicalcium Phosphate
    _ingredients['dicalcium_phosphate'] = FeedIngredient(
      id: 'dicalcium_phosphate',
      name: 'Dicalcium Phosphate',
      commonName: 'DCP',
      category: IngredientCategory.minerals,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        minerals: MineralProfile(
          calcium: 22.0,
          phosphorus: 18.5,
          availablePhosphorus: 18.5,
        ),
      ),
      currentPrice: 800.0,
      unit: 'ton',
      availabilityScore: 95.0,
      palatabilityScore: 80.0,
      digestibilityScore: 95.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 2.5,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 3650,
    );

    // Salt
    _ingredients['salt'] = FeedIngredient(
      id: 'salt',
      name: 'Salt',
      commonName: 'Sodium Chloride',
      category: IngredientCategory.minerals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        minerals: MineralProfile(
          sodium: 39.0,
          chloride: 61.0,
        ),
      ),
      currentPrice: 250.0,
      unit: 'ton',
      availabilityScore: 100.0,
      palatabilityScore: 90.0,
      digestibilityScore: 100.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 0.5,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 3650,
    );
  }

  static void _initializeVitamins() {
    // Vitamin A
    _ingredients['vitamin_a'] = FeedIngredient(
      id: 'vitamin_a',
      name: 'Vitamin A Palmitate',
      commonName: 'Vitamin A',
      category: IngredientCategory.vitamins,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        vitamins: VitaminProfile(
          vitaminA: 500000000.0, // 500 million IU/kg
        ),
      ),
      currentPrice: 15000.0,
      unit: 'ton',
      availabilityScore: 90.0,
      palatabilityScore: 100.0,
      digestibilityScore: 95.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 0.01,
      storageRequirements: 'Cool, dark, dry storage',
      shelfLifeDays: 730,
    );

    // Vitamin D3
    _ingredients['vitamin_d3'] = FeedIngredient(
      id: 'vitamin_d3',
      name: 'Vitamin D3',
      commonName: 'Cholecalciferol',
      category: IngredientCategory.vitamins,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        vitamins: VitaminProfile(
          vitaminD3: 100000000.0, // 100 million IU/kg
        ),
      ),
      currentPrice: 35000.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 100.0,
      digestibilityScore: 95.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 0.005,
      storageRequirements: 'Cool, dark, dry storage',
      shelfLifeDays: 730,
    );

    // Vitamin E
    _ingredients['vitamin_e'] = FeedIngredient(
      id: 'vitamin_e',
      name: 'Vitamin E Acetate',
      commonName: 'Vitamin E',
      category: IngredientCategory.vitamins,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        vitamins: VitaminProfile(
          vitaminE: 500000.0, // 500,000 IU/kg
        ),
      ),
      currentPrice: 12000.0,
      unit: 'ton',
      availabilityScore: 90.0,
      palatabilityScore: 100.0,
      digestibilityScore: 90.0,
      suitableSpecies: ['cattle', 'swine', 'poultry', 'sheep', 'goat'],
      maxInclusionRate: 0.02,
      storageRequirements: 'Cool, dark, dry storage',
      shelfLifeDays: 730,
    );
  }

  static void _initializeAdditives() {
    // Lysine HCl
    _ingredients['lysine_hcl'] = FeedIngredient(
      id: 'lysine_hcl',
      name: 'L-Lysine HCl',
      commonName: 'Lysine',
      category: IngredientCategory.additives,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        aminoAcids: AminoAcidProfile(
          lysine: 78.4, // 78.4% lysine content
        ),
      ),
      currentPrice: 1800.0,
      unit: 'ton',
      availabilityScore: 95.0,
      palatabilityScore: 95.0,
      digestibilityScore: 98.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 0.5,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 1095,
    );

    // Methionine
    _ingredients['dl_methionine'] = FeedIngredient(
      id: 'dl_methionine',
      name: 'DL-Methionine',
      commonName: 'Methionine',
      category: IngredientCategory.additives,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        aminoAcids: AminoAcidProfile(
          methionine: 99.0, // 99% methionine content
        ),
      ),
      currentPrice: 2200.0,
      unit: 'ton',
      availabilityScore: 90.0,
      palatabilityScore: 95.0,
      digestibilityScore: 98.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 0.3,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 1095,
    );

    // Threonine
    _ingredients['l_threonine'] = FeedIngredient(
      id: 'l_threonine',
      name: 'L-Threonine',
      commonName: 'Threonine',
      category: IngredientCategory.additives,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 99.0,
        crudeProtein: 0.0,
        aminoAcids: AminoAcidProfile(
          threonine: 98.5, // 98.5% threonine content
        ),
      ),
      currentPrice: 2500.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 95.0,
      digestibilityScore: 98.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 0.2,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 1095,
    );
  }

  static void _initializeSpecialtyIngredients() {
    // Rice Bran
    _ingredients['rice_bran'] = FeedIngredient(
      id: 'rice_bran',
      name: 'Rice Bran',
      commonName: 'Rice Bran',
      scientificName: 'Oryza sativa',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 90.0,
        crudeProtein: 13.5,
        digestibleProtein: 11.2,
        metabolizableEnergy: 2950.0,
        crudeFat: 13.0,
        ndf: 25.0,
        adf: 12.0,
        ash: 9.8,
        minerals: MineralProfile(
          calcium: 0.07,
          phosphorus: 1.6,
          potassium: 1.5,
          magnesium: 0.9,
        ),
      ),
      currentPrice: 280.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 75.0,
      digestibilityScore: 80.0,
      suitableSpecies: ['cattle', 'swine', 'poultry'],
      maxInclusionRate: 15.0,
      storageRequirements: 'Cool, dry storage',
      shelfLifeDays: 60,
    );

    // DDGS (Distillers Dried Grains with Solubles)
    _ingredients['ddgs'] = FeedIngredient(
      id: 'ddgs',
      name: 'Distillers Dried Grains with Solubles',
      commonName: 'DDGS',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 27.0,
        digestibleProtein: 24.0,
        metabolizableEnergy: 2800.0,
        crudeFat: 10.0,
        ndf: 35.0,
        adf: 15.0,
        ash: 5.2,
        minerals: MineralProfile(
          phosphorus: 0.9,
          potassium: 1.1,
          sulfur: 0.8,
        ),
      ),
      currentPrice: 320.0,
      unit: 'ton',
      availabilityScore: 90.0,
      palatabilityScore: 70.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['cattle', 'swine'],
      maxInclusionRate: 20.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 180,
    );

    // Sunflower Meal
    _ingredients['sunflower_meal'] = FeedIngredient(
      id: 'sunflower_meal',
      name: 'Sunflower Meal',
      commonName: 'Sunflower Meal',
      scientificName: 'Helianthus annuus',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 90.5,
        crudeProtein: 34.0,
        digestibleProtein: 29.0,
        metabolizableEnergy: 2200.0,
        crudeFat: 2.5,
        ndf: 30.0,
        adf: 22.0,
        ash: 7.1,
        minerals: MineralProfile(
          phosphorus: 1.1,
          potassium: 1.2,
          magnesium: 0.4,
        ),
      ),
      currentPrice: 380.0,
      unit: 'ton',
      availabilityScore: 75.0,
      palatabilityScore: 80.0,
      digestibilityScore: 75.0,
      suitableSpecies: ['cattle', 'swine', 'poultry'],
      maxInclusionRate: 15.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 120,
    );

    // Cottonseed Meal
    _ingredients['cottonseed_meal'] = FeedIngredient(
      id: 'cottonseed_meal',
      name: 'Cottonseed Meal',
      commonName: 'Cottonseed Meal',
      scientificName: 'Gossypium hirsutum',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 91.0,
        crudeProtein: 41.0,
        digestibleProtein: 35.0,
        metabolizableEnergy: 2400.0,
        crudeFat: 2.0,
        ndf: 25.0,
        adf: 18.0,
        ash: 6.8,
        minerals: MineralProfile(
          phosphorus: 1.2,
          potassium: 1.4,
          magnesium: 0.6,
        ),
      ),
      currentPrice: 420.0,
      unit: 'ton',
      availabilityScore: 70.0,
      palatabilityScore: 70.0,
      digestibilityScore: 80.0,
      suitableSpecies: ['cattle'],
      maxInclusionRate: 12.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 90,
      restrictions: ['Limited in poultry due to gossypol'],
    );

    // Brewers Grains (Wet)
    _ingredients['brewers_grains_wet'] = FeedIngredient(
      id: 'brewers_grains_wet',
      name: 'Brewers Grains, Wet',
      commonName: 'Wet Brewers Grains',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 25.0,
        crudeProtein: 26.0,
        digestibleProtein: 22.0,
        metabolizableEnergy: 2500.0,
        crudeFat: 6.5,
        ndf: 45.0,
        adf: 25.0,
        ash: 4.2,
        minerals: MineralProfile(
          phosphorus: 0.6,
          potassium: 0.3,
        ),
      ),
      currentPrice: 80.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 85.0,
      digestibilityScore: 75.0,
      suitableSpecies: ['cattle'],
      maxInclusionRate: 30.0,
      storageRequirements: 'Use fresh, refrigerated',
      shelfLifeDays: 7,
    );

    // Palm Kernel Meal
    _ingredients['palm_kernel_meal'] = FeedIngredient(
      id: 'palm_kernel_meal',
      name: 'Palm Kernel Meal',
      commonName: 'Palm Kernel Meal',
      scientificName: 'Elaeis guineensis',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 90.0,
        crudeProtein: 14.5,
        digestibleProtein: 11.0,
        metabolizableEnergy: 2100.0,
        crudeFat: 8.0,
        ndf: 65.0,
        adf: 45.0,
        ash: 4.5,
        minerals: MineralProfile(
          phosphorus: 0.6,
          potassium: 0.8,
        ),
      ),
      currentPrice: 250.0,
      unit: 'ton',
      availabilityScore: 80.0,
      palatabilityScore: 65.0,
      digestibilityScore: 65.0,
      suitableSpecies: ['cattle', 'swine'],
      maxInclusionRate: 20.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 120,
    );
  }

  static void _initializeRootTubers() {
    // Cassava Root Meal
    _ingredients['cassava_root_meal'] = FeedIngredient(
      id: 'cassava_root_meal',
      name: 'Cassava Root Meal',
      commonName: 'Cassava Meal',
      scientificName: 'Manihot esculenta',
      category: IngredientCategory.cereal_grains,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 2.5,
        digestibleProtein: 1.8,
        metabolizableEnergy: 3200.0,
        crudeFat: 0.8,
        ndf: 15.0,
        adf: 8.0,
        ash: 3.2,
        totalCarbohydrates: 85.0,
        minerals: MineralProfile(
          calcium: 0.15,
          phosphorus: 0.09,
          potassium: 0.3,
        ),
      ),
      currentPrice: 180.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 90.0,
      digestibilityScore: 90.0,
      suitableSpecies: ['swine', 'poultry', 'cattle'],
      maxInclusionRate: 25.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 180,
    );

    // Sweet Potato Meal
    _ingredients['sweet_potato_meal'] = FeedIngredient(
      id: 'sweet_potato_meal',
      name: 'Sweet Potato Meal',
      commonName: 'Sweet Potato Meal',
      scientificName: 'Ipomoea batatas',
      category: IngredientCategory.cereal_grains,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 87.0,
        crudeProtein: 4.2,
        digestibleProtein: 3.5,
        metabolizableEnergy: 3000.0,
        crudeFat: 1.2,
        ndf: 18.0,
        adf: 10.0,
        ash: 3.8,
        totalCarbohydrates: 78.0,
        minerals: MineralProfile(
          calcium: 0.2,
          phosphorus: 0.15,
          potassium: 0.8,
        ),
      ),
      currentPrice: 200.0,
      unit: 'ton',
      availabilityScore: 75.0,
      palatabilityScore: 95.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 20.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 120,
    );
  }

  static void _initializeLegumes() {
    // Field Peas
    _ingredients['field_peas'] = FeedIngredient(
      id: 'field_peas',
      name: 'Field Peas',
      commonName: 'Field Peas',
      scientificName: 'Pisum arvense',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 89.0,
        crudeProtein: 23.0,
        digestibleProtein: 20.0,
        metabolizableEnergy: 3100.0,
        crudeFat: 1.5,
        ndf: 15.0,
        adf: 8.0,
        ash: 3.0,
        totalCarbohydrates: 60.0,
        minerals: MineralProfile(
          calcium: 0.08,
          phosphorus: 0.4,
          potassium: 1.0,
        ),
        aminoAcids: AminoAcidProfile(
          lysine: 1.6,
          methionine: 0.2,
          threonine: 0.9,
        ),
      ),
      currentPrice: 350.0,
      unit: 'ton',
      availabilityScore: 80.0,
      palatabilityScore: 85.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['swine', 'poultry', 'cattle'],
      maxInclusionRate: 15.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 365,
    );

    // Cowpeas
    _ingredients['cowpeas'] = FeedIngredient(
      id: 'cowpeas',
      name: 'Cowpeas',
      commonName: 'Black-eyed Peas',
      scientificName: 'Vigna unguiculata',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 90.0,
        crudeProtein: 24.0,
        digestibleProtein: 21.0,
        metabolizableEnergy: 3050.0,
        crudeFat: 1.8,
        ndf: 18.0,
        adf: 10.0,
        ash: 3.5,
        totalCarbohydrates: 58.0,
        minerals: MineralProfile(
          calcium: 0.12,
          phosphorus: 0.45,
          potassium: 1.2,
        ),
      ),
      currentPrice: 380.0,
      unit: 'ton',
      availabilityScore: 70.0,
      palatabilityScore: 80.0,
      digestibilityScore: 80.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 12.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 300,
    );
  }

  static void _initializeOilseeds() {
    // Safflower Meal
    _ingredients['safflower_meal'] = FeedIngredient(
      id: 'safflower_meal',
      name: 'Safflower Meal',
      commonName: 'Safflower Meal',
      scientificName: 'Carthamus tinctorius',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 91.0,
        crudeProtein: 24.0,
        digestibleProtein: 20.0,
        metabolizableEnergy: 1900.0,
        crudeFat: 2.5,
        ndf: 45.0,
        adf: 35.0,
        ash: 6.0,
        minerals: MineralProfile(
          phosphorus: 0.7,
          potassium: 0.9,
        ),
      ),
      currentPrice: 300.0,
      unit: 'ton',
      availabilityScore: 60.0,
      palatabilityScore: 70.0,
      digestibilityScore: 70.0,
      suitableSpecies: ['cattle'],
      maxInclusionRate: 10.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 120,
    );

    // Linseed Meal
    _ingredients['linseed_meal'] = FeedIngredient(
      id: 'linseed_meal',
      name: 'Linseed Meal',
      commonName: 'Flax Meal',
      scientificName: 'Linum usitatissimum',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 91.0,
        crudeProtein: 35.0,
        digestibleProtein: 30.0,
        metabolizableEnergy: 2300.0,
        crudeFat: 3.0,
        ndf: 25.0,
        adf: 15.0,
        ash: 6.2,
        minerals: MineralProfile(
          phosphorus: 0.9,
          potassium: 1.1,
          magnesium: 0.6,
        ),
      ),
      currentPrice: 450.0,
      unit: 'ton',
      availabilityScore: 65.0,
      palatabilityScore: 75.0,
      digestibilityScore: 80.0,
      suitableSpecies: ['cattle', 'swine'],
      maxInclusionRate: 8.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 90,
    );

    // Sesame Meal
    _ingredients['sesame_meal'] = FeedIngredient(
      id: 'sesame_meal',
      name: 'Sesame Meal',
      commonName: 'Sesame Meal',
      scientificName: 'Sesamum indicum',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 92.0,
        crudeProtein: 45.0,
        digestibleProtein: 40.0,
        metabolizableEnergy: 2800.0,
        crudeFat: 12.0,
        ndf: 20.0,
        adf: 12.0,
        ash: 8.5,
        minerals: MineralProfile(
          calcium: 2.1,
          phosphorus: 1.4,
          magnesium: 0.8,
        ),
      ),
      currentPrice: 550.0,
      unit: 'ton',
      availabilityScore: 55.0,
      palatabilityScore: 85.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['poultry', 'swine'],
      maxInclusionRate: 10.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 120,
    );
  }

  static void _initializeFiberSources() {
    // Sugar Beet Pulp
    _ingredients['sugar_beet_pulp'] = FeedIngredient(
      id: 'sugar_beet_pulp',
      name: 'Sugar Beet Pulp',
      commonName: 'Beet Pulp',
      scientificName: 'Beta vulgaris',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 90.0,
        crudeProtein: 9.0,
        digestibleProtein: 7.0,
        metabolizableEnergy: 2800.0,
        crudeFat: 0.8,
        ndf: 45.0,
        adf: 22.0,
        ash: 5.8,
        totalCarbohydrates: 75.0,
        minerals: MineralProfile(
          calcium: 0.8,
          phosphorus: 0.1,
          potassium: 0.6,
        ),
      ),
      currentPrice: 220.0,
      unit: 'ton',
      availabilityScore: 85.0,
      palatabilityScore: 90.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['cattle', 'sheep'],
      maxInclusionRate: 20.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 180,
    );

    // Citrus Pulp
    _ingredients['citrus_pulp'] = FeedIngredient(
      id: 'citrus_pulp',
      name: 'Citrus Pulp',
      commonName: 'Citrus Pulp',
      scientificName: 'Citrus spp.',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 90.0,
        crudeProtein: 7.0,
        digestibleProtein: 5.5,
        metabolizableEnergy: 2900.0,
        crudeFat: 3.5,
        ndf: 25.0,
        adf: 18.0,
        ash: 6.2,
        totalCarbohydrates: 78.0,
        minerals: MineralProfile(
          calcium: 1.8,
          phosphorus: 0.12,
          potassium: 0.9,
        ),
      ),
      currentPrice: 200.0,
      unit: 'ton',
      availabilityScore: 80.0,
      palatabilityScore: 85.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['cattle', 'sheep'],
      maxInclusionRate: 15.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 150,
    );

    // Oat Hulls
    _ingredients['oat_hulls'] = FeedIngredient(
      id: 'oat_hulls',
      name: 'Oat Hulls',
      commonName: 'Oat Hulls',
      scientificName: 'Avena sativa',
      category: IngredientCategory.by_products,
      processing: ProcessingMethod.ground,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 91.0,
        crudeProtein: 4.0,
        digestibleProtein: 2.0,
        metabolizableEnergy: 1200.0,
        crudeFat: 1.5,
        ndf: 75.0,
        adf: 45.0,
        ash: 3.5,
        minerals: MineralProfile(
          calcium: 0.08,
          phosphorus: 0.05,
        ),
      ),
      currentPrice: 120.0,
      unit: 'ton',
      availabilityScore: 70.0,
      palatabilityScore: 60.0,
      digestibilityScore: 40.0,
      suitableSpecies: ['cattle'],
      maxInclusionRate: 15.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 365,
    );
  }

  static void _initializeAnimalProteins() {
    // Meat and Bone Meal
    _ingredients['meat_bone_meal'] = FeedIngredient(
      id: 'meat_bone_meal',
      name: 'Meat and Bone Meal',
      commonName: 'MBM',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 94.0,
        crudeProtein: 50.0,
        digestibleProtein: 45.0,
        metabolizableEnergy: 2200.0,
        crudeFat: 10.0,
        ash: 30.0,
        minerals: MineralProfile(
          calcium: 10.0,
          phosphorus: 5.0,
          sodium: 0.7,
        ),
        aminoAcids: AminoAcidProfile(
          lysine: 2.5,
          methionine: 0.7,
          threonine: 1.8,
        ),
      ),
      currentPrice: 600.0,
      unit: 'ton',
      availabilityScore: 70.0,
      palatabilityScore: 75.0,
      digestibilityScore: 85.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 5.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 180,
      restrictions: ['Check local regulations'],
    );

    // Blood Meal
    _ingredients['blood_meal'] = FeedIngredient(
      id: 'blood_meal',
      name: 'Blood Meal',
      commonName: 'Blood Meal',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 92.0,
        crudeProtein: 90.0,
        digestibleProtein: 80.0,
        metabolizableEnergy: 2800.0,
        crudeFat: 1.0,
        ash: 4.5,
        minerals: MineralProfile(
          iron: 0.25,
          phosphorus: 0.3,
        ),
        aminoAcids: AminoAcidProfile(
          lysine: 8.0,
          methionine: 1.2,
          threonine: 4.2,
        ),
      ),
      currentPrice: 800.0,
      unit: 'ton',
      availabilityScore: 65.0,
      palatabilityScore: 60.0,
      digestibilityScore: 75.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 3.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 120,
    );

    // Feather Meal
    _ingredients['feather_meal'] = FeedIngredient(
      id: 'feather_meal',
      name: 'Feather Meal',
      commonName: 'Feather Meal',
      category: IngredientCategory.protein_meals,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 93.0,
        crudeProtein: 85.0,
        digestibleProtein: 75.0,
        metabolizableEnergy: 2400.0,
        crudeFat: 7.0,
        ash: 3.0,
        minerals: MineralProfile(
          phosphorus: 0.6,
        ),
        aminoAcids: AminoAcidProfile(
          lysine: 2.0,
          methionine: 0.7,
          cystine: 4.8,
        ),
      ),
      currentPrice: 650.0,
      unit: 'ton',
      availabilityScore: 70.0,
      palatabilityScore: 65.0,
      digestibilityScore: 70.0,
      suitableSpecies: ['swine', 'poultry'],
      maxInclusionRate: 4.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 150,
    );
  }

  static void _initializePremixes() {
    // Vitamin Premix
    _ingredients['vitamin_premix'] = FeedIngredient(
      id: 'vitamin_premix',
      name: 'Vitamin Premix',
      commonName: 'Vitamin Premix',
      category: IngredientCategory.premixes,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 95.0,
        vitamins: VitaminProfile(
          vitaminA: 1000000.0, // IU/kg
          vitaminD3: 200000.0, // IU/kg
          vitaminE: 5000.0, // IU/kg
          vitaminK: 500.0, // mg/kg
          thiamine: 200.0, // mg/kg
          riboflavin: 400.0, // mg/kg
          niacin: 2000.0, // mg/kg
          pantothenicAcid: 1000.0, // mg/kg
          pyridoxine: 300.0, // mg/kg
          biotin: 10.0, // mg/kg
          folicAcid: 100.0, // mg/kg
          vitaminB12: 2.0, // mg/kg
        ),
      ),
      currentPrice: 3500.0,
      unit: 'ton',
      availabilityScore: 95.0,
      palatabilityScore: 90.0,
      digestibilityScore: 95.0,
      suitableSpecies: ['cattle', 'swine', 'poultry'],
      maxInclusionRate: 0.25,
      storageRequirements: 'Cool, dry, dark storage',
      shelfLifeDays: 365,
    );

    // Mineral Premix
    _ingredients['mineral_premix'] = FeedIngredient(
      id: 'mineral_premix',
      name: 'Mineral Premix',
      commonName: 'Mineral Premix',
      category: IngredientCategory.premixes,
      processing: ProcessingMethod.raw,
      nutritionalProfile: NutritionalProfile(
        dryMatter: 96.0,
        minerals: MineralProfile(
          calcium: 20.0,
          phosphorus: 8.0,
          sodium: 5.0,
          potassium: 2.0,
          magnesium: 3.0,
          sulfur: 1.5,
          iron: 0.15,
          zinc: 0.12,
          copper: 0.02,
          manganese: 0.08,
          iodine: 0.002,
          selenium: 0.0003,
          cobalt: 0.001,
        ),
      ),
      currentPrice: 1200.0,
      unit: 'ton',
      availabilityScore: 95.0,
      palatabilityScore: 85.0,
      digestibilityScore: 90.0,
      suitableSpecies: ['cattle', 'swine', 'poultry'],
      maxInclusionRate: 1.0,
      storageRequirements: 'Dry storage',
      shelfLifeDays: 730,
    );
  }
}