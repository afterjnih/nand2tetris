class Parser
  def initialize(file_name)
    p file_name
    file = open(file_name)
    lines_without_blank_and_comment =
    file.readlines.reject do |line|
      line[0..1].include?('//') || line.strip.empty?
    end
    @commands = lines_without_blank_and_comment.map do |line|
      tmp_line = line.strip
      slash_index = tmp_line.index('//')
      slash_index.nil? ? tmp_line : tmp_line[0...slash_index]
    end
    @command_length = @commands.length
    @current_command_number = 0
    @current_command = nil
  end

  def hasMoreCommands
    !(@current_command_number == @command_length)
  end

  def advance
    @current_command = @commands[@current_command_number]
    @current_command_number += 1
  end

  def commandType
    case @current_command.split(nil)[0]
    when 'add', 'sub', 'neg', 'eq',
         'gt', 'lt', 'and', 'or', 'not'
      'C_ARITHMETIC'
    when 'push'
      'C_PUSH'
    when 'pop'
      'C_POP'
    when 'label'
      'C_LABEL'
    when 'goto'
      'C_GOTO'
    when 'if-goto'
      'C_IF'
    when 'function'
      'C_FUNCTION'
    when 'return'
      'C_RETURN'
    when 'call'
      'C_CALL'
    end
  end

  def arg1
    if commandType == 'C_ARITHMETIC'
      @current_command.split(nil)[0]
    else
      @current_command.split(nil)[1]
    end
  end

  def arg2
    @current_command.split(nil)[2].to_i
  end
end
