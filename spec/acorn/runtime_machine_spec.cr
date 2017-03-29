require "../spec_helper"

describe Acorn::RuntimeMachine do
  it "tokenizes strings" do
    machine = Acorn::RuntimeMachine.new
    machine.token(:open_paren, "(")
    machine.token(:close_paren, ")")
    machine.token(:comma, ",")
    machine.token(:int, "0-9")

    tokens = machine.scan("(1,2)")
    expected_tokens = [
      {:open_paren, "("},
      {:int, "1"},
      {:comma, ","},
      {:int, "2"},
      {:close_paren, ")"},
    ]
    tokens.should eq(expected_tokens)
  end
end
