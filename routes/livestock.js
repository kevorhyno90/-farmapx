
const express = require('express');
const router = express.Router();
const livestockController = require('../controllers/livestockController');

// Route to get all livestock
router.get('/', livestockController.getAllLivestock);

// Route to get a single livestock item by ID
router.get('/:id', livestockController.getLivestockById);

// Route to create a new livestock item
router.post('/', livestockController.createLivestock);

// Route to update a livestock item
router.put('/:id', livestockController.updateLivestock);

// Route to delete a livestock item
router.delete('/:id', livestockController.deleteLivestock);

module.exports = router;
