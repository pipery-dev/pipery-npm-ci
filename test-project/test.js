const { test } = require('node:test');
const assert = require('node:assert');
const { greet } = require('./index');

test('greet returns correct string', () => {
  assert.strictEqual(greet('Pipery'), 'Hello, Pipery!');
});

test('greet with empty string', () => {
  assert.strictEqual(greet(''), 'Hello, !');
});
