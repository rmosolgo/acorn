require "./transition_table/prepare.cr"

module Acorn
  class TransitionTable
    alias State = Int32
    # `nil` is used as ε-transition
    alias Transition = Char | Nil
    alias Transitions = Hash(Transition, State)
    alias Table = Hash(State, Transitions)
    # TODO: is this actually worth it?
    # alias IndexedTable = Array(Transitions)

    alias Token = Tuple(Symbol, String)
    alias Tokens = Array(Token)
    alias Action = Proc(String, Tokens, Nil)
    alias Actions = Hash(State, Action)

    getter table

    def initialize(grammar : Acorn::Grammar)
      @table, @actions = TransitionTable::Prepare.call(grammar)
    end

    def consume(string : String)
      tokens = Tokens.new
      current_state = 0
      char = nil
      idx = 0
      last_idx = string.size - 1
      token_begin = 0
      while idx <= last_idx
        char ||= string.char_at(idx)
        transitions = @table[current_state]
        if (next_state = transitions[char]?)
          idx += 1
          char = nil
        else
          next_state = transitions[nil]
          token_value = string[token_begin...idx]
          @actions[current_state].call(token_value, tokens)
          token_begin = idx
        end
        current_state = next_state
      end
      # last token:
      token_value = string[token_begin..idx]
      @actions[current_state].call(token_value, tokens)
      tokens
    end
  end
end
