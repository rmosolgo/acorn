require "../spec_helper"

describe Acorn::TransitionTable do
  describe "generating" do
    it "builds and consumes the grammar" do
      m = Acorn::RuntimeMachine.new
      m.token(:a, "abc")
      m.token(:b, "ax")
      m.token(:c, "a")

      table = Acorn::TransitionTable.new(m)
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

    it "handles repetition" do
      m = Acorn::RuntimeMachine.new
      m.token(:a, "a?")
      m.token(:b, "b+")
      m.token(:c, "c*")
      m.token(:d, "d{2,4}")
      table = Acorn::TransitionTable.new(m)
      tokens = table.scan("aadddccddddddbbabc")
      expected_tokens = [
        {:a, "a"},
        {:a, "a"},
        {:d, "ddd"},
        {:c, "cc"},
        {:d, "dddd"},
        {:d, "dd"},
        {:b, "bb"},
        {:a, "a"},
        {:b, "b"},
        {:c, "c"},
      ]
      tokens.should eq(expected_tokens)
    end

    pending "handes alternation AND repetition" { }
  end

  describe "errors" do
    pending "handles unexpected characters" { }
    pending "handles unexpected end" { }
  end
end
