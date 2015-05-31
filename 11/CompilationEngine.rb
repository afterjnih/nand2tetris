require './SymbolTable'
require './VMWriter'
 
class CompilationEngine
 
  def initialize(tokens, output)
    @tokens = tokens
    @identifier_tokens = Marshal.load(Marshal.dump(@tokens.clone))
#    @output = output
    @symbol_table = SymbolTable.new
    @vm_writer = VMWriter.new(output)
    @name = nil
    @while_number = -1
    @if_number = -1
    # @return_var = nil
    @class_name = nil
  end
 
  def puts_keyword
    @tokens.advance
  end
 
  def puts_symbol
    @tokens.advance
  end
 
  def puts_integer_constant
    @tokens.advance
  end
 
  def puts_string_constant
    @tokens.advance
  end
 
  def puts_identifier(defined = nil)
#    kind = @symbol_table.kindOf(@tokens.identifier)
#    index = @symbol_table.indexOf(@tokens.identifier) unless kind == 'NONE'
#    name = @tokens.identifier
    @tokens.advance
#    if kind == 'NONE'
#      if @tokens.tokenType == 'SYMBOL' && @tokens.symbol == '('
#        category = 'SUBROUTINE'
#      else
#        category = 'CLASS'
#      end
#    else
#      category = kind
#    end
#    @output.puts '<identifier>'
#    @output.print '<category> '
#    @output.print category
#    @output.puts ' </category>'
#    if kind == 'VAR'
#      @output.print '<defined> '
#      if defined == 'defined'
#        @output.print 'defined'
#      else
#        @output.print 'used'
#      end
#      @output.puts ' </defined>'
#    end
#    unless kind == 'NONE'
#      @output.print '<kind> '
#      @output.print kind 
#      @output.puts ' </kind>'
#      @output.print '<index> '
#      @output.print index 
#      @output.puts ' </index>'
#    end
#    @output.print '<name> '
#    @output.print name 
#    @output.puts ' </name> '
#    @output.puts ' </identifier>'
  end
 
  def compileClass
    type = nil
    kind = nil
    keyword_flag = nil
    while true
      break unless @identifier_tokens.hasMoreToken
      if @identifier_tokens.tokenType == 'KEYWORD'
        break if ['constructor', 'function', 'method'].include?(@identifier_tokens.keyWord)
        if ['static', 'field'].include?(@identifier_tokens.keyWord)
          kind = @identifier_tokens.keyWord.upcase
          keyword_flag = false
        else
          type = @identifier_tokens.keyWord
          keyword_flag = true
        end
      end
 
      if @identifier_tokens.tokenType == 'IDENTIFIER'
        if keyword_flag == true
    if type == 'class'
      @class_name = @identifier_tokens.identifier
    else
      @symbol_table.define(@identifier_tokens.identifier, type, kind)
    end
        else
          type = @identifier_tokens.identifier
          keyword_flag = true
        end
      end
      @identifier_tokens.advance
    end
#    @output.puts '<class>'
    puts_keyword
#    puts_identifier
     @tokens.advance
    puts_symbol
    while @tokens.keyWord == 'static' || @tokens.keyWord == 'field'
      compileClassVarDec
    end
 
    while @tokens.keyWord == 'constructor' || @tokens.keyWord == 'function' || @tokens.keyWord == 'method'
      compileSubroutine
    end
    puts_symbol
#    @output.puts '</class>'
  end
 
  def compileClassVarDec
    # @output.puts '<classVarDec>'
    puts_keyword
    if @tokens.tokenType == 'KEYWORD'
      puts_keyword
    else
      puts_identifier
    end
    puts_identifier
 
    while @tokens.symbol == ','
      puts_symbol
      puts_identifier
    end
 
    puts_symbol
    # @output.puts '</classVarDec>'
  end
 
  def compileSubroutine
    @while_number = -1
    @if_number = -1
    @symbol_table.startSubroutine
    @return_var = nil
    @symbol_table.define('this', @class_name, 'ARG') if @tokens.keyWord == 'method'
    type = nil
    kind = 'ARG'
    arg_register_flag = nil
    var_register_flag = nil
    subroutine_kind_flag = true
    subroutine_type_flag = true
    subroutine_name_flag = true
    while true
      break unless @identifier_tokens.hasMoreToken
      if @identifier_tokens.tokenType == 'KEYWORD'
        if subroutine_kind_flag == true
          subroutine_kind_flag = false
          @identifier_tokens.advance
          next
        end
        if subroutine_type_flag == true
          subroutine_type_flag = false
          @identifier_tokens.advance
          next
        end
        break if ['constructor', 'function', 'method'].include?(@identifier_tokens.keyWord)
        if @identifier_tokens.keyWord == 'var'
          var_register_flag = false
          kind = 'VAR'
        elsif ['let', 'if', 'while', 'do', 'return'].include?(@identifier_tokens.keyWord)
          var_register_flag = false
          kind = nil
        else
          if kind == 'ARG'
            type = @identifier_tokens.keyWord
            arg_register_flag = true
          elsif kind == 'VAR'
            type = @identifier_tokens.keyWord
            var_register_flag = true
          end
        end
      end
 
      if @identifier_tokens.tokenType == 'SYMBOL'
        kind = 'VAR' if @identifier_tokens.symbol == ')' && kind == 'ARG'
        if var_register_flag == true && @identifier_tokens.symbol == ';'
          var_register_flag = false
          kind = nil
        end
      end
 
      if @identifier_tokens.tokenType == 'IDENTIFIER'
        if subroutine_type_flag == true
          subroutine_type_flag = false
          kind = nil unless kind == 'ARG'
          @identifier_tokens.advance
          next
        end
        if subroutine_name_flag == true
          subroutine_name_flag = false
          @identifier_tokens.advance
          next
        end
        if kind == 'ARG'
          if arg_register_flag == true
            @symbol_table.define(@identifier_tokens.identifier, type, kind)
            arg_register_flag = false
          else
            type = @identifier_tokens.identifier
            arg_register_flag = true
          end
          type = @identifier_tokens.identifier
        elsif kind == 'VAR'
          if var_register_flag == true
            @symbol_table.define(@identifier_tokens.identifier, type, kind)
          else
            type = @identifier_tokens.identifier
            var_register_flag = true
          end
        end
      end
 
      @identifier_tokens.advance
    end
 
p @symbol_table
 
#    @output.puts '<subroutineDec>'
    subroutine = @tokens.keyWord
    puts_keyword
#    @tokens.tokenType == 'IDENTIFIER' ? puts_identifier : puts_keyword
    @return_var = 'void' if @tokens.tokenType == 'KEYWORD' && @tokens.keyWord == 'void'
    @tokens.advance
#    puts_identifier
#    @output.puts "function #{@symbol_table.typeOf('this')}.#{@tokens.identifier} #{@symbol_table.varCount('ARG') - 1}"
    @vm_writer.writeFunction(@class_name + '.' + @tokens.identifier, @symbol_table.varCount('VAR'))
    if subroutine == 'constructor'
      @vm_writer.writePush('constant', @symbol_table.varCount('FIELD'))
      @vm_writer.writeCall('Memory.alloc', 1)
      # @vm_writer.writeCall('Memory.alloc', @symbol_table.varCount('FIELD'))
      @vm_writer.writePop('pointer', 0);
    elsif subroutine == 'method'
      @vm_writer.writePush('argument', 0)
      @vm_writer.writePop('pointer', 0)
    end
    @tokens.advance
 
    puts_symbol
    
    compileParameterList
    puts_symbol
 
#    @output.puts '<subroutineBody>'
    puts_symbol
    while @tokens.keyWord == 'var'
      compileVarDec
    end
    compileStatements
    puts_symbol
#    @output.puts '</subroutineBody>'
 
#    @output.puts '</subroutineDec>'
  end
 
  def compileParameterList
#    @output.puts '<parameterList>'
    
    if @tokens.tokenType == 'KEYWORD' || @tokens.tokenType == 'IDENTIFIER'
      if @tokens.tokenType == 'KEYWORD'
        puts_keyword
      elsif @tokens.tokenType == 'IDENTIFIER'
        puts_identifier
      end
      puts_identifier
 
      while @tokens.symbol == ','
        puts_symbol
        if @tokens.tokenType == 'KEYWORD'
          puts_keyword
        elsif @tokens.tokenType == 'IDENTIFIER'
          puts_identifier
        end
        puts_identifier
      end
    end
 
#    @output.puts '</parameterList>'
  end
 
  def compileVarDec
    # @output.puts '<varDec>'
    puts_keyword
    if @tokens.tokenType == 'KEYWORD'
      puts_keyword
    else
      puts_identifier
    end
    puts_identifier('defined')
 
    while @tokens.symbol == ','
      puts_symbol
      puts_identifier('defined')
    end
    puts_symbol
    # @output.puts '</varDec>'
  end
 
  def compileStatements
#    @output.puts '<statements>'
    while @tokens.tokenType == 'KEYWORD'
      case @tokens.keyWord
      when 'let'
        compileLet
      when 'if'
        compileIf
      when 'while'
        compileWhile
      when 'do'
        compileDo
      when 'return'
        compileReturn
      end
    end
#    @output.puts '</statements>'
  end
 
  def compileDo
    nArgs = 0 
#    @output.puts '<doStatement>'
    puts_keyword
 
#    puts_identifier
    @name = @tokens.identifier
    # if (@symbol_table.kindOf(@name) == 'VAR') || (@symbol_table.kindOf(@name) == 'ARG')
    if (@symbol_table.kindOf(@name) == 'VAR')
      @vm_writer.writePush('local', @symbol_table.indexOf(@name))
      method_flag = true
      nArgs += 1
      @name = @symbol_table.typeOf(@name)
    elsif (@symbol_table.kindOf(@name) == 'ARG')
      @vm_writer.writePush('argument', @symbol_table.indexOf(@name))
      method_flag = true
      nArgs += 1
      @name = @symbol_table.typeOf(@name)
    elsif (@symbol_table.kindOf(@name) == 'FIELD')
      @vm_writer.writePush('this', @symbol_table.indexOf(@name))
      method_flag = true
      nArgs += 1
      @name = @symbol_table.typeOf(@name)
    end
    @tokens.advance
 
    if @tokens.symbol == '('
      @name = @class_name + '.' +  @name
      nArgs = 1
      @vm_writer.writePush('pointer', 0)
      puts_symbol
      nArgs += compileExpressionList
      puts_symbol
    else
      puts_symbol
#      puts_identifier
      # @name = @symbol_table.typeOf(@name) + '.' + @tokens.identifier
      @name = @name + '.' + @tokens.identifier
      @tokens.advance
      puts_symbol
      nArgs += compileExpressionList
      puts_symbol
    end
    puts_symbol
    # @vm_writer.writePush('this', 0) if method_flag == true
@vm_writer.writeCall(@name, nArgs)
@vm_writer.writePop('temp', 0)
@name = nil
 
#    @output.puts '</doStatement>'
  end
 
  def compileLet
    # @output.puts '<letStatement>'
    array_flag = false
    puts_keyword
    identifier = @tokens.identifier
    kind = @symbol_table.kindOf(identifier)
    puts_identifier
    if @tokens.tokenType == 'SYMBOL'
      if @tokens.symbol == '['
        array_flag = true
        # @vm_writer.writePush(kind, @symbol_table.indexOf(identifier))
        puts_symbol
        compileExpression
        puts_symbol
        if kind == 'VAR'
          @vm_writer.writePush('local', @symbol_table.indexOf(identifier))
        elsif kind == 'ARG'
          @vm_writer.writePush('argument', @symbol_table.indexOf(identifier))
        elsif kind == 'FIELD'
          @vm_writer.writePush('this', @symbol_table.indexOf(identifier))
        elsif kind == 'STATIC'
          @vm_writer.writePush('static', @symbol_table.indexOf(identifier))
        end
        @vm_writer.writeArithmetic('+')
        # @vm_writer.writePop('pointer', 1)
      end
    end
    puts_symbol # =
    compileExpression
    if array_flag == true
      @vm_writer.writePop('temp', 0)
      @vm_writer.writePop('pointer', 1)
      @vm_writer.writePush('temp', 0)
      @vm_writer.writePop('that', 0)
    else
      if kind == 'ARG'
        @vm_writer.writePop('argument', @symbol_table.indexOf(identifier))
      elsif kind == 'VAR'
        @vm_writer.writePop('local', @symbol_table.indexOf(identifier))
      elsif kind == 'FIELD'
        @vm_writer.writePop('this', @symbol_table.indexOf(identifier))
      elsif kind == 'STATIC'
        @vm_writer.writePop('static', @symbol_table.indexOf(identifier))
      elsif array_flag == true
        @vm_writer.writerPop('that', 0)
      end
    end
    # if kind == 'ARG'
    #   @vm_writer.writePop('argument', @symbol_table.indexOf(identifier))
    # elsif kind == 'VAR'
    #   @vm_writer.writePop('local', @symbol_table.indexOf(identifier))
    # elsif kind == 'FIELD'
    #   @vm_writer.writePop('this', @symbol_table.indexOf(identifier))
    # elsif kind == 'STATIC'
    # elsif array_flag == true
    #   @vm_writer.writerPop('that', 0)
    # end
    puts_symbol
    # @output.puts '</letStatement>'
  end
 
  def compileWhile
    @while_number += 1
    while_number = @while_number
    @vm_writer.writeLabel('WHILE_EXP' + while_number.to_s)
    puts_keyword
    puts_symbol
    compileExpression
    puts_symbol
    @vm_writer.writeArithmetic('~')
    @vm_writer.writeIf('WHILE_END' + while_number.to_s)
    puts_symbol
    compileStatements
    @vm_writer.writeGoto('WHILE_EXP' + while_number.to_s)
    puts_symbol
    @vm_writer.writeLabel('WHILE_END' + while_number.to_s)
    # @while_number += 1
    # @output.puts '<whileStatement>'
    # puts_keyword
    # puts_symbol
    # compileExpression
    # puts_symbol
    # puts_symbol
    # compileStatements
    # puts_symbol
    # @output.puts '</whileStatement>'
  end
 
  def compileReturn
    # @output.puts '<returnStatement>'
    puts_keyword
    if @tokens.tokenType == 'SYMBOL'
      compileExpression unless @tokens.symbol == ';'
    else
      compileExpression
    end
    puts_symbol
    if @return_var == 'void'
      @vm_writer.writePush('constant', 0)
      @return_var = nil
    end
    @vm_writer.writeReturn
    # @output.puts '</returnStatement>'
  end
 
  def compileIf
    @if_number += 1
    if_number = @if_number
    # @output.puts '<ifStatement>'
    puts_keyword
    puts_symbol
    compileExpression
    puts_symbol
    @vm_writer.writeIf('IF_TRUE' + if_number.to_s)
    @vm_writer.writeGoto('IF_FALSE' + if_number.to_s)
    @vm_writer.writeLabel('IF_TRUE' + if_number.to_s)
    puts_symbol
    compileStatements
    puts_symbol
    if @tokens.tokenType == 'KEYWORD' && @tokens.keyWord == 'else'
      @vm_writer.writeGoto('IF_END' + if_number.to_s)
      @vm_writer.writeLabel('IF_FALSE' + if_number.to_s)
      puts_keyword
      puts_symbol
      compileStatements
      puts_symbol
      @vm_writer.writeLabel('IF_END' + if_number.to_s)
    else
      @vm_writer.writeLabel('IF_FALSE' + if_number.to_s)
    end
    # @output.puts '</ifStatement>'
  end
 
  def compileExpression
#    @output.puts '<expression>'
    compileTerm
    if @tokens.tokenType == 'SYMBOL'
      if ['+', '-', '&', '|', '<', '>', '=', '~'].include?(@tokens.symbol)
        command = @tokens.symbol
        puts_symbol
        compileTerm
  @vm_writer.writeArithmetic(command)
 
      elsif ['*', '/'].include?(@tokens.symbol)
        if @tokens.symbol == '*'
          command = 'multiply' 
        else
          command = 'divide' 
        end
        puts_symbol
 
        compileTerm
  @vm_writer.writeCall('Math.' + command, 2)
      end
    end
#    @output.puts '</expression>'
  end
 
  def compileTerm
    nArgs = 0
    array_flag = false
#    @output.puts '<term>'
    if @tokens.tokenType == 'IDENTIFIER'
      token = @tokens.identifier
p token
      if token == 'value'
      end
      @tokens.advance
      next_token = @tokens.symbol
p next_token
      array_flag = true if next_token == '['
#      @output.puts '<identifier>'
      kind = @symbol_table.kindOf(token)
      index = @symbol_table.indexOf(token) unless kind == 'NONE'
      name = token 
# p name
      if kind == 'NONE'
        # @name = token
        name = token
        if next_token == '('
          # p 'sub'
          category = 'SUBROUTINE'
        else
          # p 'class'
          # p next_token
          category = 'CLASS'
        end
      elsif kind == 'VAR' && array_flag == false
        name = @symbol_table.typeOf(token)
        nArgs += 1
        @vm_writer.writePush('local', index)
        category = kind
      elsif kind == 'ARG' && array_flag == false
        name = @symbol_table.typeOf(token)
        nArgs += 1
        @vm_writer.writePush('argument', index)
        category = kind
        # p token
      elsif kind == 'FIELD' && array_flag == false
        name = @symbol_table.typeOf(token)
        nArgs += 1
        # @vm_writer.writePush('pointer', 0)
        @vm_writer.writePush('this', index)
      elsif kind == 'STATIC' && array_flag == false
        name = @symbol_table.typeOf(token)
        nArgs += 1
        @vm_writer.writePush('static', index)
        category = kind
      end
    
#      @output.print '<category> '
#      @output.print category
#      @output.puts ' </category>'
      if kind == 'VAR'
        # @output.print '<defined> '
        # @output.print 'used'
        # @output.puts ' </defined>'
      end
 
      unless kind == 'NONE'
        # @output.print '<kind> '
        # @output.print kind 
        # @output.puts ' </kind>'
        # @output.print '<index> '
        # @output.print index 
        # @output.puts ' </index>'
      end
      # @output.print '<name> '
      # p token
      # @output.print token
      # @output.puts ' </name> '
      # @output.puts '</identifier>'
 
      case next_token
      when '['
        @tokens.advance
        compileExpression
        case kind
        when 'VAR'
          @vm_writer.writePush('local', index)
        when 'ARG'
        @vm_writer.writePush('argument', index)
        when 'FIELD'
        @vm_writer.writePush('this', index)
        when 'STATIC'
        @vm_writer.writePush('static', index)
        end
        # @output.print '<symbol> '
        # @output.print next_token
        # @output.puts ' </symbol>'
        # @tokens.advance
        # compileExpression
        @vm_writer.writeArithmetic('+')
        puts_symbol
        @vm_writer.writePop('pointer', 1)
        @vm_writer.writePush('that', 0)
      when '('
        # @name = @class_name + '.' + @name
        name = @class_name + '.' + name
        nArgs = 1
        @vm_writer.writePush('argument', 0)
        # puts_symbol
        nArgs += compileExpressionList
        puts_symbol
        # @vm_writer.writeCall(@name, nArgs)
        @vm_writer.writeCall(name, nArgs)
        # @name = nil
        name = nil
        # @output.print '<symbol> '
        # @output.print next_token
        # @output.puts ' </symbol>'
        # @tokens.advance
        # expressionList
        # puts_symbol
      when '.'
        # if (@symbol_table.kindOf(@name) == 'VAR') || (@symbol_table.kindOf(@name) == 'ARG')
        #   nArgs += 1
        #   @vm_writer.writePush('local', @symbol_table.indexOf(@name))
        # end
        # @output.print '<symbol> '
        # @output.print next_token
        # p @name
        # @name = @symbol_table.typeOf(@name) + next_token
        # @output.puts ' </symbol>'
        @tokens.advance
 
        # @name = @name + '.' +  @tokens.identifier 
        name = name + '.' +  @tokens.identifier 
        # @name = @symbol_table.typeOf(token) + '.' +  @tokens.identifier 
        puts_identifier
        puts_symbol
        nArgs += compileExpressionList
        puts_symbol
        # @vm_writer.writeCall(@name, nArgs)
        @vm_writer.writeCall(name, nArgs)
        # @name = nil
        name = nil
      else
        # @output.puts '</term>'
        return
      end
    else
      case  @tokens.tokenType
      when 'INT_CONST'
        @vm_writer.writePush('constant', @tokens.intVal)
        puts_integer_constant
      when 'STRING_CONST'
        string_length = @tokens.stringVal.length
        @vm_writer.writePush('constant', string_length)
        @vm_writer.writeCall('String.new', 1)
        string_length.times do |t|
          @vm_writer.writePush('constant', @tokens.stringVal[t].ord)
          @vm_writer.writeCall('String.appendChar', 2)
        end
        puts_string_constant
      when 'KEYWORD'
        if @tokens.keyWord == 'true'
          @vm_writer.writePush('constant', 1)
          @vm_writer.writeArithmetic('NEG')
        elsif @tokens.keyWord == 'false'
          @vm_writer.writePush('constant', 0)
        elsif @tokens.keyWord == 'null'
          @vm_writer.writePush('constant', 0)
        elsif @tokens.keyWord == 'this'
          @vm_writer.writePush('pointer', 0)
        end
        puts_keyword
      when 'SYMBOL'
        if @tokens.symbol == '('
          puts_symbol
  # p @tokens.symbol
          compileExpression
  # p @tokens.symbol
          puts_symbol
  # p @tokens.symbol
        elsif @tokens.symbol == '-'
          puts_symbol
          compileTerm
          @vm_writer.writeArithmetic('NEG')
        elsif @tokens.symbol == '~'
          puts_symbol
          compileTerm
          @vm_writer.writeArithmetic('~')
        else
          puts_symbol
          compileTerm
        end
      end
    end
#    @output.puts '</term>'
  end
 
  def compileExpressionList
    nArgs = 0
#    @output.puts '<expressionList>'
    until (@tokens.tokenType == 'SYMBOL' && @tokens.symbol == ')')
      compileExpression
      puts_symbol if @tokens.symbol == ','
      nArgs += 1
    end
#    @output.puts '</expressionList>'
    nArgs
  end
end
