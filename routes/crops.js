const express = require('express');
const router = express.Router();
const { readData, writeData } = require('../utils/db'); // Import the new DB module

// --- Crop Routes ---

// 1. Display all crops
router.get('/', (req, res) => {
    const data = readData();
    res.render('crops/index', { crops: data.crops });
});

// 2. Show the form to add a new crop
router.get('/add', (req, res) => {
    res.render('crops/add');
});

// 3. Handle the submission of the 'add' form
router.post('/add', (req, res) => {
    const data = readData();
    const newCrop = {
        id: `crop_${new Date().getTime()}`,
        name: req.body.name,
        planted_date: req.body.planted_date,
        expected_harvest: req.body.expected_harvest,
        status: req.body.status
    };
    data.crops.push(newCrop);
    writeData(data);
    res.redirect('/crops');
});

// 4. Show the form to edit a crop
router.get('/edit/:id', (req, res) => {
    const data = readData();
    const crop = data.crops.find(c => c.id === req.params.id);
    if (crop) {
        res.render('crops/edit', { crop });
    } else {
        res.status(404).send('Crop not found');
    }
});

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', (req, res) => {
    const data = readData();
    const cropIndex = data.crops.findIndex(c => c.id === req.params.id);
    if (cropIndex !== -1) {
        data.crops[cropIndex] = {
            id: req.params.id,
            name: req.body.name,
            planted_date: req.body.planted_date,
            expected_harvest: req.body.expected_harvest,
            status: req.body.status
        };
        writeData(data);
        res.redirect('/crops');
    } else {
        res.status(404).send('Crop not found');
    }
});

// 6. Handle the deletion of a crop
router.post('/delete/:id', (req, res) => {
    let data = readData();
    data.crops = data.crops.filter(c => c.id !== req.params.id);
    writeData(data);
    res.redirect('/crops');
});

module.exports = router;
