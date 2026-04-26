const { test } = require('node:test');
const assert = require('node:assert');
const { greet } = require('./src/index');

test('greet from build project', () => {
  assert.strictEqual(greet('Pipery'), 'Hello from build, Pipery!');
});
