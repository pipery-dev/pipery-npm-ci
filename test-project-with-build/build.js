const fs = require('fs');
const path = require('path');
// Simple "build": copy src to dist
fs.mkdirSync('dist', { recursive: true });
const src = fs.readFileSync(path.join('src', 'index.js'), 'utf8');
fs.writeFileSync(path.join('dist', 'index.js'), src);
console.log('Build complete: dist/index.js');
