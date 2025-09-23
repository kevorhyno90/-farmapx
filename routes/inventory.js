const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const { readData, writeData } = require('../utils/db');

// A simple utility to handle async route errors
const asyncHandler = fn => (req, res, next) => {
    return Promise.resolve(fn(req, res, next)).catch(next);
};

// --- Validation Rules ---
const inventoryValidationRules = [
    body('item_name').not().isEmpty().withMessage('Item name is required.').trim().escape(),
    body('category').not().isEmpty().withMessage('Category is required.').trim().escape(),
    body('quantity').isInt({ gt: -1 }).withMessage('Quantity must be a non-negative number.'),
    body('condition').not().isEmpty().withMessage('Condition is required.').trim().escape()
];

// --- Inventory Routes ---

// 1. Display all inventory items
router.get('/', asyncHandler(async (req, res) => {
    const data = await readData();
    res.render('inventory/index', { inventory: data.inventory });
}));

// 2. Show the form to add a new item
router.get('/add', (req, res) => {
    res.render('inventory/add', { errors: [], inventory: {} });
});

// 3. Handle the submission of the 'add' form
router.post('/add', inventoryValidationRules, asyncHandler(async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).render('inventory/add', {
            errors: errors.array(),
            inventory: req.body
        });
    }

    const data = await readData();
    const newItem = {
        id: `inventory_${new Date().getTime()}`,
        item_name: req.body.item_name,
        category: req.body.category,
        quantity: parseInt(req.body.quantity),
        condition: req.body.condition
    };
    data.inventory.push(newItem);
    await writeData(data);
    res.redirect('/inventory');
}));

// 4. Show the form to edit an item
router.get('/edit/:id', asyncHandler(async (req, res) => {
    const data = await readData();
    const item = data.inventory.find(i => i.id === req.params.id);
    if (item) {
        res.render('inventory/edit', { inventory: item, errors: [] });
    } else {
        res.status(404).send('Inventory item not found');
    }
}));

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', inventoryValidationRules, asyncHandler(async (req, res) => {
    const errors = validationResult(req);
    const data = await readData();
    const itemIndex = data.inventory.findIndex(i => i.id === req.params.id);

    if (itemIndex === -1) {
        return res.status(404).send('Inventory item not found');
    }

    if (!errors.isEmpty()) {
        const item = { id: req.params.id, ...req.body };
        return res.status(400).render('inventory/edit', {
            errors: errors.array(),
            inventory: item
        });
    }

    data.inventory[itemIndex] = {
        id: req.params.id,
        item_name: req.body.item_name,
        category: req.body.category,
        quantity: parseInt(req.body.quantity),
        condition: req.body.condition
    };
    await writeData(data);
    res.redirect('/inventory');
}));

// 6. Handle the deletion of an item
router.post('/delete/:id', asyncHandler(async (req, res) => {
    let data = await readData();
    data.inventory = data.inventory.filter(i => i.id !== req.params.id);
    await writeData(data);
    res.redirect('/inventory');
}));

module.exports = router;
