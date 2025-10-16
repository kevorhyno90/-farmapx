enum AnimalGender { male, female, unknown }
enum AnimalStatus { active, sold, deceased, breeding, dry, lactating, pregnant }
enum HealthStatus { healthy, sick, recovering, quarantine, critical }

class HealthRecord {
  final String id;
  final DateTime date;
  final String type; // vaccination, treatment, checkup
  final String description;
  final String? veterinarian;
  final String? medication;
  final double? cost;
  final DateTime? nextDue;

  HealthRecord({
    required this.id,
    required this.date,
    required this.type,
    required this.description,
    this.veterinarian,
    this.medication,
    this.cost,
    this.nextDue,
  });
}

class BreedingRecord {
  final String id;
  final DateTime date;
  final String? sireId;
  final String? damId;
  final DateTime? expectedCalving;
  final DateTime? actualCalving;
  final String? notes;
  final bool isArtificial;

  BreedingRecord({
    required this.id,
    required this.date,
    this.sireId,
    this.damId,
    this.expectedCalving,
    this.actualCalving,
    this.notes,
    this.isArtificial = false,
  });
}

class WeightRecord {
  final DateTime date;
  final double weight; // in kg
  final String? notes;

  WeightRecord({
    required this.date,
    required this.weight,
    this.notes,
  });
}

class MilkRecord {
  final DateTime date;
  final double morningMilk; // in liters
  final double eveningMilk; // in liters
  final double fatContent; // percentage
  final double proteinContent; // percentage
  final String? quality; // A, B, C grade

  MilkRecord({
    required this.date,
    required this.morningMilk,
    required this.eveningMilk,
    this.fatContent = 0.0,
    this.proteinContent = 0.0,
    this.quality,
  });

  double get totalMilk => morningMilk + eveningMilk;
}

class Animal {
  final String id;
  final String tag;
  final String species;
  final String breed;
  final AnimalGender gender;
  final DateTime? dateOfBirth;
  final DateTime dateAcquired;
  final AnimalStatus status;
  final HealthStatus healthStatus;
  final String? motherId;
  final String? fatherId;
  final double? purchasePrice;
  final String? purchaseLocation;
  final String? color;
  final String? markings;
  final String? rfidTag;
  final String? notes;
  final String? feedGroup;
  final String? location; // pen, pasture, barn
  final List<HealthRecord> healthRecords;
  final List<BreedingRecord> breedingRecords;
  final List<WeightRecord> weightRecords;
  final List<MilkRecord> milkRecords;

  Animal({
    required this.id,
    required this.tag,
    this.species = '',
    this.breed = '',
    this.gender = AnimalGender.unknown,
    this.dateOfBirth,
    DateTime? dateAcquired,
    this.status = AnimalStatus.active,
    this.healthStatus = HealthStatus.healthy,
    this.motherId,
    this.fatherId,
    this.purchasePrice,
    this.purchaseLocation,
    this.color,
    this.markings,
    this.rfidTag,
    this.notes,
    this.feedGroup,
    this.location,
    List<HealthRecord>? healthRecords,
    List<BreedingRecord>? breedingRecords,
    List<WeightRecord>? weightRecords,
    List<MilkRecord>? milkRecords,
  }) : 
    dateAcquired = dateAcquired ?? DateTime.now(),
    healthRecords = healthRecords ?? [],
    breedingRecords = breedingRecords ?? [],
    weightRecords = weightRecords ?? [],
    milkRecords = milkRecords ?? [];

  // Calculated properties
  int? get ageInDays {
    if (dateOfBirth == null) return null;
    return DateTime.now().difference(dateOfBirth!).inDays;
  }

  int? get ageInMonths {
    if (ageInDays == null) return null;
    return (ageInDays! / 30.44).round(); // Average days per month
  }

  double? get currentWeight {
    if (weightRecords.isEmpty) return null;
    final sorted = weightRecords.toList()..sort((a, b) => b.date.compareTo(a.date));
    return sorted.first.weight;
  }

  double? get averageDailyMilk {
    if (milkRecords.isEmpty) return null;
    final last30Days = milkRecords.where((record) =>
      DateTime.now().difference(record.date).inDays <= 30).toList();
    if (last30Days.isEmpty) return null;
    
    final totalMilk = last30Days.fold(0.0, (sum, record) => sum + record.totalMilk);
    return totalMilk / last30Days.length;
  }

  bool get isPregnant => status == AnimalStatus.pregnant;
  bool get isLactating => status == AnimalStatus.lactating;
  bool get isDry => status == AnimalStatus.dry;

  DateTime? get nextVaccinationDue {
    final upcomingVaccinations = healthRecords
        .where((record) => record.nextDue != null && record.nextDue!.isAfter(DateTime.now()))
        .toList();
    
    if (upcomingVaccinations.isEmpty) return null;
    
    upcomingVaccinations.sort((a, b) => a.nextDue!.compareTo(b.nextDue!));
    return upcomingVaccinations.first.nextDue;
  }

  // Copy with method for updates
  Animal copyWith({
    String? tag,
    String? species,
    String? breed,
    AnimalGender? gender,
    DateTime? dateOfBirth,
    DateTime? dateAcquired,
    AnimalStatus? status,
    HealthStatus? healthStatus,
    String? motherId,
    String? fatherId,
    double? purchasePrice,
    String? purchaseLocation,
    String? color,
    String? markings,
    String? rfidTag,
    String? notes,
    String? feedGroup,
    String? location,
    List<HealthRecord>? healthRecords,
    List<BreedingRecord>? breedingRecords,
    List<WeightRecord>? weightRecords,
    List<MilkRecord>? milkRecords,
  }) {
    return Animal(
      id: id,
      tag: tag ?? this.tag,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      dateAcquired: dateAcquired ?? this.dateAcquired,
      status: status ?? this.status,
      healthStatus: healthStatus ?? this.healthStatus,
      motherId: motherId ?? this.motherId,
      fatherId: fatherId ?? this.fatherId,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      purchaseLocation: purchaseLocation ?? this.purchaseLocation,
      color: color ?? this.color,
      markings: markings ?? this.markings,
      rfidTag: rfidTag ?? this.rfidTag,
      notes: notes ?? this.notes,
      feedGroup: feedGroup ?? this.feedGroup,
      location: location ?? this.location,
      healthRecords: healthRecords ?? this.healthRecords,
      breedingRecords: breedingRecords ?? this.breedingRecords,
      weightRecords: weightRecords ?? this.weightRecords,
      milkRecords: milkRecords ?? this.milkRecords,
    );
  }
}
