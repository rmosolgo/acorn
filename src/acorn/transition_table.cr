require "./transition_table/*"

module Acorn
  class TransitionTable
    alias State = Int32
    # `:epsilon` is used as ε-transition
    # `:any` is used as `.`
    alias Transition = Char | Symbol | Range(Char, Char)
    alias Transitions = Hash(Transition, State)
    alias Table = Hash(State, Transitions)
    alias StateMap = Hash(Symbol, Array(State))
    # TODO: is this actually worth it?
    # alias IndexedTable = Array(Transitions)

    getter table
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

      Prepare.call(self, grammar)
    end

    def to_debug
      io = IO::Memory.new
      io << "\n"
      io << @table.to_s
      io << "\n"
      io << @ending_states.to_s
      io.to_s
    end
  end
end
