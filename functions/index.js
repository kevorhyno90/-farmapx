
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const path = require('path');
const cors = require('cors');
const compression = require('compression'); // Import compression middleware

admin.initializeApp();

const app = express();

// --- Middleware Setup ---

// Enable Gzip compression for all responses
app.use(compression());

// Middleware for parsing JSON and URL-encoded data
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// EJS setup
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// --- Main Route ---
app.get('/', (req, res) => {
    res.render('index', { title: 'Farm Dashboard' });
});

// --- Progress Sync Stream Route ---
app.get('/api/sync-stream', (req, res) => {
    // Set headers for Server-Sent Events (SSE)
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.flushHeaders(); // Flush the headers to establish the connection

    let workCompleted = 0;
    const workEstimated = 100;
    const taskName = "Syncing farm data...";

    // Send an initial message
    const initialData = { task: taskName, workCompleted: 0, workEstimated };
    res.write(`data: ${JSON.stringify(initialData)}\n\n`);

    const interval = setInterval(() => {
        workCompleted += Math.floor(Math.random() * 10) + 5; // Increment progress randomly
        if (workCompleted >= workEstimated) {
            workCompleted = workEstimated;
            const finalData = { task: "Sync Complete", workCompleted, workEstimated };
            res.write(`data: ${JSON.stringify(finalData)}\n\n`);
            clearInterval(interval);
            res.end(); // Close the connection
            return;
        }

        const progressData = { task: taskName, workCompleted, workEstimated };
        res.write(`data: ${JSON.stringify(progressData)}\n\n`);
    }, 300); // Send update every 300ms

    // Clean up if the client closes the connection
    req.on('close', () => {
        clearInterval(interval);
        res.end();
    });
});

// --- Refactored Routes ---
const livestockRoutes = require('./routes/livestock');
app.use('/api/livestock', livestockRoutes);

const cropRoutes = require('./routes/crops');
app.use('/api/crops', cropRoutes);

const financialRoutes = require('./routes/financials');
app.use('/api/financials', financialRoutes);

const inventoryRoutes = require('./routes/inventory');
app.use('/api/inventory', inventoryRoutes);

const healthRoutes = require('./routes/health');
app.use('/api/health', healthRoutes);

// --- Centralized Error Handling ---
app.use((err, req, res, next) => {
    console.error('Global error handler:', err);
    res.status(500).json({ error: 'Something went wrong on the server.' });
});

exports.api = functions.https.onRequest(app);
