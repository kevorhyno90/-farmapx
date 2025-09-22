const express = require('express');
const path = require('path');
const { readData } = require('./utils/db'); // Import the new DB module

// --- Routers ---
const cropsRouter = require('./routes/crops');
const livestockRouter = require('./routes/livestock');
const inventoryRouter = require('./routes/inventory');
const financialsRouter = require('./routes/financials');

const app = express();
const port = parseInt(process.env.PORT) || 8080;

// --- Middleware ---
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true }));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// --- Main Routes ---
app.get('/', (req, res) => {
  const data = readData();
  // The new readData ensures financials and crops are always arrays
  res.render('dashboard', { financials: data.financials, crops: data.crops });
});

// --- Section Routes ---
app.use('/crops', cropsRouter);
app.use('/livestock', livestockRouter);
app.use('/inventory', inventoryRouter);
app.use('/financials', financialsRouter);

app.listen(port, () => {
  console.log(`Listening on http://localhost:${port}`);
});
