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

### Regular Expressions

Tokens are defined with a small regular expression language:

Feature | Example
---|---
Character| `a`, `1`, `❤️`
Sequence |`ab`, `123`
Alternation | `a┃b`
~~Grouping~~ | `(ab)┃c`
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

## Development

- rebuild fixtures with `crystal run spec/prepare.cr`
- `crystal spec`

## TODO

- Add proper error handling
- Finish regexp language (`(...)`, `.`, `[^...]`)
- Better tokens: include line & col out of the box

## Contributing

1. Fork it (https://github.com/rmosolgo/acorn/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

LGPLv3
