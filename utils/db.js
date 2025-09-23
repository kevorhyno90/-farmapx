const fs = require('fs').promises;
const path = require('path');

// Path to the JSON database
const dbPath = path.join(__dirname, '..', 'db.json');

// A simple in-memory cache to reduce disk I/O
let inMemoryCache = null;

/**
 * Reads and parses the JSON database file asynchronously.
 * It uses an in-memory cache to avoid reading from disk on every request.
 * @returns {Promise<object>} A promise that resolves to the parsed database object.
 */
const readData = async () => {
    if (inMemoryCache) {
        return inMemoryCache;
    }

    try {
        await fs.access(dbPath); // Check if the file exists
        const jsonData = await fs.readFile(dbPath, 'utf8');
        const data = JSON.parse(jsonData);

        // Ensure all top-level keys exist to prevent errors in routes
        const validatedData = {
            crops: data.crops || [],
            livestock: data.livestock || [],
            inventory: data.inventory || [],
            financials: data.financials || [],
        };
        inMemoryCache = validatedData;
        return validatedData;
    } catch (error) {
        // If file doesn't exist, is corrupt, or another error occurs
        if (error.code === 'ENOENT') {
            // File doesn't exist, create it with a default structure
            console.log('db.json not found. Creating a new one.');
            const defaultData = { crops: [], livestock: [], inventory: [], financials: [] };
            await writeData(defaultData);
            inMemoryCache = defaultData;
            return defaultData;
        }
        console.error('Error reading or parsing db.json:', error);
        // Return a default structure on other errors to ensure app stability
        return { crops: [], livestock: [], inventory: [], financials: [] };
    }
};

/**
 * Asynchronously writes data to the JSON database file.
 * Clears the cache after writing to ensure the next read gets the fresh data.
 * @param {object} data The data object to write to the file.
 * @returns {Promise<void>}
 */
const writeData = async (data) => {
    try {
        await fs.writeFile(dbPath, JSON.stringify(data, null, 2));
        inMemoryCache = null; // Invalidate cache after writing
    } catch (error) {
        console.error('Error writing to db.json:', error);
        // In a real-world scenario, you might want to throw the error 
        // to let the calling function know the write failed.
        throw error;
    }
};

module.exports = { readData, writeData };
