enum IngredientCategory {
  cereal_grains,
  protein_meals,
  fats_oils,
  forages,
  by_products,
  minerals,
  vitamins,
  additives,
  premixes
}

enum ProcessingMethod {
  raw,
  ground,
  pelleted,
  extruded,
  steam_flaked,
  rolled,
  cracked,
  roasted,
  fermented
}

class AminoAcidProfile {
  final double lysine;
  final double methionine;
  final double cystine;
  final double threonine;
  final double tryptophan;
  final double arginine;
  final double histidine;
  final double isoleucine;
  final double leucine;
  final double valine;
  final double phenylalanine;
  final double tyrosine;
  final double glycine;
  final double serine;
  final double proline;
  final double alanine;
  final double asparticAcid;
  final double glutamicAcid;

  AminoAcidProfile({
    this.lysine = 0.0,
    this.methionine = 0.0,
    this.cystine = 0.0,
    this.threonine = 0.0,
    this.tryptophan = 0.0,
    this.arginine = 0.0,
    this.histidine = 0.0,
    this.isoleucine = 0.0,
    this.leucine = 0.0,
    this.valine = 0.0,
    this.phenylalanine = 0.0,
    this.tyrosine = 0.0,
    this.glycine = 0.0,
    this.serine = 0.0,
    this.proline = 0.0,
    this.alanine = 0.0,
    this.asparticAcid = 0.0,
    this.glutamicAcid = 0.0,
  });
}

class MineralProfile {
  final double calcium;
  final double phosphorus;
  final double availablePhosphorus;
  final double sodium;
  final double chloride;
  final double potassium;
  final double magnesium;
  final double sulfur;
  final double iron;
  final double zinc;
  final double copper;
  final double manganese;
  final double iodine;
  final double selenium;
  final double cobalt;
  final double chromium;

  MineralProfile({
    this.calcium = 0.0,
    this.phosphorus = 0.0,
    this.availablePhosphorus = 0.0,
    this.sodium = 0.0,
    this.chloride = 0.0,
    this.potassium = 0.0,
    this.magnesium = 0.0,
    this.sulfur = 0.0,
    this.iron = 0.0,
    this.zinc = 0.0,
    this.copper = 0.0,
    this.manganese = 0.0,
    this.iodine = 0.0,
    this.selenium = 0.0,
    this.cobalt = 0.0,
    this.chromium = 0.0,
  });
}

class VitaminProfile {
  final double vitaminA; // IU/kg
  final double vitaminD3; // IU/kg
  final double vitaminE; // IU/kg
  final double vitaminK; // mg/kg
  final double thiamine; // mg/kg
  final double riboflavin; // mg/kg
  final double niacin; // mg/kg
  final double pantothenicAcid; // mg/kg
  final double pyridoxine; // mg/kg
  final double biotin; // mg/kg
  final double folicAcid; // mg/kg
  final double vitaminB12; // mcg/kg
  final double choline; // mg/kg
  final double vitaminC; // mg/kg

  VitaminProfile({
    this.vitaminA = 0.0,
    this.vitaminD3 = 0.0,
    this.vitaminE = 0.0,
    this.vitaminK = 0.0,
    this.thiamine = 0.0,
    this.riboflavin = 0.0,
    this.niacin = 0.0,
    this.pantothenicAcid = 0.0,
    this.pyridoxine = 0.0,
    this.biotin = 0.0,
    this.folicAcid = 0.0,
    this.vitaminB12 = 0.0,
    this.choline = 0.0,
    this.vitaminC = 0.0,
  });
}

class AntiNutritionalFactors {
  final double trypsinInhibitor;
  final double phyticAcid;
  final double tannins;
  final double saponins;
  final double glucosinolates;
  final double aflatoxin;
  final double ochratoxin;
  final double zearalenone;
  final double fumonisin;
  final double deoxynivalenol;

  AntiNutritionalFactors({
    this.trypsinInhibitor = 0.0,
    this.phyticAcid = 0.0,
    this.tannins = 0.0,
    this.saponins = 0.0,
    this.glucosinolates = 0.0,
    this.aflatoxin = 0.0,
    this.ochratoxin = 0.0,
    this.zearalenone = 0.0,
    this.fumonisin = 0.0,
    this.deoxynivalenol = 0.0,
  });
}

class NutritionalProfile {
  final double dryMatter;
  final double crudeProtein;
  final double digestibleProtein;
  final double crudeEnergy; // kcal/kg
  final double digestibleEnergy; // kcal/kg
  final double metabolizableEnergy; // kcal/kg
  final double netEnergy; // kcal/kg
  final double crudeFat;
  final double crudeStarch;
  final double totalCarbohydrates;
  final double ndf; // Neutral Detergent Fiber
  final double adf; // Acid Detergent Fiber
  final double lignin;
  final double ash;
  final double tdn; // Total Digestible Nutrients
  final double nfc; // Non-Fiber Carbohydrates
  final AminoAcidProfile aminoAcids;
  final MineralProfile minerals;
  final VitaminProfile vitamins;
  final AntiNutritionalFactors antiNutritionalFactors;

  NutritionalProfile({
    this.dryMatter = 0.0,
    this.crudeProtein = 0.0,
    this.digestibleProtein = 0.0,
    this.crudeEnergy = 0.0,
    this.digestibleEnergy = 0.0,
    this.metabolizableEnergy = 0.0,
    this.netEnergy = 0.0,
    this.crudeFat = 0.0,
    this.crudeStarch = 0.0,
    this.totalCarbohydrates = 0.0,
    this.ndf = 0.0,
    this.adf = 0.0,
    this.lignin = 0.0,
    this.ash = 0.0,
    this.tdn = 0.0,
    this.nfc = 0.0,
    AminoAcidProfile? aminoAcids,
    MineralProfile? minerals,
    VitaminProfile? vitamins,
    AntiNutritionalFactors? antiNutritionalFactors,
  }) : 
    aminoAcids = aminoAcids ?? AminoAcidProfile(),
    minerals = minerals ?? MineralProfile(),
    vitamins = vitamins ?? VitaminProfile(),
    antiNutritionalFactors = antiNutritionalFactors ?? AntiNutritionalFactors();
}

class PriceHistory {
  final DateTime date;
  final double price;
  final String currency;
  final String supplier;
  final String location;

  PriceHistory({
    required this.date,
    required this.price,
    this.currency = 'USD',
    this.supplier = '',
    this.location = '',
  });
}

class QualitySpecification {
  final double minProtein;
  final double maxMoisture;
  final double maxAsh;
  final double maxFiber;
  final double minEnergy;
  final double maxAflatoxin;
  final String colorRequirement;
  final String textureRequirement;
  final String odorRequirement;

  QualitySpecification({
    this.minProtein = 0.0,
    this.maxMoisture = 100.0,
    this.maxAsh = 100.0,
    this.maxFiber = 100.0,
    this.minEnergy = 0.0,
    this.maxAflatoxin = 20.0, // ppb
    this.colorRequirement = '',
    this.textureRequirement = '',
    this.odorRequirement = '',
  });
}

class FeedIngredient {
  final String id;
  final String name;
  final String commonName;
  final String scientificName;
  final IngredientCategory category;
  final ProcessingMethod processing;
  final NutritionalProfile nutritionalProfile;
  final QualitySpecification qualitySpec;
  final List<PriceHistory> priceHistory;
  final double currentPrice;
  final String currency;
  final String unit; // kg, ton, lb
  final double availabilityScore; // 0-100
  final double palatabilityScore; // 0-100
  final double digestibilityScore; // 0-100
  final List<String> suitableSpecies; // cattle, swine, poultry, etc.
  final List<String> restrictions; // age, stage restrictions
  final double maxInclusionRate; // % in diet
  final String storageRequirements;
  final int shelfLifeDays;
  final String supplier;
  final String origin;
  final String certification; // organic, non-GMO, etc.
  final DateTime lastUpdated;
  final String notes;
  final bool isActive;

  FeedIngredient({
    required this.id,
    required this.name,
    this.commonName = '',
    this.scientificName = '',
    this.category = IngredientCategory.cereal_grains,
    this.processing = ProcessingMethod.raw,
    NutritionalProfile? nutritionalProfile,
    QualitySpecification? qualitySpec,
    List<PriceHistory>? priceHistory,
    this.currentPrice = 0.0,
    this.currency = 'USD',
    this.unit = 'kg',
    this.availabilityScore = 100.0,
    this.palatabilityScore = 100.0,
    this.digestibilityScore = 100.0,
    List<String>? suitableSpecies,
    List<String>? restrictions,
    this.maxInclusionRate = 100.0,
    this.storageRequirements = '',
    this.shelfLifeDays = 365,
    this.supplier = '',
    this.origin = '',
    this.certification = '',
    DateTime? lastUpdated,
    this.notes = '',
    this.isActive = true,
  }) :
    nutritionalProfile = nutritionalProfile ?? NutritionalProfile(),
    qualitySpec = qualitySpec ?? QualitySpecification(),
    priceHistory = priceHistory ?? [],
    suitableSpecies = suitableSpecies ?? [],
    restrictions = restrictions ?? [],
    lastUpdated = lastUpdated ?? DateTime.now();

  // Calculated properties
  double get averagePrice {
    if (priceHistory.isEmpty) return currentPrice;
    final last30Days = priceHistory
        .where((p) => DateTime.now().difference(p.date).inDays <= 30)
        .toList();
    if (last30Days.isEmpty) return currentPrice;
    return last30Days.fold(0.0, (sum, p) => sum + p.price) / last30Days.length;
  }

  double get priceVolatility {
    if (priceHistory.length < 2) return 0.0;
    final prices = priceHistory.map((p) => p.price).toList();
    final avg = prices.fold(0.0, (sum, p) => sum + p) / prices.length;
    final variance = prices.fold(0.0, (sum, p) => sum + ((p - avg) * (p - avg))) / prices.length;
    return variance > 0 ? (variance / avg) * 100 : 0.0; // CV%
  }

  bool isAvailableForSpecies(String species) {
    return suitableSpecies.isEmpty || suitableSpecies.contains(species.toLowerCase());
  }

  bool meetsQualityStandards(NutritionalProfile actualProfile) {
    return actualProfile.crudeProtein >= qualitySpec.minProtein &&
           actualProfile.dryMatter >= (100 - qualitySpec.maxMoisture) &&
           actualProfile.ash <= qualitySpec.maxAsh &&
           actualProfile.crudeEnergy >= qualitySpec.minEnergy;
  }

  FeedIngredient copyWith({
    String? name,
    String? commonName,
    String? scientificName,
    IngredientCategory? category,
    ProcessingMethod? processing,
    NutritionalProfile? nutritionalProfile,
    QualitySpecification? qualitySpec,
    List<PriceHistory>? priceHistory,
    double? currentPrice,
    String? currency,
    String? unit,
    double? availabilityScore,
    double? palatabilityScore,
    double? digestibilityScore,
    List<String>? suitableSpecies,
    List<String>? restrictions,
    double? maxInclusionRate,
    String? storageRequirements,
    int? shelfLifeDays,
    String? supplier,
    String? origin,
    String? certification,
    DateTime? lastUpdated,
    String? notes,
    bool? isActive,
  }) {
    return FeedIngredient(
      id: id,
      name: name ?? this.name,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      category: category ?? this.category,
      processing: processing ?? this.processing,
      nutritionalProfile: nutritionalProfile ?? this.nutritionalProfile,
      qualitySpec: qualitySpec ?? this.qualitySpec,
      priceHistory: priceHistory ?? this.priceHistory,
      currentPrice: currentPrice ?? this.currentPrice,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      availabilityScore: availabilityScore ?? this.availabilityScore,
      palatabilityScore: palatabilityScore ?? this.palatabilityScore,
      digestibilityScore: digestibilityScore ?? this.digestibilityScore,
      suitableSpecies: suitableSpecies ?? this.suitableSpecies,
      restrictions: restrictions ?? this.restrictions,
      maxInclusionRate: maxInclusionRate ?? this.maxInclusionRate,
      storageRequirements: storageRequirements ?? this.storageRequirements,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      supplier: supplier ?? this.supplier,
      origin: origin ?? this.origin,
      certification: certification ?? this.certification,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }
}
