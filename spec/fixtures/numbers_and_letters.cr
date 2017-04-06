module NumbersAndLetters
  extend self
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
      transitions = TABLE[current_state]
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
          raise "Unsupported transition move: #{move} (between #{current_state} and #{end_state})"
        end
      end
    end

    if finishing_states.any?
      finishing_state = finishing_states.first
      ACTIONS[finishing_state].call(acc, input, token_begin, idx - 1)
      token_begin = idx
      current_states.clear
      current_states << 0
      finishing_states.clear
      next_states.clear
    elsif next_states.any?
      idx += 1
      char = nil
      current_states.clear
      current_states.concat(next_states)
      next_states.clear
    else
      raise UnexpectedInputError.new(char, idx)
    end
  end

  # last token:
  action = nil
  current_states.each do |current_state|
    action = ACTIONS[current_state]?
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

  def scan(input : String) : Accumulator
    acc = Accumulator.new
    consume(input, acc)
    acc
  end

  # A deterministic finite automaton built from the specified patterns
  TABLE = {
    0 => {
      'a'..'z' => 1,
      '0'..'9' => 2,
    },
    1 => {
      :epsilon => 0,
    },
    2 => {
      '0'..'9' => 3,
    },
    3 => {
      '0'..'9' => 4,
      :epsilon => 0,
    },
    4 => {
      '0'..'9' => 4,
      :epsilon => 0,
    },
  }

  # A map of state => Action pairs to call when machines are finished
  ACTIONS = {
    1 => Action.new { |acc, str, ts, te| acc << {:letter, str[ts..te]} },
    4 => Action.new { |acc, str, ts, te| acc << {:number, str[ts..te]} },
    3 => Action.new { |acc, str, ts, te| acc << {:number, str[ts..te]} },
  }


  class Error < Exception
  end
  class UnexpectedEndError < Error
    getter position
    def initialize(position : Int32)
      @position = position
      super("Unexpected EOS")
    end
  end
  class UnexpectedInputError < Error
    getter char
    getter position
    def initialize(char : Char, position : Int32)
      @char = char
      @position = position
      super("Unexpected input: '#{char}'")
    end
  end
end
