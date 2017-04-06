require "../spec_helper"

def pattern_parse_one(string)
  pattern_parse_many(string, 1).first.as(Acorn::CharPattern)
end

def pattern_parse_one_either(string)
  pattern_parse_many(string, 1).first.as(Acorn::EitherPattern)
end

def pattern_parse_one_range(string)
  pattern_parse_many(string, 1).first.as(Acorn::RangePattern)
end

def pattern_parse_one_any(string)
  pattern_parse_many(string, 1).first.as(Acorn::AnyPattern)
end

def pattern_parse_many(string, expected)
  patterns = Acorn::Pattern.parse(string)
  if patterns.size == expected
    patterns
  else
    raise "Expected #{expected}, got #{patterns.size} (#{patterns.map(&.to_debug)})"
  end
end

describe Acorn::Pattern do
  describe "simple patterns" do
    it "handles single characters" do
      pattern = pattern_parse_one("a")
      pattern.matches.should eq(['a'])
      pattern.match.should eq('a')
      pattern.occurrences.should eq(1..1)

      pattern = pattern_parse_one("9")
      pattern.matches.should eq(['9'])
      pattern = pattern_parse_one("Ω")
      pattern.matches.should eq(['Ω'])
    end

    it "unpacks sequences" do
      pattern = pattern_parse_one_range("A-Z")
      pattern.range.should eq('A'..'Z')

      pattern = pattern_parse_one_range("乮-乲")
      pattern.range.should eq('乮'..'乲')
    end

    it "unpacks literal numbers" do
      pattern = pattern_parse_one("👻{2,3}")
      pattern.matches.should eq(['👻'])
      pattern.occurrences.should eq(2..3)

      pattern = pattern_parse_one("a{2,}")
      pattern.occurrences.should eq(2..Int32::MAX)

      pattern = pattern_parse_one("a{,2}")
      pattern.occurrences.should eq(0..2)

      pattern = pattern_parse_one("a{10}")
      pattern.occurrences.should eq(10..10)
    end

    it "unpacks zero-or-ones" do
      pattern = pattern_parse_one("Ꚋ?")
      pattern.matches.should eq(['Ꚋ'])
      pattern.occurrences.should eq(0..1)

      pattern = pattern_parse_one_range("0-3?")
      pattern.range.should eq('0'..'3')
      pattern.occurrences.should eq(0..1)
    end

    it "unpacks one-or-mores" do
      pattern = pattern_parse_one("$+")
      pattern.matches.should eq(['$'])
      pattern.occurrences.should eq(1..Int32::MAX)

      pattern = pattern_parse_one_range("c-f+")
      pattern.range.should eq('c'..'f')
      pattern.occurrences.should eq(1..Int32::MAX)
    end

    it "unpacks zero-or-mores" do
      pattern = pattern_parse_one_range("6-8*")
      pattern.range.should eq('6'..'8')
      pattern.occurrences.should eq(0..Int32::MAX)
    end

    it "unpacks alternation" do
      pattern = pattern_parse_one_either("a|b")
      pattern.left.matches.should eq(['a'])
      pattern.right.matches.should eq(['b'])
      pattern.occurrences.should eq(1..1)

      pattern = pattern_parse_one_either("a|b|c")
      pattern.left.as(Acorn::EitherPattern).left.matches.should eq(['a'])
      pattern.left.as(Acorn::EitherPattern).right.matches.should eq(['b'])
      pattern.right.matches.should eq(['c'])

      pattern = pattern_parse_one_either("a?|0-2{2,}")

      pattern.left.matches.should eq(['a'])
      pattern.left.occurrences.should eq(0..1)

      pattern.right.as(Acorn::RangePattern).range.should eq('0'..'2')
      pattern.right.occurrences.should eq(2..Int32::MAX)

      pattern.occurrences.should eq(1..1)
    end

    it "handles escapes" do
      pattern = pattern_parse_one("\\0")
      pattern.matches.should eq(['0'])
      pattern.occurrences.should eq(1..1)

      pattern = pattern_parse_one("\\*")
      pattern.matches.should eq(['*'])
      pattern.occurrences.should eq(1..1)

      pattern = pattern_parse_one("\\+")
      pattern.matches.should eq(['+'])

      pattern = pattern_parse_one("\\?")
      pattern.matches.should eq(['?'])

      pattern = pattern_parse_one("\\\\")
      pattern.matches.should eq(['\\'])

      pattern = pattern_parse_one("\\-")
      pattern.matches.should eq(['-'])
    end

    it "handles one-of" do
      pattern = pattern_parse_one_either("[abc]+")
      pattern.occurrences.should eq(1..Int32::MAX)
      pattern.left.matches.should eq(['a', 'b'])
      pattern.left.occurrences.should eq(1..1)

      pattern.right.matches.should eq(['c'])
      pattern.right.occurrences.should eq(1..1)
    end

    it "unpacks anys" do
      pattern = pattern_parse_one_any(".+")
      pattern.occurrences.should eq(1..Int32::MAX)
    end
  end

  describe "sequence" do
    it "gets sequences" do
      patterns = pattern_parse_many("謝謝你", 3)
      matches = patterns.map(&.matches)
      matches.should eq([['謝'], ['謝'],['你']])
      occurrences = patterns.map(&.occurrences)
      occurrences.should eq([1..1, 1..1, 1..1])
    end

    it "gets sequences with operators" do
      patterns = pattern_parse_many("謝謝你?", 3)
      matches = patterns.map(&.matches)
      matches.should eq([['謝'], ['謝'],['你']])

      patterns = pattern_parse_many("謝?謝|你", 2)
      matches = patterns.map(&.matches)
      matches.should eq([['謝'], ['謝', '你']])
    end
  end

  describe "grouping" do
    pending "applies implicit groups" do
      # a+|b
      # 0?|1
    end

    pending "applies explicit groups" do
      # c?|(ab)
    end
  end

  describe "errors" do
    pending "errors on unsatisfied repetition" do
      # ?, +, *
    end

    it "errors on unmatched infixes" do
      # |, -
    end

    it "errors on unmatched parens etc" do
      # {, [, (
    end
  end
end
