const express = require('express');
const router = express.Router();
const { readData, writeData } = require('../utils/db');

// A simple utility to handle async route errors
const asyncHandler = fn => (req, res, next) => {
    return Promise.resolve(fn(req, res, next)).catch(next);
};

// --- Financials Routes ---

// 1. Display all financial transactions
router.get('/', asyncHandler(async (req, res) => {
    const data = await readData();
    res.render('financials/index', { financials: data.financials });
}));

// 2. Show the form to add a new transaction
router.get('/add', (req, res) => {
    res.render('financials/add');
});

// 3. Handle the submission of the 'add' form
router.post('/add', asyncHandler(async (req, res) => {
    const data = await readData();
    const newTransaction = {
        id: `trans_${new Date().getTime()}`,
        date: req.body.date,
        description: req.body.description,
        type: req.body.type,
        amount: parseFloat(req.body.amount)
    };
    data.financials.push(newTransaction);
    await writeData(data);
    res.redirect('/financials');
}));

// 4. Show the form to edit a transaction
router.get('/edit/:id', asyncHandler(async (req, res) => {
    const data = await readData();
    const transaction = data.financials.find(t => t.id === req.params.id);
    if (transaction) {
        res.render('financials/edit', { transaction });
    } else {
        res.status(404).send('Transaction not found');
    }
}));

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', asyncHandler(async (req, res) => {
    const data = await readData();
    const transIndex = data.financials.findIndex(t => t.id === req.params.id);
    if (transIndex !== -1) {
        data.financials[transIndex] = {
            id: req.params.id,
            date: req.body.date,
            description: req.body.description,
            type: req.body.type,
            amount: parseFloat(req.body.amount)
        };
        await writeData(data);
        res.redirect('/financials');
    } else {
        res.status(404).send('Transaction not found');
    }
}));

// 6. Handle the deletion of a transaction
router.post('/delete/:id', asyncHandler(async (req, res) => {
    let data = await readData();
    data.financials = data.financials.filter(t => t.id !== req.params.id);
    await writeData(data);
    res.redirect('/financials');
}));

module.exports = router;
