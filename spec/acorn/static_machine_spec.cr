require "../spec_helper"

def normalize_code(code)
  code.gsub(/\s/, "")
end

describe Acorn::StaticMachine do
  it "generates output" do
    machine = Acorn::StaticMachine.new
    machine.token(:num, "0-1")
    machine.token(:let, "a-b")
    machine.name = "My::Grammar"
    crystal_code = machine.to_s
    crystal_code.should contain("module My::Grammar")
    normalized_crystal_code = normalize_code(crystal_code)
    rendered_transitions = normalize_code "TABLE = {"
    normalized_crystal_code.should contain(rendered_transitions)
    rendered_actions = normalize_code "ACTIONS = {"
    normalized_crystal_code.should contain(rendered_actions)
  end

  describe "error handling" do
    # TODO: Acorn isn't available here
    it "handles unexpected inputs" do
      err = expect_raises(NumbersAndLetters::UnexpectedInputError) {
        NumbersAndLetters.scan("ab&123")
      }
      err.message.should eq("Unexpected input: '&'")
      err.position.should eq(2)
    end

    it "handles unexpected end" do
      err = expect_raises(NumbersAndLetters::UnexpectedEndError) {
        NumbersAndLetters.scan("aaa1")
      }
      err.message.should eq("Unexpected EOS")
      err.position.should eq(4)
    end
  end
end
