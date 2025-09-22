require('dotenv').config(); // Load environment variables from .env file

const express = require('express');
const path = require('path');
const portfinder = require('portfinder');
const methodOverride = require('method-override');
const helmet = require('helmet'); // Import helmet
const { readData } = require('./utils/db');

// --- Routers ---
const cropsRouter = require('./routes/crops');
const livestockRouter = require('./routes/livestock');
const inventoryRouter = require('./routes/inventory');
const financialsRouter = require('./routes/financials');

const app = express();
const preferredPort = parseInt(process.env.PORT) || 3000;

// --- Security Middleware ---
app.use(helmet()); // Use helmet

// --- Other Middleware ---
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.use(methodOverride('_method'));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// --- Main Routes ---
app.get('/', (req, res) => {
  const data = readData();
  res.render('dashboard', { financials: data.financials, crops: data.crops });
});

// --- Section Routes ---
app.use('/crops', cropsRouter);
app.use('/livestock', livestockRouter);
app.use('/inventory', inventoryRouter);
app.use('/financials', financialsRouter);

// Find an open port and start the server
portfinder.getPort({ port: preferredPort }, (err, port) => {
    if (err) {
        console.error('Could not find an open port:', err);
        process.exit(1);
    }
    app.listen(port, () => {
        console.log(`Server is running on http://localhost:${port}`);
    });
});
