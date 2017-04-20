require "ecr/macros"
require "./transition_table/consume"

module Acorn
  class StaticMachine
    include Acorn::TransitionTable::Consume

    alias ActionDefinition = Tuple(Symbol, String, String)
    alias ActionDefinitions = Array(ActionDefinition)

    property name = "AcornGeneratedMachine"
    property accumulator = "Array(Tuple(Symbol, String))"
    getter consume_method : String = CONSUME_DEFINITION.gsub("$$table", "TABLE").gsub("$$actions", "ACTIONS")

    getter actions

    def initialize
      @actions = ActionDefinitions.new
    end

    def token(name, pattern)
      act_defn = "{ |acc, str, ts, te| acc << {:#{name}, str[ts..te]} }"
      action(name, pattern, act_defn)
    end

    def action(name, pattern, body)
      @actions << ActionDefinition.new(name, pattern, body)
    end

    def table
      @table ||= Acorn::TransitionTable.new(grammar: self)
    end

    ECR.def_to_s "#{__DIR__}/static_machine/template.ecr"

    def to_outfile(outfile)
      File.write(outfile, to_s)
    end
  end
end
