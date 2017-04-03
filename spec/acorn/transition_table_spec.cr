require "../spec_helper"

describe Acorn::TransitionTable do
  describe "generating" do
    it "builds and consumes the grammar" do
      m = Acorn::RuntimeMachine.new do |rm|
        rm.token(:a, "abc")
        rm.token(:b, "ax")
        rm.token(:c, "a")
      end

      tokens = m.scan("abcaaaxabc")
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

      terminals = m.ending_states
      terminals[:a].should eq([3])
      terminals[:b].should eq([4])
      terminals[:c].should eq([1])
    end

    it "handles repetition" do
      m = Acorn::RuntimeMachine.new do |rm|
        rm.token(:a, "a?")
        rm.token(:b, "b+")
        rm.token(:c, "c*")
        rm.token(:d, "d{2,4}")
      end

      tokens = m.scan("aadddccddddddbbabc")
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
      m = Acorn::RuntimeMachine.new do |rm|
        rm.token(:sm, "0*0-2")
        rm.token(:md, "3|4")
        rm.token(:lg, "6-7+")
        rm.token(:xl, "[89]*")
      end
      tokens = m.scan("340026670119988")
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
      m = Acorn::RuntimeMachine.new do |rm|
        rm.token(:a, ".a")
        # TODO: this goes infinite
        # rm.token :a, "a.."
        rm.token(:b, "b.*c")
        rm.token(:c, "c*")
        rm.token(:d, "d.{2}")
      end

      tokens = m.scan("zaccdabzycdccc")
      expected_tokens = [
        {:a, "za"},
        {:c, "cc"},
        {:a, "da"},
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
