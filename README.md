## Neotest Node.js test runner

Neotest adapter for [Node.js test runner](https://nodejs.org/api/test.html). Runs with following flags:

- `--experimental-strip-types`,
- `--experimental-transform-types`,
- `--no-warnings=ExperimentalWarning`,

## Requirements

- `Node.js` >= 22
- [Neotest](https://github.com/nvim-neotest/neotest)

## Setup

### LazyVim

```lua
return {
  {
    "nvim-neotest/neotest-plenary",
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "Nelfimov/neotest-node-test-runner" },
    opts = {
      adapters = { ["neotest-node-test-runner"] = {} },
    },
  },
}
```
