require "../spec_helper"

describe Acorn::TransitionTable do
  describe "generating" do
    it "builds and consumes the grammar" do
      g = Acorn::Grammar.new
      g.token(:a, "abc")
      g.token(:b, "ax")
      g.token(:c, "a")

      table = Acorn::TransitionTable.build(g)
      puts "\n"
      p table
      puts "\n"

      Acorn::TransitionTable.consume(table, "abcaaaxabc")
    end
  end

  describe "errors" do
    pending "handles unexpected characters" { }
    pending "handles unexpected end" { }
  end
end
