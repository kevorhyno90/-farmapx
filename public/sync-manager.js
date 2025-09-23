/**
 * Manages data synchronization between the local IndexedDB and the remote server.
 */
(function(window) {
    'use strict';

    const syncManager = {
        SYNC_QUEUE_KEY: 'syncQueue',

        /**
         * Checks if the application is currently online.
         * @returns {boolean} True if online, false otherwise.
         */
        isOnline: () => navigator.onLine,

        /**
         * Adds a data modification action to the synchronization queue.
         * This is used when the app is offline.
         * @param {string} action The type of action (e.g., 'add-livestock', 'update-crop').
         * @param {object} payload The data associated with the action.
         */
        addToQueue: async (action, payload) => {
            const queue = await localDB.get(syncManager.SYNC_QUEUE_KEY) || [];
            queue.push({ action, payload, timestamp: new Date().toISOString() });
            await localDB.set(syncManager.SYNC_QUEUE_KEY, queue);
            console.log(`Action ${action} added to sync queue.`);
        },

        /**
         * Processes the synchronization queue, sending pending changes to the server.
         */
        processQueue: async () => {
            if (!syncManager.isOnline()) {
                console.log('Offline. Sync queue processing deferred.');
                return;
            }

            let queue = await localDB.get(syncManager.SYNC_QUEUE_KEY) || [];
            if (queue.length === 0) {
                return; // Nothing to sync
            }

            console.log(`Processing ${queue.length} items from sync queue.`);

            for (const item of queue) {
                try {
                    // Example: Determine the endpoint and method from the action
                    // This part needs to be customized based on your API structure.
                    let endpoint = '/api/sync'; // A generic endpoint for simplicity
                    let method = 'POST';

                    const response = await fetch(endpoint, {
                        method: method,
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(item),
                    });

                    if (!response.ok) {
                        throw new Error(`Server responded with status ${response.status}`);
                    }

                    // Remove the successfully synced item from the queue
                    queue = queue.filter(i => i.timestamp !== item.timestamp);
                    await localDB.set(syncManager.SYNC_QUEUE_KEY, queue);
                    console.log(`Action ${item.action} synced successfully.`);

                } catch (error) {
                    console.error(`Failed to sync action ${item.action}:`, error);
                    // Keep the item in the queue to retry later
                }
            }
        },

        /**
         * Fetches the latest data from the server and updates the local database.
         * @returns {Promise<boolean>} True if sync was successful, false otherwise.
         */
        syncFromServer: async () => {
            if (!syncManager.isOnline()) {
                console.log('Offline. Cannot sync from server.');
                return false;
            }

            try {
                // Create a generic endpoint to get all data at once
                const response = await fetch('/api/get-all-data');
                if (!response.ok) {
                    throw new Error('Failed to fetch data from server.');
                }
                const serverData = await response.json();

                // Update local database with server data
                await localDB.set('farmData', serverData);
                console.log('Local database synced with server data.');
                return true;

            } catch (error) {
                console.error('Error syncing from server:', error);
                return false;
            }
        },

        /**
         * Initializes the sync manager, setting up online/offline event listeners.
         */
        init: () => {
            window.addEventListener('online', syncManager.processQueue);
            // Attempt to process the queue as soon as the app loads, in case it was offline before
            syncManager.processQueue();
            // Periodically check for connection and sync
            setInterval(syncManager.processQueue, 5 * 60 * 1000); // every 5 minutes
        }
    };

    window.syncManager = syncManager;

})(window);
