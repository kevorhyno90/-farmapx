
const Financial = require('../models/financialModel');

// Controller to get all financial records and render the view
exports.getAllFinancials = async (req, res, next) => {
    try {
        const financials = await Financial.getAll();
        res.render('financials', { financials }); // Assuming a 'financials.ejs' view
    } catch (error) {
        next(error);
    }
};

// Controller to get a single financial record by its ID
exports.getFinancialById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const financialItem = await Financial.getById(id);
        if (!financialItem) {
            return res.status(404).send('Financial record not found');
        }
        res.render('financialDetail', { financialItem }); // Assuming a 'financialDetail.ejs' view
    } catch (error) {
        next(error);
    }
};

// Controller to create a new financial record
exports.createFinancial = async (req, res, next) => {
    try {
        const newFinancial = await Financial.create(req.body);
        res.status(201).json(newFinancial);
    } catch (error) {
        next(error);
    }
};

// Controller to update an existing financial record
exports.updateFinancial = async (req, res, next) => {
    try {
        const { id } = req.params;
        const updatedFinancial = await Financial.update(id, req.body);
        if (!updatedFinancial) {
            return res.status(404).send('Financial record not found');
        }
        res.json(updatedFinancial);
    } catch (error) {
        next(error);
    }
};

// Controller to delete a financial record
exports.deleteFinancial = async (req, res, next) => {
    try {
        const { id } = req.params;
        const success = await Financial.delete(id);
        if (!success) {
            return res.status(404).send('Financial record not found');
        }
        res.status(204).send();
    } catch (error) {
        next(error);
    }
};
