
const express = require('express');
const router = express.Router();
const livestockController = require('../controllers/livestockController');

// --- Livestock Routes ---
router.get('/', livestockController.getAllLivestock);
router.get('/:id', livestockController.getLivestockById);
router.post('/', livestockController.createLivestock);
router.put('/:id', livestockController.updateLivestock);
router.delete('/:id', livestockController.deleteLivestock);

// --- Breeding Record Routes ---
// You can add more breeding-specific routes here, e.g., POST, PUT

// Route to delete a breeding record
router.delete('/breeding/:id', livestockController.deleteBreedingRecord);

module.exports = router;
