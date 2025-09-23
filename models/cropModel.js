
const { readData, writeData } = require('../utils/db');

class Crop {
    static async getAll() {
        const data = await readData();
        return data.crops;
    }

    static async getById(id) {
        const data = await readData();
        return data.crops.find(item => item.id === id);
    }

    static async create(newCrop) {
        const data = await readData();
        newCrop.id = Date.now().toString(); // Assign a unique ID
        data.crops.push(newCrop);
        await writeData(data);
        return newCrop;
    }

    static async update(id, updatedCrop) {
        const data = await readData();
        const index = data.crops.findIndex(item => item.id === id);
        if (index === -1) {
            return null; // Not found
        }
        data.crops[index] = { ...data.crops[index], ...updatedCrop };
        await writeData(data);
        return data.crops[index];
    }

    static async delete(id) {
        const data = await readData();
        const initialLength = data.crops.length;
        data.crops = data.crops.filter(item => item.id !== id);
        if (data.crops.length === initialLength) {
            return false; // No item was deleted
        }
        await writeData(data);
        return true; // Deletion was successful
    }
}

module.exports = Crop;
