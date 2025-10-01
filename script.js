
document.addEventListener('DOMContentLoaded', () => {
    const mainContent = document.getElementById('main-content');
    let currentSection = 'dashboard';

    // --- Data for all modules ---
    window.clientData = [{ id: 1, name: 'John Smith', farm_name: 'Smith Farms', contact: '555-1234' }];
    window.livestockData = [{ id: 1, client_id: 1, animal: 'Cow', tag: '001', breed: 'Holstein', birthDate: '2022-03-10', gender: 'Female', weight: '650kg', vaccination_status: 'Up-to-date' }];
    window.healthData = [{ id: 1, animal_tag: '001', date: '2024-07-20', clinical_signs: 'Reduced appetite, lethargy, swollen udder', temperature: '40.1°C', heart_rate: '80 bpm', respiratory_rate: '35 bpm', diagnosis: 'Clinical Mastitis', treatment: 'Intramammary antibiotics', dosage: '1 tube/quarter', withdrawal_period: '72 hours' }];
    window.vaccinationData = [{ id: 1, animal_tag: '001', vaccine_name: 'Bovishield Gold', date: '2024-07-15', next_due_date: '2025-07-15', quarantine_status: 'None' }];
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
    window.financialData = [{ id: 1, date: '2024-07-28', type: 'Income', category: 'Veterinary Services', amount: 1200 }];
    window.budgetData = [{ id: 1, category: 'Medical Supplies', budget: 15000, actual: 8500 }];
    window.suppliesData = [{ id: 1, item: 'Antibiotics', quantity: 100, unit: 'Bottles' }];
    window.harvestedGoodsData = [{ id: 1, crop: 'Corn', quantity: 10, unit: 'Tons' }];
    window.equipmentData = [{ id: 1, name: 'Ultrasound Machine', model: 'Easi-Scan', purchaseDate: '2022-01-15', maintenanceSchedule: 'Annual calibration' }];

    function renderDashboard() {
        const totalClients = window.clientData.length;
        const totalAnimals = window.livestockData.length;
        const upcomingVaccinations = window.vaccinationData.filter(v => new Date(v.next_due_date) > new Date());
        const upcomingDueDates = window.breedingData.filter(b => new Date(b.due_date) > new Date());

        return `
            <h2>Veterinary Dashboard</h2>
            <div class="dashboard-grid">
                <div class="dashboard-card"><h3>Total Clients</h3><p>${totalClients}</p></div>
                <div class="dashboard-card"><h3>Animals Under Care</h3><p>${totalAnimals}</p></div>
            </div>
            <div class="dashboard-section">
                <h3>Upcoming Reminders</h3>
                <div class="dashboard-list">
                    <h4>Next Vaccinations</h4>
                    <ul>${upcomingVaccinations.map(v => `<li>Animal #${v.animal_tag} - ${v.vaccine_name} due ${v.next_due_date}</li>`).join('')}</ul>
                    <h4>Breeding Due Dates</h4>
                    <ul>${upcomingDueDates.map(b => `<li>Animal #${b.animal_tag} - due ${b.due_date}</li>`).join('')}</ul>
                </div>
            </div>
            </div>`;
    }

    // --- Generic CRUD Functions ---
    function renderTable(title, data, dataName, headers, formFunctionName) {
        let html = `<h2>${title}</h2><button onclick="${formFunctionName}()">Add New</button>`;
        html += '<table><thead><tr>';
        headers.forEach(h => html += `<th>${h.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}</th>`);
        html += '<th>Actions</th></tr></thead><tbody>';
        data.forEach((row, index) => {
            html += '<tr>';
            headers.forEach(h => html += `<td>${row[h]}</td>`);
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
            formHtml += `<input type="${inputType}" name="${field}" placeholder="${placeholder}" value="${item[field] || ''}" required> `;
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
        health: () => renderTable('Health & Treatment', window.healthData, 'healthData', ['animal_tag', 'date', 'clinical_signs', 'temperature', 'heart_rate', 'respiratory_rate', 'diagnosis', 'treatment', 'dosage', 'withdrawal_period'], 'showHealthForm'),
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
        finance: () => renderTable('Transactions', window.financialData, 'financialData', ['date', 'type', 'category', 'amount'], 'showFinanceForm'),
        budget: () => renderTable('Budgeting', window.budgetData, 'budgetData', ['category', 'budget', 'actual'], 'showBudgetForm'),
        supplies: () => renderTable('Supplies', window.suppliesData, 'suppliesData', ['item', 'quantity', 'unit'], 'showSuppliesForm'),
        harvested_goods: () => renderTable('Harvested Goods', window.harvestedGoodsData, 'harvestedGoodsData', ['crop', 'quantity', 'unit'], 'showHarvested_goodsForm'),
        equipment: () => renderTable('Equipment', window.equipmentData, 'equipmentData', ['name', 'model', 'purchaseDate', 'maintenanceSchedule'], 'showEquipmentForm'),
        reports: () => `<h2>Reports</h2><button onclick="generateReport()">Generate Consolidated Report</button><div id="report-output"></div>`,
    };

    // --- Form Display and Submission Handlers ---
    const all_fields = {
        client: ['name', 'farm_name', 'contact'],
        livestock: ['client_id', 'animal', 'tag', 'breed', 'birthDate', 'gender', 'weight', 'vaccination_status'],
        health: ['animal_tag', 'date', 'clinical_signs', 'temperature', 'heart_rate', 'respiratory_rate', 'diagnosis', 'treatment', 'dosage', 'withdrawal_period'],
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
        finance: ['date', 'type', 'category', 'amount'],
        budget: ['category', 'budget', 'actual'],
        supplies: ['item', 'quantity', 'unit'],
        harvested_goods: ['crop', 'quantity', 'unit'],
        equipment: ['name', 'model', 'purchaseDate', 'maintenanceSchedule']
    };

    for (const [key, fields] of Object.entries(all_fields)) {
        const capitalizedKey = key.replace(/_([a-z])/g, g => g[1].toUpperCase()).charAt(0).toUpperCase() + key.slice(1).replace(/_([a-z])/g, g => g[1].toUpperCase());
        let dataName = `${key.split('_')[0]}Data`; // Use let instead of const
        
        // Handle specific cases for data names
        if (key.includes('_')) {
            dataName = `${key.split('_')[0]}${key.split('_')[1].charAt(0).toUpperCase() + key.split('_')[1].slice(1)}Data`;
        }


        window[`show${capitalizedKey}Form`] = (index) => showForm(index, window[dataName], fields, `handle${capitalizedKey}Submit`);
        window[`handle${capitalizedKey}Submit`] = createSubmitHandler(dataName, fields);
    }
    
    window.generateReport = function() {
        let report = '<h1>Consolidated Farm Report</h1>';

        // Clients and Livestock
        report += `<h2>Clients & Livestock</h2>`;
        report += `<p>Total Clients: ${window.clientData.length}</p>`;
        report += `<p>Total Animals: ${window.livestockData.length}</p>`;
        const animalByClient = window.clientData.map(client => {
            const count = window.livestockData.filter(animal => animal.client_id == client.id).length;
            return `<li>${client.name}: ${count} animals</li>`;
        }).join('');
        report += `<ul>${animalByClient}</ul>`;


        // Health
        report += `<h2>Animal Health</h2>`;
        report += `<p>Total Health Records: ${window.healthData.length}</p>`;
        report += `<p>Total Vaccination Records: ${window.vaccinationData.length}</p>`;

        // Breeding
        report += `<h2>Breeding Program</h2>`;
        report += `<p>Total Breeding Records: ${window.breedingData.length}</p>`;

        // Crop Management
        report += `<h2>Crop Management</h2>`;
        report += `<p>Total Fields: ${window.fieldData.length}</p>`;
        report += `<p>Total Crop Plans: ${window.cropPlanData.length}</p>`;
        report += `<p>Total Harvests: ${window.harvestLogData.length}</p>`;

        // Financials
        report += `<h2>Financial Overview</h2>`;
        const totalIncome = (window.financialData || []).filter(t => t.type === 'Income').reduce((sum, t) => sum + parseFloat(t.amount || 0), 0);
        const totalExpense = (window.financialData || []).filter(t => t.type === 'Expense').reduce((sum, t) => sum + parseFloat(t.amount || 0), 0);
        report += `<p>Total Income: $${totalIncome.toFixed(2)}</p>`;
        report += `<p>Total Expense: $${totalExpense.toFixed(2)}</p>`;
        report += `<p>Net Profit: $${(totalIncome - totalExpense).toFixed(2)}</p>`;

        // Inventory
        report += `<h2>Inventory</h2>`;
        report += `<p>Supply Items: ${window.suppliesData.length}</p>`;
        report += `<p>Harvested Goods Items: ${window.harvestedGoodsData.length}</p>`;


        document.getElementById('report-output').innerHTML = report;
    }

    // --- Navigation ---
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', (e) => {
            const section = e.target.getAttribute('data-section');
            if (section && renderers[section]) {
                e.preventDefault();
                currentSection = section;
                mainContent.innerHTML = renderers[section]();
            }
        });
    });

    mainContent.innerHTML = renderers.dashboard();
});
