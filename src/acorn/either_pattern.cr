require "./pattern"
module Acorn
  class EitherPattern < Pattern
    getter left
    getter right

    def initialize(@left : Pattern, @right : Pattern, @occurrences : Occurrences = ONCE)
      @matches = @left.matches | @right.matches
    end

    def to_debug
      "(#{@left.to_debug}|#{@right.to_debug})"
    end
  end
end
