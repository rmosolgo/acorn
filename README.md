# Acorn [![Build Status](https://travis-ci.org/rmosolgo/acorn.svg?branch=master)](https://travis-ci.org/rmosolgo/acorn)

🚧 Under Construction 👷

A state machine compiler with no runtime dependency. Define a grammar using a subset of regular expression notation, then compile it into a blazing-fast state machine. `Acorn` supports lexers or custom string-based state machines.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  acorn:
    github: "rmosolgo/acorn"
```

## Usage

- Define the grammar in a build file:

  ```ruby
  # ./build/my_lexer.cr
  require "acorn"

  class MyLexer < Acorn::Lexer
    # optional, rename the generated class:
    # name("Namespace::MyLexer")
    token :letter "a-z"
    token :number "0-9"
    generate "./src/my_lexer.cr"
  end
  ```

- Generate the lexer:

  ```
  crystal run ./build/my_lexer.cr
  ```

- Use the compiled lexer:

  ```ruby
  require "./src/my_lexer.cr"
  MyLexer.scan(input) # => Array(Tuple(Symbol, String))
  ```

### Regular Expressions

Tokens are defined with a small regular expression language:

Feature | Example
---|---
Character| `a`, `1`, `❤️`
Sequence |`ab`, `123`
Alternation | <code>a&#124;b</code>
~~Grouping~~ | <code>(ab)&#124;c</code>
~~Any character~~ | `.`
One of | `[abc]`
~~Not one of~~ | `[^abc]`
Escape | `\[`, `\.`
Unicode character range | `a-z`, `0-9`
Zero-or-more | `a*`
One-or-more | `a+`
Zero-or-one | `a?`
Specific number | `a{3}`
Between numbers | `a{3,4}`
At least | `a{3,}`

### Build Step

An `Acorn` module is a Crystal program that generates code. To get a lexer, you have to run the `Acorn` module. Then, your main program should use the generated code.

For example, if you define a lexer:

```ruby
# build/my_lexer.cr
class MyLexer < Acorn::Lexer
  # ...
  generate("./app/my_lexer.cr")
end
```

You should _run_ the file with Crystal to generate the specified file:

```
crystal run build/my_lexer.cr
```

Then, your main program should `require` the generated file:

```ruby
# my_app.cr
require "app/my_lexer"
MyLexer.scan(input) # => Array(Tuple(Symbol, String))
```

The generated code has no dependency on `Acorn`, so you only need this library during development.

### Tokens

`Acorn` returns an of array tokens. Each token is a tuple with:

- `Symbol`: the name of this token in the lexer definition
- `String`: the segment of input which matched the pattern
- ~~`{Int32, Int32}`~~: line number and column number where the token began
- ~~`{Int32, Int32}`~~: line number and column number where the token ended

Line numbers and column numbers are _1-indexed_, so the first character in the input is `1:1`.

### Custom Machines

`Acorn` lexers are actually a special case of state machine. You can specify a custom machine, too.

- `class MyMachine < Acorn::Machine` to bring in the macros
- `alias Accumulator = ...` to specify the data that will be modified during the process
  - It will be initialized with `.new`
  - It will be returned from `.scan`
- use `action :name, "pattern" { |acc, str, ts, te| ... }` to define patterns
  - `acc` is an instance of your `Accumulator`
  - `str` is the original input
  - `ts` is the index in `str` where this token began
  - `te` is the index in `str` where this token ended (if the match is one character long, `ts == te`)
- optionally, `name("MyNamespace::MachineName")` to rename the generated Crystal class

## Development

- rebuild fixtures with `crystal run spec/prepare.cr`
- `crystal spec`

## Goals & Non-Goals

__Goals:__

- Great runtime performance
- Linear time complexity
- Reasonable code size (`.cr` file and memory usage)
- No runtime dependency
- Plain-Crystal API (source files are `.cr`, not a special format)
- Easy to write a lexer, possible to write something else

__Non-goals:__

- Great compile-time performance (choose simplicity over performance)
- Fancy regexp features


## TODO

- Finish regexp language (`(...)`, `.`, `[^...]`)
  - A move on `a` is _also_ a move on `:any`, how is that handled?
- Better line/col awareness:
  - Add line/col to tokens
  - Add line/col to errors

## License

LGPLv3
