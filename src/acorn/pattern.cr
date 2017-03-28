require "string_scanner"
require "./pattern/parse.cr"

module Acorn
  class Pattern
    alias Matches = Array(Char)
    alias Occurrences = Range(Int32, Int32)
    ONCE = 1..1
    def self.parse(expression : String)
      Parse.call(expression)
    end

    getter matches
    getter occurrences

    def initialize(@matches : Matches, @occurrences : Occurrences = ONCE)
    end

    def occurs(new_occurs : Occurrences)
      @occurrences = new_occurs
    end

    def union(other : Pattern)
      EitherPattern.new(left: self, right: other)
    end

    class EitherPattern < Pattern
      property occurrences
      getter matches
      getter left
      getter right

      def initialize(@left : Pattern, @right : Pattern, @occurrences : Occurrences = ONCE)
        @matches = @left.matches | @right.matches
      end

      def occurs(new_occurs : Occurrences)
        @occurrences = new_occurs
      end
    end
  end
end
