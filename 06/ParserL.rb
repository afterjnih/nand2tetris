class ParserL
  def initialize(file_name)
    file = open(file_name)
    lines_without_blank_and_comment =
    file.readlines.reject do |line|
      line[0..1].include?('//') || line.strip.empty?
    end
    @commands = lines_without_blank_and_comment.map do |line|
      line.gsub(' ', '').strip
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
    @current_command.chr == '@' ? 'A_COMMAND' : 'C_COMMAND'
  end

  def symbol
    @current_command.chomp[1..-1]
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
end
