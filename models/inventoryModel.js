
const { readData, writeData } = require('../utils/db');

class Inventory {
    static async getAll() {
        const data = await readData();
        return data.inventory;
    }

    static async getById(id) {
        const data = await readData();
        return data.inventory.find(item => item.id === id);
    }

    static async create(newInventory) {
        const data = await readData();
        newInventory.id = Date.now().toString(); // Assign a unique ID
        data.inventory.push(newInventory);
        await writeData(data);
        return newInventory;
    }

    static async update(id, updatedInventory) {
        const data = await readData();
        const index = data.inventory.findIndex(item => item.id === id);
        if (index === -1) {
            return null; // Not found
        }
        data.inventory[index] = { ...data.inventory[index], ...updatedInventory };
        await writeData(data);
        return data.inventory[index];
    }

    static async delete(id) {
        const data = await readData();
        const initialLength = data.inventory.length;
        data.inventory = data.inventory.filter(item => item.id !== id);
        if (data.inventory.length === initialLength) {
            return false; // No item was deleted
        }
        await writeData(data);
        return true; // Deletion was successful
    }
}

module.exports = Inventory;
