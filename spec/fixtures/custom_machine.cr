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
  TABLE = {
    0 => {
      'a' => 1,
      'b' => 2,
      'c' => 3,
      'd' => 4,
      'e' => 5,
      'f' => 6,
      'g' => 7,
      'h' => 8,
      'i' => 9,
      'j' => 10,
      'k' => 11,
      'l' => 12,
      'm' => 13,
      'n' => 14,
      'o' => 15,
      'p' => 16,
      'q' => 17,
      'r' => 18,
      's' => 19,
      't' => 20,
      'u' => 21,
      'v' => 22,
      'w' => 23,
      'x' => 24,
      'y' => 25,
      'z' => 26,
    },
    1 => {
      nil => 0,
    },
    2 => {
      nil => 0,
    },
    3 => {
      nil => 0,
    },
    4 => {
      nil => 0,
    },
    5 => {
      nil => 0,
    },
    6 => {
      nil => 0,
    },
    7 => {
      nil => 0,
    },
    8 => {
      nil => 0,
    },
    9 => {
      nil => 0,
    },
    10 => {
      nil => 0,
    },
    11 => {
      nil => 0,
    },
    12 => {
      nil => 0,
    },
    13 => {
      nil => 0,
    },
    14 => {
      nil => 0,
    },
    15 => {
      nil => 0,
    },
    16 => {
      nil => 0,
    },
    17 => {
      nil => 0,
    },
    18 => {
      nil => 0,
    },
    19 => {
      nil => 0,
    },
    20 => {
      nil => 0,
    },
    21 => {
      nil => 0,
    },
    22 => {
      nil => 0,
    },
    23 => {
      nil => 0,
    },
    24 => {
      nil => 0,
    },
    25 => {
      nil => 0,
    },
    26 => {
      nil => 0,
    },
  }

  # A map of state => Action pairs to call when machines are finished
  ACTIONS = {
    1 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    2 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    3 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    4 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    5 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    6 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    7 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    8 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    9 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    10 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    11 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    12 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    13 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    14 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    15 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    16 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    17 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    18 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    19 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    20 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    21 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    22 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    23 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    24 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    25 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
    26 => Action.new { |acc,str,ts,te| acc << ({ts, te}) },
  }
end
