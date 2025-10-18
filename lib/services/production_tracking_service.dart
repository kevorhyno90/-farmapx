import 'package:flutter/material.dart';
import '../models/comprehensive_animal_record.dart';

/// Advanced production tracking service for performance analytics
class ProductionTrackingService {
  final List<ProductionTarget> _productionTargets = [];
  final List<ProductionAlert> _productionAlerts = [];
  final List<FeedConversionAnalysis> _feedConversionAnalyses = [];
  final List<ProductionTrend> _productionTrends = [];

  // Getters
  List<ProductionTarget> get productionTargets => _productionTargets;
  List<ProductionAlert> get productionAlerts => _productionAlerts;
  List<FeedConversionAnalysis> get feedConversionAnalyses => _feedConversionAnalyses;
  List<ProductionTrend> get productionTrends => _productionTrends;

  /// Track milk production with detailed analytics
  MilkProductionAnalysis analyzeMilkProduction(
    ComprehensiveAnimalRecord animal,
    DateTime startDate,
    DateTime endDate,
  ) {
    final milkRecords = animal.productionRecords
        .where((p) => p.type == 'milk' && 
                     p.date.isAfter(startDate) && 
                     p.date.isBefore(endDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (milkRecords.isEmpty) {
      return MilkProductionAnalysis.empty(animal.id, animal.name);
    }

    final totalMilk = milkRecords.fold<double>(0.0, (sum, record) => sum + record.quantity);
    final averageDailyMilk = totalMilk / milkRecords.length;
    final peakProduction = milkRecords.map((r) => r.quantity).reduce((a, b) => a > b ? a : b);
    final lowestProduction = milkRecords.map((r) => r.quantity).reduce((a, b) => a < b ? a : b);
    
    // Calculate lactation curve parameters
    final lactationDay = _calculateLactationDay(animal, milkRecords.first.date);
    final predictedPeakDay = _predictPeakProductionDay(milkRecords);
    final persistency = _calculatePersistency(milkRecords);
    
    // Quality metrics
    final qualityRecords = milkRecords.where((r) => r.quality != null).toList();
    final averageQuality = qualityRecords.isNotEmpty ?
        qualityRecords.fold<double>(0.0, (sum, r) => sum + r.quality!) / qualityRecords.length : 0.0;

    return MilkProductionAnalysis(
      animalId: animal.id,
      animalName: animal.name,
      periodStart: startDate,
      periodEnd: endDate,
      totalMilkProduced: totalMilk,
      averageDailyProduction: averageDailyMilk,
      peakProduction: peakProduction,
      lowestProduction: lowestProduction,
      productionDays: milkRecords.length,
      currentLactationDay: lactationDay,
      predictedPeakDay: predictedPeakDay,
      persistency: persistency,
      averageQuality: averageQuality,
      productionTrend: _calculateProductionTrend(milkRecords),
      recommendations: _generateMilkProductionRecommendations(averageDailyMilk, persistency, averageQuality),
    );
  }

  /// Track egg production for poultry
  EggProductionAnalysis analyzeEggProduction(
    ComprehensiveAnimalRecord animal,
    DateTime startDate,
    DateTime endDate,
  ) {
    final eggRecords = animal.productionRecords
        .where((p) => p.type == 'eggs' && 
                     p.date.isAfter(startDate) && 
                     p.date.isBefore(endDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (eggRecords.isEmpty) {
      return EggProductionAnalysis.empty(animal.id, animal.name);
    }

    final totalEggs = eggRecords.fold<double>(0.0, (sum, record) => sum + record.quantity);
    final productionDays = eggRecords.length;
    final layingPercentage = (totalEggs / productionDays) * 100; // Assuming 1 egg per day is 100%
    
    // Calculate feed conversion for eggs
    final feedRecords = animal.feedConversion
        .where((f) => f.startDate.isAfter(startDate) && f.endDate.isBefore(endDate))
        .toList();
    
    final feedConversionRatio = feedRecords.isNotEmpty ?
        feedRecords.fold<double>(0.0, (sum, f) => sum + f.conversionRatio) / feedRecords.length : 0.0;

    return EggProductionAnalysis(
      animalId: animal.id,
      animalName: animal.name,
      periodStart: startDate,
      periodEnd: endDate,
      totalEggsProduced: totalEggs.toInt(),
      productionDays: productionDays,
      layingPercentage: layingPercentage,
      averageEggsPerDay: totalEggs / productionDays,
      feedConversionRatio: feedConversionRatio,
      productionTrend: _calculateProductionTrend(eggRecords),
      recommendations: _generateEggProductionRecommendations(layingPercentage, feedConversionRatio),
    );
  }

  /// Analyze meat production and growth performance
  MeatProductionAnalysis analyzeMeatProduction(
    ComprehensiveAnimalRecord animal,
    DateTime startDate,
    DateTime endDate,
  ) {
    final growthRecords = animal.growthRecords
        .where((g) => g.date.isAfter(startDate) && g.date.isBefore(endDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    if (growthRecords.length < 2) {
      return MeatProductionAnalysis.empty(animal.id, animal.name);
    }

    final startWeight = growthRecords.first.weight;
    final endWeight = growthRecords.last.weight;
    final weightGain = endWeight - startWeight;
    final daysPeriod = growthRecords.last.date.difference(growthRecords.first.date).inDays;
    final averageDailyGain = daysPeriod > 0 ? weightGain / daysPeriod : 0.0;

    // Calculate feed conversion
    final feedRecords = animal.feedConversion
        .where((f) => f.startDate.isAfter(startDate) && f.endDate.isBefore(endDate))
        .toList();
    
    final totalFeedConsumed = feedRecords.fold<double>(0.0, (sum, f) => sum + f.feedConsumed);
    final feedConversionRatio = weightGain > 0 ? totalFeedConsumed / weightGain : 0.0;

    // Estimate carcass characteristics
    final estimatedCarcassWeight = endWeight * 0.65; // Typical dressing percentage
    final estimatedLeanMeat = estimatedCarcassWeight * 0.75; // Estimated lean meat percentage

    return MeatProductionAnalysis(
      animalId: animal.id,
      animalName: animal.name,
      periodStart: startDate,
      periodEnd: endDate,
      startWeight: startWeight,
      endWeight: endWeight,
      totalWeightGain: weightGain,
      averageDailyGain: averageDailyGain,
      totalFeedConsumed: totalFeedConsumed,
      feedConversionRatio: feedConversionRatio,
      estimatedCarcassWeight: estimatedCarcassWeight,
      estimatedLeanMeat: estimatedLeanMeat,
      growthEfficiency: _calculateGrowthEfficiency(averageDailyGain, feedConversionRatio),
      recommendations: _generateMeatProductionRecommendations(averageDailyGain, feedConversionRatio),
    );
  }

  /// Generate comprehensive production dashboard
  ProductionDashboard generateProductionDashboard(
    List<ComprehensiveAnimalRecord> animals,
    DateTime startDate,
    DateTime endDate,
  ) {
    final milkAnimals = animals.where((a) => a.productionRecords.any((p) => p.type == 'milk')).toList();
    final eggAnimals = animals.where((a) => a.productionRecords.any((p) => p.type == 'eggs')).toList();
    final meatAnimals = animals.where((a) => a.growthRecords.isNotEmpty).toList();

    // Aggregate milk production
    double totalMilk = 0.0;
    for (final animal in milkAnimals) {
      final milkRecords = animal.productionRecords
          .where((p) => p.type == 'milk' && p.date.isAfter(startDate) && p.date.isBefore(endDate));
      totalMilk += milkRecords.fold<double>(0.0, (sum, r) => sum + r.quantity);
    }

    // Aggregate egg production
    int totalEggs = 0;
    for (final animal in eggAnimals) {
      final eggRecords = animal.productionRecords
          .where((p) => p.type == 'eggs' && p.date.isAfter(startDate) && p.date.isBefore(endDate));
      totalEggs += eggRecords.fold<int>(0, (sum, r) => sum + r.quantity.toInt());
    }

    // Calculate feed efficiency metrics
    final feedEfficiencyMetrics = _calculateOverallFeedEfficiency(animals, startDate, endDate);

    return ProductionDashboard(
      periodStart: startDate,
      periodEnd: endDate,
      totalMilkProduction: totalMilk,
      totalEggProduction: totalEggs,
      milkProducingAnimals: milkAnimals.length,
      eggProducingAnimals: eggAnimals.length,
      meatAnimalsInProduction: meatAnimals.length,
      averageFeedConversionRatio: feedEfficiencyMetrics['averageFCR'] ?? 0.0,
      topPerformers: _identifyTopPerformers(animals, startDate, endDate),
      underPerformers: _identifyUnderPerformers(animals, startDate, endDate),
      productionAlerts: _generateProductionAlerts(animals, startDate, endDate),
      trendsAnalysis: _analyzeTrends(animals, startDate, endDate),
    );
  }

  /// Set production targets for animals
  void setProductionTarget(ProductionTarget target) {
    _productionTargets.add(target);
  }

  /// Check production against targets and generate alerts
  List<ProductionAlert> checkProductionTargets(List<ComprehensiveAnimalRecord> animals) {
    final alerts = <ProductionAlert>[];
    
    for (final target in _productionTargets) {
      final applicableAnimals = animals.where((a) => 
          target.animalIds.isEmpty || target.animalIds.contains(a.id)).toList();
      
      for (final animal in applicableAnimals) {
        final currentProduction = _getCurrentProduction(animal, target);
        final targetValue = target.targetValue;
        
        if (currentProduction < targetValue * 0.8) { // 20% below target
          alerts.add(ProductionAlert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            animalId: animal.id,
            animalName: animal.name,
            alertType: 'Below Target',
            productionType: target.productionType,
            currentValue: currentProduction,
            targetValue: targetValue,
            severity: currentProduction < targetValue * 0.6 ? 'High' : 'Medium',
            message: '${target.productionType} production is ${((targetValue - currentProduction) / targetValue * 100).toStringAsFixed(1)}% below target',
            createdAt: DateTime.now(),
          ));
        }
      }
    }
    
    return alerts;
  }

  // Private helper methods
  int _calculateLactationDay(ComprehensiveAnimalRecord animal, DateTime currentDate) {
    final lastCalving = animal.offspring.isNotEmpty ? 
        animal.offspring.map((o) => o.birthDate).reduce((a, b) => a.isAfter(b) ? a : b) : null;
    
    if (lastCalving != null) {
      return currentDate.difference(lastCalving).inDays;
    }
    return 0;
  }

  int _predictPeakProductionDay(List<ProductionRecord> records) {
    if (records.length < 10) return 0;
    
    double maxProduction = 0.0;
    int peakDay = 0;
    
    for (int i = 0; i < records.length; i++) {
      if (records[i].quantity > maxProduction) {
        maxProduction = records[i].quantity;
        peakDay = i + 1;
      }
    }
    
    return peakDay;
  }

  double _calculatePersistency(List<ProductionRecord> records) {
    if (records.length < 30) return 0.0;
    
    // Calculate persistency as percentage decline per month after peak
    final peakIndex = _predictPeakProductionDay(records) - 1;
    if (peakIndex < 0 || peakIndex >= records.length) return 0.0;
    
    final peakProduction = records[peakIndex].quantity;
    final lastProduction = records.last.quantity;
    
    final monthsAfterPeak = (records.length - peakIndex) / 30.0;
    if (monthsAfterPeak <= 0) return 100.0;
    
    final totalDecline = ((peakProduction - lastProduction) / peakProduction) * 100;
    return 100 - (totalDecline / monthsAfterPeak);
  }

  String _calculateProductionTrend(List<ProductionRecord> records) {
    if (records.length < 7) return 'Insufficient Data';
    
    final recent = records.takeLast(7).map((r) => r.quantity).toList();
    final previous = records.length > 14 ? 
        records.skip(records.length - 14).take(7).map((r) => r.quantity).toList() : recent;
    
    final recentAvg = recent.fold<double>(0.0, (sum, q) => sum + q) / recent.length;
    final previousAvg = previous.fold<double>(0.0, (sum, q) => sum + q) / previous.length;
    
    final change = ((recentAvg - previousAvg) / previousAvg) * 100;
    
    if (change > 5) return 'Increasing';
    if (change < -5) return 'Decreasing';
    return 'Stable';
  }

  List<String> _generateMilkProductionRecommendations(double avgDaily, double persistency, double quality) {
    final recommendations = <String>[];
    
    if (avgDaily < 20) {
      recommendations.add('Consider nutritional supplementation to boost milk production');
      recommendations.add('Evaluate feed quality and energy content');
    }
    
    if (persistency < 80) {
      recommendations.add('Review lactation curve management');
      recommendations.add('Consider energy balance optimization');
    }
    
    if (quality < 3.5) {
      recommendations.add('Focus on protein and fat content improvement');
      recommendations.add('Review genetic selection for milk quality traits');
    }
    
    return recommendations;
  }

  List<String> _generateEggProductionRecommendations(double layingPercentage, double fcr) {
    final recommendations = <String>[];
    
    if (layingPercentage < 80) {
      recommendations.add('Review lighting program and day length');
      recommendations.add('Check for stress factors affecting production');
    }
    
    if (fcr > 2.5) {
      recommendations.add('Optimize feed formulation for egg production');
      recommendations.add('Consider feed restriction programs');
    }
    
    return recommendations;
  }

  List<String> _generateMeatProductionRecommendations(double adg, double fcr) {
    final recommendations = <String>[];
    
    if (adg < 1.0) {
      recommendations.add('Increase energy density in diet');
      recommendations.add('Check for health issues affecting growth');
    }
    
    if (fcr > 7.0) {
      recommendations.add('Review feed efficiency and diet formulation');
      recommendations.add('Consider genetic selection for feed conversion');
    }
    
    return recommendations;
  }

  double _calculateGrowthEfficiency(double adg, double fcr) {
    // Higher ADG and lower FCR indicate better efficiency
    if (fcr <= 0) return 0.0;
    return (adg * 100) / fcr;
  }

  Map<String, double> _calculateOverallFeedEfficiency(List<ComprehensiveAnimalRecord> animals, DateTime start, DateTime end) {
    final feedRecords = <FeedConversionRecord>[];
    
    for (final animal in animals) {
      feedRecords.addAll(animal.feedConversion
          .where((f) => f.startDate.isAfter(start) && f.endDate.isBefore(end)));
    }
    
    if (feedRecords.isEmpty) {
      return {'averageFCR': 0.0, 'totalFeed': 0.0, 'totalGain': 0.0};
    }
    
    final totalFeed = feedRecords.fold<double>(0.0, (sum, f) => sum + f.feedConsumed);
    final totalGain = feedRecords.fold<double>(0.0, (sum, f) => sum + f.weightGain);
    final averageFCR = feedRecords.fold<double>(0.0, (sum, f) => sum + f.conversionRatio) / feedRecords.length;
    
    return {
      'averageFCR': averageFCR,
      'totalFeed': totalFeed,
      'totalGain': totalGain,
    };
  }

  List<ProductionPerformer> _identifyTopPerformers(List<ComprehensiveAnimalRecord> animals, DateTime start, DateTime end) {
    final performers = <ProductionPerformer>[];
    
    for (final animal in animals) {
      final milkRecords = animal.productionRecords
          .where((p) => p.type == 'milk' && p.date.isAfter(start) && p.date.isBefore(end))
          .toList();
      
      if (milkRecords.isNotEmpty) {
        final avgDaily = milkRecords.fold<double>(0.0, (sum, r) => sum + r.quantity) / milkRecords.length;
        performers.add(ProductionPerformer(
          animalId: animal.id,
          animalName: animal.name,
          productionType: 'Milk',
          averageProduction: avgDaily,
          rank: 0, // Will be calculated after sorting
        ));
      }
    }
    
    performers.sort((a, b) => b.averageProduction.compareTo(a.averageProduction));
    for (int i = 0; i < performers.length; i++) {
      performers[i] = performers[i].copyWith(rank: i + 1);
    }
    
    return performers.take(5).toList(); // Top 5 performers
  }

  List<ProductionPerformer> _identifyUnderPerformers(List<ComprehensiveAnimalRecord> animals, DateTime start, DateTime end) {
    final performers = _identifyTopPerformers(animals, start, end);
    return performers.reversed.take(5).toList(); // Bottom 5 performers
  }

  List<ProductionAlert> _generateProductionAlerts(List<ComprehensiveAnimalRecord> animals, DateTime start, DateTime end) {
    return checkProductionTargets(animals);
  }

  Map<String, dynamic> _analyzeTrends(List<ComprehensiveAnimalRecord> animals, DateTime start, DateTime end) {
    final trends = <String, dynamic>{};
    
    // Milk production trend
    final milkData = <DateTime, double>{};
    for (final animal in animals) {
      for (final record in animal.productionRecords) {
        if (record.type == 'milk' && record.date.isAfter(start) && record.date.isBefore(end)) {
          final dateKey = DateTime(record.date.year, record.date.month, record.date.day);
          milkData[dateKey] = (milkData[dateKey] ?? 0.0) + record.quantity;
        }
      }
    }
    
    trends['milkTrend'] = _calculateTrendDirection(milkData.values.toList());
    
    return trends;
  }

  String _calculateTrendDirection(List<double> values) {
    if (values.length < 3) return 'Insufficient Data';
    
    final firstHalf = values.take(values.length ~/ 2);
    final secondHalf = values.skip(values.length ~/ 2);
    
    final firstAvg = firstHalf.fold<double>(0.0, (sum, v) => sum + v) / firstHalf.length;
    final secondAvg = secondHalf.fold<double>(0.0, (sum, v) => sum + v) / secondHalf.length;
    
    final change = ((secondAvg - firstAvg) / firstAvg) * 100;
    
    if (change > 10) return 'Strong Increase';
    if (change > 5) return 'Moderate Increase';
    if (change < -10) return 'Strong Decrease';
    if (change < -5) return 'Moderate Decrease';
    return 'Stable';
  }

  double _getCurrentProduction(ComprehensiveAnimalRecord animal, ProductionTarget target) {
    final recent30Days = DateTime.now().subtract(Duration(days: 30));
    final recentRecords = animal.productionRecords
        .where((p) => p.type == target.productionType && p.date.isAfter(recent30Days))
        .toList();
    
    if (recentRecords.isEmpty) return 0.0;
    
    return recentRecords.fold<double>(0.0, (sum, r) => sum + r.quantity) / recentRecords.length;
  }
}

// Supporting classes for production tracking

class MilkProductionAnalysis {
  final String animalId;
  final String animalName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalMilkProduced;
  final double averageDailyProduction;
  final double peakProduction;
  final double lowestProduction;
  final int productionDays;
  final int currentLactationDay;
  final int predictedPeakDay;
  final double persistency;
  final double averageQuality;
  final String productionTrend;
  final List<String> recommendations;

  MilkProductionAnalysis({
    required this.animalId,
    required this.animalName,
    required this.periodStart,
    required this.periodEnd,
    required this.totalMilkProduced,
    required this.averageDailyProduction,
    required this.peakProduction,
    required this.lowestProduction,
    required this.productionDays,
    required this.currentLactationDay,
    required this.predictedPeakDay,
    required this.persistency,
    required this.averageQuality,
    required this.productionTrend,
    required this.recommendations,
  });

  factory MilkProductionAnalysis.empty(String animalId, String animalName) => MilkProductionAnalysis(
    animalId: animalId,
    animalName: animalName,
    periodStart: DateTime.now(),
    periodEnd: DateTime.now(),
    totalMilkProduced: 0.0,
    averageDailyProduction: 0.0,
    peakProduction: 0.0,
    lowestProduction: 0.0,
    productionDays: 0,
    currentLactationDay: 0,
    predictedPeakDay: 0,
    persistency: 0.0,
    averageQuality: 0.0,
    productionTrend: 'No Data',
    recommendations: ['No production data available'],
  );
}

class EggProductionAnalysis {
  final String animalId;
  final String animalName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalEggsProduced;
  final int productionDays;
  final double layingPercentage;
  final double averageEggsPerDay;
  final double feedConversionRatio;
  final String productionTrend;
  final List<String> recommendations;

  EggProductionAnalysis({
    required this.animalId,
    required this.animalName,
    required this.periodStart,
    required this.periodEnd,
    required this.totalEggsProduced,
    required this.productionDays,
    required this.layingPercentage,
    required this.averageEggsPerDay,
    required this.feedConversionRatio,
    required this.productionTrend,
    required this.recommendations,
  });

  factory EggProductionAnalysis.empty(String animalId, String animalName) => EggProductionAnalysis(
    animalId: animalId,
    animalName: animalName,
    periodStart: DateTime.now(),
    periodEnd: DateTime.now(),
    totalEggsProduced: 0,
    productionDays: 0,
    layingPercentage: 0.0,
    averageEggsPerDay: 0.0,
    feedConversionRatio: 0.0,
    productionTrend: 'No Data',
    recommendations: ['No production data available'],
  );
}

class MeatProductionAnalysis {
  final String animalId;
  final String animalName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double startWeight;
  final double endWeight;
  final double totalWeightGain;
  final double averageDailyGain;
  final double totalFeedConsumed;
  final double feedConversionRatio;
  final double estimatedCarcassWeight;
  final double estimatedLeanMeat;
  final double growthEfficiency;
  final List<String> recommendations;

  MeatProductionAnalysis({
    required this.animalId,
    required this.animalName,
    required this.periodStart,
    required this.periodEnd,
    required this.startWeight,
    required this.endWeight,
    required this.totalWeightGain,
    required this.averageDailyGain,
    required this.totalFeedConsumed,
    required this.feedConversionRatio,
    required this.estimatedCarcassWeight,
    required this.estimatedLeanMeat,
    required this.growthEfficiency,
    required this.recommendations,
  });

  factory MeatProductionAnalysis.empty(String animalId, String animalName) => MeatProductionAnalysis(
    animalId: animalId,
    animalName: animalName,
    periodStart: DateTime.now(),
    periodEnd: DateTime.now(),
    startWeight: 0.0,
    endWeight: 0.0,
    totalWeightGain: 0.0,
    averageDailyGain: 0.0,
    totalFeedConsumed: 0.0,
    feedConversionRatio: 0.0,
    estimatedCarcassWeight: 0.0,
    estimatedLeanMeat: 0.0,
    growthEfficiency: 0.0,
    recommendations: ['Insufficient growth data available'],
  );
}

class ProductionDashboard {
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalMilkProduction;
  final int totalEggProduction;
  final int milkProducingAnimals;
  final int eggProducingAnimals;
  final int meatAnimalsInProduction;
  final double averageFeedConversionRatio;
  final List<ProductionPerformer> topPerformers;
  final List<ProductionPerformer> underPerformers;
  final List<ProductionAlert> productionAlerts;
  final Map<String, dynamic> trendsAnalysis;

  ProductionDashboard({
    required this.periodStart,
    required this.periodEnd,
    required this.totalMilkProduction,
    required this.totalEggProduction,
    required this.milkProducingAnimals,
    required this.eggProducingAnimals,
    required this.meatAnimalsInProduction,
    required this.averageFeedConversionRatio,
    required this.topPerformers,
    required this.underPerformers,
    required this.productionAlerts,
    required this.trendsAnalysis,
  });
}

class ProductionTarget {
  final String id;
  final String productionType; // milk, eggs, weight_gain
  final double targetValue;
  final String unit;
  final String period; // daily, weekly, monthly
  final List<String> animalIds; // Empty means applies to all
  final DateTime startDate;
  final DateTime? endDate;

  ProductionTarget({
    required this.id,
    required this.productionType,
    required this.targetValue,
    required this.unit,
    required this.period,
    required this.animalIds,
    required this.startDate,
    this.endDate,
  });
}

class ProductionAlert {
  final String id;
  final String animalId;
  final String animalName;
  final String alertType;
  final String productionType;
  final double currentValue;
  final double targetValue;
  final String severity;
  final String message;
  final DateTime createdAt;

  ProductionAlert({
    required this.id,
    required this.animalId,
    required this.animalName,
    required this.alertType,
    required this.productionType,
    required this.currentValue,
    required this.targetValue,
    required this.severity,
    required this.message,
    required this.createdAt,
  });
}

class ProductionPerformer {
  final String animalId;
  final String animalName;
  final String productionType;
  final double averageProduction;
  final int rank;

  ProductionPerformer({
    required this.animalId,
    required this.animalName,
    required this.productionType,
    required this.averageProduction,
    required this.rank,
  });

  ProductionPerformer copyWith({
    String? animalId,
    String? animalName,
    String? productionType,
    double? averageProduction,
    int? rank,
  }) => ProductionPerformer(
    animalId: animalId ?? this.animalId,
    animalName: animalName ?? this.animalName,
    productionType: productionType ?? this.productionType,
    averageProduction: averageProduction ?? this.averageProduction,
    rank: rank ?? this.rank,
  );
}

class ProductionTrend {
  final String productionType;
  final DateTime startDate;
  final DateTime endDate;
  final List<double> values;
  final String trendDirection;
  final double changePercentage;

  ProductionTrend({
    required this.productionType,
    required this.startDate,
    required this.endDate,
    required this.values,
    required this.trendDirection,
    required this.changePercentage,
  });
}

class FeedConversionAnalysis {
  final String animalId;
  final String animalName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalFeedConsumed;
  final double totalWeightGain;
  final double feedConversionRatio;
  final String efficiency; // Excellent, Good, Average, Poor
  final List<String> recommendations;

  FeedConversionAnalysis({
    required this.animalId,
    required this.animalName,
    required this.periodStart,
    required this.periodEnd,
    required this.totalFeedConsumed,
    required this.totalWeightGain,
    required this.feedConversionRatio,
    required this.efficiency,
    required this.recommendations,
  });
}

// Extension to support takeLast method
extension ListExtension<T> on List<T> {
  List<T> takeLast(int count) {
    if (count >= length) return this;
    return skip(length - count).toList();
  }
}