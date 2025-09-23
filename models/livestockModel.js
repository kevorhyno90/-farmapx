
const { readData, writeData } = require('../utils/db');

class Livestock {
    static async getAll() {
        const data = await readData();
        return data.livestock;
    }

    static async getById(id) {
        const data = await readData();
        return data.livestock.find(item => item.id === id);
    }

    static async create(newLivestock) {
        const data = await readData();
        newLivestock.id = Date.now().toString(); // Assign a unique ID
        data.livestock.push(newLivestock);
        await writeData(data);
        return newLivestock;
    }

    static async update(id, updatedLivestock) {
        const data = await readData();
        const index = data.livestock.findIndex(item => item.id === id);
        if (index === -1) {
            return null; // Not found
        }
        data.livestock[index] = { ...data.livestock[index], ...updatedLivestock };
        await writeData(data);
        return data.livestock[index];
    }

    static async delete(id) {
        const data = await readData();
        const initialLength = data.livestock.length;
        data.livestock = data.livestock.filter(item => item.id !== id);
        if (data.livestock.length === initialLength) {
            return false; // No item was deleted
        }
        await writeData(data);
        return true; // Deletion was successful
    }
}

module.exports = Livestock;
