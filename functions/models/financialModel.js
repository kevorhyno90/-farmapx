
const { readData, writeData } = require('../utils/db');

class Financial {
    static async getAll() {
        const data = await readData();
        return data.financials;
    }

    static async getById(id) {
        const data = await readData();
        return data.financials.find(item => item.id === id);
    }

    static async create(newFinancial) {
        const data = await readData();
        newFinancial.id = Date.now().toString(); // Assign a unique ID
        data.financials.push(newFinancial);
        await writeData(data);
        return newFinancial;
    }

    static async update(id, updatedFinancial) {
        const data = await readData();
        const index = data.financials.findIndex(item => item.id === id);
        if (index === -1) {
            return null; // Not found
        }
        data.financials[index] = { ...data.financials[index], ...updatedFinancial };
        await writeData(data);
        return data.financials[index];
    }

    static async delete(id) {
        const data = await readData();
        const initialLength = data.financials.length;
        data.financials = data.financials.filter(item => item.id !== id);
        if (data.financials.length === initialLength) {
            return false; // No item was deleted
        }
        await writeData(data);
        return true; // Deletion was successful
    }
}

module.exports = Financial;
