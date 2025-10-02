
// This file contains sample data for all sections of the application.
// This data will be used to populate the database if it's empty.

const sampleData = {
    clients: [
        { name: 'John Smith', farm_name: 'Smith Farms', contact: '555-1234' },
        { name: 'Jane Doe', farm_name: 'Doe Meadows', contact: '555-5678' }
    ],
    livestock: [
        { client_id: '1', animal: 'Cow', tag: 'A-01', breed: 'Holstein', birthDate: '2022-01-15', gender: 'Female', weight: '1200', vaccination_status: 'Up to date' },
        { client_id: '1', animal: 'Cow', tag: 'A-02', breed: 'Angus', birthDate: '2022-03-20', gender: 'Male', weight: '1500', vaccination_status: 'Needs booster' },
        { client_id: '2', animal: 'Sheep', tag: 'S-01', breed: 'Merino', birthDate: '2023-04-10', gender: 'Female', weight: '150', vaccination_status: 'Up to date' }
    ],
    health: [
        { animal_tag: 'A-01', date: '2023-10-26', diagnosis: 'Mastitis', veterinarian: 'Dr. Devin', observation: { clinical_signs: 'Swollen udder', behavior: 'Lethargic' }, vital_signs: { temperature: '102.5 F', heart_rate: '80 bpm', respiratory_rate: '30 rpm' }, treatment: { medication: 'Penicillin', dosage: '10cc', route: 'IM', start_date: '2023-10-26', end_date: '2023-10-31', withdrawal_period: '5 days' }, follow_up: { notes: 'Re-check in 1 week', next_appointment: '2023-11-02' } }
    ],
    vaccination: [
        { animal_tag: 'A-01', vaccine_name: '8-way', date: '2023-09-01', next_due_date: '2024-09-01', quarantine_status: 'None' }
    ],
    breeding: [
        { animal_tag: 'A-01', breeding_date: '2023-05-10', due_date: '2024-02-15', sire_tag: 'B-01', dam_tag: 'A-01', insemination_method: 'AI' }
    ],
    feed: [
        { animal_tag: 'A-02', feed_type: 'Grain', feed_formulation: 'High-energy mix', quantity: '20', unit: 'lbs/day' }
    ],
    lab_results: [
        { animal_tag: 'S-01', test_type: 'Fecal Egg Count', date: '2023-11-01', results: 'Low', notes: 'No deworming needed.' }
    ],
    fields: [
        { name: 'North Field', size: '40', location: '45.123, -93.456' },
        { name: 'South Pasture', size: '100', location: '45.120, -93.450' }
    ],
    crops: [
        { field: 'North Field', crop: 'Corn', variety: 'DKC50-84RIB', plantingDate: '2023-05-01', harvestDate: '2023-10-15' }
    ],
    soil_analysis: [
        { field: 'North Field', date: '2023-04-15', ph: '6.8', nitrogen: '150', phosphorus: '75', potassium: '100' }
    ],
    irrigation: [
        { field: 'North Field', date: '2023-07-20', duration_minutes: '120', water_amount: '5000', unit: 'gallons' }
    ],
    scouting: [
        { field: 'North Field', date: '2023-08-01', issue: 'Corn borer', severity: 'Low' }
    ],
    pest_control: [
        { field: 'North Field', date: '2023-08-05', issue: 'Corn borer', treatment: 'Insecticide', application_rate: '1 qt/acre' }
    ],
    harvest_log: [
        { crop: 'Corn', field: 'North Field', date: '2023-10-15', quantity: '8000', unit: 'bushels', quality: 'Good', storage_location: 'Silo 3' }
    ],
    yield: [
        { field: 'North Field', crop: 'Corn', quantity: '200', unit: 'bu/acre' }
    ],
    production: [
        { type: 'Milk', quantity: '500', unit: 'gallons', date: '2023-10-31' }
    ],
    finance: [
        { date: '2023-10-28', type: 'Expense', category: 'Feed', amount: '500' },
        { date: '2023-10-25', type: 'Income', category: 'Milk Sale', amount: '1200' }
    ],
    budget: [
        { category: 'Veterinary', budget: '2000', actual: '1500' }
    ],
    invoicing: [
        { client_id: '2', date: '2023-11-01', amount: '350', status: 'Unpaid' }
    ],
    supplies: [
        { item: 'Penicillin', quantity: '1000', unit: 'cc' },
        { item: 'Syringes', quantity: '500', unit: 'count' }
    ],
    harvested_goods: [
        { crop: 'Corn', quantity: '8000', unit: 'bushels' }
    ],
    equipment: [
        { name: 'Tractor', model: 'John Deere 8R', purchaseDate: '2020-01-10', maintenanceSchedule: 'Every 200 hours' }
    ]
};

// Function to populate Firestore with sample data
async function populateWithSampleData(db) {
    try {
        const collections = Object.keys(sampleData);
        let shouldPopulate = false;

        // Check if the 'clients' collection is empty. If so, we assume the whole DB is.
        const clientsSnap = await db.collection('clients').limit(1).get();
        if (clientsSnap.empty) {
            shouldPopulate = true;
        }

        if (shouldPopulate) {
            console.log('Database appears to be empty. Populating with sample data...');
            const batch = db.batch();

            for (const collectionName of collections) {
                const data = sampleData[collectionName];
                data.forEach(item => {
                    const docRef = db.collection(collectionName).doc();
                    batch.set(docRef, item);
                });
            }
            await batch.commit();
            console.log('Sample data successfully populated.');
        } else {
            console.log('Database already contains data. Skipping sample data population.');
        }
    } catch (error) {
        console.error('Error during sample data population check. This may be due to Firestore security rules. The application will continue without seeding data.', error);
    }
}
