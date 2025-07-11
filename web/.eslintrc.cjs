module.exports = {
    root: true,
    env: {browser: true, es2020: true},
    extends: [
        "eslint:recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:react-hooks/recommended",
    ],
    ignorePatterns: ["dist", ".eslintrc.cjs"],
    parser: "@typescript-eslint/parser",
    plugins: ["react-refresh"],
    overrides: [{files: ["*.ts", "*.tsx"]}],
    rules: {
        "@typescript-eslint/ no-explicit-any": "off",
        "react-refresh/only-export-components": [
            "warn",
            {allowConstantExport: true},
        ],
    },
};
