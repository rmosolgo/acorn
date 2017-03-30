module Acorn
  class RuntimeMachine
    alias Token = Tuple(Symbol, String)
    alias Tokens = Array(Token)
    alias Action = Proc(Tokens, String, Int32, Int32, Nil)
    alias ActionDefinition = Tuple(Symbol, String, Action)
    alias ActionDefinitions = Array(ActionDefinition)

    property name = "AcornGeneratedMachine"
    property accumulator = "Array(Tuple(Symbol, String))"
    getter actions
    def initialize
      @actions = ActionDefinitions.new
    end

    def token(name, pattern : String)
      action(name, pattern, Action.new { |acc, str, t_beg, t_end| acc << Token.new(name, str[t_beg...t_end]) })
    end

    def action(name, pattern, body)
      @actions << ActionDefinition.new(name, pattern, body)
    end

    def scan(input)
      table.scan(input)
    end

    private def table
      @table ||= Acorn::TransitionTable.new(grammar: self)
    end
  end
end
