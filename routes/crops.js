
const express = require('express');
const router = express.Router();
const cropController = require('../controllers/cropController');

// Route to get all crops
router.get('/', cropController.getAllCrops);

// Route to get a single crop item by ID
router.get('/:id', cropController.getCropById);

// Route to create a new crop item
router.post('/', cropController.createCrop);

// Route to update a crop item
router.put('/:id', cropController.updateCrop);

// Route to delete a crop item
router.delete('/:id', cropController.deleteCrop);

module.exports = router;
