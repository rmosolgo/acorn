require "string_scanner"
require "./pattern/parse.cr"

module Acorn
  abstract class Pattern
    alias Matches = Array(Char)
    alias Occurrences = Range(Int32, Int32)
    ONCE = 1..1
    ANY_NUMBER = Int32::MAX

    def self.parse(expression : String)
      Parse.call(expression)
    end

    getter occurrences : Occurrences = ONCE
    getter matches : Matches = Matches.new

    def occurs(new_occurs : Occurrences)
      @occurrences = new_occurs
    end

    def union(other : Pattern)
      Acorn::EitherPattern.new(left: self, right: other)
    end

    # Why doesn't `abstract def` work here?
    def to_debug
      "ABSTRACT"
    end
  end
end
