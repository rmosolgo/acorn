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

    it "handes alternation AND repetition" do
      m = Acorn::RuntimeMachine.new
      m.token(:sm, "0*0-2")
      m.token(:md, "3|4")
      m.token(:lg, "6-7+")
      m.token(:xl, "[89]*")
      table = Acorn::TransitionTable.new(m)
      tokens = table.scan("340026670119988")
      expected_tokens = [
        {:md, "3"},
        {:md, "4"},
        {:sm, "002"},
        {:lg, "667"},
        {:sm, "01"},
        {:sm, "1"},
        {:xl, "9988"},
      ]
      tokens.should eq(expected_tokens)
    end

    it "handes any-char" do
      m = Acorn::RuntimeMachine.new
      m.token(:a, "a.")
      # TODO: this goes infinite:
      # m.token :a, "a.."
      m.token(:b, "b.*c")
      m.token(:c, "c*")
      m.token(:d, "d.{2}")
      table = Acorn::TransitionTable.new(m)
      tokens = table.scan("azccacbzycdccc")
      expected_tokens = [
        {:a, "az"},
        {:c, "cc"},
        {:a, "ac"},
        {:b, "bzyc"},
        {:d, "dcc"},
        {:c, "c"}
      ]
      tokens.should eq(expected_tokens)
    end
  end

  describe "errors" do
    pending "handles unexpected characters" { }
    pending "handles unexpected end" { }
  end
end
