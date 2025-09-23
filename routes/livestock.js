const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { readData, writeData } = require('../utils/db');

// A simple utility to handle async route errors
const asyncHandler = fn => (req, res, next) => {
    return Promise
        .resolve(fn(req, res, next))
        .catch(next);
};

// --- Validation Rules ---
const livestockValidationRules = [
    body('type').not().isEmpty().withMessage('Type is required.').trim().escape(),
    body('breed').not().isEmpty().withMessage('Breed is required.').trim().escape(),
    body('quantity').isInt({ gt: 0 }).withMessage('Quantity must be a positive number.'),
    body('health_status').not().isEmpty().withMessage('Health status is required.').trim().escape()
];

// --- Livestock Routes ---

// 1. Display all livestock
router.get('/', asyncHandler(async (req, res) => {
    const data = await readData();
    res.render('livestock/index', { livestock: data.livestock });
}));

// 2. Show the form to add new livestock
router.get('/add', (req, res) => {
    res.render('livestock/add', { errors: [], livestock: {} });
});

// 3. Handle the submission of the 'add' form
router.post('/add', livestockValidationRules, asyncHandler(async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).render('livestock/add', {
            errors: errors.array(),
            livestock: req.body
        });
    }

    const data = await readData();
    const newLivestock = {
        id: `livestock_${new Date().getTime()}`,
        type: req.body.type,
        breed: req.body.breed,
        quantity: parseInt(req.body.quantity),
        health_status: req.body.health_status
    };
    data.livestock.push(newLivestock);
    await writeData(data);
    res.redirect('/livestock');
}));

// 4. Show the form to edit livestock
router.get('/edit/:id', asyncHandler(async (req, res) => {
    const data = await readData();
    const livestock = data.livestock.find(l => l.id === req.params.id);
    if (livestock) {
        res.render('livestock/edit', { livestock, errors: [] });
    } else {
        res.status(404).send('Livestock not found');
    }
}));

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', livestockValidationRules, asyncHandler(async (req, res) => {
    const data = await readData();
    const livestockIndex = data.livestock.findIndex(l => l.id === req.params.id);

    if (livestockIndex === -1) {
        return res.status(404).send('Livestock not found');
    }

    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        const livestock = { id: req.params.id, ...req.body };
        return res.status(400).render('livestock/edit', {
            errors: errors.array(),
            livestock
        });
    }

    data.livestock[livestockIndex] = {
        id: req.params.id,
        type: req.body.type,
        breed: req.body.breed,
        quantity: parseInt(req.body.quantity),
        health_status: req.body.health_status
    };
    await writeData(data);
    res.redirect('/livestock');
}));

// 6. Handle the deletion of livestock
router.post('/delete/:id', asyncHandler(async (req, res) => {
    let data = await readData();
    data.livestock = data.livestock.filter(l => l.id !== req.params.id);
    await writeData(data);
    res.redirect('/livestock');
}));

module.exports = router;
