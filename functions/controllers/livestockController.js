
const Livestock = require('../models/livestockModel');

// Controller to get all livestock and render the view
exports.getAllLivestock = async (req, res, next) => {
    try {
        const livestock = await Livestock.getAll();
        // The view that will display the list of livestock
        // We pass the 'livestock' data to the EJS template
        res.render('livestock', { livestock }); 
    } catch (error) {
        next(error); // Pass errors to the centralized error handler
    }
};

// Controller to get a single livestock item by its ID
exports.getLivestockById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const livestockItem = await Livestock.getById(id);
        if (!livestockItem) {
            return res.status(404).send('Livestock not found');
        }
        // Render a detail view for a single livestock item
        res.render('livestockDetail', { livestockItem });
    } catch (error) {
        next(error);
    }
};

// Controller to create a new livestock item
exports.createLivestock = async (req, res, next) => {
    try {
        const newLivestock = await Livestock.create(req.body);
        res.status(201).json(newLivestock);
    } catch (error) {
        next(error);
    }
};

// Controller to update an existing livestock item
exports.updateLivestock = async (req, res, next) => {
    try {
        const { id } = req.params;
        const updatedLivestock = await Livestock.update(id, req.body);
        if (!updatedLivestock) {
            return res.status(404).send('Livestock not found');
        }
        res.json(updatedLivestock);
    } catch (error) {
        next(error);
    }
};

// Controller to delete a livestock item
exports.deleteLivestock = async (req, res, next) => {
    try {
        const { id } = req.params;
        const success = await Livestock.delete(id);
        if (!success) {
            return res.status(404).send('Livestock not found');
        }
        res.status(204).send(); // 204 No Content for successful deletion
    } catch (error) {
        next(error);
    }
};

// Controller to delete a breeding record
exports.deleteBreedingRecord = async (req, res, next) => {
    try {
        const { id } = req.params;
        const success = await Livestock.deleteBreedingRecord(id);
        if (!success) {
            // Use a more specific error message
            return res.status(404).json({ error: 'Breeding record not found.' });
        }
        // Send a success response
        res.status(200).json({ message: 'Breeding record deleted successfully.' });
    } catch (error) {
        next(error); // Pass errors to the centralized handler
    }
};
