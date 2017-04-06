module Acorn
  class TransitionTable
    module Consume
      # This method is shared by StaticMachine and RuntimeMachine
      CONSUME_DEFINITION = <<-CRYSTAL
  def consume(input : String, acc : Accumulator) : Nil
    current_states = Set(Int32).new
    current_states << 0
    next_states = Set(Int32).new
    finishing_states = Set(Int32).new

    char = nil
    idx = 0
    last_idx = input.size - 1
    token_begin = 0
    while idx <= last_idx
      char ||= input.char_at(idx)
      current_states.each do |current_state|
        transitions = $$table[current_state]
        transitions.each do |move, end_state|
          case move
          when Char
            if move == char
              next_states << end_state
            end
          when :any
            next_states << end_state
          when :epsilon
            finishing_states << current_state
          when Range(Char, Char)
            if move.includes?(char)
              next_states << end_state
            end
          else
            raise "Unsupported transition move: \#{move} (between \#{current_state} and \#{end_state})"
          end
        end
      end

      # Follow next_states if possible (this finds the longest match)
      if next_states.any?
        idx += 1
        char = nil
        current_states.clear
        current_states.concat(next_states)
        next_states.clear
        finishing_states.clear
      elsif finishing_states.any?
        finishing_state = finishing_states.first
        $$actions[finishing_state].call(acc, input, token_begin, idx - 1)
        token_begin = idx
        current_states.clear
        current_states << 0
        finishing_states.clear
        next_states.clear
      else
        raise UnexpectedInputError.new(char, idx)
      end
    end

    # last token:
    action = nil
    current_states.each do |current_state|
      action = $$actions[current_state]?
      if action
        action.call(acc, input, token_begin, idx - 1)
        break
      end
    end
    # didn't find an end state:
    if action.nil?
      raise UnexpectedEndError.new(idx)
    end
  end
  CRYSTAL

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
