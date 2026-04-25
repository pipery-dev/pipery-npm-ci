export default [
  {
    languageOptions: {
      ecmaVersion: "latest",
      globals: {
        console: "readonly",
      },
    },
    rules: {
      "no-unused-vars": "error",
      "no-undef": "error",
      "no-eval": "error",
    },
  },
];
