require "../spec_helper"

describe Acorn::TransitionTable do
  describe "generating" do
    it "builds and consumes the grammar" do
      m = Acorn::RuntimeMachine.new
      m.token(:a, "abc")
      m.token(:b, "ax")
      m.token(:c, "a")

      table = Acorn::TransitionTable.new(m)
      # puts "\n Table:"
      # p table.table
      # puts "\n"

      tokens = table.scan("abcaaaxabc")
      expected_tokens = [
        {:a, "abc"},
        {:c, "a"},
        {:c, "a"},
        {:b, "ax"},
        {:a, "abc"},
      ]
      tokens.should eq(expected_tokens)

      # puts "\n  Ending States:"
      # p table.ending_states
      # puts "\n"

      terminals = table.ending_states
      terminals[:a].should eq([3])
      terminals[:b].should eq([4])
      terminals[:c].should eq([1])
    end
  end

  describe "errors" do
    pending "handles unexpected characters" { }
    pending "handles unexpected end" { }
  end
end
