
const Crop = require('../models/cropModel');

// Controller to get all crops and render the view
exports.getAllCrops = async (req, res, next) => {
    try {
        const crops = await Crop.getAll();
        res.render('crops', { crops }); // Assuming a 'crops.ejs' view
    } catch (error) {
        next(error);
    }
};

// Controller to get a single crop item by its ID
exports.getCropById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const cropItem = await Crop.getById(id);
        if (!cropItem) {
            return res.status(404).send('Crop not found');
        }
        res.render('cropDetail', { cropItem }); // Assuming a 'cropDetail.ejs' view
    } catch (error) {
        next(error);
    }
};

// Controller to create a new crop item
exports.createCrop = async (req, res, next) => {
    try {
        const newCrop = await Crop.create(req.body);
        res.status(201).json(newCrop);
    } catch (error) {
        next(error);
    }
};

// Controller to update an existing crop item
exports.updateCrop = async (req, res, next) => {
    try {
        const { id } = req.params;
        const updatedCrop = await Crop.update(id, req.body);
        if (!updatedCrop) {
            return res.status(404).send('Crop not found');
        }
        res.json(updatedCrop);
    } catch (error) {
        next(error);
    }
};

// Controller to delete a crop item
exports.deleteCrop = async (req, res, next) => {
    try {
        const { id } = req.params;
        const success = await Crop.delete(id);
        if (!success) {
            return res.status(404).send('Crop not found');
        }
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};
