const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { readData, writeData } = require('../utils/db');

// A simple utility to handle async route errors
const asyncHandler = fn => (req, res, next) => {
    return Promise.resolve(fn(req, res, next)).catch(next);
};

// --- Validation Rules ---
const cropValidationRules = [
    body('name').not().isEmpty().withMessage('Crop name is required.').trim().escape(),
    body('planted_date').isISO8601().toDate().withMessage('Planted date must be a valid date.'),
    body('expected_harvest').isISO8601().toDate().withMessage('Expected harvest date must be a valid date.'),
    body('status').not().isEmpty().withMessage('Status is required.').trim().escape()
];

// --- Crop Routes ---

// 1. Display all crops
router.get('/', asyncHandler(async (req, res) => {
    const data = await readData();
    res.render('crops/index', { crops: data.crops });
}));

// 2. Show the form to add a new crop
router.get('/add', (req, res) => {
    res.render('crops/add', { errors: [], crop: {} });
});

// 3. Handle the submission of the 'add' form
router.post('/add', cropValidationRules, asyncHandler(async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).render('crops/add', {
            errors: errors.array(),
            crop: req.body
        });
    }

    const data = await readData();
    const newCrop = {
        id: `crop_${new Date().getTime()}`,
        name: req.body.name,
        planted_date: req.body.planted_date,
        expected_harvest: req.body.expected_harvest,
        status: req.body.status
    };
    data.crops.push(newCrop);
    await writeData(data);
    res.redirect('/crops');
}));

// 4. Show the form to edit a crop
router.get('/edit/:id', asyncHandler(async (req, res) => {
    const data = await readData();
    const crop = data.crops.find(c => c.id === req.params.id);
    if (crop) {
        res.render('crops/edit', { crop, errors: [] });
    } else {
        res.status(404).send('Crop not found');
    }
}));

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', cropValidationRules, asyncHandler(async (req, res) => {
    const errors = validationResult(req);
    const data = await readData();
    
    if (!errors.isEmpty()) {
        const crop = data.crops.find(c => c.id === req.params.id);
        if (!crop) {
            return res.status(404).send('Crop not found');
        }
        const viewData = { ...crop, ...req.body };
        return res.status(400).render('crops/edit', {
            errors: errors.array(),
            crop: viewData
        });
    }

    const cropIndex = data.crops.findIndex(c => c.id === req.params.id);
    if (cropIndex !== -1) {
        data.crops[cropIndex] = {
            id: req.params.id,
            name: req.body.name,
            planted_date: req.body.planted_date,
            expected_harvest: req.body.expected_harvest,
            status: req.body.status
        };
        await writeData(data);
        res.redirect('/crops');
    } else {
        res.status(404).send('Crop not found');
    }
}));

// 6. Handle the deletion of a crop
router.post('/delete/:id', asyncHandler(async (req, res) => {
    let data = await readData();
    data.crops = data.crops.filter(c => c.id !== req.params.id);
    await writeData(data);
    res.redirect('/crops');
}));

module.exports = router;