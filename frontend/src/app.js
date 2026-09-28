/*import React, { useEffect, useState } from 'react';

function App() {
  const [data, setData] = useState({ message: "Loading..." });

  useEffect(() => {
    fetch('/api/message')
      .then((res) => res.json())
      .then((data) => setData(data))
      .catch((err) => setData({ message: "Error connecting to backend." }));
  }, []);

  return (
    <div style={{ textAlign: 'center', marginTop: '50px', fontFamily: 'Arial, sans-serif' }}>
      <h1>Node.js + React Monolith Deployment</h1>
      <p>Backend API response: <strong>{data.message}</strong></p>
    </div>
  );
}

export default App;
*/

import React, { useEffect, useState } from 'react'; 

function App() {
const [data, setData] = useState({ message: "Loading..." }); 

useEffect(() => {
// Correct relative fetch path hitting the Express proxy / monolithic routing setup
fetch('/api/message')
.then((res) => {
if (!res.ok) {
throw new Error('Network response was not ok');
}
return res.json();
})
.then((data) => setData(data))
.catch((err) => setData({ message: "Error connecting to backend." }));
}, []); 

return (
    <div style={{ textAlign: 'center', marginTop: '50px', fontFamily: 'Arial, sans-serif' }}>
      <h1>Node.js + React Monolith Deployment</h1>
      <p>Backend API response: <strong>{data.message}</strong></p>
    </div>
  );
} 

export default App;


