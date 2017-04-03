require "../spec_helper"

describe Acorn::RuntimeMachine do
  it "tokenizes strings" do
    machine = Acorn::RuntimeMachine.new do |m|
      m.token(:open_paren, "(")
      m.token(:close_paren, ")")
      m.token(:comma, ",")
      m.token(:int, "0-9")
    end

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
