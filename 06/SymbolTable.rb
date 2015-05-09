class SymbolTable
  def initialize
    @symbol_table = {}
    (0..15).each do |n|
      addEntry("R#{n}", n)
    end
    addEntry('SP', 0)
    addEntry('LCL', 1)
    addEntry('ARG', 2)
    addEntry('THIS', 3)
    addEntry('THAT', 4)
    addEntry('SCREEN', 16384)
    addEntry('KBD', 24576)
  end

  def addEntry(symbol, address)
    @symbol_table.update({symbol.intern => address})
  end

  def contains(symbol)
    @symbol_table.key?(symbol.intern)
  end

  def getAdress(symbol)
    @symbol_table[symbol.intern]
  end
end
