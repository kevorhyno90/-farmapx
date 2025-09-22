const express = require('express');
const router = express.Router();
const { readData, writeData } = require('../utils/db'); // Import the new DB module

// --- Inventory Routes ---

// 1. Display all inventory items
router.get('/', (req, res) => {
    const data = readData();
    res.render('inventory/index', { inventory: data.inventory });
});

// 2. Show the form to add a new item
router.get('/add', (req, res) => {
    res.render('inventory/add');
});

// 3. Handle the submission of the 'add' form
router.post('/add', (req, res) => {
    const data = readData();
    const newItem = {
        id: `item_${new Date().getTime()}`,
        name: req.body.name,
        category: req.body.category,
        quantity: parseInt(req.body.quantity),
        location: req.body.location
    };
    data.inventory.push(newItem);
    writeData(data);
    res.redirect('/inventory');
});

// 4. Show the form to edit an item
router.get('/edit/:id', (req, res) => {
    const data = readData();
    const item = data.inventory.find(i => i.id === req.params.id);
    if (item) {
        res.render('inventory/edit', { item });
    } else {
        res.status(404).send('Item not found');
    }
});

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', (req, res) => {
    const data = readData();
    const itemIndex = data.inventory.findIndex(i => i.id === req.params.id);
    if (itemIndex !== -1) {
        data.inventory[itemIndex] = {
            id: req.params.id,
            name: req.body.name,
            category: req.body.category,
            quantity: parseInt(req.body.quantity),
            location: req.body.location
        };
        writeData(data);
        res.redirect('/inventory');
    } else {
        res.status(404).send('Item not found');
    }
});

// 6. Handle the deletion of an item
router.post('/delete/:id', (req, res) => {
    let data = readData();
    data.inventory = data.inventory.filter(i => i.id !== req.params.id);
    writeData(data);
    res.redirect('/inventory');
});

module.exports = router;
