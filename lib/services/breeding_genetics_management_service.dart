import 'package:flutter/material.dart';
import '../models/comprehensive_animal_record.dart';

/// Advanced breeding and genetics management service
class BreedingGeneticsManagementService {
  final List<GeneticLineage> _geneticLineages = [];
  final List<BreedingPlan> _breedingPlans = [];
  final List<ArtificialInseminationLog> _aiLogs = [];
  final List<ReproductivePerformanceAnalysis> _performanceAnalyses = [];

  // Getters
  List<GeneticLineage> get geneticLineages => _geneticLineages;
  List<BreedingPlan> get breedingPlans => _breedingPlans;
  List<ArtificialInseminationLog> get aiLogs => _aiLogs;
  List<ReproductivePerformanceAnalysis> get performanceAnalyses => _performanceAnalyses;

  /// Create genetic lineage tracking
  void createGeneticLineage(GeneticLineage lineage) {
    _geneticLineages.add(lineage);
  }

  /// Generate breeding recommendations based on genetics and performance
  List<BreedingRecommendation> generateBreedingRecommendations(
    ComprehensiveAnimalRecord female,
    List<ComprehensiveAnimalRecord> availableMales,
  ) {
    final recommendations = <BreedingRecommendation>[];
    
    for (final male in availableMales) {
      final compatibility = _calculateGeneticCompatibility(female, male);
      final predictedOffspringTraits = _predictOffspringTraits(female, male);
      final inbreedingCoefficient = _calculateInbreedingCoefficient(female, male);
      
      recommendations.add(BreedingRecommendation(
        femaleId: female.id,
        femaleName: female.name,
        maleId: male.id,
        maleName: male.name,
        compatibilityScore: compatibility,
        predictedTraits: predictedOffspringTraits,
        inbreedingCoefficient: inbreedingCoefficient,
        expectedBenefits: _getExpectedBenefits(female, male),
        potentialRisks: _getPotentialRisks(female, male, inbreedingCoefficient),
        recommendationReason: _getRecommendationReason(compatibility, inbreedingCoefficient),
      ));
    }
    
    // Sort by compatibility score descending
    recommendations.sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
    return recommendations;
  }

  /// Track artificial insemination procedures
  void logArtificialInsemination(ArtificialInseminationLog log) {
    _aiLogs.add(log);
  }

  /// Analyze reproductive performance
  ReproductivePerformanceAnalysis analyzeReproductivePerformance(
    ComprehensiveAnimalRecord animal,
  ) {
    final breedingRecords = animal.breedingHistory;
    final pregnancyRecords = animal.pregnancies;
    
    final totalBreedings = breedingRecords.length;
    final successfulPregnancies = pregnancyRecords
        .where((p) => p.status == 'calved' || p.status == 'pregnant')
        .length;
    
    final conceptionRate = totalBreedings > 0 ? 
        (successfulPregnancies / totalBreedings) * 100 : 0.0;
    
    final averageGestationDays = pregnancyRecords
        .where((p) => p.status == 'calved')
        .map((p) => p.expectedDueDate != null && p.breedingDate != null ?
            p.expectedDueDate!.difference(p.breedingDate).inDays : 0)
        .where((days) => days > 0)
        .fold<double>(0, (sum, days) => sum + days) / 
        pregnancyRecords.where((p) => p.status == 'calved').length;
    
    final offspring = animal.offspring;
    final liveOffspringRate = offspring.isNotEmpty ?
        (offspring.where((o) => o.status == 'alive').length / offspring.length) * 100 : 0.0;
    
    return ReproductivePerformanceAnalysis(
      animalId: animal.id,
      animalName: animal.name,
      totalBreedings: totalBreedings,
      successfulPregnancies: successfulPregnancies,
      conceptionRate: conceptionRate,
      averageGestationDays: averageGestationDays,
      totalOffspring: offspring.length,
      liveOffspringRate: liveOffspringRate,
      averageBirthWeight: _calculateAverageBirthWeight(offspring),
      breedingEfficiencyScore: _calculateBreedingEfficiencyScore(
        conceptionRate, liveOffspringRate, averageGestationDays,
      ),
      recommendations: _generateReproductiveRecommendations(
        conceptionRate, liveOffspringRate, averageGestationDays,
      ),
      analysisDate: DateTime.now(),
    );
  }

  /// Get breeding calendar for upcoming activities
  List<BreedingCalendarEvent> getBreedingCalendar(
    List<ComprehensiveAnimalRecord> animals,
    DateTime startDate,
    DateTime endDate,
  ) {
    final events = <BreedingCalendarEvent>[];
    
    for (final animal in animals) {
      // Add expected breeding dates
      for (final pregnancy in animal.pregnancies) {
        if (pregnancy.status == 'pregnant' && pregnancy.expectedDueDate != null) {
          final dueDate = pregnancy.expectedDueDate!;
          if (dueDate.isAfter(startDate) && dueDate.isBefore(endDate)) {
            events.add(BreedingCalendarEvent(
              date: dueDate,
              type: 'Expected Calving',
              animalId: animal.id,
              animalName: animal.name,
              description: 'Expected calving date',
              priority: 'High',
            ));
          }
        }
      }
      
      // Add breeding schedule based on cycles
      final lastBreeding = animal.breedingHistory.isNotEmpty ?
          animal.breedingHistory.reduce((a, b) => a.breedingDate.isAfter(b.breedingDate) ? a : b) : null;
      
      if (lastBreeding != null && lastBreeding.status == 'failed') {
        final nextBreedingDate = lastBreeding.breedingDate.add(Duration(days: 21)); // Typical cycle
        if (nextBreedingDate.isAfter(startDate) && nextBreedingDate.isBefore(endDate)) {
          events.add(BreedingCalendarEvent(
            date: nextBreedingDate,
            type: 'Breeding Opportunity',
            animalId: animal.id,
            animalName: animal.name,
            description: 'Next breeding opportunity',
            priority: 'Medium',
          ));
        }
      }
    }
    
    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  /// Calculate genetic diversity metrics for the herd
  GeneticDiversityMetrics calculateGeneticDiversity(List<ComprehensiveAnimalRecord> animals) {
    final bloodlines = <String, int>{};
    final breeds = <String, int>{};
    
    for (final animal in animals) {
      breeds[animal.breed] = (breeds[animal.breed] ?? 0) + 1;
      if (animal.geneticLine != null) {
        bloodlines[animal.geneticLine!] = (bloodlines[animal.geneticLine!] ?? 0) + 1;
      }
    }
    
    final breedDiversityIndex = _calculateDiversityIndex(breeds.values.toList());
    final bloodlineDiversityIndex = _calculateDiversityIndex(bloodlines.values.toList());
    
    return GeneticDiversityMetrics(
      totalAnimals: animals.length,
      numberOfBreeds: breeds.length,
      numberOfBloodlines: bloodlines.length,
      breedDiversityIndex: breedDiversityIndex,
      bloodlineDiversityIndex: bloodlineDiversityIndex,
      breedDistribution: breeds,
      bloodlineDistribution: bloodlines,
      inbreedingRisk: _assessInbreedingRisk(animals),
      recommendations: _generateDiversityRecommendations(breedDiversityIndex, bloodlineDiversityIndex),
    );
  }

  // Private helper methods
  double _calculateGeneticCompatibility(ComprehensiveAnimalRecord female, ComprehensiveAnimalRecord male) {
    double score = 100.0;
    
    // Reduce score for same bloodline
    if (female.geneticLine == male.geneticLine && female.geneticLine != null) {
      score -= 30.0;
    }
    
    // Reduce score for common ancestors
    if (female.sireId == male.sireId || female.damId == male.damId) {
      score -= 40.0;
    }
    
    // Add score for complementary traits
    final femaleTraits = female.geneticTraits;
    final maleTraits = male.geneticTraits;
    
    if (femaleTraits.isNotEmpty && maleTraits.isNotEmpty) {
      // Example: milk production traits
      final femaleMilkProduction = femaleTraits['milkProduction'] as double? ?? 0.0;
      final maleMilkProduction = maleTraits['milkProduction'] as double? ?? 0.0;
      
      if (femaleMilkProduction < 80 && maleMilkProduction > 90) {
        score += 15.0; // Male can improve female's milk production genetics
      }
    }
    
    return score.clamp(0.0, 100.0);
  }

  Map<String, dynamic> _predictOffspringTraits(ComprehensiveAnimalRecord female, ComprehensiveAnimalRecord male) {
    final predictedTraits = <String, dynamic>{};
    
    // Combine parental traits
    final femaleTraits = female.geneticTraits;
    final maleTraits = male.geneticTraits;
    
    // Simple inheritance model (average of parents with some variation)
    if (femaleTraits.containsKey('milkProduction') && maleTraits.containsKey('milkProduction')) {
      final femaleMilk = femaleTraits['milkProduction'] as double;
      final maleMilk = maleTraits['milkProduction'] as double;
      predictedTraits['milkProduction'] = (femaleMilk + maleMilk) / 2;
    }
    
    if (femaleTraits.containsKey('growthRate') && maleTraits.containsKey('growthRate')) {
      final femaleGrowth = femaleTraits['growthRate'] as double;
      final maleGrowth = maleTraits['growthRate'] as double;
      predictedTraits['growthRate'] = (femaleGrowth + maleGrowth) / 2;
    }
    
    return predictedTraits;
  }

  double _calculateInbreedingCoefficient(ComprehensiveAnimalRecord female, ComprehensiveAnimalRecord male) {
    // Simplified inbreeding coefficient calculation
    double coefficient = 0.0;
    
    // Same sire or dam
    if (female.sireId == male.sireId || female.damId == male.damId) {
      coefficient += 0.25; // Half siblings
    }
    
    // Same grandparents (would need more genealogy data)
    // This is a simplified version
    
    return coefficient;
  }

  List<String> _getExpectedBenefits(ComprehensiveAnimalRecord female, ComprehensiveAnimalRecord male) {
    final benefits = <String>[];
    
    final femaleTraits = female.geneticTraits;
    final maleTraits = male.geneticTraits;
    
    if (maleTraits.containsKey('milkProduction')) {
      final maleMilk = maleTraits['milkProduction'] as double? ?? 0.0;
      if (maleMilk > 85) {
        benefits.add('Improved milk production genetics');
      }
    }
    
    if (maleTraits.containsKey('growthRate')) {
      final maleGrowth = maleTraits['growthRate'] as double? ?? 0.0;
      if (maleGrowth > 80) {
        benefits.add('Enhanced growth rate potential');
      }
    }
    
    return benefits;
  }

  List<String> _getPotentialRisks(ComprehensiveAnimalRecord female, ComprehensiveAnimalRecord male, double inbreedingCoeff) {
    final risks = <String>[];
    
    if (inbreedingCoeff > 0.125) {
      risks.add('High inbreeding risk - genetic defects possible');
    } else if (inbreedingCoeff > 0.06) {
      risks.add('Moderate inbreeding risk - monitor offspring closely');
    }
    
    if (female.healthHistory.any((h) => h.condition.contains('genetic'))) {
      risks.add('Female has history of genetic conditions');
    }
    
    return risks;
  }

  String _getRecommendationReason(double compatibility, double inbreedingCoeff) {
    if (compatibility > 85 && inbreedingCoeff < 0.06) {
      return 'Excellent genetic match with low inbreeding risk';
    } else if (compatibility > 70 && inbreedingCoeff < 0.125) {
      return 'Good genetic compatibility with acceptable risk';
    } else if (inbreedingCoeff > 0.125) {
      return 'Not recommended due to high inbreeding risk';
    } else {
      return 'Moderate compatibility - consider other options';
    }
  }

  double _calculateAverageBirthWeight(List<OffspringRecord> offspring) {
    final weightsWithData = offspring.where((o) => o.birthWeight != null).toList();
    if (weightsWithData.isEmpty) return 0.0;
    
    final totalWeight = weightsWithData.fold<double>(0.0, (sum, o) => sum + o.birthWeight!);
    return totalWeight / weightsWithData.length;
  }

  double _calculateBreedingEfficiencyScore(double conceptionRate, double liveOffspringRate, double avgGestation) {
    // Weighted scoring system
    final conceptionScore = conceptionRate * 0.4; // 40% weight
    final offspringScore = liveOffspringRate * 0.4; // 40% weight
    final gestationScore = avgGestation > 0 ? 
        ((280 - (avgGestation - 280).abs()) / 280) * 100 * 0.2 : 0; // 20% weight (closer to 280 days is better)
    
    return conceptionScore + offspringScore + gestationScore;
  }

  List<String> _generateReproductiveRecommendations(double conceptionRate, double liveOffspringRate, double avgGestation) {
    final recommendations = <String>[];
    
    if (conceptionRate < 70) {
      recommendations.add('Consider nutritional supplementation to improve conception rate');
      recommendations.add('Evaluate breeding timing and heat detection methods');
    }
    
    if (liveOffspringRate < 90) {
      recommendations.add('Review prenatal care and monitoring protocols');
      recommendations.add('Consider genetic screening for reproductive issues');
    }
    
    if (avgGestation > 290) {
      recommendations.add('Monitor for breeding date accuracy');
      recommendations.add('Consider genetic factors affecting gestation length');
    }
    
    return recommendations;
  }

  double _calculateDiversityIndex(List<int> counts) {
    final total = counts.fold(0, (sum, count) => sum + count);
    if (total == 0) return 0.0;
    
    // Shannon diversity index
    double index = 0.0;
    for (final count in counts) {
      if (count > 0) {
        final proportion = count / total;
        index -= proportion * (log(proportion) / log(2));
      }
    }
    return index;
  }

  String _assessInbreedingRisk(List<ComprehensiveAnimalRecord> animals) {
    // Simplified assessment based on bloodline concentration
    final bloodlines = <String, int>{};
    for (final animal in animals) {
      if (animal.geneticLine != null) {
        bloodlines[animal.geneticLine!] = (bloodlines[animal.geneticLine!] ?? 0) + 1;
      }
    }
    
    if (bloodlines.isEmpty) return 'Unknown - no genetic line data';
    
    final maxConcentration = bloodlines.values.reduce((a, b) => a > b ? a : b);
    final concentrationPercentage = (maxConcentration / animals.length) * 100;
    
    if (concentrationPercentage > 50) return 'High Risk';
    if (concentrationPercentage > 30) return 'Moderate Risk';
    return 'Low Risk';
  }

  List<String> _generateDiversityRecommendations(double breedDiversity, double bloodlineDiversity) {
    final recommendations = <String>[];
    
    if (breedDiversity < 1.5) {
      recommendations.add('Consider introducing animals from different breeds');
    }
    
    if (bloodlineDiversity < 2.0) {
      recommendations.add('Diversify genetic lines to reduce inbreeding risk');
      recommendations.add('Consider outcrossing to unrelated bloodlines');
    }
    
    return recommendations;
  }
}

// Supporting classes for the breeding and genetics management

class GeneticLineage {
  final String id;
  final String name;
  final String species;
  final String originCountry;
  final List<String> keyTraits;
  final Map<String, dynamic> averagePerformance;
  final List<String> knownGeneticIssues;
  final DateTime establishedDate;

  GeneticLineage({
    required this.id,
    required this.name,
    required this.species,
    required this.originCountry,
    required this.keyTraits,
    required this.averagePerformance,
    required this.knownGeneticIssues,
    required this.establishedDate,
  });
}

class BreedingPlan {
  final String id;
  final String name;
  final List<String> targetTraits;
  final List<BreedingGoal> goals;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;
  final List<String> participatingAnimals;

  BreedingPlan({
    required this.id,
    required this.name,
    required this.targetTraits,
    required this.goals,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.participatingAnimals,
  });
}

class BreedingGoal {
  final String trait;
  final String direction; // increase, decrease, maintain
  final double targetValue;
  final int timeframeYears;

  BreedingGoal({
    required this.trait,
    required this.direction,
    required this.targetValue,
    required this.timeframeYears,
  });
}

class ArtificialInseminationLog {
  final String id;
  final String femaleId;
  final String semenSource;
  final String bullId;
  final DateTime inseminationDate;
  final String technician;
  final String semenBatch;
  final DateTime semenCollectionDate;
  final String method; // Fresh, Frozen, Sexed
  final String notes;

  ArtificialInseminationLog({
    required this.id,
    required this.femaleId,
    required this.semenSource,
    required this.bullId,
    required this.inseminationDate,
    required this.technician,
    required this.semenBatch,
    required this.semenCollectionDate,
    required this.method,
    required this.notes,
  });
}

class ReproductivePerformanceAnalysis {
  final String animalId;
  final String animalName;
  final int totalBreedings;
  final int successfulPregnancies;
  final double conceptionRate;
  final double averageGestationDays;
  final int totalOffspring;
  final double liveOffspringRate;
  final double averageBirthWeight;
  final double breedingEfficiencyScore;
  final List<String> recommendations;
  final DateTime analysisDate;

  ReproductivePerformanceAnalysis({
    required this.animalId,
    required this.animalName,
    required this.totalBreedings,
    required this.successfulPregnancies,
    required this.conceptionRate,
    required this.averageGestationDays,
    required this.totalOffspring,
    required this.liveOffspringRate,
    required this.averageBirthWeight,
    required this.breedingEfficiencyScore,
    required this.recommendations,
    required this.analysisDate,
  });
}

class BreedingRecommendation {
  final String femaleId;
  final String femaleName;
  final String maleId;
  final String maleName;
  final double compatibilityScore;
  final Map<String, dynamic> predictedTraits;
  final double inbreedingCoefficient;
  final List<String> expectedBenefits;
  final List<String> potentialRisks;
  final String recommendationReason;

  BreedingRecommendation({
    required this.femaleId,
    required this.femaleName,
    required this.maleId,
    required this.maleName,
    required this.compatibilityScore,
    required this.predictedTraits,
    required this.inbreedingCoefficient,
    required this.expectedBenefits,
    required this.potentialRisks,
    required this.recommendationReason,
  });
}

class BreedingCalendarEvent {
  final DateTime date;
  final String type;
  final String animalId;
  final String animalName;
  final String description;
  final String priority;

  BreedingCalendarEvent({
    required this.date,
    required this.type,
    required this.animalId,
    required this.animalName,
    required this.description,
    required this.priority,
  });
}

class GeneticDiversityMetrics {
  final int totalAnimals;
  final int numberOfBreeds;
  final int numberOfBloodlines;
  final double breedDiversityIndex;
  final double bloodlineDiversityIndex;
  final Map<String, int> breedDistribution;
  final Map<String, int> bloodlineDistribution;
  final String inbreedingRisk;
  final List<String> recommendations;

  GeneticDiversityMetrics({
    required this.totalAnimals,
    required this.numberOfBreeds,
    required this.numberOfBloodlines,
    required this.breedDiversityIndex,
    required this.bloodlineDiversityIndex,
    required this.breedDistribution,
    required this.bloodlineDistribution,
    required this.inbreedingRisk,
    required this.recommendations,
  });
}

// Helper function for logarithm calculation
double log(double x) => math.log(x);

import 'dart:math' as math;