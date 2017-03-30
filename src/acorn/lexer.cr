require "./machine"

module Acorn
  class Lexer < Acorn::Machine
    macro inherited
      @@_acorn_machine.name = "{{ @type.name }}"
    end

    macro token(symbol, pattern)
      @@_acorn_machine.token({{symbol}}, {{pattern}})
    end
  end
end
