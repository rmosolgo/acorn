require "../../src/acorn"

class NumbersAndLetters < Acorn::Lexer
  token :letter, "a-z"
  token :number, "0-9{2,}"
  generate("./spec/fixtures/numbers_and_letters.cr")
end
