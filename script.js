
document.addEventListener('DOMContentLoaded', () => {
    const mainContent = document.getElementById('main-content');
    let currentSection = 'dashboard';

    // --- Data Initialization ---
    function initializeData() {
        window.clientData = [{ id: 1, name: 'John Smith', farm_name: 'Smith Farms', contact: '555-1234' }];
        window.livestockData = [{ id: 1, client_id: 1, animal: 'Cow', tag: '001', breed: 'Holstein', birthDate: '2022-03-10', gender: 'Female', weight: '650kg', vaccination_status: 'Up-to-date' }];
        window.healthData = [
            {
                id: 1, animal_tag: '001', date: '2024-07-20', diagnosis: 'Clinical Mastitis', prognosis: 'Good', veterinarian: 'Dr. Evans',
                observation: { clinical_signs: 'Reduced appetite, lethargy, swollen udder', behavior: 'Restless and reluctant to move' },
                vital_signs: { temperature: '40.1°C', heart_rate: '80 bpm', respiratory_rate: '35 bpm' },
                treatment: { medication: 'Intramammary antibiotics', dosage: '1 tube/quarter', route: 'Intramammary', start_date: '2024-07-20', end_date: '2024-07-27', withdrawal_period: '72 hours (milk), 7 days (meat)' },
                follow_up: { notes: 'Re-check in 3 days. Monitor milk quality.', next_appointment: '2024-07-23' }
            }
        ];
        window.vaccinationData = [
            { id: 1, animal_tag: '001', vaccine_name: 'Bovishield Gold', date: '2024-07-15', next_due_date: '2025-07-15', quarantine_status: 'None' },
            { id: 2, animal_tag: '002', vaccine_name: 'CalfGuard', date: '2023-10-01', next_due_date: '2024-04-01', quarantine_status: 'None' }
        ];
        window.breedingData = [{ id: 1, animal_tag: '001', breeding_date: '2024-06-01', due_date: '2025-03-01', sire_tag: 'S012', dam_tag: 'D045', insemination_method: 'AI' }];
        window.feedData = [{ id: 1, animal_tag: '001', feed_type: 'TMR', feed_formulation: 'Corn silage, Alfalfa hay, Protein supplement', quantity: 25, unit: 'kg' }];
        window.labResultsData = [{ id: 1, animal_tag: '001', test_type: 'Milk Culture', date: '2024-07-18', results: 'Staphylococcus aureus positive', notes: 'High somatic cell count observed.' }];
        window.fieldData = [{ id: 1, name: 'North Field', size: 50, location: 'Northern border' }];
        window.cropPlanData = [{ id: 1, field: 'North Field', crop: 'Corn', variety: 'Golden Bantam', plantingDate: '2024-05-15', harvestDate: '2024-08-20' }];
        window.soilAnalysisData = [{ id: 1, field: 'North Field', date: '2024-04-15', ph: 6.8, nitrogen: 20, phosphorus: 15, potassium: 25 }];
        window.irrigationData = [{ id: 1, field: 'North Field', date: '2024-06-20', duration_minutes: 60, water_amount: 5000, unit: 'gallons' }];
        window.scoutingData = [{ id: 1, field: 'North Field', date: '2024-06-10', issue: 'Corn Borer', severity: 'Low' }];
        window.pestControlData = [{ id: 1, field: 'North Field', date: '2024-06-12', issue: 'Corn Borer', treatment: 'Pesticide A', application_rate: '1L/ha' }];
        window.harvestLogData = [{ id: 1, crop: 'Corn', field: 'North Field', date: '2024-08-20', quantity: 10, unit: 'Tons', quality: 'Grade A', storage_location: 'Silo 1' }];
        window.yieldData = [{ id: 1, field: 'North Field', crop: 'Corn', quantity: 10, unit: 'Tons' }];
        window.productionData = [{ id: 1, type: 'Milk', quantity: 100, unit: 'Litres', date: '2024-07-28' }];
        window.invoiceData = [{ id: 1, client_id: 1, date: '2024-07-28', amount: 1200, status: 'Paid' }];
        window.financialData = [
            { id: 1, date: '2024-07-28', type: 'Income', category: 'Veterinary Services', amount: 1200 },
            { id: 2, date: '2024-07-27', type: 'Expense', category: 'Medical Supplies', amount: 350 },
            { id: 3, date: '2024-07-26', type: 'Income', category: 'Crop Sales', amount: 2500 }
        ];
        window.budgetData = [{ id: 1, category: 'Medical Supplies', budget: 15000, actual: 8500 }];
        window.suppliesData = [
            { id: 1, item: 'Antibiotics', quantity: 15, unit: 'Bottles' },
            { id: 2, item: 'Vaccines', quantity: 50, unit: 'Doses' },
            { id: 3, item: 'Feed Supplement', quantity: 10, unit: 'Bags' }
        ];
        window.harvestedGoodsData = [{ id: 1, crop: 'Corn', quantity: 10, unit: 'Tons' }];
        window.equipmentData = [{ id: 1, name: 'Ultrasound Machine', model: 'Easi-Scan', purchaseDate: '2022-01-15', maintenanceSchedule: 'Annual calibration' }];
    }

    // --- Dashboard Rendering ---
    function renderDashboard() {
        const totalClients = window.clientData.length;
        const totalAnimals = window.livestockData.length;
        mainContent.innerHTML = `<h2>Dashboard</h2>
            <p>Total Clients: ${totalClients}</p>
            <p>Total Animals: ${totalAnimals}</p>`;
    }

    // --- Health Module Specific Functions ---
    function renderHealth() {
        let html = `<h2>Health & Treatment</h2><button onclick="showHealthForm()">Add New Health Record</button>`;
        html += `<table>
                    <thead>
                        <tr>
                            <th>Animal Tag</th><th>Date</th><th>Diagnosis</th><th>Veterinarian</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>`;
        window.healthData.forEach((record, index) => {
            html += `
                <tr class="health-row">
                    <td>${record.animal_tag}</td>
                    <td>${record.date}</td>
                    <td>${record.diagnosis}</td>
                    <td>${record.veterinarian}</td>
                    <td>
                        <button onclick="toggleDetails(${index})">Details</button>
                        <button onclick="showHealthForm(${index})">Edit</button>
                        <button onclick="deleteItem('healthData', ${index})">Delete</button>
                    </td>
                </tr>
                <tr id="details-${index}" class="details-row">
                    <td colspan="5" class="details-cell">
                        <div class="details-grid">
                            <div class="details-group">
                                <h4>Observation</h4>
                                <p><strong>Clinical Signs:</strong> ${record.observation.clinical_signs}</p>
                                <p><strong>Behavior:</strong> ${record.observation.behavior}</p>
                            </div>
                            <div class="details-group">
                                <h4>Vital Signs</h4>
                                <p><strong>Temperature:</strong> ${record.vital_signs.temperature}</p>
                                <p><strong>Heart Rate:</strong> ${record.vital_signs.heart_rate}</p>
                                <p><strong>Respiratory Rate:</strong> ${record.vital_signs.respiratory_rate}</p>
                            </div>
                            <div class="details-group">
                                <h4>Treatment</h4>
                                <p><strong>Medication:</strong> ${record.treatment.medication}</p>
                                <p><strong>Dosage:</strong> ${record.treatment.dosage}</p>
                                <p><strong>Route:</strong> ${record.treatment.route}</p>
                                <p><strong>Duration:</strong> ${record.treatment.start_date} to ${record.treatment.end_date}</p>
                                <p><strong>Withdrawal:</strong> ${record.treatment.withdrawal_period}</p>
                            </div>
                            <div class="details-group">
                                <h4>Follow-up</h4>
                                <p><strong>Next Appointment:</strong> ${record.follow_up.next_appointment}</p>
                                <p><strong>Notes:</strong> ${record.follow_up.notes}</p>
                            </div>
                        </div>
                    </td>
                </tr>`;
        });
        html += `</tbody></table><div id="form-container"></div>`;
        mainContent.innerHTML = html;
    }

    window.toggleDetails = function(index) {
        document.getElementById(`details-${index}`).classList.toggle('show');
    }

    window.showHealthForm = function(index) {
        const item = index !== undefined ? window.healthData[index] : {};
        const formHtml = `
            <h3>${index !== undefined ? 'Edit' : 'Add'} Health Record</h3>
            <form onsubmit="handleHealthSubmit(event, ${index})">
                <h4>Basic Info</h4>
                <input type="text" name="animal_tag" placeholder="Animal Tag" value="${item.animal_tag || ''}" required>
                <input type="date" name="date" value="${item.date || ''}" required>
                <input type="text" name="diagnosis" placeholder="Diagnosis" value="${item.diagnosis || ''}" required>
                <input type="text" name="veterinarian" placeholder="Veterinarian" value="${item.veterinarian || ''}" required>

                <h4>Observation</h4>
                <textarea name="observation_clinical_signs" placeholder="Clinical Signs">${item.observation?.clinical_signs || ''}</textarea>
                <textarea name="observation_behavior" placeholder="Behavior">${item.observation?.behavior || ''}</textarea>

                <h4>Vital Signs</h4>
                <input type="text" name="vital_signs_temperature" placeholder="Temperature" value="${item.vital_signs?.temperature || ''}">
                <input type="text" name="vital_signs_heart_rate" placeholder="Heart Rate" value="${item.vital_signs?.heart_rate || ''}">
                <input type="text" name="vital_signs_respiratory_rate" placeholder="Respiratory Rate" value="${item.vital_signs?.respiratory_rate || ''}">

                <h4>Treatment</h4>
                <input type="text" name="treatment_medication" placeholder="Medication" value="${item.treatment?.medication || ''}">
                <input type="text" name="treatment_dosage" placeholder="Dosage" value="${item.treatment?.dosage || ''}">
                <input type="text" name="treatment_route" placeholder="Route" value="${item.treatment?.route || ''}">
                <input type="date" name="treatment_start_date" placeholder="Start Date" value="${item.treatment?.start_date || ''}">
                <input type="date" name="treatment_end_date" placeholder="End Date" value="${item.treatment?.end_date || ''}">
                <input type="text" name="treatment_withdrawal_period" placeholder="Withdrawal Period" value="${item.treatment?.withdrawal_period || ''}">

                <h4>Follow-up</h4>
                <input type="date" name="follow_up_next_appointment" placeholder="Next Appointment" value="${item.follow_up?.next_appointment || ''}">
                <textarea name="follow_up_notes" placeholder="Follow-up Notes">${item.follow_up?.notes || ''}</textarea>

                <button type="submit">${index !== undefined ? 'Update' : 'Save'} Record</button>
            </form>`;
        document.getElementById('form-container').innerHTML = formHtml;
    }

    window.handleHealthSubmit = function(event, index) {
        event.preventDefault();
        const formData = new FormData(event.target);
        const record = {
            id: index !== undefined ? window.healthData[index].id : Date.now(),
            animal_tag: formData.get('animal_tag'),
            date: formData.get('date'),
            diagnosis: formData.get('diagnosis'),
            prognosis: formData.get('prognosis'),
            veterinarian: formData.get('veterinarian'),
            observation: {
                clinical_signs: formData.get('observation_clinical_signs'),
                behavior: formData.get('observation_behavior'),
            },
            vital_signs: {
                temperature: formData.get('vital_signs_temperature'),
                heart_rate: formData.get('vital_signs_heart_rate'),
                respiratory_rate: formData.get('vital_signs_respiratory_rate'),
            },
            treatment: {
                medication: formData.get('treatment_medication'),
                dosage: formData.get('treatment_dosage'),
                route: formData.get('treatment_route'),
                start_date: formData.get('treatment_start_date'),
                end_date: formData.get('treatment_end_date'),
                withdrawal_period: formData.get('treatment_withdrawal_period'),
            },
            follow_up: {
                notes: formData.get('follow_up_notes'),
                next_appointment: formData.get('follow_up_next_appointment'),
            }
        };

        if (index !== undefined) {
            window.healthData[index] = record;
        } else {
            window.healthData.push(record);
        }
        renderers.health();
    }

    // --- Generic CRUD Functions ---
    function renderTable(title, data, dataName, headers, formFunctionName) {
        let html = `<h2>${title}</h2><button onclick="${formFunctionName}()">Add New</button>`;
        html += '<table><thead><tr>';
        headers.forEach(h => html += `<th>${h.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}</th>`);
        html += '<th>Actions</th></tr></thead><tbody>';
        data.forEach((row, index) => {
            html += '<tr>';
            headers.forEach(h => html += `<td>${row[h] === undefined ? '' : row[h]}</td>`);
            html += `<td><button onclick="${formFunctionName}(${index})">Edit</button> <button onclick="deleteItem('${dataName}', ${index})">Delete</button></td></tr>`;
        });
        html += `</tbody></table><div id="form-container"></div>`;
        return html;
    }

    function showForm(index, data, fields, handlerName) {
        const item = index !== undefined ? data[index] : {};
        let formHtml = `<form onsubmit="${handlerName}(event, ${index})">`;
        fields.forEach(field => {
            const placeholder = field.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
            let inputType = 'text';
            if (field.includes('date')) inputType = 'date';
            if (['amount', 'size', 'quantity', 'budget', 'actual', 'ph', 'nitrogen', 'phosphorus', 'potassium', 'duration_minutes', 'water_amount', 'client_id'].includes(field)) inputType = 'number';
            
            let value = item[field] || '';
            if (inputType === 'date' && value) {
                value = new Date(value).toISOString().split('T')[0];
            }

            formHtml += `<input type="${inputType}" name="${field}" placeholder="${placeholder}" value="${value}" required> `;
        });
        formHtml += `<button type="submit">${index !== undefined ? 'Update' : 'Save'}</button></form>`;
        document.getElementById('form-container').innerHTML = formHtml;
    }

    const createSubmitHandler = (dataName, fields) => (event, index) => {
        event.preventDefault();
        const dataArray = window[dataName];
        const formData = new FormData(event.target);
        const newItem = { id: index !== undefined ? dataArray[index].id : Date.now() };
        fields.forEach(field => newItem[field] = formData.get(field));
        if (index !== undefined) {
            dataArray[index] = newItem;
        } else {
            dataArray.push(newItem);
        }
        mainContent.innerHTML = renderers[currentSection]();
    };

    window.deleteItem = function(dataName, index) {
        if (confirm('Are you sure you want to delete this item?')) {
            window[dataName].splice(index, 1);
            mainContent.innerHTML = renderers[currentSection]();
        }
    };

    // --- Renderers for all sections ---
    const renderers = {
        dashboard: renderDashboard,
        clients: () => renderTable('Clients', window.clientData, 'clientData', ['name', 'farm_name', 'contact'], 'showClientForm'),
        livestock: () => renderTable('Animal Records', window.livestockData, 'livestockData', ['client_id', 'animal', 'tag', 'breed', 'birthDate', 'gender', 'weight', 'vaccination_status'], 'showLivestockForm'),
        health: renderHealth,
        vaccination: () => renderTable('Vaccination & Quarantine', window.vaccinationData, 'vaccinationData', ['animal_tag', 'vaccine_name', 'date', 'next_due_date', 'quarantine_status'], 'showVaccinationForm'),
        breeding: () => renderTable('Breeding Records', window.breedingData, 'breedingData', ['animal_tag', 'breeding_date', 'due_date', 'sire_tag', 'dam_tag', 'insemination_method'], 'showBreedingForm'),
        feed: () => renderTable('Feed Management', window.feedData, 'feedData', ['animal_tag', 'feed_type', 'feed_formulation', 'quantity', 'unit'], 'showFeedForm'),
        lab_results: () => renderTable('Laboratory Results', window.labResultsData, 'labResultsData', ['animal_tag', 'test_type', 'date', 'results', 'notes'], 'showLab_resultsForm'),
        fields: () => renderTable('Field Mapping', window.fieldData, 'fieldData', ['name', 'size', 'location'], 'showFieldForm'),
        crops: () => renderTable('Crop Planning', window.cropPlanData, 'cropPlanData', ['field', 'crop', 'variety', 'plantingDate', 'harvestDate'], 'showCropsForm'),
        soil_analysis: () => renderTable('Soil Analysis', window.soilAnalysisData, 'soilAnalysisData', ['field', 'date', 'ph', 'nitrogen', 'phosphorus', 'potassium'], 'showSoil_analysisForm'),
        irrigation: () => renderTable('Irrigation', window.irrigationData, 'irrigationData', ['field', 'date', 'duration_minutes', 'water_amount', 'unit'], 'showIrrigationForm'),
        scouting: () => renderTable('Scouting', window.scoutingData, 'scoutingData', ['field', 'date', 'issue', 'severity'], 'showScoutingForm'),
        pest_control: () => renderTable('Pest & Disease Control', window.pestControlData, 'pestControlData', ['field', 'date', 'issue', 'treatment', 'application_rate'], 'showPest_controlForm'),
        harvest_log: () => renderTable('Harvest Log', window.harvestLogData, 'harvestLogData', ['crop', 'field', 'date', 'quantity', 'unit', 'quality', 'storage_location'], 'showHarvest_logForm'),
        yield: () => renderTable('Yield Tracking', window.yieldData, 'yieldData', ['field', 'crop', 'quantity', 'unit'], 'showYieldForm'),
        production: () => renderTable('Production', window.productionData, 'productionData', ['type', 'quantity', 'unit', 'date'], 'showProductionForm'),
        finance: () => renderTable('Transactions', window.financialData, 'financialData', ['date', 'type', 'category', 'amount'], 'showFinanceForm'),
        budget: () => renderTable('Budgeting', window.budgetData, 'budgetData', ['category', 'budget', 'actual'], 'showBudgetForm'),
        invoicing: () => renderTable('Invoices', window.invoiceData, 'invoiceData', ['client_id', 'date', 'amount', 'status'], 'showInvoicingForm'),
        supplies: () => renderTable('Supplies', window.suppliesData, 'suppliesData', ['item', 'quantity', 'unit'], 'showSuppliesForm'),
        harvested_goods: () => renderTable('Harvested Goods', window.harvestedGoodsData, 'harvestedGoodsData', ['crop', 'quantity', 'unit'], 'showHarvested_goodsForm'),
        equipment: () => renderTable('Equipment', window.equipmentData, 'equipmentData', ['name', 'model', 'purchaseDate', 'maintenanceSchedule'], 'showEquipmentForm'),
        reports: () => `<h2>Reports</h2><p>This section will contain various generated reports.</p>`
    };

    // --- Form Display and Submission Handlers ---
    const all_fields = {
        client: ['name', 'farm_name', 'contact'],
        livestock: ['client_id', 'animal', 'tag', 'breed', 'birthDate', 'gender', 'weight', 'vaccination_status'],
        vaccination: ['animal_tag', 'vaccine_name', 'date', 'next_due_date', 'quarantine_status'],
        breeding: ['animal_tag', 'breeding_date', 'due_date', 'sire_tag', 'dam_tag', 'insemination_method'],
        feed: ['animal_tag', 'feed_type', 'feed_formulation', 'quantity', 'unit'],
        lab_results: ['animal_tag', 'test_type', 'date', 'results', 'notes'],
        field: ['name', 'size', 'location'],
        crops: ['field', 'crop', 'variety', 'plantingDate', 'harvestDate'],
        soil_analysis: ['field', 'date', 'ph', 'nitrogen', 'phosphorus', 'potassium'],
        irrigation: ['field', 'date', 'duration_minutes', 'water_amount', 'unit'],
        scouting: ['field', 'date', 'issue', 'severity'],
        pest_control: ['field', 'date', 'issue', 'treatment', 'application_rate'],
        harvest_log: ['crop', 'field', 'date', 'quantity', 'unit', 'quality', 'storage_location'],
        yield: ['field', 'crop', 'quantity', 'unit'],
        production: ['type', 'quantity', 'unit', 'date'],
        finance: ['date', 'type', 'category', 'amount'],
        budget: ['category', 'budget', 'actual'],
        invoicing: ['client_id', 'date', 'amount', 'status'],
        supplies: ['item', 'quantity', 'unit'],
        harvested_goods: ['crop', 'quantity', 'unit'],
        equipment: ['name', 'model', 'purchaseDate', 'maintenanceSchedule']
    };

    const dataNameMapping = {
        client: 'clientData',
        livestock: 'livestockData',
        vaccination: 'vaccinationData',
        breeding: 'breedingData',
        feed: 'feedData',
        lab_results: 'labResultsData',
        field: 'fieldData',
        crops: 'cropPlanData',
        soil_analysis: 'soilAnalysisData',
        irrigation: 'irrigationData',
        scouting: 'scoutingData',
        pest_control: 'pestControlData',
        harvest_log: 'harvestLogData',
        yield: 'yieldData',
        production: 'productionData',
        finance: 'financialData',
        budget: 'budgetData',
        invoicing: 'invoiceData', 
        supplies: 'suppliesData',
        harvested_goods: 'harvestedGoodsData',
        equipment: 'equipmentData'
    };
    
    for (const [key, fields] of Object.entries(all_fields)) {
        const capitalizedKey = key.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join('');
        const dataName = dataNameMapping[key];
        window[`show${capitalizedKey}Form`] = (index) => showForm(index, window[dataName], fields, `handle${capitalizedKey}Submit`);
        window[`handle${capitalizedKey}Submit`] = createSubmitHandler(dataName, fields);
    }

    // --- Navigation ---
    document.querySelectorAll('nav a').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const section = e.target.getAttribute('data-section');
            if (section && renderers[section]) {
                currentSection = section;
                mainContent.innerHTML = renderers[section]();
            }
        });
    });

    // --- Initial Load ---
    initializeData();
    mainContent.innerHTML = renderers.dashboard(); // Load dashboard by default
});
