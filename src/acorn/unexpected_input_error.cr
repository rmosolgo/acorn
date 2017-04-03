require "./error"

module Acorn
  class UnexpectedInputError < Acorn::Error
    getter char
    getter position
    def initialize(char : Char, position : Int32)
      @char = char
      @position = position
      super("Unexpected input: '#{char}'")
    end
  end
end
