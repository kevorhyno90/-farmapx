import 'package:flutter/material.dart';

// Professional Animal Management System Models

class AnimalProfile {
  final String id;
  final String name;
  final String species; // cattle, sheep, goat, pig, poultry
  final String breed;
  final String gender;
  final DateTime birthDate;
  final double birthWeight;
  final String identificationNumber; // ear tag, microchip, etc.
  final String identificationType;
  final String motherID;
  final String fatherID;
  final String origin; // purchased, born on farm, etc.
  final DateTime acquisitionDate;
  final double acquisitionCost;
  final String currentLocation; // pasture, barn, etc.
  final AnimalStatus status;
  final String notes;
  final List<String> photoUrls;
  final List<HealthRecord> healthRecords;
  final List<BreedingRecord> breedingRecords;
  final List<ProductionRecord> productionRecords;
  final List<WeightRecord> weightRecords;
  final DateTime lastUpdated;

  AnimalProfile({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birthDate,
    required this.birthWeight,
    required this.identificationNumber,
    required this.identificationType,
    this.motherID = '',
    this.fatherID = '',
    required this.origin,
    required this.acquisitionDate,
    required this.acquisitionCost,
    required this.currentLocation,
    required this.status,
    this.notes = '',
    this.photoUrls = const [],
    this.healthRecords = const [],
    this.breedingRecords = const [],
    this.productionRecords = const [],
    this.weightRecords = const [],
    required this.lastUpdated,
  });

  int get ageInDays => DateTime.now().difference(birthDate).inDays;
  int get ageInMonths => (ageInDays / 30.44).floor();
  int get ageInYears => (ageInDays / 365.25).floor();
  
  String get ageString {
    if (ageInYears >= 1) {
      return '$ageInYears years ${ageInMonths % 12} months';
    } else if (ageInMonths >= 1) {
      return '$ageInMonths months';
    } else {
      return '$ageInDays days';
    }
  }

  double get currentWeight {
    if (weightRecords.isEmpty) return birthWeight;
    return weightRecords.last.weight;
  }

  AnimalProfile copyWith({
    String? name,
    String? species,
    String? breed,
    String? gender,
    DateTime? birthDate,
    double? birthWeight,
    String? identificationNumber,
    String? identificationType,
    String? motherID,
    String? fatherID,
    String? origin,
    DateTime? acquisitionDate,
    double? acquisitionCost,
    String? currentLocation,
    AnimalStatus? status,
    String? notes,
    List<String>? photoUrls,
    List<HealthRecord>? healthRecords,
    List<BreedingRecord>? breedingRecords,
    List<ProductionRecord>? productionRecords,
    List<WeightRecord>? weightRecords,
  }) {
    return AnimalProfile(
      id: id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      birthWeight: birthWeight ?? this.birthWeight,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      identificationType: identificationType ?? this.identificationType,
      motherID: motherID ?? this.motherID,
      fatherID: fatherID ?? this.fatherID,
      origin: origin ?? this.origin,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      acquisitionCost: acquisitionCost ?? this.acquisitionCost,
      currentLocation: currentLocation ?? this.currentLocation,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      photoUrls: photoUrls ?? this.photoUrls,
      healthRecords: healthRecords ?? this.healthRecords,
      breedingRecords: breedingRecords ?? this.breedingRecords,
      productionRecords: productionRecords ?? this.productionRecords,
      weightRecords: weightRecords ?? this.weightRecords,
      lastUpdated: DateTime.now(),
    );
  }
}

enum AnimalStatus {
  active,
  pregnant,
  lactating,
  dry,
  sick,
  quarantine,
  sold,
  deceased,
  retired
}

class HealthRecord {
  final String id;
  final DateTime date;
  final HealthRecordType type;
  final String description;
  final String diagnosis;
  final String treatment;
  final String medication;
  final double? dosage;
  final String? dosageUnit;
  final String veterinarian;
  final double cost;
  final DateTime? followUpDate;
  final String notes;
  final List<String> attachments; // lab results, X-rays, etc.

  HealthRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    this.diagnosis = '',
    this.treatment = '',
    this.medication = '',
    this.dosage,
    this.dosageUnit,
    required this.veterinarian,
    this.cost = 0.0,
    this.followUpDate,
    this.notes = '',
    this.attachments = const [],
  });

  HealthRecord copyWith({
    DateTime? date,
    HealthRecordType? type,
    String? description,
    String? diagnosis,
    String? treatment,
    String? medication,
    double? dosage,
    String? dosageUnit,
    String? veterinarian,
    double? cost,
    DateTime? followUpDate,
    String? notes,
    List<String>? attachments,
  }) {
    return HealthRecord(
      id: id,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      medication: medication ?? this.medication,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      veterinarian: veterinarian ?? this.veterinarian,
      cost: cost ?? this.cost,
      followUpDate: followUpDate ?? this.followUpDate,
      notes: notes ?? this.notes,
      attachments: attachments ?? this.attachments,
    );
  }
}

enum HealthRecordType {
  vaccination,
  treatment,
  examination,
  surgery,
  labTest,
  disease,
  injury,
  preventive,
  emergency
}

class BreedingRecord {
  final String id;
  final DateTime date;
  final BreedingType type;
  final String? maleID;
  final String? maleName;
  final String? semenSource;
  final String? semenBatch;
  final DateTime? expectedDueDate;
  final DateTime? actualBirthDate;
  final BreedingOutcome outcome;
  final int? numberOfOffspring;
  final List<String> offspringIDs;
  final String notes;
  final double cost;

  BreedingRecord({
    required this.id,
    required this.date,
    required this.type,
    this.maleID,
    this.maleName,
    this.semenSource,
    this.semenBatch,
    this.expectedDueDate,
    this.actualBirthDate,
    this.outcome = BreedingOutcome.pending,
    this.numberOfOffspring,
    this.offspringIDs = const [],
    this.notes = '',
    this.cost = 0.0,
  });

  BreedingRecord copyWith({
    DateTime? date,
    BreedingType? type,
    String? maleID,
    String? maleName,
    String? semenSource,
    String? semenBatch,
    DateTime? expectedDueDate,
    DateTime? actualBirthDate,
    BreedingOutcome? outcome,
    int? numberOfOffspring,
    List<String>? offspringIDs,
    String? notes,
    double? cost,
  }) {
    return BreedingRecord(
      id: id,
      date: date ?? this.date,
      type: type ?? this.type,
      maleID: maleID ?? this.maleID,
      maleName: maleName ?? this.maleName,
      semenSource: semenSource ?? this.semenSource,
      semenBatch: semenBatch ?? this.semenBatch,
      expectedDueDate: expectedDueDate ?? this.expectedDueDate,
      actualBirthDate: actualBirthDate ?? this.actualBirthDate,
      outcome: outcome ?? this.outcome,
      numberOfOffspring: numberOfOffspring ?? this.numberOfOffspring,
      offspringIDs: offspringIDs ?? this.offspringIDs,
      notes: notes ?? this.notes,
      cost: cost ?? this.cost,
    );
  }
}

enum BreedingType {
  naturalMating,
  artificialInsemination,
  embryoTransfer
}

enum BreedingOutcome {
  pending,
  pregnant,
  notPregnant,
  aborted,
  stillborn,
  successful
}

class ProductionRecord {
  final String id;
  final DateTime date;
  final ProductionType type;
  final double quantity;
  final String unit;
  final double? quality; // milk fat %, grade, etc.
  final String? qualityMetric;
  final double? price;
  final String notes;

  ProductionRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.quantity,
    required this.unit,
    this.quality,
    this.qualityMetric,
    this.price,
    this.notes = '',
  });

  ProductionRecord copyWith({
    DateTime? date,
    ProductionType? type,
    double? quantity,
    String? unit,
    double? quality,
    String? qualityMetric,
    double? price,
    String? notes,
  }) {
    return ProductionRecord(
      id: id,
      date: date ?? this.date,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      quality: quality ?? this.quality,
      qualityMetric: qualityMetric ?? this.qualityMetric,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }
}

enum ProductionType {
  milk,
  eggs,
  meat,
  wool,
  fiber,
  manure
}

class WeightRecord {
  final String id;
  final DateTime date;
  final double weight;
  final String unit;
  final String? bodyConditionScore;
  final String notes;

  WeightRecord({
    required this.id,
    required this.date,
    required this.weight,
    this.unit = 'kg',
    this.bodyConditionScore,
    this.notes = '',
  });

  WeightRecord copyWith({
    DateTime? date,
    double? weight,
    String? unit,
    String? bodyConditionScore,
    String? notes,
  }) {
    return WeightRecord(
      id: id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      bodyConditionScore: bodyConditionScore ?? this.bodyConditionScore,
      notes: notes ?? this.notes,
    );
  }
}

// Veterinary Examination Record
class VeterinaryExamination {
  final String id;
  final DateTime date;
  final String animalId;
  final String veterinarian;
  final String reasonForExamination;
  final VitalSigns vitalSigns;
  final PhysicalExamination physicalExam;
  final List<String> findings;
  final List<String> diagnoses;
  final List<String> recommendations;
  final List<String> prescriptions;
  final DateTime? nextExamDate;
  final double cost;
  final String notes;

  VeterinaryExamination({
    required this.id,
    required this.date,
    required this.animalId,
    required this.veterinarian,
    required this.reasonForExamination,
    required this.vitalSigns,
    required this.physicalExam,
    this.findings = const [],
    this.diagnoses = const [],
    this.recommendations = const [],
    this.prescriptions = const [],
    this.nextExamDate,
    this.cost = 0.0,
    this.notes = '',
  });
}

class VitalSigns {
  final double? temperature;
  final int? heartRate;
  final int? respiratoryRate;
  final String? bloodPressure;
  final double? weight;
  final String? bodyConditionScore;

  VitalSigns({
    this.temperature,
    this.heartRate,
    this.respiratoryRate,
    this.bloodPressure,
    this.weight,
    this.bodyConditionScore,
  });
}

class PhysicalExamination {
  final String? generalAppearance;
  final String? eyes;
  final String? ears;
  final String? nose;
  final String? mouth;
  final String? teeth;
  final String? lymphNodes;
  final String? heart;
  final String? lungs;
  final String? abdomen;
  final String? musculoskeletal;
  final String? skin;
  final String? reproductive;
  final String? neurological;

  PhysicalExamination({
    this.generalAppearance,
    this.eyes,
    this.ears,
    this.nose,
    this.mouth,
    this.teeth,
    this.lymphNodes,
    this.heart,
    this.lungs,
    this.abdomen,
    this.musculoskeletal,
    this.skin,
    this.reproductive,
    this.neurological,
  });
}

// Vaccination Schedule
class VaccinationSchedule {
  final String id;
  final String animalId;
  final String vaccineName;
  final DateTime scheduledDate;
  final DateTime? administeredDate;
  final String? veterinarian;
  final String? batchNumber;
  final DateTime? expiryDate;
  final VaccinationStatus status;
  final String notes;

  VaccinationSchedule({
    required this.id,
    required this.animalId,
    required this.vaccineName,
    required this.scheduledDate,
    this.administeredDate,
    this.veterinarian,
    this.batchNumber,
    this.expiryDate,
    this.status = VaccinationStatus.scheduled,
    this.notes = '',
  });
}

enum VaccinationStatus {
  scheduled,
  administered,
  overdue,
  cancelled
}