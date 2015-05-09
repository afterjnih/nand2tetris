class Parser
  def initialize(file_name)
    file = open(file_name)
    lines_without_blank_and_comment =
    file.readlines.reject do |line|
      line[0..1].include?('//') || line.strip.empty?
    end
    @commands = lines_without_blank_and_comment.map do |line|
      tmp_line = line.gsub(' ', '').strip
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
    case @current_command.chr
    when '@'
      'A_COMMAND'
    when '('
      'L_COMMAND'
    else
      'C_COMMAND'
    end
  end

  def symbol
    if @current_command.chr == '@'
      @current_command[1..-1]
    else
      @current_command[1...-1]
    end
  end

  def dest
    pos_of_equal = @current_command.index('=')
    if pos_of_equal.nil?
      'null'
    else
      @current_command[0..pos_of_equal - 1]
    end
  end

  def comp
    pos_of_equal = @current_command.index('=')
    pos_of_semicolon = @current_command.index(';')
    if pos_of_equal.nil? && pos_of_semicolon.nil?
      @current_command
    elsif !pos_of_equal.nil? && pos_of_semicolon.nil?
      @current_command[(pos_of_equal + 1)..-1]
    elsif pos_of_equal.nil? && !pos_of_semicolon.nil?
      @current_command[0...(pos_of_semicolon)]
    else
      @current_command[(pos_of_equal + 1)...(pos_of_semicolon)]
    end
  end

  def jump
    pos_of_semicolon = @current_command.index(';')
    if pos_of_semicolon.nil?
      'null'
    else
      @current_command[(pos_of_semicolon + 1)..-1]
    end
  end

  def rewind
    @current_command_number = 0
    @current_command = nil
  end
end
