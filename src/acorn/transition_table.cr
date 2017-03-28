module Acorn
  module TransitionTable
    alias State = Int32
    # `nil` is used as ε-transition
    alias Transition = Char | Nil
    alias Transitions = Hash(Transition, State)
    alias Table = Hash(State, Transitions)
    alias IndexedTable = Array(Transitions)
    START_STATE = 0

    def self.build(grammar : Acorn::Grammar) : IndexedTable
      table = Table.new
      next_state = START_STATE
      grammar.tokens.each do |tok_name, tok_pat|
        patterns = Acorn::Pattern.parse(tok_pat)
        next_states = Set(State).new([START_STATE])
        patterns.each_with_index do |pattern, idx|
          all_transitions = next_states.map { |s| table[s] ||= Transitions.new }
          next_states.clear
          is_last = idx == patterns.size - 1
          pattern.matches.each do |char|
            all_transitions.each do |transitions|
              to_state = transitions[char] ||= (next_state += 1)
              next_states.add(to_state)
            end
          end
        end

        next_states.each do |ending_state|
          transitions = table[ending_state] ||= Transitions.new
          transitions[nil] = 0
        end
      end

      table.values
    end

    def self.consume(table : IndexedTable, string : String)
      current_state = START_STATE
      char = nil
      idx = 0
      last_idx = string.size - 1
      while idx < last_idx
        char ||= string.char_at(idx)
        transitions = table[current_state]
        if (next_state = transitions[char]?)
          idx += 1
          char = nil
        else
          next_state = transitions[nil]
        end
        current_state = next_state
      end
    end
  end
end
