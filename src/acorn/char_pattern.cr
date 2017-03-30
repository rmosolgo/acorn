require "./pattern"
module Acorn
  class CharPattern < Pattern
    getter match
    def initialize(@match : Char, @occurrences : Occurrences = ONCE)
      @matches = [@match]
    end

    def to_debug
      "[#{@matches.join(",")}]@{#{@occurrences}}"
    end
  end
end
