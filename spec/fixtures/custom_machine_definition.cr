require "../../src/acorn"

module CustomMachineDefinition
  include Acorn::Macros
  machine "CustomMachine"
  accumulator "Array(Tuple(Int32, Int32))"
  action :letter, "a-z" { |acc, str, ts, te| acc << {ts, te} }
  generate("./spec/fixtures/custom_machine.cr")
end
