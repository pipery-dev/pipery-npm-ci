const { test } = require('node:test');
const assert = require('node:assert');
const { greet } = require('./index');

test('greet with yarn', () => {
  assert.strictEqual(greet('Pipery'), 'Hello from Yarn, Pipery!');
});
