require "./transition_table/*"

module Acorn
  class TransitionTable
    alias State = Int32
    # `:epsilon` is used as ε-transition
    alias Transition = Char | Symbol
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
      next_state = 0
      @table = Table.new do |h, k|
        h[k] = Transitions.new do |h2, k2|
          ns = next_state += 1
          # puts "#{k} -> #{k2} -> #{ns}"
          h2[k2] = ns
        end
      end

      @ending_states = StateMap.new { |h, k| h[k] = Array(TransitionTable::State).new }
      @actions = Actions.new

      Prepare.call(self, grammar)
    end

    def scan(string : String)
      tokens = Tokens.new
      consume(string, tokens)
      tokens
    end

    def to_debug
      io = IO::Memory.new
      io << "\n"
      io << @table.to_s
      io << "\n"
      io << @ending_states.to_s
      io.to_s
    end

    Acorn::TransitionTable::Consume.define_consume_method("@table", "@actions")
  end
end
