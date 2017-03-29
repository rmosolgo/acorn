require "ecr/macros"

module Acorn
  class StaticMachine
    alias ActionDefinition = Tuple(Symbol, String, String)
    alias ActionDefinitions = Array(ActionDefinition)

    property name = "AcornGeneratedMachine"
    property accumulator = "Array(Tuple(Symbol, String))"
    getter actions

    def initialize
      @actions = ActionDefinitions.new
    end

    def token(name, pattern)
      act_defn = "{ |acc, str, t_beg, t_end| acc << {:#{name}, str[t_beg...t_end]} }"
      action(name, pattern, act_defn)
    end

    def action(name, pattern, body)
      @actions << ActionDefinition.new(name, pattern, body)
    end

    def table
      @table ||= Acorn::TransitionTable.new(grammar: self)
    end

    ECR.def_to_s("./src/acorn/machine/template.ecr")
  end
end
