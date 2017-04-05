require "../spec_helper"


describe Acorn::Machine do
  it "makes a lexer" do
    tokens = NumbersAndLetters.scan("a11b22")
    expected_tokens = [
      {:letter, "a"},
      {:number, "11"},
      {:letter, "b"},
      {:number, "22"},
    ]
    tokens.should eq(expected_tokens)
  end

  it "makes a custom machine" do
    tokens = CustomMachine.scan("xyz")
    expected_tokens = [
      {0, 0},
      {1, 1},
      {2, 2},
    ]
    tokens.should eq(expected_tokens)
  end
end
