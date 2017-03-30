require "./static_machine"

module Acorn
  class Machine
    macro inherited
      @@_acorn_machine = Acorn::StaticMachine.new
      @@_acorn_machine.name = "{{ @type.name }}"
    end

    macro machine(name)
      @@_acorn_machine.name = {{ name }}
    end

    macro action(symbol, pattern, &block)
      @@_acorn_machine.action({{symbol}}, {{pattern}}, "{ |{{block.args.join(",").id}}| {{block.body}} }")
    end

    macro accumulator(acc_name)
      @@_acorn_machine.accumulator = {{ acc_name }}
    end

    macro generate(outfile)
      @@_acorn_machine.to_outfile({{ outfile }})
    end
  end
end
