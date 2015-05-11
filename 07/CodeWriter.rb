class CodeWriter
  def initialize(file_name)
    @asm_file = File.open(file_name, 'w')
    @i = 0
  end

  def setFileName(file_name)
    @asm_file_name = file_name
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
    if command ==  'C_PUSH'
      case segment
      when 'constant'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'D=A'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      when 'local'
        @asm_file.puts '@LCL'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'A=D+A'
        @asm_file.puts 'D=M'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      when 'argument'
        @asm_file.puts '@ARG'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'A=D+A'
        @asm_file.puts 'D=M'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      when 'this'
        @asm_file.puts '@THIS'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'A=D+A'
        @asm_file.puts 'D=M'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      when 'that'
        @asm_file.puts '@THAT'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'A=D+A'
        @asm_file.puts 'D=M'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      when 'pointer'
        @asm_file.puts '@R' + (3 + index).to_s
        @asm_file.puts 'D=M'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      when 'temp'
        @asm_file.puts '@R' + (5 + index).to_s
        @asm_file.puts 'D=M'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      when 'static'
        @asm_file.puts '@' + @asm_file_name + '.' + index.to_s
        # @asm_file.puts '@' + (16 + index).to_s
        @asm_file.puts 'D=M'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M+1'
      end
    else
      case segment
      when 'constant'
      when 'local'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=D'

        @asm_file.puts '@LCL'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'D=D+A'

        @asm_file.puts '@R14'
        @asm_file.puts 'M=D'

        @asm_file.puts '@R13'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R14'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'

        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=0'
        @asm_file.puts '@R14'
        @asm_file.puts 'M=0'
      when 'argument'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=D'

        @asm_file.puts '@ARG'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'D=D+A'

        @asm_file.puts '@R14'
        @asm_file.puts 'M=D'

        @asm_file.puts '@R13'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R14'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'

        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=0'
        @asm_file.puts '@R14'
        @asm_file.puts 'M=0'
      when 'this'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=D'

        @asm_file.puts '@THIS'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'D=D+A'

        @asm_file.puts '@R14'
        @asm_file.puts 'M=D'

        @asm_file.puts '@R13'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R14'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'

        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=0'
        @asm_file.puts '@R14'
        @asm_file.puts 'M=0'
      when 'that'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=D'

        @asm_file.puts '@THAT'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'D=D+A'

        @asm_file.puts '@R14'
        @asm_file.puts 'M=D'

        @asm_file.puts '@R13'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R14'
        @asm_file.puts 'A=M'
        @asm_file.puts 'M=D'

        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'

        @asm_file.puts '@R13'
        @asm_file.puts 'M=0'
        @asm_file.puts '@R14'
        @asm_file.puts 'M=0'
      when 'pointer'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'
        if index == 0
          @asm_file.puts '@THIS'
          @asm_file.puts 'M=D'
        else
          @asm_file.puts '@THAT'
          @asm_file.puts 'M=D'
        end
        @asm_file.puts '@SP'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R' + (5 + index).to_s
        @asm_file.puts 'M=D'

        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'
      when 'temp'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'
        @asm_file.puts '@R' + (5 + index).to_s
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'
      when 'static'
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'
        @asm_file.puts '@' + @asm_file_name + '.' + index.to_s
        # @asm_file.puts '@' + (16 + index).to_s
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'
      end
    end
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
