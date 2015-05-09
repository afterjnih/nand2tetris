require './Parser'
require './Code'
require './SymbolTable'

def integer_string?(str)
  Integer(str)
  true
rescue ArgumentError
  false
end

File.open("#{ARGV[0].split('.')[0]}.hack", 'w') do |hack_file|
  asm_file = Parser.new(ARGV[0])
  symbol_table = SymbolTable.new

  rom_number = 0
  while asm_file.hasMoreCommands
    asm_file.advance
    if asm_file.commandType == 'L_COMMAND'
      symbol_table.addEntry(asm_file.symbol, rom_number)
    else
      rom_number += 1
    end
  end

  asm_file.rewind
  n = 16

  while asm_file.hasMoreCommands
    asm_file.advance
    symbol = asm_file.symbol
    if asm_file.commandType == 'A_COMMAND'
      if !integer_string?(symbol)
        if symbol_table.contains(symbol)
          hack_file.puts symbol_table.getAdress(symbol).to_i.to_s(2).rjust(16, '0')
        else
          symbol_table.addEntry(symbol, n)
          hack_file.puts n.to_s(2).rjust(16, '0')
          n += 1
        end
      else
        hack_file.puts asm_file.symbol.to_i.to_s(2).rjust(16, '0')
      end
    elsif asm_file.commandType == 'C_COMMAND'
      hack_file.print "111"
      hack_file.print Code.comp(asm_file.comp)
      hack_file.print Code.dest(asm_file.dest)
      hack_file.puts Code.jump(asm_file.jump)

      # print "111"
      # print Code.comp(asm_file.comp)
      # print Code.dest(asm_file.dest)
      # puts Code.jump(asm_file.jump)
    end
  end
end
