const express = require('express');
const router = express.Router();
const { readData, writeData } = require('../utils/db'); // Import the new DB module

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
