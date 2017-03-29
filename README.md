# Acorn [![Build Status](https://travis-ci.org/rmosolgo/acorn.svg?branch=master)](https://travis-ci.org/rmosolgo/acorn)

🚧 Under Construction 👷

Define a grammar using a subset of regular expression notation, then compile it into a blazing-fast state machine. `Acorn` supports lexers or custom string-based state machines.

## Installation

Add this to your application's `shard.yml`:

```
dependencies:
  acorn:
    github: "rmosolgo/acorn"
```

## Usage

- Define the grammar in a build file:

  ```ruby
  # ./build/my_lexer.cr
  require "acorn"

  module MyLexer
    include Acorn::Macros
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

## Development

- `crystal spec`
- The fixtures are weird, use `crystal run spec/prepare.cr` if they're stale

## TODO

- Better tokens: include line & col out of the box
- Handle repetition in the transition table

## Contributing

1. Fork it (https://github.com/rmosolgo/acorn/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

LGPLv3
