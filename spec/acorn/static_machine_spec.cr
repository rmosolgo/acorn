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
    rendered_transitions = normalize_code "
    TABLE = {
      0 => { '0' => 1, '1' => 2, 'a' => 3, 'b' => 4, },
      1 => { :epsilon => 0, },
      2 => { :epsilon => 0, },
      3 => { :epsilon => 0, },
      4 => { :epsilon => 0, },
    }"
    normalized_crystal_code.should contain(rendered_transitions)

    rendered_actions = normalize_code "
    ACTIONS = {
      1 => Action.new { |acc, str, ts, te| acc << {:num, str[ts..te]} },
      2 => Action.new { |acc, str, ts, te| acc << {:num, str[ts..te]} },
      3 => Action.new { |acc, str, ts, te| acc << {:let, str[ts..te]} },
      4 => Action.new { |acc, str, ts, te| acc << {:let, str[ts..te]} },
    }
    "
    normalized_crystal_code.should contain(rendered_actions)
  end

  describe "error handling" do
    # TODO: Acorn isn't available here
    pending "handles unexpected inputs" { }
    pending "handles unexpected end" { }
  end
end
