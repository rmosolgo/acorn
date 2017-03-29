module Acorn
  class TransitionTable
    module Prepare
      def self.call(grammar) : Tuple(TransitionTable::Table, TransitionTable::Actions, TransitionTable::StateMap)
        table = TransitionTable::Table.new
        ending_states = TransitionTable::StateMap.new
        actions = TransitionTable::Actions.new
        # Incrementing counter for state numbers
        next_state = 0
        grammar.actions.each do |tok_name, tok_pat, tok_handler|
          patterns = Acorn::Pattern.parse(tok_pat)
          # 0 is always the start state:
          next_states = Set(State).new([0])

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

          # Add a loopback to the starting state when we finish this token
          # Register the action
          next_states.each do |ending_state|
            s = ending_states[tok_name] ||= Array(TransitionTable::State).new
            s << ending_state
            transitions = table[ending_state] ||= Transitions.new
            transitions[nil] = 0
            actions[ending_state] = TransitionTable::Action.new { |str, tokens| tokens << {tok_name, str} }
          end
        end

        return table, actions, ending_states
      end
    end
  end
end
