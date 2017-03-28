require "./acorn/*"

module Acorn
  # Generate a grammar according to the block and return it.
  # If an outfile is provided, write the crystal code to that file.
  def self.grammar(outfile : String | Nil = nil )
    grammar = Acorn::Grammar.new
    yield(grammar)
    crystal_code = "" # Acorn::Grammar::Codegen.generate(grammar)
    if outfile
      puts "Grammar -> #{outfile}"
      File.write(outfile, crystal_code)
    end
    grammar
  end
end
