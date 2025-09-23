
const express = require('express');
const path = require('path');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3002;

// Middleware for parsing JSON and URL-encoded data
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// EJS setup
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Static files
app.use(express.static(path.join(__dirname, 'public')));

// --- Main Routes ---
app.get('/', (req, res) => {
    // This will now serve as the main shell of the PWA
    res.render('index', { title: 'Farm Dashboard' });
});

// --- API Routes for Data Sync ---
const apiRoutes = require('./routes/api');
app.use('/api', apiRoutes);

// --- Page-specific Routes ---
const livestockRoutes = require('./routes/livestock');
app.use('/livestock', livestockRoutes);
const cropRoutes = require('./routes/crops');
app.use('/crops', cropRoutes);
const financialRoutes = require('./routes/financials');
app.use('/financials', financialRoutes);
const inventoryRoutes = require('./routes/inventory');
app.use('/inventory', inventoryRoutes);

// --- Centralized Error Handling ---
app.use((err, req, res, next) => {
    console.error('Global error handler:', err);
    res.status(500).json({ error: 'Something went wrong on the server.' });
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
