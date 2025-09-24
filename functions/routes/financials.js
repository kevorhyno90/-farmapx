
const express = require('express');
const router = express.Router();
const financialController = require('../controllers/financialController');

// Route to get all financial records
router.get('/', financialController.getAllFinancials);

// Route to get a single financial record by ID
router.get('/:id', financialController.getFinancialById);

// Route to create a new financial record
router.post('/', financialController.createFinancial);

// Route to update a financial record
router.put('/:id', financialController.updateFinancial);

// Route to delete a financial record
router.delete('/:id', financialController.deleteFinancial);

module.exports = router;
