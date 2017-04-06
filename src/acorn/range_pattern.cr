require "./pattern"

module Acorn
  class RangePattern < Acorn::Pattern
    getter range
    def initialize(@range : Range(Char, Char), @occurences : Int32 = 1)
    end

    def to_debug
      "#{range}@#{occurrences}"
    end
  end
end
