require "./transition_table/*"

module Acorn
  class TransitionTable
    alias State = Int32
    # `nil` is used as ε-transition
    alias Transition = Char | Nil
    alias Transitions = Hash(Transition, State)
    alias Table = Hash(State, Transitions)
    alias StateMap = Hash(Symbol, Array(State))
    # TODO: is this actually worth it?
    # alias IndexedTable = Array(Transitions)

    alias Token = Tuple(Symbol, String)
    alias Tokens = Array(Token)
    alias Accumulator = Tokens
    alias Action = Proc(Tokens, String, Int32, Int32, Nil)
    alias Actions = Hash(State, Action)

    getter table
    getter actions
    getter ending_states

    def initialize(grammar)
      @table, @actions, @ending_states = TransitionTable::Prepare.call(grammar)
    end

    def scan(string : String)
      tokens = Tokens.new
      consume(string, tokens)
      tokens
    end

    Acorn::TransitionTable::Consume.define_consume_method("@table", "@actions")
  end
end
