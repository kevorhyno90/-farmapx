
const Health = require('../models/healthModel');

// Get all health records
exports.getAllHealthRecords = async (req, res, next) => {
    try {
        const records = await Health.getAll();
        res.json(records);
    } catch (error) {
        next(error);
    }
};

// Create a new health record
exports.createHealthRecord = async (req, res, next) => {
    try {
        const newRecord = await Health.create(req.body);
        res.status(201).json(newRecord);
    } catch (error) {
        next(error);
    }
};

// Update a health record
exports.updateHealthRecord = async (req, res, next) => {
    try {
        const { id } = req.params;
        const updatedRecord = await Health.update(id, req.body);
        if (!updatedRecord) {
            return res.status(404).send('Health record not found');
        }
        res.json(updatedRecord);
    } catch (error) {
        next(error);
    }
};

// Delete a health record
exports.deleteHealthRecord = async (req, res, next) => {
    try {
        const { id } = req.params;
        const success = await Health.delete(id);
        if (!success) {
            return res.status(404).send('Health record not found');
        }
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};
