'use strict';

const { test } = require('node:test');
const assert = require('node:assert');
const { greet } = require('./index');

test('greet with eslint project', () => {
  assert.strictEqual(greet('Pipery'), 'Hello from ESLint project, Pipery!');
});
