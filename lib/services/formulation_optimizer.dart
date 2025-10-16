import 'dart:math' as math;
import '../models/feed_ingredient.dart';
import '../models/nutritional_requirements.dart';

class FormulationConstraint {
  final String nutrient;
  final double? minimum;
  final double? maximum;
  final String unit;
  final bool isHard; // Hard constraint vs soft constraint
  final double penalty; // Penalty factor for soft constraints

  const FormulationConstraint({
    required this.nutrient,
    this.minimum,
    this.maximum,
    required this.unit,
    this.isHard = true,
    this.penalty = 1.0,
  });
}

class FormulationResult {
  final Map<String, double> ingredientPercentages;
  final double totalCost;
  final double costPerTon;
  final Map<String, double> nutritionalProfile;
  final List<String> constraintViolations;
  final List<String> warnings;
  final double feasibilityScore; // 0-100, 100 = fully feasible
  final String status; // 'optimal', 'suboptimal', 'infeasible'

  const FormulationResult({
    required this.ingredientPercentages,
    required this.totalCost,
    required this.costPerTon,
    required this.nutritionalProfile,
    this.constraintViolations = const [],
    this.warnings = const [],
    this.feasibilityScore = 100.0,
    this.status = 'optimal',
  });
}

class FormulationOptimizer {
  static const int maxIterations = 1000;
  static const double tolerance = 1e-6;
  static const double convergenceThreshold = 1e-8;

  /// Main optimization method using Simplex algorithm for linear programming
  static FormulationResult optimizeFormulation({
    required List<FeedIngredient> availableIngredients,
    required AnimalRequirements animalRequirements,
    required List<FormulationConstraint> constraints,
    Map<String, double> ingredientLimits = const {},
    String objective = 'minimize_cost',
    double targetWeight = 1000.0, // kg (1 ton)
  }) {
    try {
      // Filter out ingredients with no nutritional data
      final validIngredients = availableIngredients
          .where((ing) => ing.nutritionalProfile.crudeProtein != null)
          .toList();

      if (validIngredients.isEmpty) {
        return FormulationResult(
          ingredientPercentages: {},
          totalCost: 0.0,
          costPerTon: 0.0,
          nutritionalProfile: {},
          constraintViolations: ['No valid ingredients available'],
          status: 'infeasible',
          feasibilityScore: 0.0,
        );
      }

      // Set up the linear programming problem
      final result = _solveLeastCostFormulation(
        validIngredients,
        animalRequirements,
        constraints,
        ingredientLimits,
        targetWeight,
      );

      return result;
    } catch (e) {
      return FormulationResult(
        ingredientPercentages: {},
        totalCost: 0.0,
        costPerTon: 0.0,
        nutritionalProfile: {},
        constraintViolations: ['Optimization error: ${e.toString()}'],
        status: 'error',
        feasibilityScore: 0.0,
      );
    }
  }

  static FormulationResult _solveLeastCostFormulation(
    List<FeedIngredient> ingredients,
    AnimalRequirements animalRequirements,
    List<FormulationConstraint> constraints,
    Map<String, double> ingredientLimits,
    double targetWeight,
  ) {
    final n = ingredients.length; // Number of variables (ingredients)
    
    // Initialize solution with equal percentages
    List<double> solution = List.filled(n, 100.0 / n);
    
    // Use iterative improvement algorithm (simplified simplex-like approach)
    for (int iteration = 0; iteration < maxIterations; iteration++) {
      final currentCost = _calculateCost(solution, ingredients);
      final improved = _improveFormulation(
        solution,
        ingredients,
        animalRequirements,
        constraints,
        ingredientLimits,
      );
      
      final newCost = _calculateCost(improved, ingredients);
      
      // Check for convergence
      if ((currentCost - newCost).abs() < convergenceThreshold) {
        solution = improved;
        break;
      }
      
      solution = improved;
    }

    // Normalize solution to ensure it sums to 100%
    final sum = solution.fold(0.0, (a, b) => a + b);
    if (sum > 0) {
      solution = solution.map((x) => x / sum * 100.0).toList();
    }

    // Build result
    final ingredientPercentages = <String, double>{};
    for (int i = 0; i < ingredients.length; i++) {
      if (solution[i] > 0.001) { // Only include ingredients with >0.1%
        ingredientPercentages[ingredients[i].id] = solution[i];
      }
    }

    final nutritionalProfile = _calculateNutritionalProfile(solution, ingredients);
    final violations = _checkConstraints(nutritionalProfile, constraints);
    final warnings = _generateWarnings(solution, ingredients, animalRequirements);
    final feasibilityScore = _calculateFeasibilityScore(nutritionalProfile, constraints);
    
    final totalCost = _calculateCost(solution, ingredients) * targetWeight / 100;
    final costPerTon = _calculateCost(solution, ingredients) * 10; // Cost per ton

    return FormulationResult(
      ingredientPercentages: ingredientPercentages,
      totalCost: totalCost,
      costPerTon: costPerTon,
      nutritionalProfile: nutritionalProfile,
      constraintViolations: violations,
      warnings: warnings,
      feasibilityScore: feasibilityScore,
      status: violations.isEmpty ? 'optimal' : 'suboptimal',
    );
  }

  static List<double> _improveFormulation(
    List<double> current,
    List<FeedIngredient> ingredients,
    AnimalRequirements animalRequirements,
    List<FormulationConstraint> constraints,
    Map<String, double> ingredientLimits,
  ) {
    final improved = List<double>.from(current);
    final stepSize = 0.5; // Adjustment step size

    for (int i = 0; i < ingredients.length; i++) {
      for (int j = i + 1; j < ingredients.length; j++) {
        // Try swapping small amounts between ingredients
        final originalI = improved[i];
        final originalJ = improved[j];
        
        // Check if we can transfer from j to i
        if (originalJ > stepSize) {
          improved[i] = originalI + stepSize;
          improved[j] = originalJ - stepSize;
          
          // Apply ingredient limits
          final limitI = ingredientLimits[ingredients[i].id] ?? 100.0;
          final limitJ = ingredientLimits[ingredients[j].id] ?? 100.0;
          
          if (improved[i] > limitI) {
            improved[i] = limitI;
            improved[j] = originalJ - (limitI - originalI);
          }
          
          if (improved[j] < 0) {
            improved[j] = 0;
            improved[i] = originalI + originalJ;
          }
          
          // Check if this improves the formulation
          final currentProfile = _calculateNutritionalProfile(current, ingredients);
          final improvedProfile = _calculateNutritionalProfile(improved, ingredients);
          
          final currentScore = _evaluateFormulation(currentProfile, constraints, current, ingredients);
          final improvedScore = _evaluateFormulation(improvedProfile, constraints, improved, ingredients);
          
          if (improvedScore <= currentScore) {
            // Revert if no improvement
            improved[i] = originalI;
            improved[j] = originalJ;
          }
        }
      }
    }

    return improved;
  }

  static double _evaluateFormulation(
    Map<String, double> nutritionalProfile,
    List<FormulationConstraint> constraints,
    List<double> percentages,
    List<FeedIngredient> ingredients,
  ) {
    double cost = _calculateCost(percentages, ingredients);
    double penalty = 0.0;

    // Add penalties for constraint violations
    for (final constraint in constraints) {
      final value = nutritionalProfile[constraint.nutrient] ?? 0.0;
      
      if (constraint.minimum != null && value < constraint.minimum!) {
        penalty += constraint.penalty * (constraint.minimum! - value).abs();
      }
      
      if (constraint.maximum != null && value > constraint.maximum!) {
        penalty += constraint.penalty * (value - constraint.maximum!).abs();
      }
    }

    return cost + penalty;
  }

  static double _calculateCost(List<double> percentages, List<FeedIngredient> ingredients) {
    double cost = 0.0;
    for (int i = 0; i < ingredients.length; i++) {
      cost += (percentages[i] / 100.0) * ingredients[i].currentPrice;
    }
    return cost;
  }

  static Map<String, double> _calculateNutritionalProfile(
    List<double> percentages,
    List<FeedIngredient> ingredients,
  ) {
    final profile = <String, double>{};
    
    // Initialize all nutrients to 0
    profile['crude_protein'] = 0.0;
    profile['crude_fat'] = 0.0;
    profile['crude_fiber'] = 0.0;
    profile['ash'] = 0.0;
    profile['metabolizable_energy'] = 0.0;
    profile['digestible_energy'] = 0.0;
    profile['calcium'] = 0.0;
    profile['phosphorus'] = 0.0;
    profile['lysine'] = 0.0;
    profile['methionine'] = 0.0;
    profile['threonine'] = 0.0;

    for (int i = 0; i < ingredients.length; i++) {
      final ingredient = ingredients[i];
      final percentage = percentages[i] / 100.0;
      final nutrition = ingredient.nutritionalProfile;

      // Proximate analysis
      if (nutrition.crudeProtein != null) {
        profile['crude_protein'] = profile['crude_protein']! + (nutrition.crudeProtein! * percentage);
      }
      if (nutrition.crudeFat != null) {
        profile['crude_fat'] = profile['crude_fat']! + (nutrition.crudeFat! * percentage);
      }
      if (nutrition.adf != null) {
        profile['crude_fiber'] = profile['crude_fiber']! + (nutrition.adf! * percentage);
      }
      if (nutrition.ash != null) {
        profile['ash'] = profile['ash']! + (nutrition.ash! * percentage);
      }

      // Energy
      if (nutrition.metabolizableEnergy != null) {
        profile['metabolizable_energy'] = profile['metabolizable_energy']! + (nutrition.metabolizableEnergy! * percentage);
      }
      if (nutrition.digestibleEnergy != null) {
        profile['digestible_energy'] = profile['digestible_energy']! + (nutrition.digestibleEnergy! * percentage);
      }

      // Minerals
      if (nutrition.minerals != null) {
        if (nutrition.minerals!.calcium != null) {
          profile['calcium'] = profile['calcium']! + (nutrition.minerals!.calcium! * percentage);
        }
        if (nutrition.minerals!.phosphorus != null) {
          profile['phosphorus'] = profile['phosphorus']! + (nutrition.minerals!.phosphorus! * percentage);
        }
      }

      // Amino acids
      if (nutrition.aminoAcids != null) {
        if (nutrition.aminoAcids!.lysine != null) {
          profile['lysine'] = profile['lysine']! + (nutrition.aminoAcids!.lysine! * percentage);
        }
        if (nutrition.aminoAcids!.methionine != null) {
          profile['methionine'] = profile['methionine']! + (nutrition.aminoAcids!.methionine! * percentage);
        }
        if (nutrition.aminoAcids!.threonine != null) {
          profile['threonine'] = profile['threonine']! + (nutrition.aminoAcids!.threonine! * percentage);
        }
      }
    }

    return profile;
  }

  static List<String> _checkConstraints(
    Map<String, double> nutritionalProfile,
    List<FormulationConstraint> constraints,
  ) {
    final violations = <String>[];

    for (final constraint in constraints) {
      final value = nutritionalProfile[constraint.nutrient] ?? 0.0;
      
      if (constraint.minimum != null && value < constraint.minimum!) {
        violations.add(
          '${constraint.nutrient}: ${value.toStringAsFixed(2)} < ${constraint.minimum!.toStringAsFixed(2)} ${constraint.unit}',
        );
      }
      
      if (constraint.maximum != null && value > constraint.maximum!) {
        violations.add(
          '${constraint.nutrient}: ${value.toStringAsFixed(2)} > ${constraint.maximum!.toStringAsFixed(2)} ${constraint.unit}',
        );
      }
    }

    return violations;
  }

  static List<String> _generateWarnings(
    List<double> percentages,
    List<FeedIngredient> ingredients,
    AnimalRequirements animalRequirements,
  ) {
    final warnings = <String>[];

    // Check for high inclusion rates
    for (int i = 0; i < ingredients.length; i++) {
      if (percentages[i] > ingredients[i].maxInclusionRate) {
        warnings.add(
          '${ingredients[i].commonName}: ${percentages[i].toStringAsFixed(1)}% exceeds recommended maximum of ${ingredients[i].maxInclusionRate}%',
        );
      }
    }

    // Check for ingredient diversity
    final activeIngredients = percentages.where((p) => p > 1.0).length;
    if (activeIngredients < 3) {
      warnings.add('Low ingredient diversity - consider using more ingredients');
    }

    // Check for single ingredient dominance
    final maxPercentage = percentages.fold(0.0, math.max);
    if (maxPercentage > 70.0) {
      warnings.add('Single ingredient dominance detected - formulation may lack balance');
    }

    return warnings;
  }

  static double _calculateFeasibilityScore(
    Map<String, double> nutritionalProfile,
    List<FormulationConstraint> constraints,
  ) {
    if (constraints.isEmpty) return 100.0;

    int satisfiedConstraints = 0;
    for (final constraint in constraints) {
      final value = nutritionalProfile[constraint.nutrient] ?? 0.0;
      bool satisfied = true;
      
      if (constraint.minimum != null && value < constraint.minimum!) {
        satisfied = false;
      }
      
      if (constraint.maximum != null && value > constraint.maximum!) {
        satisfied = false;
      }
      
      if (satisfied) satisfiedConstraints++;
    }

    return (satisfiedConstraints / constraints.length) * 100.0;
  }

  /// Generate default constraints based on animal requirements
  static List<FormulationConstraint> generateDefaultConstraints(
    AnimalRequirements animalRequirements,
  ) {
    final constraints = <FormulationConstraint>[];

    // Add constraints from animal requirements
    for (final requirement in animalRequirements.requirements) {
      constraints.add(FormulationConstraint(
        nutrient: requirement.nutrient,
        minimum: requirement.minimum,
        maximum: requirement.maximum,
        unit: requirement.unit,
        isHard: requirement.isCritical,
        penalty: requirement.isCritical ? 100.0 : 10.0,
      ));
    }

    // Add basic constraints for common nutrients if not already present
    final existingNutrients = constraints.map((c) => c.nutrient).toSet();

    if (!existingNutrients.contains('crude_protein')) {
      constraints.add(FormulationConstraint(
        nutrient: 'crude_protein',
        minimum: _getDefaultProteinRequirement(animalRequirements),
        unit: '%',
        isHard: true,
        penalty: 50.0,
      ));
    }

    if (!existingNutrients.contains('metabolizable_energy')) {
      constraints.add(FormulationConstraint(
        nutrient: 'metabolizable_energy',
        minimum: _getDefaultEnergyRequirement(animalRequirements),
        unit: 'kcal/kg',
        isHard: true,
        penalty: 50.0,
      ));
    }

    return constraints;
  }

  static double _getDefaultProteinRequirement(AnimalRequirements animalRequirements) {
    switch (animalRequirements.species) {
      case AnimalSpecies.cattle:
        return animalRequirements.stage == ProductionStage.lactation ? 16.0 : 14.0;
      case AnimalSpecies.swine:
        switch (animalRequirements.stage) {
          case ProductionStage.starter:
            return 20.0;
          case ProductionStage.grower:
            return 16.0;
          case ProductionStage.finisher:
            return 14.0;
          default:
            return 16.0;
        }
      case AnimalSpecies.poultry:
        if (animalRequirements.subType == 'broiler') {
          return animalRequirements.stage == ProductionStage.starter ? 22.0 : 18.0;
        } else {
          return 16.0; // Layer
        }
      default:
        return 14.0;
    }
  }

  static double _getDefaultEnergyRequirement(AnimalRequirements animalRequirements) {
    switch (animalRequirements.species) {
      case AnimalSpecies.cattle:
        return 2500.0;
      case AnimalSpecies.swine:
        return 3200.0;
      case AnimalSpecies.poultry:
        return animalRequirements.subType == 'broiler' ? 3100.0 : 2750.0;
      default:
        return 2500.0;
    }
  }
}