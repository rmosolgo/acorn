module Acorn
  class TransitionTable
    module Prepare
      def self.call(transition_table, grammar) : Nil
        table = transition_table.table
        ending_states = transition_table.ending_states

        grammar.actions.each do |tok_name, tok_pat, tok_handler|
          patterns = Acorn::Pattern.parse(tok_pat)
          # 0 is always the start state:
          next_start_states = Set(TransitionTable::State).new([0])
          patterns.each do |pattern|
            next_start_states = build_states(table, pattern, next_start_states)
          end

          # Add a loopback to the starting state when we finish this token
          # Register the action
          next_start_states.each do |ending_state|
            table[ending_state][:epsilon] = 0
            ending_states[tok_name] << ending_state
          end
        end
      end

      def self.build_states(table, pattern, start_states)
        all_states = start_states
        next_pattern_start_states = Set(State).new
        reps = 0
        min_reps = pattern.occurrences.begin
        max_reps = pattern.occurrences.end

        # We haven't hit the minimum yet,
        # so add intermediary steps until we
        # reach valid ending points
        while reps < min_reps
          next_states = [] of State
          all_states.each do |st|
            next_states.concat(add_states(table, st, pattern))
          end
          all_states = next_states
          reps += 1
        end

        if max_reps == Acorn::Pattern::ANY_NUMBER
          # We'll never reach the ending point, so instead:
          # - This state is an ending state
          # - Add a loop state if we receive one more valid input
          all_states.each do |st|
            loop_states = add_states(table, st, pattern)
            loop_states.each do |loop_state|
              add_loop_state(table, loop_state, pattern)
              next_pattern_start_states << loop_state
            end
            next_pattern_start_states << st
          end
        else
          # There's a finite end to this range,
          # so add states which are ending states
          while reps < max_reps
            next_states = [] of State
            all_states.each do |st|
              next_pattern_start_states << st
              next_states.concat(add_states(table, st, pattern))
            end
            all_states = next_states
            reps += 1
          end
        end

        next_pattern_start_states.concat(all_states)
      end

      def self.add_states(table, st, pattern : Acorn::CharPattern) : Set(State)
        next_states = Set(State).new
        next_states << table[st][pattern.match]
        next_states
      end

      def self.add_states(table, st, pattern : Acorn::AnyPattern) : Set(State)
        next_states = Set(State).new
        next_states.add(table[st][:any])
        next_states
      end

      def self.add_states(table, st, pattern : Acorn::EitherPattern) : Set(State)
        next_states = Set(State).new
        next_states.concat(build_states(table, pattern.left, [st]))
        next_states.concat(build_states(table, pattern.right, [st]))
        next_states
      end

      def self.add_states(table, st, pattern : Acorn::RangePattern) : Set(State)
        next_states = Set(State).new
        next_states.add(table[st][pattern.range])
        next_states
      end

      def self.add_states(table, st, pattern : Acorn::Pattern) : Set(State)
        raise ".add_states Not implemented for #{pattern}"
      end

      def self.add_loop_state(table, st, pattern : Acorn::CharPattern) : Nil
        table[st][pattern.match] = st
      end

      def self.add_loop_state(table, st, pattern : Acorn::AnyPattern) : Nil
        table[st][:any] = st
      end

      def self.add_loop_state(table, st, pattern : Acorn::RangePattern) : Nil
        table[st][pattern.range] = st
      end

      def self.add_loop_state(table, st, pattern : Acorn::EitherPattern) : Nil
        add_loop_state(table, st, pattern.left)
        add_loop_state(table, st, pattern.right)
      end

      def self.add_loop_state(table, st, pattern : Acorn::Pattern) : Nil
        raise ".add_loop_state not implemented for #{pattern}"
      end
    end
  end
end
