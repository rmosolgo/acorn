require "../../src/acorn"

module NumbersAndLettersDefinition
  include Acorn::Macros
  machine "NumbersAndLetters"
  token :letter, "a-z"
  token :number, "0-9"
  generate("./spec/fixtures/numbers_and_letters.cr")
end
