
const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from the test server!');
});

app.listen(port, () => {
  console.log(`Test server is running on http://localhost:${port}`);
});
