require "../spec_helper"

describe Acorn::Grammar do
  it "stores tokens" do
    grammar = Acorn::Grammar.new
    grammar.token(:num, "0-9")
    grammar.token(:let, "A-Za-z")
    tokens = grammar.tokens
    tokens.size.should eq(2)
    tokens[:num].should eq("0-9")
  end
end
