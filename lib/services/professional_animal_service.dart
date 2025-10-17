import '../models/professional_animal_models.dart';

class ProfessionalAnimalService {
  static final Map<String, AnimalProfile> _animals = {};
  static final Map<String, VeterinaryExamination> _examinations = {};
  static final Map<String, VaccinationSchedule> _vaccinations = {};

  // Initialize with comprehensive sample data
  static void initialize() {
    _initializeCattleSampleData();
    _initializeGoatSampleData();
    _initializePigSampleData();
    _initializePoultryFlockData();
  }

  // CRUD Operations for Animals
  static List<AnimalProfile> getAllAnimals() => _animals.values.toList();
  
  static AnimalProfile? getAnimal(String id) => _animals[id];
  
  static void addAnimal(AnimalProfile animal) {
    _animals[animal.id] = animal;
  }
  
  static void updateAnimal(AnimalProfile animal) {
    _animals[animal.id] = animal.copyWith();
  }
  
  static void deleteAnimal(String id) {
    _animals.remove(id);
  }

  static List<AnimalProfile> getAnimalsBySpecies(String species) {
    return _animals.values.where((animal) => 
      animal.species.toLowerCase() == species.toLowerCase()).toList();
  }

  static List<AnimalProfile> getAnimalsByStatus(AnimalStatus status) {
    return _animals.values.where((animal) => animal.status == status).toList();
  }

  // Health Records Management
  static void addHealthRecord(String animalId, HealthRecord record) {
    final animal = _animals[animalId];
    if (animal != null) {
      final updatedRecords = List<HealthRecord>.from(animal.healthRecords)..add(record);
      _animals[animalId] = animal.copyWith(healthRecords: updatedRecords);
    }
  }

  static void updateHealthRecord(String animalId, HealthRecord updatedRecord) {
    final animal = _animals[animalId];
    if (animal != null) {
      final updatedRecords = animal.healthRecords.map((record) => 
        record.id == updatedRecord.id ? updatedRecord : record).toList();
      _animals[animalId] = animal.copyWith(healthRecords: updatedRecords);
    }
  }

  static void deleteHealthRecord(String animalId, String recordId) {
    final animal = _animals[animalId];
    if (animal != null) {
      final updatedRecords = animal.healthRecords.where((record) => 
        record.id != recordId).toList();
      _animals[animalId] = animal.copyWith(healthRecords: updatedRecords);
    }
  }

  // Breeding Records Management
  static void addBreedingRecord(String animalId, BreedingRecord record) {
    final animal = _animals[animalId];
    if (animal != null) {
      final updatedRecords = List<BreedingRecord>.from(animal.breedingRecords)..add(record);
      _animals[animalId] = animal.copyWith(breedingRecords: updatedRecords);
    }
  }

  // Production Records Management
  static void addProductionRecord(String animalId, ProductionRecord record) {
    final animal = _animals[animalId];
    if (animal != null) {
      final updatedRecords = List<ProductionRecord>.from(animal.productionRecords)..add(record);
      _animals[animalId] = animal.copyWith(productionRecords: updatedRecords);
    }
  }

  // Weight Records Management
  static void addWeightRecord(String animalId, WeightRecord record) {
    final animal = _animals[animalId];
    if (animal != null) {
      final updatedRecords = List<WeightRecord>.from(animal.weightRecords)..add(record);
      _animals[animalId] = animal.copyWith(weightRecords: updatedRecords);
    }
  }

  // Veterinary Examinations
  static void addVeterinaryExamination(VeterinaryExamination exam) {
    _examinations[exam.id] = exam;
  }

  static List<VeterinaryExamination> getExaminationsForAnimal(String animalId) {
    return _examinations.values.where((exam) => exam.animalId == animalId).toList();
  }

  // Vaccination Management
  static void addVaccinationSchedule(VaccinationSchedule vaccination) {
    _vaccinations[vaccination.id] = vaccination;
  }

  static List<VaccinationSchedule> getVaccinationsForAnimal(String animalId) {
    return _vaccinations.values.where((vac) => vac.animalId == animalId).toList();
  }

  static List<VaccinationSchedule> getOverdueVaccinations() {
    final now = DateTime.now();
    return _vaccinations.values.where((vac) => 
      vac.status == VaccinationStatus.scheduled && 
      vac.scheduledDate.isBefore(now)).toList();
  }

  // Analytics and Reports
  static Map<String, int> getAnimalCountBySpecies() {
    final counts = <String, int>{};
    for (final animal in _animals.values) {
      counts[animal.species] = (counts[animal.species] ?? 0) + 1;
    }
    return counts;
  }

  static Map<AnimalStatus, int> getAnimalCountByStatus() {
    final counts = <AnimalStatus, int>{};
    for (final animal in _animals.values) {
      counts[animal.status] = (counts[animal.status] ?? 0) + 1;
    }
    return counts;
  }

  static double getTotalAnimalValue() {
    return _animals.values.fold(0.0, (sum, animal) => sum + animal.acquisitionCost);
  }

  static List<AnimalProfile> getAnimalsRequiringAttention() {
    final now = DateTime.now();
    return _animals.values.where((animal) => 
      animal.status == AnimalStatus.sick || 
      animal.status == AnimalStatus.quarantine ||
      animal.healthRecords.any((record) => 
        record.followUpDate != null && 
        record.followUpDate!.isBefore(now.add(Duration(days: 7))))).toList();
  }

  // Sample Data Initialization
  static void _initializeCattleSampleData() {
    // Holstein Dairy Cow - Bella
    final bella = AnimalProfile(
      id: 'cattle_001',
      name: 'Bella',
      species: 'Cattle',
      breed: 'Holstein Friesian',
      gender: 'Female',
      birthDate: DateTime(2021, 3, 15),
      birthWeight: 42.0,
      identificationNumber: 'HF-2021-001',
      identificationType: 'Ear Tag',
      origin: 'Born on Farm',
      acquisitionDate: DateTime(2021, 3, 15),
      acquisitionCost: 0.0,
      currentLocation: 'Dairy Barn A',
      status: AnimalStatus.lactating,
      notes: 'High-producing dairy cow with excellent genetics',
      healthRecords: [
        HealthRecord(
          id: 'health_001',
          date: DateTime.now().subtract(Duration(days: 30)),
          type: HealthRecordType.vaccination,
          description: 'Annual vaccination program',
          treatment: 'IBR-BVD-PI3-BRSV vaccine',
          veterinarian: 'Dr. Smith',
          cost: 25.0,
          notes: 'No adverse reactions observed',
        ),
      ],
      productionRecords: [
        ProductionRecord(
          id: 'prod_001',
          date: DateTime.now().subtract(Duration(days: 1)),
          type: ProductionType.milk,
          quantity: 28.5,
          unit: 'liters',
          quality: 3.8,
          qualityMetric: 'Fat %',
        ),
      ],
      weightRecords: [
        WeightRecord(
          id: 'weight_001',
          date: DateTime.now().subtract(Duration(days: 60)),
          weight: 580.0,
          bodyConditionScore: '3.5',
        ),
      ],
      lastUpdated: DateTime.now(),
    );
    _animals[bella.id] = bella;

    // Angus Bull - Thor
    final thor = AnimalProfile(
      id: 'cattle_002',
      name: 'Thor',
      species: 'Cattle',
      breed: 'Angus',
      gender: 'Male',
      birthDate: DateTime(2020, 5, 20),
      birthWeight: 38.0,
      identificationNumber: 'ANG-2020-001',
      identificationType: 'Ear Tag',
      origin: 'Purchased',
      acquisitionDate: DateTime(2021, 8, 10),
      acquisitionCost: 3500.0,
      currentLocation: 'Bull Pen',
      status: AnimalStatus.active,
      notes: 'Proven breeding bull with excellent EPDs',
      healthRecords: [
        HealthRecord(
          id: 'health_002',
          date: DateTime.now().subtract(Duration(days: 45)),
          type: HealthRecordType.examination,
          description: 'Breeding soundness examination',
          diagnosis: 'Satisfactory breeder',
          veterinarian: 'Dr. Johnson',
          cost: 150.0,
        ),
      ],
      weightRecords: [
        WeightRecord(
          id: 'weight_002',
          date: DateTime.now().subtract(Duration(days: 30)),
          weight: 950.0,
          bodyConditionScore: '6',
        ),
      ],
      lastUpdated: DateTime.now(),
    );
    _animals[thor.id] = thor;
  }

  static void _initializeGoatSampleData() {
    // Boer Goat - Luna
    final luna = AnimalProfile(
      id: 'goat_001',
      name: 'Luna',
      species: 'Goat',
      breed: 'Boer',
      gender: 'Female',
      birthDate: DateTime(2022, 2, 10),
      birthWeight: 3.2,
      identificationNumber: 'BG-2022-001',
      identificationType: 'Ear Tag',
      origin: 'Born on Farm',
      acquisitionDate: DateTime(2022, 2, 10),
      acquisitionCost: 0.0,
      currentLocation: 'Goat Pasture',
      status: AnimalStatus.pregnant,
      notes: 'First kidding expected in spring',
      healthRecords: [
        HealthRecord(
          id: 'health_003',
          date: DateTime.now().subtract(Duration(days: 15)),
          type: HealthRecordType.preventive,
          description: 'Pregnancy check and care',
          diagnosis: 'Healthy pregnancy, twins expected',
          veterinarian: 'Dr. Williams',
          cost: 50.0,
        ),
      ],
      breedingRecords: [
        BreedingRecord(
          id: 'breed_001',
          date: DateTime.now().subtract(Duration(days: 120)),
          type: BreedingType.naturalMating,
          maleID: 'goat_002',
          maleName: 'Atlas',
          expectedDueDate: DateTime.now().add(Duration(days: 30)),
          outcome: BreedingOutcome.pregnant,
        ),
      ],
      weightRecords: [
        WeightRecord(
          id: 'weight_003',
          date: DateTime.now().subtract(Duration(days: 7)),
          weight: 55.0,
          bodyConditionScore: '3',
        ),
      ],
      lastUpdated: DateTime.now(),
    );
    _animals[luna.id] = luna;
  }

  static void _initializePigSampleData() {
    // Yorkshire Sow - Rosie
    final rosie = AnimalProfile(
      id: 'pig_001',
      name: 'Rosie',
      species: 'Pig',
      breed: 'Yorkshire',
      gender: 'Female',
      birthDate: DateTime(2021, 9, 5),
      birthWeight: 1.8,
      identificationNumber: 'YS-2021-001',
      identificationType: 'Ear Notch',
      origin: 'Purchased',
      acquisitionDate: DateTime(2022, 1, 15),
      acquisitionCost: 450.0,
      currentLocation: 'Farrowing Barn',
      status: AnimalStatus.lactating,
      notes: 'Excellent mother with large litters',
      healthRecords: [
        HealthRecord(
          id: 'health_004',
          date: DateTime.now().subtract(Duration(days: 20)),
          type: HealthRecordType.vaccination,
          description: 'Pre-farrowing vaccination',
          treatment: 'E. coli vaccine',
          veterinarian: 'Dr. Brown',
          cost: 35.0,
        ),
      ],
      breedingRecords: [
        BreedingRecord(
          id: 'breed_002',
          date: DateTime.now().subtract(Duration(days: 135)),
          type: BreedingType.artificialInsemination,
          semenSource: 'Genetic Technologies Inc.',
          actualBirthDate: DateTime.now().subtract(Duration(days: 21)),
          outcome: BreedingOutcome.successful,
          numberOfOffspring: 12,
        ),
      ],
      weightRecords: [
        WeightRecord(
          id: 'weight_004',
          date: DateTime.now().subtract(Duration(days: 25)),
          weight: 180.0,
          bodyConditionScore: '3',
        ),
      ],
      lastUpdated: DateTime.now(),
    );
    _animals[rosie.id] = rosie;
  }

  static void _initializePoultryFlockData() {
    // Rhode Island Red Flock
    for (int i = 1; i <= 50; i++) {
      final hen = AnimalProfile(
        id: 'poultry_${i.toString().padLeft(3, '0')}',
        name: 'RIR-${i.toString().padLeft(2, '0')}',
        species: 'Poultry',
        breed: 'Rhode Island Red',
        gender: 'Female',
        birthDate: DateTime(2023, 4, 1),
        birthWeight: 0.05,
        identificationNumber: 'RIR-2023-${i.toString().padLeft(3, '0')}',
        identificationType: 'Wing Band',
        origin: 'Purchased',
        acquisitionDate: DateTime(2023, 4, 1),
        acquisitionCost: 5.0,
        currentLocation: 'Layer House 1',
        status: AnimalStatus.active,
        notes: 'Part of main laying flock',
        productionRecords: [
          ProductionRecord(
            id: 'prod_poultry_$i',
            date: DateTime.now().subtract(Duration(days: 1)),
            type: ProductionType.eggs,
            quantity: 1.0,
            unit: 'eggs',
          ),
        ],
        weightRecords: [
          WeightRecord(
            id: 'weight_poultry_$i',
            date: DateTime.now().subtract(Duration(days: 30)),
            weight: 2.2,
          ),
        ],
        lastUpdated: DateTime.now(),
      );
      _animals[hen.id] = hen;
    }
  }

  // Search and Filter Functions
  static List<AnimalProfile> searchAnimals(String query) {
    final lowerQuery = query.toLowerCase();
    return _animals.values.where((animal) =>
      animal.name.toLowerCase().contains(lowerQuery) ||
      animal.identificationNumber.toLowerCase().contains(lowerQuery) ||
      animal.breed.toLowerCase().contains(lowerQuery) ||
      animal.species.toLowerCase().contains(lowerQuery)).toList();
  }

  static List<AnimalProfile> filterAnimals({
    String? species,
    String? breed,
    AnimalStatus? status,
    String? location,
    DateTime? birthDateFrom,
    DateTime? birthDateTo,
  }) {
    return _animals.values.where((animal) {
      if (species != null && animal.species != species) return false;
      if (breed != null && animal.breed != breed) return false;
      if (status != null && animal.status != status) return false;
      if (location != null && animal.currentLocation != location) return false;
      if (birthDateFrom != null && animal.birthDate.isBefore(birthDateFrom)) return false;
      if (birthDateTo != null && animal.birthDate.isAfter(birthDateTo)) return false;
      return true;
    }).toList();
  }
}