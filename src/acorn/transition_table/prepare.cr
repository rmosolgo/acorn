module Acorn
  class TransitionTable
    module Prepare
      def self.call(grammar) : Tuple(TransitionTable::Table, TransitionTable::Actions, TransitionTable::StateMap)
        # Incrementing counter for state numbers
        next_state = 0
        table = TransitionTable::Table.new do |h, k|
          h[k] = Transitions.new do |h2, k2|
            ns = next_state += 1
            # puts "#{k} -> #{k2} -> #{ns}"
            h2[k2] = ns
          end
        end

        ending_states = TransitionTable::StateMap.new { |h, k| h[k] = Array(TransitionTable::State).new }
        actions = TransitionTable::Actions.new

        grammar.actions.each do |tok_name, tok_pat, tok_handler|
          push_token = TransitionTable::Action.new { |tokens, str, ts, te| tokens << {tok_name, str[ts...te]} }
          patterns = Acorn::Pattern.parse(tok_pat)
          # 0 is always the start state:
          next_pattern_start_states = Set(TransitionTable::State).new([0])
          all_states = [0]
          patterns.each_with_index do |pattern|
            all_states = next_pattern_start_states.to_a
            next_pattern_start_states.clear
            case pattern
            when Acorn::CharPattern
              reps = 0
              min_reps = pattern.occurrences.begin
              max_reps = pattern.occurrences.end
              char = pattern.match

              # We haven't hit the minimum yet,
              # so add intermediary steps until we
              # reach valid ending points
              while reps < min_reps
                next_states = [] of State
                all_states.each do |st|
                  next_states << table[st][char]
                end
                all_states = next_states
                reps += 1
              end

              if max_reps == Acorn::Pattern::ANY_NUMBER
                # We'll never reach the ending point, so instead:
                # - This state is an ending state
                # - Add a loop state if we receive one more valid input
                all_states.each do |st|
                  loop_state = table[st][char]
                  table[loop_state][char] = loop_state
                  next_pattern_start_states << st
                  next_pattern_start_states << loop_state
                end
              else
                # There's a finite end to this range,
                # so add states which are ending states
                while reps < max_reps
                  next_states = [] of State
                  all_states.each do |st|
                    next_pattern_start_states << st
                    next_states << table[st][char]
                  end
                  all_states = next_states
                  reps += 1
                end
              end
            when Acorn::EitherPattern
            else
              raise "Unexpected pattern: #{pattern}"
            end

            all_states = next_pattern_start_states.concat(all_states).to_a
          end

          # Add a loopback to the starting state when we finish this token
          # Register the action
          all_states.each do |ending_state|
            table[ending_state][nil] = 0
            ending_states[tok_name] << ending_state
            actions[ending_state] = push_token
          end
        end

        return table, actions, ending_states
      end
    end
  end
end
