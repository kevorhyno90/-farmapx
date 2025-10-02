
document.addEventListener('DOMContentLoaded', () => {
    const mainContent = document.getElementById('main-content');
    let currentSection = 'dashboard';
    const db = firebase.firestore();

    // Populate the database in the background without blocking the UI.
    populateWithSampleData(db);

    // --- Navigation and Content Rendering ---
    async function setContent(section) {
        currentSection = section;
        const renderer = renderers[section];
        if (!renderer) {
            mainContent.innerHTML = `<p>Section not found.</p>`;
            return;
        }
        try {
            const { html, callback } = await renderer();
            mainContent.innerHTML = html;
            if (callback) callback();
        } catch (error) {
            console.error("Error rendering section:", error);
            mainContent.innerHTML = `<p>Error loading this section. Please check your connection and configuration.</p>`;
        }
    }

    document.querySelectorAll('nav a, .dropdown-content a').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const section = e.target.getAttribute('data-section');
            if (section) setContent(section);
        });
    });

    // --- Form Submission Handler ---
    async function handleFormSubmit(e) {
        e.preventDefault();
        const form = e.target;
        const id = form.dataset.id;
        const formData = new FormData(form);
        let data = {};

        try {
            if (currentSection === 'health') {
                data = {
                    animal_tag: formData.get('basic_info_animal_tag'), date: formData.get('basic_info_date'),
                    diagnosis: formData.get('basic_info_diagnosis'), veterinarian: formData.get('basic_info_veterinarian'),
                    observation: { clinical_signs: formData.get('observation_clinical_signs'), behavior: formData.get('observation_behavior') },
                    vital_signs: { temperature: formData.get('vital_signs_temperature'), heart_rate: formData.get('vital_signs_heart_rate'), respiratory_rate: formData.get('vital_signs_respiratory_rate') },
                    treatment: { medication: formData.get('treatment_medication'), dosage: formData.get('treatment_dosage'), route: formData.get('treatment_route'), start_date: formData.get('treatment_start_date'), end_date: formData.get('treatment_end_date'), withdrawal_period: formData.get('treatment_withdrawal_period') },
                    follow_up: { notes: formData.get('follow_up_notes'), next_appointment: formData.get('follow_up_next_appointment') }
                };
            } else {
                all_fields[currentSection].forEach(field => data[field] = formData.get(field));
            }

            if (id) {
                await db.collection(currentSection).doc(id).set(data, { merge: true });
            } else {
                await db.collection(currentSection).add(data);
            }
            setContent(currentSection);
        } catch (error) {
            console.error(`Error saving to ${currentSection}:`, error);
            alert('Failed to save data. Please check console for details.');
        }
    }

    // --- Data Fetching and Rendering ---
    const renderers = {
        dashboard: async () => {
            let html = `<h2>Dashboard</h2>`;
            try {
                const [clients, livestock, health] = await Promise.all([
                    db.collection('clients').get(),
                    db.collection('livestock').get(),
                    db.collection('health').orderBy('date', 'desc').limit(5).get()
                ]);
                html += `
                    <div class="summary-grid">
                        <p>Total Clients: ${clients.size}</p>
                        <p>Total Animals: ${livestock.size}</p>
                    </div>
                    <div class="dashboard-section">
                        <h3>Recent Health Records</h3>
                        <ul>${health.docs.map(doc => `<li>[${doc.data().date}] ${doc.data().animal_tag}: ${doc.data().diagnosis}</li>`).join('')}</ul>
                    </div>
                `;
            } catch (error) {
                console.error("Error fetching dashboard data: ", error);
                html += '<p>Could not load dashboard data.</p>';
            }
            return { html };
        },
        health: () => renderHealth(),
        reports: () => window.renderReports(db)
    };

    async function renderHealth() {
        let html = `<h2>Health & Treatment</h2><button data-action="add">Add New Health Record</button>`;
        html += `<table><thead><tr><th>Animal Tag</th><th>Date</th><th>Diagnosis</th><th>Veterinarian</th><th>Actions</th></tr></thead><tbody>`;
        try {
            const snapshot = await db.collection('health').get();
            snapshot.forEach(doc => {
                const record = doc.data();
                html += `
                    <tr data-id="${doc.id}">
                        <td>${record.animal_tag}</td><td>${record.date}</td><td>${record.diagnosis}</td><td>${record.veterinarian}</td>
                        <td>
                            <button data-action="details">Details</button>
                            <button data-action="edit">Edit</button>
                            <button data-action="delete">Delete</button>
                        </td>
                    </tr>
                    <tr class="details-row" data-details-id="${doc.id}"><td colspan="5" class="details-cell">
                        <div class="details-grid">
                            ${Object.entries(record).map(([key, value]) => `
                                <div class="details-group"><h4>${key.replace(/_/g, ' ')}</h4>
                                ${typeof value === 'object' && value !== null ?
                                    Object.entries(value).map(([subKey, subValue]) => `<p><strong>${subKey.replace(/_/g, ' ')}:</strong> ${subValue}</p>`).join('') :
                                    `<p>${value}</p>`
                                }</div>`).join('')}
                        </div>
                    </td></tr>`;
            });
        } catch (e) { html += '<p>Could not load health records.</p>'; }
        html += `</tbody></table><div id="form-container"></div>`;
        return { html };
    }

    async function renderTable(title, collectionName, headers) {
        let html = `<h2>${title}</h2><button data-action="add">Add New</button>`;
        html += `<table><thead><tr>${headers.map(h => `<th>${h.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}</th>`).join('')}<th>Actions</th></tr></thead><tbody>`;
        try {
            const snapshot = await db.collection(collectionName).get();
            snapshot.forEach(doc => {
                html += `<tr data-id="${doc.id}">${headers.map(h => `<td>${doc.data()[h] || ''}</td>`).join('')}<td><button data-action="edit">Edit</button> <button data-action="delete">Delete</button></td></tr>`;
            });
        } catch (e) { html += `<p>Could not load ${title.toLowerCase()}.</p>`; }
        html += `</tbody></table><div id="form-container"></div>`;
        return { html };
    }

    // --- Form Generation ---
    async function showForm(id, collectionName, fields) {
        const item = id ? (await db.collection(collectionName).doc(id).get()).data() : {};
        let formHtml = `<form data-id="${id || ''}">`;
        fields.forEach(field => {
            const ph = field.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
            let type = 'text';
            if (field.includes('date')) type = 'date';
            if (['amount', 'size', 'quantity', 'budget', 'actual', 'ph', 'nitrogen', 'phosphorus', 'potassium', 'duration_minutes', 'water_amount', 'client_id'].includes(field)) type = 'number';
            let val = item[field] || '';
            if (type === 'date' && val) val = new Date(val).toISOString().split('T')[0];
            formHtml += `<input type="${type}" name="${field}" placeholder="${ph}" value="${val}" required> `;
        });
        formHtml += `<button type="submit">${id ? 'Update' : 'Save'}</button></form>`;
        const formContainer = document.getElementById('form-container');
        formContainer.innerHTML = formHtml;
        formContainer.querySelector('form').addEventListener('submit', handleFormSubmit);
    }

    async function showHealthForm(id) {
        const item = id ? (await db.collection('health').doc(id).get()).data() : {};
        const formHtml = `
            <h3>${id ? 'Edit' : 'Add'} Health Record</h3>
            <form data-id="${id || ''}">
                ${Object.keys(all_fields.health_full).map(group => `
                    <h4>${group.replace(/_/g, ' ')}</h4>
                    ${all_fields.health_full[group].map(field => `<input type="text" name="${group}_${field}" placeholder="${field.replace(/_/g, ' ')}" value="${(item[group] && item[group][field]) || ''}">`).join('')}
                `).join('')}
                <button type="submit">${id ? 'Update' : 'Save'} Record</button>
            </form>`;
        const formContainer = document.getElementById('form-container');
        formContainer.innerHTML = formHtml;
        formContainer.querySelector('form').addEventListener('submit', handleFormSubmit);
    }

    // --- Event Delegation (Main Handler) ---
    mainContent.addEventListener('click', (e) => {
        const button = e.target.closest('button');
        if (!button) return;
        const action = button.dataset.action;
        if (!action) return;

        const row = button.closest('tr');
        const id = row ? row.dataset.id : null;

        if (action === 'add') {
            currentSection === 'health' ? showHealthForm() : showForm(null, currentSection, all_fields[currentSection]);
        } else if (action === 'edit' && id) {
            currentSection === 'health' ? showHealthForm(id) : showForm(id, currentSection, all_fields[currentSection]);
        } else if (action === 'delete' && id) {
            if (confirm('Are you sure?')) db.collection(currentSection).doc(id).delete().then(() => setContent(currentSection));
        } else if (action === 'details' && id) {
            const detailsRow = document.querySelector(`tr[data-details-id="${id}"]`);
            if (detailsRow) detailsRow.classList.toggle('show');
        }
    });

    // --- Data Definitions and Initial Load ---
    const all_fields = {
        clients: ['name', 'farm_name', 'contact'],
        livestock: ['client_id', 'animal', 'tag', 'breed', 'birthDate', 'gender', 'weight', 'vaccination_status'],
        vaccination: ['animal_tag', 'vaccine_name', 'date', 'next_due_date', 'quarantine_status'],
        breeding: ['animal_tag', 'breeding_date', 'due_date', 'sire_tag', 'dam_tag', 'insemination_method'],
        feed: ['animal_tag', 'feed_type', 'feed_formulation', 'quantity', 'unit'],
        lab_results: ['animal_tag', 'test_type', 'date', 'results', 'notes'],
        fields: ['name', 'size', 'location'],
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
        equipment: ['name', 'model', 'purchaseDate', 'maintenanceSchedule'],
        health_full: { /* Complex object handled in form logic */
            basic_info: ['animal_tag', 'date', 'diagnosis', 'veterinarian'],
            observation: ['clinical_signs', 'behavior'],
            vital_signs: ['temperature', 'heart_rate', 'respiratory_rate'],
            treatment: ['medication', 'dosage', 'route', 'start_date', 'end_date', 'withdrawal_period'],
            follow_up: ['notes', 'next_appointment']
        }
    };

    for (const [key, fields] of Object.entries(all_fields)) {
        if (renderers[key]) continue;
        const title = key.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
        renderers[key] = () => renderTable(title, key, Array.isArray(fields) ? fields : Object.keys(fields));
    }

    setContent('dashboard'); // Initial Load
});
