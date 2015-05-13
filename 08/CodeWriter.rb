class CodeWriter
  def initialize(file_name)
    @asm_file = File.open(file_name, 'w')
    @i = 0
  end

  def setFileName(file_name)
    @asm_file_name = file_name
  end

  def calc(command)
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'D=M' # M[@SP-1]
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'A=A-1'
      if command == 'add'
        @asm_file.puts 'D=M+D'
      else command == 'sub'
        @asm_file.puts 'D=M-D'
      end
      @asm_file.puts '@SP'
      @asm_file.puts 'M=M-1'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=D'
  end

  def compare(command)
    @asm_file.puts '@SP'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'D=M' # M[@SP-1]
    @asm_file.puts '@SP'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'A=A-1'
    @asm_file.puts 'D=M-D'
    @asm_file.puts '@TRUE' + @i.to_s
    if command == 'eq'
      @asm_file.puts 'D;JEQ'
    elsif command == 'gt'
      @asm_file.puts 'D;JGT'
    elsif command == 'lt'
      @asm_file.puts 'D;JLT'
    end
    @asm_file.puts '@FALSE' + @i.to_s
    @asm_file.puts '0;JMP'
    end_line
  end

  def logical_operation(command)
    @asm_file.puts '@SP'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'D=M' # M[@SP-1]
    @asm_file.puts '@SP'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'A=A-1'
    if command == 'and'
      @asm_file.puts 'D=M&D'
    elsif command == 'or'
      @asm_file.puts 'D=M|D'
    end
    @asm_file.puts '@SP'
    @asm_file.puts 'M=M-1'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'M=D'
  end

  def writeArithmetic(command)
    case command
    when 'add', 'sub'
      calc(command)
    when 'neg'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=-M'
    when 'eq', 'gt', 'lt'
      compare(command)
    when 'and', 'or'
      logical_operation(command)
    when 'not'
      @asm_file.puts '@SP'
      @asm_file.puts 'A=M-1'
      @asm_file.puts 'M=!M'
    end
  end

  def push_on_stack
    @asm_file.puts '@SP'
    @asm_file.puts 'A=M'
    @asm_file.puts 'M=D'
    @asm_file.puts '@SP'
    @asm_file.puts 'M=M+1'
  end

  def push_to_stack_from(segment, index)
    case segment
    when 'local'
      @asm_file.puts '@LCL'
    when 'argument'
      @asm_file.puts '@ARG'
    when 'this'
      @asm_file.puts '@THIS'
    when 'that'
      @asm_file.puts '@THAT'
    end
    @asm_file.puts 'D=M'
    @asm_file.puts '@' + index.to_s
    @asm_file.puts 'A=D+A'
    @asm_file.puts 'D=M'
    push_on_stack
  end

  def pop
    @asm_file.puts '@SP'
    @asm_file.puts 'A=M-1'
    @asm_file.puts 'D=M'
  end

  def pop_from_stack_to(segment, index)
    pop

    @asm_file.puts '@R13'
    @asm_file.puts 'M=D'

    case segment
    when 'local'
      @asm_file.puts '@LCL'
    when 'argument'
      @asm_file.puts '@ARG'
    when 'this'
      @asm_file.puts '@THIS'
    when 'that'
      @asm_file.puts '@THAT'
    end
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
  end

  def writePushPop(command, segment, index)
    if command ==  'C_PUSH'
      case segment
      when 'constant'
        @asm_file.puts '@' + index.to_s
        @asm_file.puts 'D=A'
        push_on_stack
      when 'local', 'argument', 'this', 'that'
        push_to_stack_from(segment, index)
      when 'pointer'
        @asm_file.puts '@R' + (3 + index).to_s
        @asm_file.puts 'D=M'
        push_on_stack
      when 'temp'
        @asm_file.puts '@R' + (5 + index).to_s
        @asm_file.puts 'D=M'
        push_on_stack
      when 'static'
        @asm_file.puts '@' + @asm_file_name + '.' + index.to_s
        # @asm_file.puts '@' + (16 + index).to_s
        @asm_file.puts 'D=M'
        push_on_stack
      end
    elsif command == 'C_POP'
      case segment
      when 'constant'
      when 'local', 'argument', 'this', 'that'
        pop_from_stack_to(segment, index)
      when 'pointer'
        pop
        if index == 0
          @asm_file.puts '@THIS'
          @asm_file.puts 'M=D'
        else
          @asm_file.puts '@THAT'
          @asm_file.puts 'M=D'
        end
        @asm_file.puts '@SP'
        @asm_file.puts 'A=M-1'
        @asm_file.puts 'D=M'

        @asm_file.puts '@R' + (5 + index).to_s
        @asm_file.puts 'M=D'

        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'
      when 'temp'
        pop
        @asm_file.puts '@R' + (5 + index).to_s
        @asm_file.puts 'M=D'
        @asm_file.puts '@SP'
        @asm_file.puts 'M=M-1'
      when 'static'
        pop
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

  def writeLabel(label)
    @asm_file.puts '(' + label + ')'
  end

  def writeGoto(label)
    @asm_file.puts '@' + label
    @asm_file.puts '0;JMP'
  end

  def writeIf(label)
    pop
    @asm_file.puts '@SP'
    @asm_file.puts 'M=M-1'
    @asm_file.puts '@' + label
    @asm_file.puts 'D;JNE'
  end

  def writeCall(functionName, numArgs)
    @asm_file.puts '@return_address_' + n.to_s
    @asm_file.puts 'D=A+1'
    push_on_stack
    @asm_file.puts '@LCL'
    @asm_file.puts 'D=M'
    push_on_stack
    @asm_file.puts '@ARG'
    @asm_file.puts 'D=M'
    push_on_stack
    @asm_file.puts '@THIS'
    @asm_file.puts 'D=M'
    push_on_stack
    @asm_file.puts '@THAT'
    @asm_file.puts 'D=M'
    push_on_stack
    @asm_file.puts '@SP'
    @asm_file.puts 'D=M'
    @asm_file.puts '@LCL'
    @asm_file.puts 'M=D'
    @asm_file.puts '@5'
    @asm_file.puts 'D=D-A'
    @asm_file.puts '@ARG'
    @asm_file.puts 'M=D'
    @asm_file.puts '@' + functionName
    @asm_file.puts '0;JMP'
    @asm_file.puts '(return_address_' + n.to_s + ')'
  end

  def writeReturn
    @asm_file.puts '@LCL'
    @asm_file.puts 'D=M'
    @asm_file.puts '@R13' #FRAME
    @asm_file.puts 'M=D'
    @asm_file.puts '@5'
    @asm_file.puts 'A=D-A'
    @asm_file.puts 'D=M'
    @asm_file.puts '@R14' #RET
    @asm_file.puts 'M=D'

    pop
    @asm_file.puts '@ARG'
    @asm_file.puts 'A=M'
    @asm_file.puts 'M=D'

    @asm_file.puts '@ARG'
    @asm_file.puts 'D=M+1'
    @asm_file.puts '@SP'
    @asm_file.puts 'M=D'
    @asm_file.puts '@13'
    @asm_file.puts 'D=M'
    @asm_file.puts '@1'
    @asm_file.puts 'A=D-A'
    @asm_file.puts 'D=M'
    @asm_file.puts '@THAT'
    @asm_file.puts 'M=D'
    @asm_file.puts '@13'
    @asm_file.puts 'D=M'
    @asm_file.puts '@2'
    @asm_file.puts 'A=D-A'
    @asm_file.puts 'D=M'
    @asm_file.puts '@THIS'
    @asm_file.puts 'M=D'
    @asm_file.puts '@13'
    @asm_file.puts 'D=M'
    @asm_file.puts '@3'
    @asm_file.puts 'A=D-A'
    @asm_file.puts 'D=M'
    @asm_file.puts '@ARG'
    @asm_file.puts 'M=D'
    @asm_file.puts '@13'
    @asm_file.puts 'D=M'
    @asm_file.puts '@4'
    @asm_file.puts 'A=D-A'
    @asm_file.puts 'D=M'
    @asm_file.puts '@LCL'
    @asm_file.puts 'M=D'

    @asm_file.puts '@R14'
    @asm_file.puts 'A=M'
    @asm_file.puts '0;JMP'
  end

  def writeFunction(functionName, numLocals)
    writeLabel(functionName)
    numLocals.times do
      @asm_file.puts 'D=0'
      push_on_stack
    end
  end

  def close
    @asm_file.close
  end
end
