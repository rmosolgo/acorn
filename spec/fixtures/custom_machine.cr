module CustomMachine
  extend self
  # This is the kind of thing which is:
  # - initially passed to `consume`
  # - passed to each
  alias Accumulator = Array(Tuple(Int32, Int32))
  # When we finish a pattern, we call its corresponding action.
  # The action should modify `Accumulator`.
  # The first `int` is the beginning index of the current pattern.
  # The second `int` is the ending index of the current pattern.
  alias Action = Proc(Accumulator, String, Int32, Int32, Nil)

  # Work through `input` according to this machine,
  # passing `acc` to each action. `acc` will be modified in-place
  # since this method returns nil.
  #
  # If there's a scanning error, an error is raised.
  def consume(input : String, acc : Accumulator) : Nil
    current_state = 0
    char = nil
    idx = 0
    last_idx = input.size - 1
    token_begin = 0
    while idx <= last_idx
      char ||= input.char_at(idx)
      transitions = TABLE[current_state]
      if (next_state = transitions[char]?)
        idx += 1
        char = nil
      else
        next_state = transitions[nil]
        ACTIONS[current_state].call(acc, input, token_begin, idx)
        token_begin = idx
      end
      current_state = next_state
    end
    # last token:
    ACTIONS[current_state].call(acc, input, token_begin, idx)
  end

  def scan(input : String) : Accumulator
    acc = Accumulator.new
    consume(input, acc)
    acc
  end

  # A deterministic finite automaton built from the specified patterns
  alias State = Int32
  alias Transition = Char | Nil
  alias TransitionTable = Hash(Transition, State)
  TABLE = {
    0 => {
      nil => 0,
    } of Transition => State,
  } of State => TransitionTable

  # A map of state => Action pairs to call when machines are finished
  ACTIONS = {
    0 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
  }
end
