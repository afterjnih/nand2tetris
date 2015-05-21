class JackTokenizer
  def initialize(file_name)
    File.open(file_name) do |file|
      string_flag = false
      slash_comment_flag = 0
      @tokens = []
      tmp_token = ''
      file.each_char do |char|
        if string_flag == true
          tmp_token << char
          if char == '"'
            @tokens << tmp_token
            tmp_token = ''
            string_flag = false
          end
        elsif slash_comment_flag == 2
          slash_comment_flag = 0 if char == "\n" || char == "\r"
        elsif slash_comment_flag == 3
          slash_comment_flag += 1 if char == '*'
        elsif slash_comment_flag == 4
          if char == '/'
            slash_comment_flag = 0
          else
            slash_comment_flag = 3
          end
        else
          case char
          when ' ', "\t", "\n", "\r"
            unless tmp_token.empty?
              @tokens << tmp_token
              tmp_token = ''
            end

            if slash_comment_flag == 1
              @tokens << '/'
              slash_comment_flag = 0
            end
          when '{', '}', '(', ')', '[', ']', '.', ',', ';', '+', '-', '&', '|', '<', '>', '=', '~'
            unless tmp_token.empty?
              @tokens << tmp_token
              tmp_token = ''
            end

            if slash_comment_flag == 1
              @tokens << '/'
              slash_comment_flag = 0
            end
            @tokens << char
          when '/'
            unless tmp_token.empty?
              @tokens << tmp_token
              tmp_token = ''
            end
            slash_comment_flag += 1
          when '*'
            unless tmp_token.empty?
              @tokens << tmp_token
              tmp_token = ''
            end
            slash_comment_flag = 3 if slash_comment_flag == 1
          when '"'
            slash_comment_flag = 0
            tmp_token << char
            string_flag = true
          else
            slash_comment_flag = 0
            tmp_token << char
          end
        end
      end
    end
    p @tokens
    @token_length = @tokens.length
    @current_token_number = 0
    @current_token = @tokens[@current_token_number]
  end

  def hasMoreToken
    !(@current_token_number == @token_length)
  end

  def advance
    @current_token_number += 1
    @current_token = @tokens[@current_token_number]
  end

  def tokenType
    def integer_string?(str)
      Integer(str)
      true
    rescue ArgumentError
      false
    end
# p @current_token
    if @current_token[0] == '"' && @current_token[-1] == '"' 
      return 'STRING_CONST'
    elsif integer_string?(@current_token)
      return 'INT_CONST'
    else
      case @current_token
      when 'class', 'constructor', 'function', 'method', 'field', 'static', 'var', 'int', 'char', 'boolean', 'void', 'true', 'false', 'null', 'this', 'let', 'do', 'if', 'else', 'while', 'return'
        return 'KEYWORD'
      when '{', '}', '(', ')', '[', ']', '.', ',', ';', '+', '-', '*', '/', '&', '|', '<', '>', '=', '~'
        return 'SYMBOL'
      else
        return 'IDENTIFIER'
      end
    end
  end

  def keyWord
    @current_token
  end

  def symbol
    @current_token
  end

  def identifier
    @current_token
  end

  def intVal
    @current_token.to_i
  end

  def stringVal
    @current_token[1..-2]
  end
end
