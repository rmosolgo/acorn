require "../spec_helper"


describe Acorn::Macros do
  it "makes a lexer" do
    tokens = NumbersAndLetters.scan("a1b2")
    expected_tokens = [
      {:letter, "a"},
      {:number, "1"},
      {:letter, "b"},
      {:number, "2"},
    ]
    tokens.should eq(expected_tokens)
  end

  it "makes a custom machine" do
    tokens = CustomMachine.scan("xyz")
    expected_tokens = [
      {0, 1},
      {1, 2},
      {2, 3},
    ]
    tokens.should eq(expected_tokens)
  end
end
