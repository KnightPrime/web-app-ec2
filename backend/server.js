/*
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 5000;

// Sample API Endpoint
app.get('/api/message', (req, res) => {
  res.json({ message: "Hello from the Node.js Backend!" });
});

// Serve static assets from the React build folder
app.use(express.static(path.join(__dirname, '../frontend/build')));

// Handle any requests that don't match the API routes to return the React index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

*/


/*
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 5000; 

// Sample API Endpoint
app.get('/api/message', (req, res) => {
res.json({ message: "Hello from the Node.js Backend!" });
}); 

// FIXED PATH: Explicitly configured to match your repository layout which builds to 'frontend/build'
app.use(express.static(path.join(__dirname, '../frontend/build'))); 

// Wildcard routing to handle client-side refreshes by serving the production compiled template
app.get('*', (req, res) => {
res.sendFile(path.join(__dirname, '../frontend/build', 'index.html'));
}); 

app.listen(PORT, () => {
console.log(Server running on port ${PORT});
});
*/
