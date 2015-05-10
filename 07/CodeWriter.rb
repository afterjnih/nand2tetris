class CodeWriter
  def initialize(file_name)
    @asm_file = File.open(file_name, 'w')
    @i = 0
  end

  def setFileName(fileName)

  end

  def writeArithmetic(command)
    case command
    when 'add'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      @asm_file.puts 'D=M+D'
      @asm_file.puts '@SP'
      @asm_file.puts 'M=M-1'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=D'
    when 'sub'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      @asm_file.puts 'D=M-D'
      @asm_file.puts '@SP'
      @asm_file.puts 'M=M-1'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=D'
    when 'neg'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=-M'
    when 'eq'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      @asm_file.puts 'D=M-D'
      @asm_file.puts '@TRUE' + @i.to_s
      @asm_file.puts 'D;JEQ'
      @asm_file.puts '@FALSE' + @i.to_s
      @asm_file.puts '0;JMP'
      end_line
    when 'gt'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      @asm_file.puts 'D=M-D'
      @asm_file.puts '@TRUE' + @i.to_s
      @asm_file.puts 'D;JGT'
      @asm_file.puts '@FALSE' + @i.to_s
      @asm_file.puts '0;JMP'
      end_line
    when 'lt'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      @asm_file.puts 'D=M-D'
      @asm_file.puts '@TRUE' + @i.to_s
      @asm_file.puts 'D;JLT'
      @asm_file.puts '@FALSE' + @i.to_s
      @asm_file.puts '0;JMP'
      end_line
    when 'and'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      @asm_file.puts 'D=M&D'
      @asm_file.puts '@SP'
      @asm_file.puts 'M=M-1'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=D'
    when 'or'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      @asm_file.puts 'D=M|D'
      @asm_file.puts '@SP'
      @asm_file.puts 'M=M-1'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=D'
    when 'not'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=!M'
    end
  end

  def writePushPop(command, segment, index)
    @asm_file.puts '@' + index.to_s
    @asm_file.puts 'D=A'
    @asm_file.puts '@SP'
    @asm_file.puts 'A=M'
    @asm_file.puts 'M=D'
    @asm_file.puts '@SP'
    @asm_file.puts 'M=M+1'
  end

  def end_line
    @asm_file.puts '(TRUE' + @i.to_s + ')'
    @asm_file.puts '@SP'
    @asm_file.puts 'M=M-1'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'M=-1'
    @asm_file.puts '@END' + @i.to_s
    @asm_file.puts '0;JMP'
    
    @asm_file.puts '(FALSE' + @i.to_s + ')'
    @asm_file.puts '@SP'
    @asm_file.puts 'M=M-1'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'M=0'

    @asm_file.puts '(END' + @i.to_s + ')'
    @i += 1
  end

  def close
    @asm_file.close
  end
end
