module Acorn
  class Grammar
    getter tokens

    def initialize
      @tokens = {} of Symbol => String
    end

    def token(name : Symbol, pattern : String)
      @tokens[name] = pattern
    end
  end
end
