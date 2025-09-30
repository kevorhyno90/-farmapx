const app = document.getElementById('app');
const navLinks = document.querySelectorAll('nav a');

let livestock = [
    {
        id: 1,
        name: 'Bessie',
        sex: 'Female',
        breed: 'Holstein',
        dob: '2022-01-15',
        sire: 'Ferdinand',
        dam: 'Daisy',
        purchasePrice: 1500,
        salePrice: null,
        group: 'Dairy Cows'
    },
    {
        id: 2,
        name: 'Angus',
        sex: 'Male',
        breed: 'Angus',
        dob: '2023-03-20',
        sire: 'Unknown',
        dam: 'Unknown',
        purchasePrice: 1200,
        salePrice: null,
        group: 'Beef Cattle'
    },
    {
        id: 3,
        name: 'Dolly',
        sex: 'Female',
        breed: 'Merino',
        dob: '2021-11-01',
        sire: 'Ramsey',
        dam: 'Ewey',
        purchasePrice: 800,
        salePrice: null,
        group: 'Sheep'
    }
];

let breeding = [];

function showDashboard() {
    app.innerHTML = '<h2>Dashboard</h2><p>Welcome to your Farm Science dashboard!</p>';
}

function showLivestock(filter = '') {
    let html = '<h2>Livestock</h2>';
    html += '<div class="toolbar">';
    html += '<button id="add-animal">Add Animal</button>';
    html += `<input type="text" id="filter-livestock" placeholder="Filter by name, breed, or group..." value="${filter}">`;
    html += '</div>';
    html += '<table>';
    html += '<thead><tr><th>Name</th><th>Sex</th><th>Breed</th><th>Group</th><th>Actions</th></tr></thead>';
    html += '<tbody>';

    const filteredLivestock = livestock.filter(animal => {
        const filterText = filter.toLowerCase();
        return animal.name.toLowerCase().includes(filterText) ||
               animal.breed.toLowerCase().includes(filterText) ||
               animal.group.toLowerCase().includes(filterText);
    });

    for (const animal of filteredLivestock) {
        html += `<tr>`;
        html += `<td>${animal.name}</td>`;
        html += `<td>${animal.sex}</td>`;
        html += `<td>${animal.breed}</td>`;
        html += `<td>${animal.group}</td>`;
        html += `<td><button class="view-animal" data-id="${animal.id}">View</button></td>`;
        html += `</tr>`;
    }
    html += '</tbody>';
    html += '</table>';
    app.innerHTML = html;

    document.getElementById('add-animal').addEventListener('click', showAddAnimalForm);
    document.getElementById('filter-livestock').addEventListener('input', (event) => {
        showLivestock(event.target.value);
    });

    const viewButtons = document.querySelectorAll('.view-animal');
    for (const button of viewButtons) {
        button.addEventListener('click', (event) => {
            const animalId = parseInt(event.target.dataset.id);
            const animal = livestock.find(a => a.id === animalId);
            showAnimalProfile(animal);
        });
    }
}

function showAddAnimalForm() {
    let html = '<h2>Add Animal</h2>';
    html += '<form id="add-animal-form">';
    html += '<div class="form-grid">';
    html += '<label for="name">Name:</label><input type="text" id="name" required>';
    html += '<label for="sex">Sex:</label><input type="text" id="sex" required>';
    html += '<label for="breed">Breed:</label><input type="text" id="breed" required>';
    html += '<label for="dob">Date of Birth:</label><input type="date" id="dob" required>';
    html += '<label for="sire">Sire:</label><input type="text" id="sire">';
    html += '<label for="dam">Dam:</label><input type="text" id="dam">';
    html += '<label for="purchasePrice">Purchase Price:</label><input type="number" id="purchasePrice">';
    html += '<label for="group">Group:</label><input type="text" id="group">';
    html += '</div>';
    html += '<button type="submit">Save</button>';
    html += '<button type="button" id="cancel-add">Cancel</button>';
    html += '</form>';
    app.innerHTML = html;

    document.getElementById('add-animal-form').addEventListener('submit', addAnimal);
    document.getElementById('cancel-add').addEventListener('click', () => showLivestock());
}

function addAnimal(event) {
    event.preventDefault();
    const newAnimal = {
        id: Date.now(), // Use a timestamp for a unique ID
        name: document.getElementById('name').value,
        sex: document.getElementById('sex').value,
        breed: document.getElementById('breed').value,
        dob: document.getElementById('dob').value,
        sire: document.getElementById('sire').value,
        dam: document.getElementById('dam').value,
        purchasePrice: parseFloat(document.getElementById('purchasePrice').value),
        salePrice: null,
        group: document.getElementById('group').value
    };
    livestock.push(newAnimal);
    showLivestock();
}

function showEditAnimalForm(animal) {
    let html = `<h2>Edit Animal: ${animal.name}</h2>`;
    html += '<form id="edit-animal-form">';
    html += '<div class="form-grid">';
    html += `<label for="name">Name:</label><input type="text" id="name" value="${animal.name}" required>`;
    html += `<label for="sex">Sex:</label><input type="text" id="sex" value="${animal.sex}" required>`;
    html += `<label for="breed">Breed:</label><input type="text" id="breed" value="${animal.breed}" required>`;
    html += `<label for="dob">Date of Birth:</label><input type="date" id="dob" value="${animal.dob}" required>`;
    html += `<label for="sire">Sire:</label><input type="text" id="sire" value="${animal.sire}">`;
    html += `<label for="dam">Dam:</label><input type="text" id="dam" value="${animal.dam}">`;
    html += `<label for="purchasePrice">Purchase Price:</label><input type="number" id="purchasePrice" value="${animal.purchasePrice}">`;
    html += `<label for="salePrice">Sale Price:</label><input type="number" id="salePrice" value="${animal.salePrice || ''}">`;
    html += `<label for="group">Group:</label><input type="text" id="group" value="${animal.group}">`;
    html += '</div>';
    html += '<button type="submit">Save</button>';
    html += '<button type="button" id="cancel-edit">Cancel</button>';
    html += '</form>';
    app.innerHTML = html;

    document.getElementById('edit-animal-form').addEventListener('submit', (event) => {
        event.preventDefault();
        updateAnimal(animal.id);
    });
    document.getElementById('cancel-edit').addEventListener('click', () => showAnimalProfile(animal));
}

function updateAnimal(animalId) {
    const animalIndex = livestock.findIndex(a => a.id === animalId);
    if (animalIndex !== -1) {
        livestock[animalIndex] = {
            id: animalId,
            name: document.getElementById('name').value,
            sex: document.getElementById('sex').value,
            breed: document.getElementById('breed').value,
            dob: document.getElementById('dob').value,
            sire: document.getElementById('sire').value,
            dam: document.getElementById('dam').value,
            purchasePrice: parseFloat(document.getElementById('purchasePrice').value),
            salePrice: document.getElementById('salePrice').value ? parseFloat(document.getElementById('salePrice').value) : null,
            group: document.getElementById('group').value
        };
        showAnimalProfile(livestock[animalIndex]);
    }
}

function showAnimalProfile(animal) {
    let html = `<h2>Animal Profile: ${animal.name}</h2>`;
    html += '<ul>';
    html += `<li><strong>ID:</strong> ${animal.id}</li>`;
    html += `<li><strong>Name:</strong> ${animal.name}</li>`;
    html += `<li><strong>Sex:</strong> ${animal.sex}</li>`;
    html += `<li><strong>Breed:</strong> ${animal.breed}</li>`;
    html += `<li><strong>Date of Birth:</strong> ${animal.dob}</li>`;
    html += `<li><strong>Sire (Father):</strong> ${animal.sire}</li>`;
    html += `<li><strong>Dam (Mother):</strong> ${animal.dam}</li>`;
    html += `<li><strong>Purchase Price:</strong> $${animal.purchasePrice}</li>`;
    html += `<li><strong>Sale Price:</strong> ${animal.salePrice ? '$' + animal.salePrice : 'Not Sold'}</li>`;
    html += `<li><strong>Group:</strong> ${animal.group}</li>`;
    html += '</ul>';
    html += '<button id="edit-animal">Edit</button>';
    html += '<button id="back-to-livestock">Back to Livestock List</button>';
    app.innerHTML = html;

    document.getElementById('edit-animal').addEventListener('click', () => showEditAnimalForm(animal));
    document.getElementById('back-to-livestock').addEventListener('click', () => showLivestock());
}

function showBreeding() {
    let html = '<h2>Breeding Management</h2>';
    html += '<div class="toolbar">';
    html += '<button id="add-breeding-record">Record a Breeding Event</button>';
    html += '</div>';

    html += '<h3>Breeding Records</h3>';
    html += '<table>';
    html += '<thead><tr><th>Date</th><th>Female</th><th>Male</th><th>Status</th><th>Due Date</th><th>Actions</th></tr></thead>';
    html += '<tbody>';
    for (const record of breeding) {
        const female = livestock.find(a => a.id === record.femaleId);
        const male = livestock.find(a => a.id === record.maleId);
        html += `<tr>`;
        html += `<td>${record.date}</td>`;
        html += `<td>${female ? female.name : 'N/A'}</td>`;
        html += `<td>${male ? male.name : 'N/A'}</td>`;
        html += `<td>${record.status}</td>`;
        html += `<td>${record.dueDate || 'N/A'}</td>`;
        html += `<td><button class="view-breeding-record" data-id="${record.id}">View</button></td>`;
        html += `</tr>`;
    }
    html += '</tbody>';
    html += '</table>';

    app.innerHTML = html;

    document.getElementById('add-breeding-record').addEventListener('click', showAddBreedingForm);

    const viewButtons = document.querySelectorAll('.view-breeding-record');
    for (const button of viewButtons) {
        button.addEventListener('click', (event) => {
            const recordId = parseInt(event.target.dataset.id);
            const record = breeding.find(r => r.id === recordId);
            showBreedingRecordProfile(record);
        });
    }
}

function showBreedingRecordProfile(record) {
    const female = livestock.find(a => a.id === record.femaleId);
    const male = livestock.find(a => a.id === record.maleId);
    let html = `<h2>Breeding Record Details</h2>`;
    html += '<ul>';
    html += `<li><strong>ID:</strong> ${record.id}</li>`;
    html += `<li><strong>Date:</strong> ${record.date}</li>`;
    html += `<li><strong>Female:</strong> ${female ? female.name : 'N/A'}</li>`;
    html += `<li><strong>Male:</strong> ${male ? male.name : 'N/A'}</li>`;
    html += `<li><strong>Status:</strong> ${record.status}</li>`;
    html += `<li><strong>Due Date:</strong> ${record.dueDate || 'N/A'}</li>`;
    html += '</ul>';
    html += `<button id="edit-breeding-record" data-id="${record.id}">Edit</button>`;
    html += '<button id="back-to-breeding">Back to Breeding List</button>';
    app.innerHTML = html;

    document.getElementById('edit-breeding-record').addEventListener('click', () => showEditBreedingForm(record));
    document.getElementById('back-to-breeding').addEventListener('click', showBreeding);
}


function showAddBreedingForm() {
    let html = '<h2>Record a Breeding Event</h2>';
    html += '<form id="add-breeding-form">';
    html += '<div class="form-grid">';

    // Female selection
    html += '<label for="female">Female:</label>';
    html += '<select id="female" required>';
    for (const animal of livestock) {
        if (animal.sex === 'Female') {
            html += `<option value="${animal.id}">${animal.name}</option>`;
        }
    }
    html += '</select>';

    // Male selection
    html += '<label for="male">Male:</label>';
    html += '<select id="male" required>';
    for (const animal of livestock) {
        if (animal.sex === 'Male') {
            html += `<option value="${animal.id}">${animal.name}</option>`;
        }
    }
    html += '</select>';

    html += '<label for="date">Date:</label><input type="date" id="date" required>';
    html += '<label for="status">Status:</label><input type="text" id="status" value="Mated" required>';
    html += '</div>';
    html += '<button type="submit">Save</button>';
    html += '<button type="button" id="cancel-add-breeding">Cancel</button>';
    html += '</form>';
    app.innerHTML = html;

    document.getElementById('add-breeding-form').addEventListener('submit', addBreedingRecord);
    document.getElementById('cancel-add-breeding').addEventListener('click', showBreeding);
}

function addBreedingRecord(event) {
    event.preventDefault();

    const femaleId = parseInt(document.getElementById('female').value);
    const maleId = parseInt(document.getElementById('male').value);
    const date = document.getElementById('date').value;
    const status = document.getElementById('status').value;

    // For this example, we'll set a due date 9 months in the future
    const dueDate = new Date(date);
    dueDate.setMonth(dueDate.getMonth() + 9);

    const newRecord = {
        id: Date.now(),
        femaleId,
        maleId,
        date,
        status,
        dueDate: dueDate.toISOString().split('T')[0] // Format as YYYY-MM-DD
    };

    breeding.push(newRecord);
    showBreeding();
}

function showEditBreedingForm(record) {
    let html = `<h2>Edit Breeding Record</h2>`;
    html += '<form id="edit-breeding-form">';
    html += '<div class="form-grid">';

    // Female selection
    html += '<label for="female">Female:</label>';
    html += '<select id="female" required>';
    for (const animal of livestock) {
        if (animal.sex === 'Female') {
            const selected = animal.id === record.femaleId ? 'selected' : '';
            html += `<option value="${animal.id}" ${selected}>${animal.name}</option>`;
        }
    }
    html += '</select>';

    // Male selection
    html += '<label for="male">Male:</label>';
    html += '<select id="male" required>';
    for (const animal of livestock) {
        if (animal.sex === 'Male') {
            const selected = animal.id === record.maleId ? 'selected' : '';
            html += `<option value="${animal.id}" ${selected}>${animal.name}</option>`;
        }
    }
    html += '</select>';

    html += `<label for="date">Date:</label><input type="date" id="date" value="${record.date}" required>`;
    html += `<label for="status">Status:</label><input type="text" id="status" value="${record.status}" required>`;
    html += '</div>';
    html += '<button type="submit">Save</button>';
    html += '<button type="button" id="cancel-edit-breeding">Cancel</button>';
    html += '</form>';
    app.innerHTML = html;

    document.getElementById('edit-breeding-form').addEventListener('submit', (event) => {
        event.preventDefault();
        updateBreedingRecord(record.id);
    });
    document.getElementById('cancel-edit-breeding').addEventListener('click', () => showBreedingRecordProfile(record));
}

function updateBreedingRecord(recordId) {
    const recordIndex = breeding.findIndex(r => r.id === recordId);
    if (recordIndex !== -1) {
        const date = document.getElementById('date').value;
        const dueDate = new Date(date);
        dueDate.setMonth(dueDate.getMonth() + 9);

        breeding[recordIndex] = {
            id: recordId,
            femaleId: parseInt(document.getElementById('female').value),
            maleId: parseInt(document.getElementById('male').value),
            date: date,
            status: document.getElementById('status').value,
            dueDate: dueDate.toISOString().split('T')[0]
        };
        showBreedingRecordProfile(breeding[recordIndex]);
    }
}

function showCrops() {
    app.innerHTML = '<h2>Crops</h2><p>Here you can manage your crops.</p>';
}

function showInventory() {
    app.innerHTML = '<h2>Inventory</h2><p>Here you can manage your inventory.</p>';
}

function showFinancials() {
    app.innerHTML = '<h2>Financials</h2><p>Here you can manage your financials.</p>';
}

function showReports() {
    let html = '<h2>Reports</h2>';

    // Livestock Summary
    const totalAnimals = livestock.length;
    const totalPurchasePrice = livestock.reduce((sum, animal) => sum + (animal.purchasePrice || 0), 0);
    const totalSalePrice = livestock.reduce((sum, animal) => sum + (animal.salePrice || 0), 0);
    const netValue = totalSalePrice - totalPurchasePrice;

    html += '<h3>Livestock Summary</h3>';
    html += '<ul>';
    html += `<li><strong>Total Animals:</strong> ${totalAnimals}</li>`;
    html += `<li><strong>Total Purchase Price:</strong> $${totalPurchasePrice.toFixed(2)}</li>`;
    html += `<li><strong>Total Sale Price:</strong> $${totalSalePrice.toFixed(2)}</li>`;
    html += `<li><strong>Net Value:</strong> $${netValue.toFixed(2)}</li>`;
    html += '</ul>';

    // Breeding Summary
    html += '<h3>Breeding Summary</h3>';
    const totalBreedingRecords = breeding.length;
    html += '<ul>';
    html += `<li><strong>Total Breeding Records:</strong> ${totalBreedingRecords}</li>`;
    html += '</ul>';

    app.innerHTML = html;
}

// Show the dashboard by default
showDashboard();

document.getElementById('nav-dashboard').addEventListener('click', showDashboard);
document.getElementById('nav-livestock').addEventListener('click', () => showLivestock());
document.getElementById('nav-breeding').addEventListener('click', showBreeding);
document.getElementById('nav-crops').addEventListener('click', showCrops);
document.getElementById('nav-inventory').addEventListener('click', showInventory);
document.getElementById('nav-financials').addEventListener('click', showFinancials);
document.getElementById('nav-reports').addEventListener('click', showReports);
