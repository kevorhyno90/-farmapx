
const express = require('express');
const router = express.Router();
const healthController = require('../controllers/healthController');

// Routes for Health Records
router.get('/', healthController.getAllHealthRecords);
router.post('/', healthController.createHealthRecord);
router.put('/:id', healthController.updateHealthRecord);
router.delete('/:id', healthController.deleteHealthRecord);

module.exports = router;
