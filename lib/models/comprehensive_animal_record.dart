class ComprehensiveAnimalRecord {
  final String id;
  final String name;
  final String species;
  final String breed;
  final DateTime birthDate;
  final String gender;
  final String color;
  final double? weight;
  final String status; // Active, Sold, Deceased, etc.
  final String location; // Field, Barn, etc.
  final String? rfidTag;
  final String? earTag;
  final String? microchipId;
  
  // Genetics & Lineage
  final String? sireName;
  final String? sireId;
  final String? damName;
  final String? damId;
  final String? geneticLine;
  final Map<String, dynamic> geneticTraits;
  
  // Health Records
  final List<HealthRecord> healthHistory;
  final List<VaccinationRecord> vaccinations;
  final List<TreatmentRecord> treatments;
  final List<VeterinaryExamination> examinations;
  
  // Breeding Records
  final List<BreedingRecord> breedingHistory;
  final List<PregnancyRecord> pregnancies;
  final List<OffspringRecord> offspring;
  
  // Performance Tracking
  final List<ProductionRecord> productionRecords;
  final List<GrowthRecord> growthRecords;
  final List<FeedConversionRecord> feedConversion;
  
  // Management
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final Map<String, dynamic> customFields;
  final List<String> notes;
  final List<String> attachments; // Photo URLs, document URLs

  ComprehensiveAnimalRecord({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.birthDate,
    required this.gender,
    required this.color,
    this.weight,
    required this.status,
    required this.location,
    this.rfidTag,
    this.earTag,
    this.microchipId,
    this.sireName,
    this.sireId,
    this.damName,
    this.damId,
    this.geneticLine,
    this.geneticTraits = const {},
    this.healthHistory = const [],
    this.vaccinations = const [],
    this.treatments = const [],
    this.examinations = const [],
    this.breedingHistory = const [],
    this.pregnancies = const [],
    this.offspring = const [],
    this.productionRecords = const [],
    this.growthRecords = const [],
    this.feedConversion = const [],
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.customFields = const {},
    this.notes = const [],
    this.attachments = const [],
  });

  int get ageInDays => DateTime.now().difference(birthDate).inDays;
  String get ageDisplay {
    final days = ageInDays;
    if (days < 30) return '$days days';
    if (days < 365) return '${(days / 30).floor()} months';
    return '${(days / 365).floor()} years';
  }

  bool get isPregnant => pregnancies.any((p) => p.status == 'pregnant');
  bool get isLactating => productionRecords.any((p) => p.type == 'milk' && p.isActive);
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'species': species,
    'breed': breed,
    'birthDate': birthDate.toIso8601String(),
    'gender': gender,
    'color': color,
    'weight': weight,
    'status': status,
    'location': location,
    'rfidTag': rfidTag,
    'earTag': earTag,
    'microchipId': microchipId,
    'sireName': sireName,
    'sireId': sireId,
    'damName': damName,
    'damId': damId,
    'geneticLine': geneticLine,
    'geneticTraits': geneticTraits,
    'healthHistory': healthHistory.map((h) => h.toJson()).toList(),
    'vaccinations': vaccinations.map((v) => v.toJson()).toList(),
    'treatments': treatments.map((t) => t.toJson()).toList(),
    'examinations': examinations.map((e) => e.toJson()).toList(),
    'breedingHistory': breedingHistory.map((b) => b.toJson()).toList(),
    'pregnancies': pregnancies.map((p) => p.toJson()).toList(),
    'offspring': offspring.map((o) => o.toJson()).toList(),
    'productionRecords': productionRecords.map((p) => p.toJson()).toList(),
    'growthRecords': growthRecords.map((g) => g.toJson()).toList(),
    'feedConversion': feedConversion.map((f) => f.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'createdBy': createdBy,
    'customFields': customFields,
    'notes': notes,
    'attachments': attachments,
  };
}

class HealthRecord {
  final String id;
  final DateTime date;
  final String type; // checkup, illness, injury, surgery
  final String condition;
  final String severity; // mild, moderate, severe
  final String symptoms;
  final String diagnosis;
  final String treatment;
  final String veterinarian;
  final String status; // ongoing, resolved, chronic
  final double? cost;
  final List<String> medications;
  final String notes;

  HealthRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.condition,
    required this.severity,
    required this.symptoms,
    required this.diagnosis,
    required this.treatment,
    required this.veterinarian,
    required this.status,
    this.cost,
    this.medications = const [],
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'type': type,
    'condition': condition,
    'severity': severity,
    'symptoms': symptoms,
    'diagnosis': diagnosis,
    'treatment': treatment,
    'veterinarian': veterinarian,
    'status': status,
    'cost': cost,
    'medications': medications,
    'notes': notes,
  };
}

class VaccinationRecord {
  final String id;
  final DateTime date;
  final String vaccine;
  final String manufacturer;
  final String batchNumber;
  final DateTime expiryDate;
  final String administeredBy;
  final String site; // injection site
  final DateTime? nextDueDate;
  final String status; // completed, overdue, scheduled
  final String? reaction;
  final String notes;

  VaccinationRecord({
    required this.id,
    required this.date,
    required this.vaccine,
    required this.manufacturer,
    required this.batchNumber,
    required this.expiryDate,
    required this.administeredBy,
    required this.site,
    this.nextDueDate,
    required this.status,
    this.reaction,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'vaccine': vaccine,
    'manufacturer': manufacturer,
    'batchNumber': batchNumber,
    'expiryDate': expiryDate.toIso8601String(),
    'administeredBy': administeredBy,
    'site': site,
    'nextDueDate': nextDueDate?.toIso8601String(),
    'status': status,
    'reaction': reaction,
    'notes': notes,
  };
}

class TreatmentRecord {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final String medication;
  final String dosage;
  final String frequency;
  final String route; // oral, injection, topical
  final String prescribedBy;
  final String reason;
  final String status; // active, completed, discontinued
  final List<String> sideEffects;
  final double? cost;
  final String notes;

  TreatmentRecord({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.route,
    required this.prescribedBy,
    required this.reason,
    required this.status,
    this.sideEffects = const [],
    this.cost,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'medication': medication,
    'dosage': dosage,
    'frequency': frequency,
    'route': route,
    'prescribedBy': prescribedBy,
    'reason': reason,
    'status': status,
    'sideEffects': sideEffects,
    'cost': cost,
    'notes': notes,
  };
}

class VeterinaryExamination {
  final String id;
  final DateTime date;
  final String veterinarian;
  final String clinic;
  final String purpose; // routine, follow-up, emergency
  final double? temperature;
  final int? heartRate;
  final int? respiratoryRate;
  final double? weight;
  final String bodyConditionScore;
  final String generalAssessment;
  final Map<String, String> systemExams; // cardiovascular, respiratory, etc.
  final List<String> recommendations;
  final DateTime? nextExamDate;
  final double? cost;
  final String notes;

  VeterinaryExamination({
    required this.id,
    required this.date,
    required this.veterinarian,
    required this.clinic,
    required this.purpose,
    this.temperature,
    this.heartRate,
    this.respiratoryRate,
    this.weight,
    required this.bodyConditionScore,
    required this.generalAssessment,
    this.systemExams = const {},
    this.recommendations = const [],
    this.nextExamDate,
    this.cost,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'veterinarian': veterinarian,
    'clinic': clinic,
    'purpose': purpose,
    'temperature': temperature,
    'heartRate': heartRate,
    'respiratoryRate': respiratoryRate,
    'weight': weight,
    'bodyConditionScore': bodyConditionScore,
    'generalAssessment': generalAssessment,
    'systemExams': systemExams,
    'recommendations': recommendations,
    'nextExamDate': nextExamDate?.toIso8601String(),
    'cost': cost,
    'notes': notes,
  };
}

class BreedingRecord {
  final String id;
  final DateTime breedingDate;
  final String mateId;
  final String mateName;
  final String method; // natural, AI, embryo transfer
  final String? semenSource;
  final String? technician;
  final DateTime? expectedCalvingDate;
  final DateTime? actualCalvingDate;
  final String status; // bred, confirmed pregnant, calved, failed
  final int? gestationDays;
  final String notes;

  BreedingRecord({
    required this.id,
    required this.breedingDate,
    required this.mateId,
    required this.mateName,
    required this.method,
    this.semenSource,
    this.technician,
    this.expectedCalvingDate,
    this.actualCalvingDate,
    required this.status,
    this.gestationDays,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'breedingDate': breedingDate.toIso8601String(),
    'mateId': mateId,
    'mateName': mateName,
    'method': method,
    'semenSource': semenSource,
    'technician': technician,
    'expectedCalvingDate': expectedCalvingDate?.toIso8601String(),
    'actualCalvingDate': actualCalvingDate?.toIso8601String(),
    'status': status,
    'gestationDays': gestationDays,
    'notes': notes,
  };
}

class PregnancyRecord {
  final String id;
  final DateTime breedingDate;
  final DateTime? confirmationDate;
  final String confirmationMethod; // ultrasound, blood test, rectal palpation
  final DateTime? expectedDueDate;
  final String status; // pregnant, calved, aborted, open
  final List<PregnancyCheckup> checkups;
  final String notes;

  PregnancyRecord({
    required this.id,
    required this.breedingDate,
    this.confirmationDate,
    required this.confirmationMethod,
    this.expectedDueDate,
    required this.status,
    this.checkups = const [],
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'breedingDate': breedingDate.toIso8601String(),
    'confirmationDate': confirmationDate?.toIso8601String(),
    'confirmationMethod': confirmationMethod,
    'expectedDueDate': expectedDueDate?.toIso8601String(),
    'status': status,
    'checkups': checkups.map((c) => c.toJson()).toList(),
    'notes': notes,
  };
}

class PregnancyCheckup {
  final DateTime date;
  final String method;
  final String result;
  final String veterinarian;
  final String notes;

  PregnancyCheckup({
    required this.date,
    required this.method,
    required this.result,
    required this.veterinarian,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'method': method,
    'result': result,
    'veterinarian': veterinarian,
    'notes': notes,
  };
}

class OffspringRecord {
  final String id;
  final String name;
  final DateTime birthDate;
  final String gender;
  final double? birthWeight;
  final String status; // alive, deceased
  final String? sireId;
  final String notes;

  OffspringRecord({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.birthWeight,
    required this.status,
    this.sireId,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'birthDate': birthDate.toIso8601String(),
    'gender': gender,
    'birthWeight': birthWeight,
    'status': status,
    'sireId': sireId,
    'notes': notes,
  };
}

class ProductionRecord {
  final String id;
  final DateTime date;
  final String type; // milk, eggs, wool, meat
  final double quantity;
  final String unit; // liters, kg, dozens
  final double? quality; // fat content, protein, etc.
  final bool isActive;
  final String notes;

  ProductionRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.quantity,
    required this.unit,
    this.quality,
    required this.isActive,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'type': type,
    'quantity': quantity,
    'unit': unit,
    'quality': quality,
    'isActive': isActive,
    'notes': notes,
  };
}

class GrowthRecord {
  final String id;
  final DateTime date;
  final double weight;
  final double? height;
  final double? length;
  final String bodyConditionScore;
  final String notes;

  GrowthRecord({
    required this.id,
    required this.date,
    required this.weight,
    this.height,
    this.length,
    required this.bodyConditionScore,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'weight': weight,
    'height': height,
    'length': length,
    'bodyConditionScore': bodyConditionScore,
    'notes': notes,
  };
}

class FeedConversionRecord {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final double feedConsumed; // kg
  final double weightGain; // kg
  final double conversionRatio;
  final String feedType;
  final double? cost;
  final String notes;

  FeedConversionRecord({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.feedConsumed,
    required this.weightGain,
    required this.conversionRatio,
    required this.feedType,
    this.cost,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'feedConsumed': feedConsumed,
    'weightGain': weightGain,
    'conversionRatio': conversionRatio,
    'feedType': feedType,
    'cost': cost,
    'notes': notes,
  };
}