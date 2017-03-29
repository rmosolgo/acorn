module Acorn
  class TransitionTable
    module Consume
      # This method is shared by StaticMachine and RuntimeMachine
      CONSUME_DEFINITION = "def consume(input : String, acc : Accumulator) : Nil
    current_state = 0
    char = nil
    idx = 0
    last_idx = input.size - 1
    token_begin = 0
    while idx <= last_idx
      char ||= input.char_at(idx)
      transitions = $$table[current_state]
      if (next_state = transitions[char]?)
        idx += 1
        char = nil
      else
        next_state = transitions[nil]
        $$actions[current_state].call(acc, input, token_begin, idx)
        token_begin = idx
      end
      current_state = next_state
    end
    # last token:
    $$actions[current_state].call(acc, input, token_begin, idx)
  end"

      macro define_consume_method(table_id, actions_id)
        {{
          CONSUME_DEFINITION
            .gsub(/\$\$actions/, actions_id)
            .gsub(/\$\$table/, table_id)
            .id
        }}
      end
    end
  end
end
