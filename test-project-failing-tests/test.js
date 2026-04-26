const { test } = require('node:test');
const assert = require('node:assert');

test('this test always fails', () => {
  assert.strictEqual(1, 2, 'Intentional failure for negative test coverage');
});
