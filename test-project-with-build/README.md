# Test Project (with Build Step)

This fixture project has a `build` script in `package.json` that copies `src/index.js` to `dist/index.js`. It exists so `pipery-npm-ci` can verify that the build step is detected and executed during `pipery-actions test`.
