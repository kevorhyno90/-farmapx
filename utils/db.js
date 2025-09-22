const fs = require('fs');
const path = require('path');

// Path to the JSON database
const dbPath = path.join(__dirname, '..', 'db.json');

/**
 * Reads and parses the JSON database file.
 * @returns {object} The parsed database object with default values for each key.
 */
const readData = () => {
    try {
        const jsonData = fs.readFileSync(dbPath);
        const data = JSON.parse(jsonData);
        // Ensure all top-level keys exist to prevent errors in routes
        return {
            crops: data.crops || [],
            livestock: data.livestock || [],
            inventory: data.inventory || [],
            financials: data.financials || [],
        };
    } catch (error) {
        // If the file doesn't exist or is corrupt, return a default structure
        console.error("Error reading or parsing db.json:", error);
        return { crops: [], livestock: [], inventory: [], financials: [] };
    }
};

/**
 * Writes data to the JSON database file.
 * @param {object} data The data object to write to the file.
 */
const writeData = (data) => {
    try {
        fs.writeFileSync(dbPath, JSON.stringify(data, null, 2));
    } catch (error) {
        console.error("Error writing to db.json:", error);
    }
};

module.exports = { readData, writeData };
