class VMWriter
  def initialize(vm_file)
    @vm_file = vm_file 
  end
 
  def writeFunction(name, nArgs)
    @vm_file.puts "function #{name} #{nArgs}" 
  end
 
  def writePush(segment, index)
    @vm_file.puts "push #{segment} #{index}"
  end
 
  def writeArithmetic(command)
    case command
    when '+'
      @vm_file.puts "add"
# ADD
# SUB
# NEG
# EQ
# GT
# LT
# AND
# OR
# NOT
    end
  end
 
  def writeCall(name, nArgs)
    @vm_file.puts "call #{name} #{nArgs}"
  end

  def writeReturn
    @vm_file.puts 'return'
  end
end

