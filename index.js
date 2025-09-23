
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

// --- Main Route ---
app.get('/', (req, res) => {
    res.render('index', { title: 'Farm Dashboard' });
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


// --- Centralized Error Handling ---
app.use((err, req, res, next) => {
    console.error('Global error handler:', err);
    res.status(500).json({ error: 'Something went wrong on the server.' });
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
