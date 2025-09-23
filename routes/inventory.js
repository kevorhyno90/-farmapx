
const express = require('express');
const router = express.Router();
const inventoryController = require('../controllers/inventoryController');

// Route to get all inventory items
router.get('/', inventoryController.getAllInventory);

// Route to get a single inventory item by ID
router.get('/:id', inventoryController.getInventoryById);

// Route to create a new inventory item
router.post('/', inventoryController.createInventory);

// Route to update an inventory item
router.put('/:id', inventoryController.updateInventory);

// Route to delete an inventory item
router.delete('/:id', inventoryController.deleteInventory);

module.exports = router;
