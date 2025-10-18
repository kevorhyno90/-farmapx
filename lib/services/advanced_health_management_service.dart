import 'package:flutter/material.dart';
import '../models/comprehensive_animal_record.dart';

/// Advanced health management service for comprehensive veterinary care
class AdvancedHealthManagementService {
  final List<VaccinationSchedule> _vaccinationSchedules = [];
  final List<TreatmentProtocol> _treatmentProtocols = [];
  final List<DiseaseAlert> _diseaseAlerts = [];
  final List<HealthAlert> _healthAlerts = [];

  // Vaccination Management
  List<VaccinationSchedule> get vaccinationSchedules => _vaccinationSchedules;
  List<TreatmentProtocol> get treatmentProtocols => _treatmentProtocols;
  List<DiseaseAlert> get diseaseAlerts => _diseaseAlerts;
  List<HealthAlert> get healthAlerts => _healthAlerts;

  /// Get upcoming vaccinations for all animals
  List<UpcomingVaccination> getUpcomingVaccinations(List<ComprehensiveAnimalRecord> animals) {
    final upcoming = <UpcomingVaccination>[];
    
    for (final animal in animals) {
      for (final schedule in _vaccinationSchedules) {
        if (schedule.appliesToSpecies(animal.species)) {
          final nextDue = _calculateNextVaccinationDate(animal, schedule);
          if (nextDue != null && nextDue.isAfter(DateTime.now())) {
            upcoming.add(UpcomingVaccination(
              animalId: animal.id,
              animalName: animal.name,
              vaccineName: schedule.vaccineName,
              dueDate: nextDue,
              priority: schedule.priority,
              isOverdue: nextDue.isBefore(DateTime.now()),
            ));
          }
        }
      }
    }
    
    upcoming.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return upcoming;
  }

  /// Get overdue vaccinations
  List<UpcomingVaccination> getOverdueVaccinations(List<ComprehensiveAnimalRecord> animals) {
    return getUpcomingVaccinations(animals)
        .where((v) => v.dueDate.isBefore(DateTime.now()))
        .toList();
  }

  /// Check for disease outbreaks or patterns
  List<DiseaseAlert> checkForDiseasePatterns(List<ComprehensiveAnimalRecord> animals) {
    final alerts = <DiseaseAlert>[];
    final recentHealthRecords = <HealthRecord>[];
    
    // Collect health records from last 30 days
    final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    for (final animal in animals) {
      recentHealthRecords.addAll(
        animal.healthHistory.where((h) => h.date.isAfter(thirtyDaysAgo))
      );
    }
    
    // Group by condition and check for patterns
    final conditionCounts = <String, int>{};
    for (final record in recentHealthRecords) {
      conditionCounts[record.condition] = (conditionCounts[record.condition] ?? 0) + 1;
    }
    
    // Alert if same condition affects multiple animals
    conditionCounts.forEach((condition, count) {
      if (count >= 3) { // 3 or more animals with same condition
        alerts.add(DiseaseAlert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          condition: condition,
          affectedAnimalsCount: count,
          severity: _calculateSeverity(count, animals.length),
          detectedDate: DateTime.now(),
          status: 'Active',
          recommendations: _getRecommendationsForCondition(condition),
        ));
      }
    });
    
    return alerts;
  }

  /// Generate health recommendations for an animal
  List<HealthRecommendation> generateHealthRecommendations(ComprehensiveAnimalRecord animal) {
    final recommendations = <HealthRecommendation>[];
    
    // Check vaccination status
    final overdueVaccinations = _getOverdueVaccinationsForAnimal(animal);
    for (final vaccination in overdueVaccinations) {
      recommendations.add(HealthRecommendation(
        type: 'Vaccination',
        priority: 'High',
        description: 'Overdue vaccination: ${vaccination.vaccineName}',
        actionRequired: 'Schedule vaccination appointment',
        dueDate: vaccination.dueDate,
      ));
    }
    
    // Check for chronic conditions
    final chronicConditions = animal.healthHistory
        .where((h) => h.status == 'chronic')
        .toList();
    for (final condition in chronicConditions) {
      recommendations.add(HealthRecommendation(
        type: 'Monitoring',
        priority: 'Medium',
        description: 'Monitor chronic condition: ${condition.condition}',
        actionRequired: 'Regular check-ups and monitoring',
        dueDate: DateTime.now().add(Duration(days: 30)),
      ));
    }
    
    // Check body condition and weight trends
    if (animal.growthRecords.length >= 2) {
      final recentWeights = animal.growthRecords
          .where((g) => g.date.isAfter(DateTime.now().subtract(Duration(days: 90))))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      
      if (recentWeights.length >= 2) {
        final weightChange = recentWeights.first.weight - recentWeights.last.weight;
        final daysSpan = recentWeights.first.date.difference(recentWeights.last.date).inDays;
        final dailyChange = weightChange / daysSpan;
        
        if (dailyChange < -0.5) { // Losing more than 0.5kg per day
          recommendations.add(HealthRecommendation(
            type: 'Nutrition',
            priority: 'High',
            description: 'Rapid weight loss detected',
            actionRequired: 'Veterinary examination and nutrition review',
            dueDate: DateTime.now().add(Duration(days: 3)),
          ));
        }
      }
    }
    
    return recommendations;
  }

  /// Create treatment protocol
  void createTreatmentProtocol(TreatmentProtocol protocol) {
    _treatmentProtocols.add(protocol);
  }

  /// Create vaccination schedule
  void createVaccinationSchedule(VaccinationSchedule schedule) {
    _vaccinationSchedules.add(schedule);
  }

  DateTime? _calculateNextVaccinationDate(ComprehensiveAnimalRecord animal, VaccinationSchedule schedule) {
    final lastVaccination = animal.vaccinations
        .where((v) => v.vaccine == schedule.vaccineName)
        .fold<VaccinationRecord?>(null, (prev, curr) => 
          prev == null || curr.date.isAfter(prev.date) ? curr : prev);
    
    if (lastVaccination == null) {
      // First vaccination - use age-based schedule
      final ageInDays = animal.ageInDays;
      if (ageInDays >= schedule.firstDoseAge) {
        return animal.birthDate.add(Duration(days: schedule.firstDoseAge));
      }
    } else {
      // Calculate next dose based on interval
      return lastVaccination.date.add(Duration(days: schedule.intervalDays));
    }
    
    return null;
  }

  List<UpcomingVaccination> _getOverdueVaccinationsForAnimal(ComprehensiveAnimalRecord animal) {
    final overdue = <UpcomingVaccination>[];
    
    for (final schedule in _vaccinationSchedules) {
      if (schedule.appliesToSpecies(animal.species)) {
        final nextDue = _calculateNextVaccinationDate(animal, schedule);
        if (nextDue != null && nextDue.isBefore(DateTime.now())) {
          overdue.add(UpcomingVaccination(
            animalId: animal.id,
            animalName: animal.name,
            vaccineName: schedule.vaccineName,
            dueDate: nextDue,
            priority: schedule.priority,
            isOverdue: true,
          ));
        }
      }
    }
    
    return overdue;
  }

  String _calculateSeverity(int affectedCount, int totalAnimals) {
    final percentage = (affectedCount / totalAnimals) * 100;
    if (percentage > 20) return 'Critical';
    if (percentage > 10) return 'High';
    if (percentage > 5) return 'Medium';
    return 'Low';
  }

  List<String> _getRecommendationsForCondition(String condition) {
    final recommendations = <String, List<String>>{
      'respiratory infection': [
        'Isolate affected animals',
        'Improve ventilation',
        'Veterinary consultation',
        'Monitor temperature daily'
      ],
      'digestive issues': [
        'Review feed quality',
        'Check water sources',
        'Implement probiotics',
        'Gradual diet changes'
      ],
      'skin condition': [
        'Check for parasites',
        'Review hygiene protocols',
        'Topical treatments',
        'Environmental assessment'
      ],
    };
    
    return recommendations[condition.toLowerCase()] ?? [
      'Veterinary consultation recommended',
      'Monitor affected animals closely',
      'Review management practices'
    ];
  }
}

/// Vaccination schedule template
class VaccinationSchedule {
  final String id;
  final String vaccineName;
  final List<String> targetSpecies;
  final int firstDoseAge; // days
  final int intervalDays; // days between doses
  final int totalDoses;
  final String priority; // Critical, High, Medium, Low
  final List<String> notes;

  VaccinationSchedule({
    required this.id,
    required this.vaccineName,
    required this.targetSpecies,
    required this.firstDoseAge,
    required this.intervalDays,
    required this.totalDoses,
    required this.priority,
    this.notes = const [],
  });

  bool appliesToSpecies(String species) {
    return targetSpecies.contains(species.toLowerCase()) || 
           targetSpecies.contains('all');
  }
}

/// Treatment protocol for specific conditions
class TreatmentProtocol {
  final String id;
  final String conditionName;
  final List<String> targetSpecies;
  final List<TreatmentStep> steps;
  final int durationDays;
  final List<String> contraindications;
  final List<String> sideEffects;
  final String createdBy;
  final DateTime createdAt;

  TreatmentProtocol({
    required this.id,
    required this.conditionName,
    required this.targetSpecies,
    required this.steps,
    required this.durationDays,
    this.contraindications = const [],
    this.sideEffects = const [],
    required this.createdBy,
    required this.createdAt,
  });
}

class TreatmentStep {
  final int stepNumber;
  final String medication;
  final String dosage;
  final String frequency;
  final String route;
  final int durationDays;
  final String instructions;

  TreatmentStep({
    required this.stepNumber,
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.route,
    required this.durationDays,
    required this.instructions,
  });
}

/// Disease outbreak alert
class DiseaseAlert {
  final String id;
  final String condition;
  final int affectedAnimalsCount;
  final String severity;
  final DateTime detectedDate;
  final String status;
  final List<String> recommendations;

  DiseaseAlert({
    required this.id,
    required this.condition,
    required this.affectedAnimalsCount,
    required this.severity,
    required this.detectedDate,
    required this.status,
    required this.recommendations,
  });
}

/// Upcoming vaccination reminder
class UpcomingVaccination {
  final String animalId;
  final String animalName;
  final String vaccineName;
  final DateTime dueDate;
  final String priority;
  final bool isOverdue;

  UpcomingVaccination({
    required this.animalId,
    required this.animalName,
    required this.vaccineName,
    required this.dueDate,
    required this.priority,
    required this.isOverdue,
  });
}

/// Health recommendation
class HealthRecommendation {
  final String type;
  final String priority;
  final String description;
  final String actionRequired;
  final DateTime dueDate;

  HealthRecommendation({
    required this.type,
    required this.priority,
    required this.description,
    required this.actionRequired,
    required this.dueDate,
  });
}

/// Health alert for individual animals
class HealthAlert {
  final String id;
  final String animalId;
  final String animalName;
  final String alertType;
  final String severity;
  final String description;
  final DateTime createdAt;
  final String status;
  final List<String> actions;

  HealthAlert({
    required this.id,
    required this.animalId,
    required this.animalName,
    required this.alertType,
    required this.severity,
    required this.description,
    required this.createdAt,
    required this.status,
    required this.actions,
  });
}