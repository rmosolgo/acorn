require "../spec_helper"

def expect_tokens(machine, str, exp_tokens)
  tokens = machine.scan(str)
  tokens.should eq(exp_tokens)
end

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

      expect_tokens(m, "zaccdacbzycdccc", [
        {:a, "za"},
        {:c, "cc"},
        {:d, "dac"},
        {:b, "bzyc"},
        {:d, "dcc"},
        {:c, "c"}
      ])
    end

    it "handles ambiguous any-char" do
      m = Acorn::RuntimeMachine.new do |r|
        r.token(:a, "aa")
        r.token(:b, "a.a")
      end

      expect_tokens(m, "aaa", [{:b, "aaa"}])
    end
  end

  describe "errors" do
    it "handles unexpected characters" do
      m = Acorn::RuntimeMachine.new do |r|
        r.token(:a, "a")
        r.token(:b, "b")
      end

      err = expect_raises(Acorn::UnexpectedInputError) do
        m.scan("abc")
      end

      err.message.should eq("Unexpected input: 'c'")
      err.position.should eq(2)
    end
    pending "handles unexpected end" { }
  end
end
