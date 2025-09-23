/**
 * A simple wrapper for IndexedDB to provide a key-value store.
 */
(function(window) {
    'use strict';

    function openDB(dbName, storeName) {
        return new Promise((resolve, reject) => {
            const request = indexedDB.open(dbName, 1);

            request.onupgradeneeded = event => {
                const db = event.target.result;
                if (!db.objectStoreNames.contains(storeName)) {
                    db.createObjectStore(storeName);
                }
            };

            request.onerror = event => {
                reject('IndexedDB error: ' + event.target.errorCode);
            };

            request.onsuccess = event => {
                resolve(event.target.result);
            };
        });
    }

    async function getStore(dbName, storeName, mode) {
        const db = await openDB(dbName, storeName);
        const tx = db.transaction(storeName, mode);
        return tx.objectStore(storeName);
    }

    window.localDB = {
        /**
         * Get a value from the local database.
         * @param {string} key The key of the item to retrieve.
         * @returns {Promise<any>} A promise that resolves to the stored value.
         */
        get: async (key) => {
            const store = await getStore('farmDataDB', 'mainStore', 'readonly');
            return new Promise((resolve, reject) => {
                const request = store.get(key);
                request.onsuccess = () => resolve(request.result);
                request.onerror = () => reject(request.error);
            });
        },

        /**
         * Set a value in the local database.
         * @param {string} key The key of the item to store.
         * @param {any} value The value to store.
         * @returns {Promise<void>} A promise that resolves when the operation is complete.
         */
        set: async (key, value) => {
            const store = await getStore('farmDataDB', 'mainStore', 'readwrite');
            return new Promise((resolve, reject) => {
                const request = store.put(value, key);
                request.onsuccess = () => resolve();
                request.onerror = () => reject(request.error);
            });
        },
        
        /**
         * Get all keys from the store.
         * @returns {Promise<string[]>} A promise that resolves with an array of keys.
         */
        keys: async () => {
            const store = await getStore('farmDataDB', 'mainStore', 'readonly');
            return new Promise((resolve, reject) => {
                const request = store.getAllKeys();
                request.onsuccess = () => resolve(request.result);
                request.onerror = () => reject(request.error);
            });
        }
    };

})(window);
