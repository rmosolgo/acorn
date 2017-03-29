module Acorn
  module Macros
    macro included
      @@_acorn_machine = Acorn::StaticMachine.new
    end

    macro machine(name)
      @@_acorn_machine.name = {{ name }}
    end

    macro token(symbol, pattern)
      @@_acorn_machine.token({{symbol}}, {{pattern}})
    end

    macro action(symbol, pattern, &block)
      @@_acorn_machine.action({{symbol}}, {{pattern}}, "{ |{{block.args.join(",").id}}| {{block.body}} }")
    end

    macro accumulator(acc_name)
      @@_acorn_machine.accumulator = {{ acc_name }}
    end

    macro generate(outfile)
      File.write({{ outfile }}, @@_acorn_machine.to_s)
    end
  end
end
