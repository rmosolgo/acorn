require "./error"

module Acorn
  # Raised when the next character doesn't have a valid transition.
  #
  # Duplicated in static_machine/template.ecr
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
