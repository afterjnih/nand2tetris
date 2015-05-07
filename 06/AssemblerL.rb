require './ParserL'
require './CodeL'

File.open("#{ARGV[0].split('.')[0]}.hack", 'w') do |hack_file|
  asm_file = ParserL.new(ARGV[0])
  while asm_file.hasMoreCommands
    asm_file.advance
    if asm_file.commandType == 'A_COMMAND'
      hack_file.puts asm_file.symbol.to_i.to_s(2).rjust(16, '0')
    else
      hack_file.print "111"
      hack_file.print CodeL.comp(asm_file.comp)
      hack_file.print CodeL.dest(asm_file.dest)
      hack_file.puts CodeL.jump(asm_file.jump)
    end
  end
end
