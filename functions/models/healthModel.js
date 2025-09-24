
const { readData, writeData } = require('../utils/db');

class Health {
    static async getAll() {
        const data = await readData();
        return data.health || []; // Return health records or an empty array
    }

    static async create(newRecord) {
        const data = await readData();
        if (!data.health) {
            data.health = []; // Initialize if it doesn't exist
        }
        newRecord.id = Date.now().toString();
        data.health.push(newRecord);
        await writeData(data);
        return newRecord;
    }

    static async update(id, updatedRecord) {
        const data = await readData();
        if (!data.health) return null;

        const index = data.health.findIndex(item => item.id === id);
        if (index === -1) {
            return null; // Not found
        }
        data.health[index] = { ...data.health[index], ...updatedRecord };
        await writeData(data);
        return data.health[index];
    }

    static async delete(id) {
        const data = await readData();
        if (!data.health) return false;

        const initialLength = data.health.length;
        data.health = data.health.filter(item => item.id !== id);
        if (data.health.length === initialLength) {
            return false; // No item was deleted
        }
        await writeData(data);
        return true; // Deletion was successful
    }
}

module.exports = Health;
