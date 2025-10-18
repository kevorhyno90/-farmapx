import '../services/app_state.dart';
import '../models/animal.dart';
import '../models/calf.dart';
import '../models/poultry.dart';

class SimpleSampleDataService {
  static void populateAllSampleData(AppState appState) {
    try {
      populateBasicAnimals(appState);
      populateCalves(appState);
      populatePoultry(appState);
    } catch (e) {
      print('Error populating sample data: $e');
    }
  }

  static void populateBasicAnimals(AppState appState) {
    final sampleAnimals = [
      Animal(
        id: 'ANI001',
        tag: 'A001',
        species: 'Cow',
        breed: 'Holstein',
        location: 'Pasture A',
      ),
      Animal(
        id: 'ANI002',
        tag: 'A002',
        species: 'Bull',
        breed: 'Angus',
        location: 'Pasture B',
      ),
      Animal(
        id: 'ANI003',
        tag: 'A003',
        species: 'Sheep',
        breed: 'Merino',
        location: 'Sheep Pen',
      ),
    ];

    for (final animal in sampleAnimals) {
      appState.addAnimal(animal);
    }
  }

  static void populateCalves(AppState appState) {
    final sampleCalves = [
      Calf(
        id: 'CALF001',
        tag: 'C001',
        dob: '2024-09-15',
        sex: 'Female',
        status: 'healthy',
      ),
      Calf(
        id: 'CALF002',
        tag: 'C002',
        dob: '2024-09-01',
        sex: 'Male',
        status: 'healthy',
      ),
      Calf(
        id: 'CALF003',
        tag: 'C003',
        dob: '2024-08-20',
        sex: 'Female',
        status: 'monitoring',
      ),
    ];

    for (final calf in sampleCalves) {
      appState.addCalf(calf);
    }
  }

  static void populatePoultry(AppState appState) {
    final samplePoultry = [
      Poultry(
        id: 'POUL001',
        tag: 'CH001',
        species: 'Chicken',
        breed: 'Rhode Island Red',
        dob: '2024-01-15',
        sex: 'Female',
        purpose: 'Egg Production',
      ),
      Poultry(
        id: 'POUL002',
        tag: 'CH002',
        species: 'Chicken',
        breed: 'Leghorn',
        dob: '2024-01-15',
        sex: 'Female',
        purpose: 'Egg Production',
      ),
      Poultry(
        id: 'POUL003',
        tag: 'BR001',
        species: 'Chicken',
        breed: 'Broiler',
        dob: '2024-08-01',
        sex: 'Mixed',
        purpose: 'Meat Production',
      ),
      Poultry(
        id: 'POUL004',
        tag: 'DK001',
        species: 'Duck',
        breed: 'Pekin',
        dob: '2024-03-10',
        sex: 'Female',
        purpose: 'Egg Production',
      ),
      Poultry(
        id: 'POUL005',
        tag: 'TK001',
        species: 'Turkey',
        breed: 'Bronze',
        dob: '2024-04-01',
        sex: 'Male',
        purpose: 'Breeding',
      ),
    ];

    for (final bird in samplePoultry) {
      appState.addPoultry(bird);
    }
  }
}