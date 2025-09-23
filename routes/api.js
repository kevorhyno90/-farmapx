const express = require('express');
const router = express.Router();
const { readData, writeData } = require('../utils/db');

// A simple utility to handle async route errors
const asyncHandler = fn => (req, res, next) => {
    return Promise.resolve(fn(req, res, next)).catch(next);
};

/**
 * Endpoint to get all farm data.
 * This is used by the client to perform an initial sync.
 */
router.get('/get-all-data', asyncHandler(async (req, res) => {
    const data = await readData();
    res.json(data);
}));

/**
 * Endpoint to handle incoming synchronization actions from the client.
 * When the client is offline, it queues up actions, and this endpoint
 * processes them when the client comes back online.
 */
router.post('/sync', asyncHandler(async (req, res) => {
    const { action, payload } = req.body;
    const data = await readData();

    console.log(`Received sync action: ${action}`);

    // This is a simplified example. In a real app, you would have more robust
    // logic to handle various actions and potential data conflicts.
    switch (action) {
        case 'add-livestock':
            const newLivestock = {
                id: `livestock_${new Date().getTime()}`,
                ...payload
            };
            data.livestock.push(newLivestock);
            break;
        
        case 'update-livestock':
            const index = data.livestock.findIndex(l => l.id === payload.id);
            if (index !== -1) {
                data.livestock[index] = { ...data.livestock[index], ...payload };
            }
            break;

        case 'delete-livestock':
            data.livestock = data.livestock.filter(l => l.id !== payload.id);
            break;

        // You can add more cases here for crops, financials, etc.

        default:
            console.warn(`Unknown sync action: ${action}`);
            // Optionally, return an error to the client
            return res.status(400).json({ status: 'error', message: 'Unknown action' });
    }

    await writeData(data);
    res.json({ status: 'success', message: `Action '${action}' processed.` });
}));

module.exports = router;
