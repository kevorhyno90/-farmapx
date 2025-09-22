const express = require('express');
const router = express.Router();
const { readData, writeData } = require('../utils/db'); // Import the new DB module

// --- Livestock Routes ---

// 1. Display all livestock
router.get('/', (req, res) => {
    const data = readData();
    res.render('livestock/index', { livestock: data.livestock });
});

// 2. Show the form to add new livestock
router.get('/add', (req, res) => {
    res.render('livestock/add');
});

// 3. Handle the submission of the 'add' form
router.post('/add', (req, res) => {
    const data = readData();
    const newAnimal = {
        id: `animal_${new Date().getTime()}`,
        species: req.body.species,
        breed: req.body.breed,
        birth_date: req.body.birth_date,
        health_status: req.body.health_status
    };
    data.livestock.push(newAnimal);
    writeData(data);
    res.redirect('/livestock');
});

// 4. Show the form to edit an animal
router.get('/edit/:id', (req, res) => {
    const data = readData();
    const animal = data.livestock.find(l => l.id === req.params.id);
    if (animal) {
        res.render('livestock/edit', { animal });
    } else {
        res.status(404).send('Animal not found');
    }
});

// 5. Handle the submission of the 'edit' form
router.post('/edit/:id', (req, res) => {
    const data = readData();
    const animalIndex = data.livestock.findIndex(l => l.id === req.params.id);
    if (animalIndex !== -1) {
        data.livestock[animalIndex] = {
            id: req.params.id,
            species: req.body.species,
            breed: req.body.breed,
            birth_date: req.body.birth_date,
            health_status: req.body.health_status
        };
        writeData(data);
        res.redirect('/livestock');
    } else {
        res.status(404).send('Animal not found');
    }
});

// 6. Handle the deletion of an animal
router.post('/delete/:id', (req, res) => {
    let data = readData();
    data.livestock = data.livestock.filter(l => l.id !== req.params.id);
    writeData(data);
    res.redirect('/livestock');
});

module.exports = router;
