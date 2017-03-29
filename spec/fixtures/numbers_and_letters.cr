module NumbersAndLetters
  # This is the kind of thing which is:
  # - initially passed to `consume`
  # - passed to each
  alias Accumulator = Array(Tuple(Symbol, String))
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
  def self.consume(input : String, acc : Accumulator) : Nil
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

  def self.scan(input : String) : Accumulator
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
      '0' => 27,
      '1' => 28,
      '2' => 29,
      '3' => 30,
      '4' => 31,
      '5' => 32,
      '6' => 33,
      '7' => 34,
      '8' => 35,
      '9' => 36,
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
    27 => {
      nil => 0,
    },
    28 => {
      nil => 0,
    },
    29 => {
      nil => 0,
    },
    30 => {
      nil => 0,
    },
    31 => {
      nil => 0,
    },
    32 => {
      nil => 0,
    },
    33 => {
      nil => 0,
    },
    34 => {
      nil => 0,
    },
    35 => {
      nil => 0,
    },
    36 => {
      nil => 0,
    },
  }

  # A map of state => Action pairs to call when machines are finished
  ACTIONS = {
    1 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    2 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    3 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    4 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    5 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    6 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    7 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    8 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    9 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    10 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    11 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    12 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    13 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    14 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    15 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    16 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    17 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    18 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    19 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    20 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    21 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    22 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    23 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    24 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    25 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    26 => Action.new { |acc, str, t_beg, t_end| acc << {:letter, str[t_beg...t_end]} },
    27 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    28 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    29 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    30 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    31 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    32 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    33 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    34 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    35 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
    36 => Action.new { |acc, str, t_beg, t_end| acc << {:number, str[t_beg...t_end]} },
  }
end
