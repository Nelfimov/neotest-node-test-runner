## Neotest Node.js test runner

Neotest adapter for [Node.js test runner](https://nodejs.org/api/test.html). Runs with following flags:

- `--experimental-strip-types`,
- `--experimental-transform-types`,
- `--no-warnings=ExperimentalWarning`,

## Requirements

- `Node.js` >= 22
- [Neotest](https://github.com/nvim-neotest/neotest)

## Setup

### Lazy.nvim

```lua
return {
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = { require("Nelfimov/neotest-node-test-runner") },
    },
  },
}
```
