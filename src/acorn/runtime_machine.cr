require "./transition_table/consume"
require "./transition_table"

module Acorn
  class RuntimeMachine
    alias Token = Tuple(Symbol, String)
    alias Tokens = Array(Token)
    alias Action = Proc(Tokens, String, Int32, Int32, Nil)
    alias ActionDefinition = Tuple(Symbol, String, Action)
    alias ActionDefinitions = Array(ActionDefinition)
    alias Accumulator = Tokens

    getter actions
    @actions = ActionDefinitions.new

    def initialize
      ap = ActionProxy.new
      yield(ap)
      @actions = ap.actions
      @token_actions = Hash(Int32, Action).new
      @transition_table = Acorn::TransitionTable.new(ap)
      @token_actions = build_token_actions(ending_states, @actions)
    end

    class ActionProxy
      getter actions

      def initialize
        @actions = ActionDefinitions.new
      end

      def token(name, pattern : String)
        action(name, pattern, Action.new { |acc, str, ts, te| acc << Token.new(name, str[ts..te]) })
      end

      def action(name, pattern, body)
        @actions << ActionDefinition.new(name, pattern, body)
      end
    end

    def scan(string : String)
      tokens = Tokens.new
      consume(string, tokens)
      tokens
    end

    Acorn::TransitionTable::Consume.define_consume_method("table", "@token_actions")

    def ending_states
      @transition_table.ending_states
    end

    def table : Acorn::TransitionTable::Table
      @transition_table.table
    end

    private def build_token_actions(ending_states, actions)
      token_actions = {} of Int32 => Action
      ending_states.each do |tok_name, states|
        action = actions.find { |name, pat, act| name == tok_name }
        if action
          states.each do |state|
            token_actions[state] = action[2]
          end
        else
          raise "Couldn't find action for #{tok_name} (#{states})"
        end
      end
      token_actions
    end
  end
end
