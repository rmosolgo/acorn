# acorn

🚧 Under Construction 👷

## Installation

Add this to your application's `shard.yml`:

```
dependencies:
  acorn:
    github: "rmosolgo/acorn"
```

## Usage

```ruby
# grammar.cr
require "acorn"

module Lexer
  include Acorn

  # define the grammar
  grammar do |g|
    g.token :number, "0-9+"
    g.token :capital, "A-Z"
  end

  # dump scan methods here,
  # creates `self.scan(input)`
  yield_grammar
end

Lexer.scan(input) # => Array(Tuple(Symbol, String))
```

## Development

- `crystal spec`

## Contributing

1. Fork it (https://github.com/rmosolgo/acorn/fork)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## License

LGPLv3
