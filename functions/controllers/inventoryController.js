
const Inventory = require('../models/inventoryModel');

// Controller to get all inventory items and render the view
exports.getAllInventory = async (req, res, next) => {
    try {
        const inventory = await Inventory.getAll();
        res.render('inventory', { inventory }); // Assuming an 'inventory.ejs' view
    } catch (error) {
        next(error);
    }
};

// Controller to get a single inventory item by its ID
exports.getInventoryById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const inventoryItem = await Inventory.getById(id);
        if (!inventoryItem) {
            return res.status(404).send('Inventory item not found');
        }
        res.render('inventoryDetail', { inventoryItem }); // Assuming an 'inventoryDetail.ejs' view
    } catch (error) {
        next(error);
    }
};

// Controller to create a new inventory item
exports.createInventory = async (req, res, next) => {
    try {
        const newInventory = await Inventory.create(req.body);
        res.status(201).json(newInventory);
    } catch (error) {
        next(error);
    }
};

// Controller to update an existing inventory item
exports.updateInventory = async (req, res, next) => {
    try {
        const { id } = req.params;
        const updatedInventory = await Inventory.update(id, req.body);
        if (!updatedInventory) {
            return res.status(404).send('Inventory item not found');
        }
        res.json(updatedInventory);
    } catch (error) {
        next(error);
    }
};

// Controller to delete an inventory item
exports.deleteInventory = async (req, res, next) => {
    try {
        const { id } = req.params;
        const success = await Inventory.delete(id);
        if (!success) {
            return res.status(404).send('Inventory item not found');
        }
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};
