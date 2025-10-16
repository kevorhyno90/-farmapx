import 'dart:math' as math;

enum AnimalSpecies {
  cattle,
  swine,
  poultry,
  sheep,
  goat,
  horses,
  fish,
  rabbits,
}

enum ProductionStage {
  starter,
  grower,
  finisher,
  maintenance,
  breeding,
  lactation,
  gestation,
  layer,
  broiler,
  replacement,
}

enum PoultryType {
  broiler,
  layer,
  breeder,
  turkey,
  duck,
  goose,
}

enum SwineType {
  piglet,
  grower,
  finisher,
  sow_gestation,
  sow_lactation,
  boar,
}

enum CattleType {
  dairy_cow,
  beef_cow,
  calf,
  heifer,
  bull,
  steer,
}

class NutritionalRequirement {
  final String nutrient;
  final double minimum;
  final double? maximum;
  final String unit;
  final bool isCritical;
  final String description;

  const NutritionalRequirement({
    required this.nutrient,
    required this.minimum,
    this.maximum,
    required this.unit,
    this.isCritical = false,
    this.description = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'nutrient': nutrient,
      'minimum': minimum,
      'maximum': maximum,
      'unit': unit,
      'isCritical': isCritical,
      'description': description,
    };
  }

  factory NutritionalRequirement.fromJson(Map<String, dynamic> json) {
    return NutritionalRequirement(
      nutrient: json['nutrient'],
      minimum: json['minimum'].toDouble(),
      maximum: json['maximum']?.toDouble(),
      unit: json['unit'],
      isCritical: json['isCritical'] ?? false,
      description: json['description'] ?? '',
    );
  }
}

class AnimalRequirements {
  final AnimalSpecies species;
  final ProductionStage stage;
  final String? subType; // For specific types like broiler, layer, etc.
  final double liveWeight; // kg
  final double? dailyGain; // kg/day
  final double? milkProduction; // kg/day
  final double? eggProduction; // eggs/day
  final List<NutritionalRequirement> requirements;
  final String description;
  final String source; // NRC, etc.

  const AnimalRequirements({
    required this.species,
    required this.stage,
    this.subType,
    required this.liveWeight,
    this.dailyGain,
    this.milkProduction,
    this.eggProduction,
    required this.requirements,
    this.description = '',
    this.source = 'NRC',
  });

  Map<String, dynamic> toJson() {
    return {
      'species': species.toString(),
      'stage': stage.toString(),
      'subType': subType,
      'liveWeight': liveWeight,
      'dailyGain': dailyGain,
      'milkProduction': milkProduction,
      'eggProduction': eggProduction,
      'requirements': requirements.map((r) => r.toJson()).toList(),
      'description': description,
      'source': source,
    };
  }

  factory AnimalRequirements.fromJson(Map<String, dynamic> json) {
    return AnimalRequirements(
      species: AnimalSpecies.values.firstWhere(
        (e) => e.toString() == json['species'],
      ),
      stage: ProductionStage.values.firstWhere(
        (e) => e.toString() == json['stage'],
      ),
      subType: json['subType'],
      liveWeight: json['liveWeight'].toDouble(),
      dailyGain: json['dailyGain']?.toDouble(),
      milkProduction: json['milkProduction']?.toDouble(),
      eggProduction: json['eggProduction']?.toDouble(),
      requirements: (json['requirements'] as List)
          .map((r) => NutritionalRequirement.fromJson(r))
          .toList(),
      description: json['description'] ?? '',
      source: json['source'] ?? 'NRC',
    );
  }

  // Helper method to get requirement by nutrient name
  NutritionalRequirement? getRequirement(String nutrient) {
    try {
      return requirements.firstWhere(
        (req) => req.nutrient.toLowerCase() == nutrient.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get daily dry matter intake estimate (kg/day)
  double get estimatedDMI {
    switch (species) {
      case AnimalSpecies.cattle:
        if (stage == ProductionStage.lactation) {
          // Lactating dairy cow: 3-4% of BW + 0.35 * milk yield
          return (liveWeight * 0.035) + (0.35 * (milkProduction ?? 0));
        } else if (stage == ProductionStage.grower) {
          // Growing cattle: 2.5-3% of BW
          return liveWeight * 0.028;
        } else {
          // Maintenance: 2% of BW
          return liveWeight * 0.02;
        }

      case AnimalSpecies.swine:
        if (stage == ProductionStage.lactation) {
          // Lactating sow: 1.5-2.5% of BW + 0.5 * litter size
          return (liveWeight * 0.02) + (0.5 * 10); // Assume 10 piglets
        } else if (stage == ProductionStage.grower) {
          // Growing pigs: 3-4% of BW
          return liveWeight * 0.035;
        } else {
          // Maintenance: 2.5% of BW
          return liveWeight * 0.025;
        }

      case AnimalSpecies.poultry:
        if (subType == 'broiler') {
          // Broiler: 7-12% of BW depending on age
          if (liveWeight < 1.0) {
            return liveWeight * 0.10; // Young birds
          } else {
            return liveWeight * 0.08; // Older birds
          }
        } else if (subType == 'layer') {
          // Layer: 10-12% of BW
          return liveWeight * 0.11;
        } else {
          return liveWeight * 0.10;
        }

      case AnimalSpecies.sheep:
      case AnimalSpecies.goat:
        if (stage == ProductionStage.lactation) {
          return (liveWeight * 0.03) + (0.4 * (milkProduction ?? 0));
        } else {
          return liveWeight * 0.025;
        }

      default:
        return liveWeight * 0.025; // Default 2.5% of BW
    }
  }

  // Get metabolizable energy requirement (Mcal/day)
  double get dailyEnergyRequirement {
    final energyReq = getRequirement('metabolizable_energy');
    if (energyReq != null) {
      return energyReq.minimum * estimatedDMI;
    }

    // Fallback calculations
    switch (species) {
      case AnimalSpecies.cattle:
        if (stage == ProductionStage.lactation) {
          double maintenance = 0.077 * math.pow(liveWeight, 0.75);
          double lactation = 0.74 * (milkProduction ?? 0);
          return maintenance + lactation;
        } else if (stage == ProductionStage.grower) {
          double maintenance = 0.077 * math.pow(liveWeight, 0.75);
          double gain = 4.4 * (dailyGain ?? 0);
          return maintenance + gain;
        } else {
          return 0.077 * math.pow(liveWeight, 0.75); // Maintenance only
        }

      case AnimalSpecies.swine:
        if (stage == ProductionStage.grower) {
          return 0.11 * math.pow(liveWeight, 0.75) + (4.5 * (dailyGain ?? 0));
        } else {
          return 0.11 * math.pow(liveWeight, 0.75);
        }

      case AnimalSpecies.poultry:
        if (subType == 'broiler') {
          return 0.12 * math.pow(liveWeight, 0.75) + (5.0 * (dailyGain ?? 0));
        } else if (subType == 'layer') {
          double maintenance = 0.12 * math.pow(liveWeight, 0.75);
          double eggProduction = 1.9 * (this.eggProduction ?? 0);
          return maintenance + eggProduction;
        } else {
          return 0.12 * math.pow(liveWeight, 0.75);
        }

      default:
        return 0.08 * math.pow(liveWeight, 0.75); // Generic maintenance
    }
  }

  // Get crude protein requirement (g/day)
  double get dailyProteinRequirement {
    final proteinReq = getRequirement('crude_protein');
    if (proteinReq != null) {
      return (proteinReq.minimum / 100) * estimatedDMI * 1000; // Convert to g/day
    }

    // Fallback calculations
    switch (species) {
      case AnimalSpecies.cattle:
        if (stage == ProductionStage.lactation) {
          double maintenance = 3.8 * math.pow(liveWeight, 0.75);
          double lactation = 93.0 * (milkProduction ?? 0);
          return maintenance + lactation;
        } else {
          return 3.8 * math.pow(liveWeight, 0.75);
        }

      case AnimalSpecies.swine:
        if (stage == ProductionStage.grower) {
          return 120.0 * (dailyGain ?? 0) + (2.0 * liveWeight);
        } else {
          return 2.0 * liveWeight;
        }

      case AnimalSpecies.poultry:
        if (subType == 'broiler') {
          return 145.0 * (dailyGain ?? 0) + (1.5 * liveWeight);
        } else if (subType == 'layer') {
          return 1.5 * liveWeight + (2.1 * (eggProduction ?? 0));
        } else {
          return 1.5 * liveWeight;
        }

      default:
        return 2.0 * liveWeight;
    }
  }
}