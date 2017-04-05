require "./error"

module Acorn
  # Raised when we reach the end of a string but
  # we aren't in a finishing state of the machine.
  #
  # Duplicated in static_machine/template.cr.
  class UnexpectedEndError < Acorn::Error
    getter position
    def initialize(position : Int32)
      @position = position
      super("Unexpected EOS")
    end
  end
end
