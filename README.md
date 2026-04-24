# overloads

A small Lua library that extends the string metatable with operator overloads. Enables `+` for concatenation and `*` for repetition, with explicit opt-in/opt-out so you don't pollute the global string metatable permanently.

## Installation

Install with [lux](https://github.com/LuaLuxa):

```lua
{
    "cyb3rkun/lua-overloads",
    opts = { scope = "local" },
}
```

> **Note:** lux and the LuaLuxa ecosystem are not yet publicly released. Manual installation is available in the meantime — just drop `strings.lua` into your project.

## Modules

### `strings`

#### `enable_concat_plus()` / `disable_concat_plus()`

Overloads `+` to concatenate strings. Both operands are coerced via `tostring`, so mixing strings and numbers works naturally.

```lua
local s = require("strings")
s.enable_concat_plus()

print("hello" + "world") --> helloworld
print("hello" + 3)       --> hello3
print(3 + "hello")       --> 3hello

s.disable_concat_plus()
```

#### `enable_mult_repeat()` / `disable_mult_repeat()`

Overloads `*` to repeat a string. One operand must be a string and the other a number — order doesn't matter.

```lua
local s = require("strings")
s.enable_mult_repeat()

print("ha" * 3) --> hahaha
print(3 * "ha") --> hahaha

s.disable_mult_repeat()
```

## Design

Operators are disabled by default. Call the `enable_*` functions to activate them and `disable_*` to restore the original metamethods. The original `__add` and `__mul` metamethods are captured at module load time, so disabling always restores the true originals regardless of call order.

This opt-in model means you won't accidentally mask bugs where a string is passed where a number was expected.

## License

MIT
