require "./pattern"
module Acorn
  class AnyPattern < Pattern
    def initialize(@occurrences : Occurrences = ONCE)
      @matches = ['.']
    end

    def to_debug
      ":any"
    end
  end
end
