class VMWriter
  def initialize(vm_file)
    @vm_file = vm_file 
  end
 
  def writeFunction(name, nLocals)
    @vm_file.puts "function #{name} #{nLocals}" 
  end
 
  def writePush(segment, index)
    @vm_file.puts "push #{segment} #{index}"
  end

  def writePop(segment, index)
    @vm_file.puts "pop #{segment} #{index}"
  end
 
  def writeArithmetic(command)
    case command
    when '+'
      @vm_file.puts 'add'
    when '-'
      @vm_file.puts 'sub'
    when '<'
      @vm_file.puts 'lt'
    when '='
      @vm_file.puts 'eq'
    when '>'
      @vm_file.puts 'gt'
    when '&'
      @vm_file.puts 'and'
    when '|'
      @vm_file.puts 'or'
    when '~'
      @vm_file.puts 'not'
    when 'NEG'
      @vm_file.puts 'neg'
    end
  end

  def writeLabel(label)
    @vm_file.puts "label #{label}"
  end

  def writeGoto(label)
    @vm_file.puts "goto #{label}"
  end

  def writeIf(label)
    @vm_file.puts "if-goto #{label}"
  end
 
  def writeCall(name, nArgs)
    @vm_file.puts "call #{name} #{nArgs}"
  end

  def writeReturn
    @vm_file.puts 'return'
  end
end

