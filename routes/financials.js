const express = require('express');
const router = express.Router();
const fs = require('fs');
const path = require('path');

// Path to the JSON database
const dbPath = path.join(__dirname, '..', 'db.json');

// --- Helper Functions to Read/Write DB ---
const readData = () => {
    try {
        const jsonData = fs.readFileSync(dbPath);
        const data = JSON.parse(jsonData);
        return { 
            crops: data.crops || [], 
            livestock: data.livestock || [], 
            inventory: data.inventory || [], 
            financials: data.financials || [] 
        };
    } catch (error) {
        console.error("Error reading or parsing db.json in financials.js:", error);
        return { crops: [], livestock: [], inventory: [], financials: [] };
    }
};

const writeData = (data) => {
    try {
        fs.writeFileSync(dbPath, JSON.stringify(data, null, 2));
    } catch (error) {
        console.error("Error writing to db.json in financials.js:", error);
    }
};

// --- Financials Routes ---

// 1. Display all financial transactions
router.get('/', (req, res) => {
    const data = readData();
    res.render('financials/index', { financials: data.financials });
});

// 2. Show the form to add a new transaction
router.get('/add', (req, res) => {
    res.render('financials/add');
});

// 3. Handle the submission of the 'add' form
router.post('/add', (req, res) => {
    const data = readData();
    const newTransaction = {
        id: `trans_${new Date().getTime()}`,
        date: req.body.date,
        description: req.body.description,
        type: req.body.type,
        amount: parseFloat(req.body.amount)
    };
    data.financials.push(newTransaction);
    writeData(data);
    res.redirect('/financials');
});

// 4. Show the form to edit a transaction
router.get('/edit/:id', (req, res) => {
    const data = readData();
    const transaction = data.financials.find(t => t.id === req.params.id);
    if (transaction) {
        res.render('financials/edit', { transaction });
    } else {
        res.status(404).send('Transaction not found');
    }
});

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', (req, res) => {
    const data = readData();
    const transIndex = data.financials.findIndex(t => t.id === req.params.id);
    if (transIndex !== -1) {
        data.financials[transIndex] = {
            id: req.params.id,
            date: req.body.date,
            description: req.body.description,
            type: req.body.type,
            amount: parseFloat(req.body.amount)
        };
        writeData(data);
        res.redirect('/financials');
    } else {
        res.status(404).send('Transaction not found');
    }
});

// 6. Handle the deletion of a transaction
router.post('/delete/:id', (req, res) => {
    let data = readData();
    data.financials = data.financials.filter(t => t.id !== req.params.id);
    writeData(data);
    res.redirect('/financials');
});

module.exports = router;
