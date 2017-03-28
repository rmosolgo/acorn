require "./spec_helper"

describe Acorn do
  it "creates a grammar" do
    g = Acorn.grammar { }
    g.should be_a(Acorn::Grammar)
  end
end
