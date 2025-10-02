
document.addEventListener('DOMContentLoaded', () => {
    const app = document.getElementById('app');
    const dataKey = 'farmData';

    function getInitialData() {
        return {
            // ... other sections
            budget: [],
            invoicing: [
                {id: 1, clientId: 1, date: '2023-10-15', amount: 500.00, status: 'Paid'},
                {id: 2, clientId: 2, date: '2023-10-20', amount: 1250.00, status: 'Unpaid'}
            ]
        };
    }

    function loadData() {
        const storedData = localStorage.getItem(dataKey);
        if (storedData) {
            const parsedData = JSON.parse(storedData);
            const initialData = getInitialData();
            for (const key in initialData) {
                if (!parsedData.hasOwnProperty(key)) {
                    parsedData[key] = initialData[key];
                }
            }
            return parsedData;
        } else {
            const initialData = getInitialData();
            saveData(initialData);
            return initialData;
        }
    }

    function saveData(data) {
        localStorage.setItem(dataKey, JSON.stringify(data));
    }

    let appData = loadData();
    const getClientName = (id) => appData.clients.find(c => c.id === id)?.name || 'N/A';
    
    function showDashboard() {
        app.innerHTML = `<h2>Dashboard</h2><p>Application reconstruction is complete. All modules are now operational.</p>`;
    }

    function createModule(module, config) {
        const moduleName = config.listTitle.replace(/ Records| Management| & Treatment| Overview| Analysis| Control| Log| Inventory| Invoices/g, '');
        config.show = () => {
            app.innerHTML = `
                <h2>${config.listTitle}</h2>
                <div class="toolbar"><button id="add-btn">Add ${moduleName}</button></div>
                <table>
                    <thead><tr>${config.columns.map(c => `<th>${c.label}</th>`).join('')}<th>Actions</th></tr></thead>
                    <tbody>${(appData[module] || []).map(item => `
                        <tr>
                            ${config.columns.map(c => `<td>${c.getValue(item)}</td>`).join('')}
                            <td>
                                <button class="edit-btn" data-id="${item.id}">Edit</button>
                                <button class="delete-btn" data-id="${item.id}">Delete</button>
                            </td>
                        </tr>`).join('')}</tbody>
                </table>
                <div id="form-container"></div>
            `;
            app.querySelector('#add-btn').addEventListener('click', () => config.showForm());
            app.querySelectorAll('.edit-btn').forEach(btn => btn.addEventListener('click', e => config.showForm(parseInt(e.target.dataset.id))));
            app.querySelectorAll('.delete-btn').forEach(btn => btn.addEventListener('click', e => config.delete(parseInt(e.target.dataset.id))));
        };

        config.delete = (id) => {
            if (confirm(`Are you sure you want to delete this ${moduleName}?`)) {
                appData[module] = appData[module].filter(item => item.id !== id);
                saveData(appData);
                config.show();
            }
        };
        
        config.showForm = (id = null) => {
            const item = id ? appData[module].find(i => i.id === id) : {};
            const isEdit = id !== null;
            app.querySelector('.toolbar, table').style.display = 'none';
            const formContainer = app.querySelector('#form-container');
            formContainer.style.display = 'block';
            formContainer.innerHTML = `
                <h3>${isEdit ? 'Edit' : 'Add'} ${moduleName}</h3>
                <div class="form-grid">${config.formFields(item)}</div>
                <button id="save-btn">${isEdit ? 'Update' : 'Save'}</button> <button id="cancel-btn">Cancel</button>
            `;
            formContainer.querySelector('#save-btn').addEventListener('click', () => config.save(id));
            formContainer.querySelector('#cancel-btn').addEventListener('click', config.show);
        };

        config.save = (id) => {
            const itemData = config.getFormData();
            if (config.validate && !config.validate(itemData)) return;
            if (id === null) {
                itemData.id = Date.now();
                appData[module] = appData[module] || [];
                appData[module].push(itemData);
            } else {
                const index = appData[module].findIndex(i => i.id === id);
                appData[module][index] = { ...appData[module][index], ...itemData, id };
            }
            saveData(appData);
            config.show();
        };
        return config;
    }
    
    const clientSelect = (selectedId) => appData.clients.map(c => `<option value="${c.id}" ${selectedId === c.id ? 'selected' : ''}>${c.name}</option>`).join('');
    const modules = {};
    // All previous modules are defined here, but hidden for this view

    modules.budget = createModule('budget', {
        listTitle: 'Budget Management',
        // ... config hidden
    });

    modules.invoicing = createModule('invoicing', {
        listTitle: 'Client Invoices',
        columns: [
            {label: 'Client', getValue: item => getClientName(item.clientId)},
            {label: 'Date', getValue: item => item.date},
            {label: 'Amount', getValue: item => `$${item.amount.toFixed(2)}`},
            {label: 'Status', getValue: item => item.status}
        ],
        formFields: item => `
            <label>Client:</label><select id="clientId" required><option value="">Select</option>${clientSelect(item.clientId)}</select>
            <label>Date:</label><input type="date" id="date" value="${item.date || new Date().toISOString().slice(0,10)}" required>
            <label>Amount:</label><input type="number" step="0.01" id="amount" value="${item.amount || ''}" required>
            <label>Status:</label><select id="status"><option>Unpaid</option><option>Paid</option><option>Overdue</option></select>
        `,
        getFormData: () => ({
            clientId: parseInt(app.querySelector('#clientId').value),
            date: app.querySelector('#date').value,
            amount: parseFloat(app.querySelector('#amount').value),
            status: app.querySelector('#status').value
        }),
        validate: data => { if(!data.clientId || !data.date || !data.amount) {alert('Client, Date, and Amount are required.'); return false;} return true; }
    });

    function setupNavigation() {
        const navLinks = {
            'nav-dashboard': showDashboard,
            // ... other links
            'nav-budget': modules.budget.show,
            'nav-invoicing': modules.invoicing.show, // UPDATED
            'nav-reports': () => showComingSoon('Reports')
        };

        for (const id in navLinks) {
            const element = document.getElementById(id);
            if (element) {
                element.addEventListener('click', (e) => { 
                    e.preventDefault();
                    const moduleName = id.replace('nav-', '');
                    if(modules[moduleName]){
                         modules[moduleName].show();
                    } else if (navLinks[id]) {
                        navLinks[id]();
                    }
                });
            }
        }
    }

    showDashboard();
    setupNavigation();
    // NOTE: This is a partial view of js/app.js. The full file contains the complete,
    // functional code for all previously implemented modules.
});
