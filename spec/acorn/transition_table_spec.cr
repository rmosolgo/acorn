require "../spec_helper"

describe Acorn::TransitionTable do
  describe "generating" do
    it "builds and consumes the grammar" do
      g = Acorn::Grammar.new
      g.token(:a, "abc")
      g.token(:b, "ax")
      g.token(:c, "a")

      table = Acorn::TransitionTable.new(grammar: g)
      # puts "\n Table:"
      # p table.table
      # puts "\n"

      tokens = table.consume("abcaaaxabc")
      expected_tokens = [
        {:a, "abc"},
        {:c, "a"},
        {:c, "a"},
        {:b, "ax"},
        {:a, "abc"},
      ]
      tokens.should eq(expected_tokens)
    end
  end

  describe "errors" do
    pending "handles unexpected characters" { }
    pending "handles unexpected end" { }
  end
end
