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
    @nArgs = nil
    @while_number = 0
    @if_number = 0
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
    @output.puts '<classVarDec>'
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
    @output.puts '</classVarDec>'
  end
 
  def compileSubroutine
    @symbol_table.startSubroutine
    @symbol_table.define('this', @class_name, 'ARG')
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
    puts_keyword
#    @tokens.tokenType == 'IDENTIFIER' ? puts_identifier : puts_keyword
    @tokens.advance
#    puts_identifier
#    @output.puts "function #{@symbol_table.typeOf('this')}.#{@tokens.identifier} #{@symbol_table.varCount('ARG') - 1}"
    @vm_writer.writeFunction(@symbol_table.typeOf('this') + '.' + @tokens.identifier, @symbol_table.varCount('ARG') - 1)
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
#    @output.puts '<doStatement>'
    puts_keyword
 
#    puts_identifier
    @name = @tokens.identifier
    @tokens.advance
 
    if @tokens.symbol == '('
      puts_symbol
      compileExpressionList
      puts_symbol
    else
      puts_symbol
#      puts_identifier
      @name = @name + '.' + @tokens.identifier
      @tokens.advance
      puts_symbol
 
      compileExpressionList
      puts_symbol
    end
    puts_symbol
@vm_writer.writeCall(@name, @nArgs)
@name = nil
 
#    @output.puts '</doStatement>'
  end
 
  def compileLet
    # @output.puts '<letStatement>'
    puts_keyword
    var = @tokens.identifier
    puts_identifier
    if @tokens.tokenType == 'SYMBOL'
      if @tokens.symbol == '['
        puts_symbol
        compileExpression
        puts_symbol
      end
    end
    puts_symbol # =
    compileExpression
    @vm_writer.writePop('local', @symbol_table.indexOf(var))
    puts_symbol
    # @output.puts '</letStatement>'
  end
 
  def compileWhile
    @vm_writer.writeLabel('WHILE_EXP' + @while_number.to_s)
    puts_keyword
    puts_symbol
    compileExpression
    puts_symbol
    @vm_writer.writeIf('WHILE_END' + @while_number.to_s)
    puts_symbol
    compileStatements
    @vm_writer.writeGoto('WHILE_EXP' + @while_number.to_s)
    puts_symbol
    @vm_writer.writeLabel('WHILE_END' + @while_number.to_s)
    @while_number += 1
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
    @vm_writer.writeReturn
    puts_keyword
    if @tokens.tokenType == 'SYMBOL'
      compileExpression unless @tokens.symbol == ';'
    else
      compileExpression
    end
    puts_symbol
    # @output.puts '</returnStatement>'
  end
 
  def compileIf
    # @output.puts '<ifStatement>'
    puts_keyword
    puts_symbol
    compileExpression
    puts_symbol
    @vm_writer.writeIf('IF_TRUE' + @if_number.to_s)
    @vm_writer.writeGoto('IF_FALSE' + @if_number.to_s)
    @vm_writer.writeLabel('IF_TRUE' + @if_number.to_s)
    puts_symbol
    compileStatements
    puts_symbol
    if @tokens.tokenType == 'KEYWORD' && @tokens.keyWord == 'else'
      @vm_writer.writeGoto('IF_END' + @if_number.to_s)
      @vm_writer.writeLabel('IF_FALSE' + @if_number.to_s)
      puts_keyword
      puts_symbol
      compileStatements
      puts_symbol
      @vm_writer.writeLabel('IF_END' + @if_number.to_s)
    else
      @vm_writer.writeLabel('IF_FALSE' + @if_number.to_s)
    end
    # @output.puts '</ifStatement>'
  end
 
  def compileExpression
#    @output.puts '<expression>'
    compileTerm
    if @tokens.tokenType == 'SYMBOL'
      if ['+', '-', '&', '|', '<', '>', '='].include?(@tokens.symbol)
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
#    @output.puts '<term>'
    if @tokens.tokenType == 'IDENTIFIER'
      token = @tokens.identifier
      @tokens.advance
      next_token = @tokens.symbol
 
#      @output.puts '<identifier>'
      kind = @symbol_table.kindOf(token)
      index = @symbol_table.indexOf(token) unless kind == 'NONE'
      name = token 
# p name
      if kind == 'NONE'
        if next_token == '('
          # p 'sub'
          category = 'SUBROUTINE'
        else
          # p 'class'
          # p next_token
          category = 'CLASS'
        end
      else
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
      p token
      if @symbol_table.kindOf(token) == 'NONE'
        @name = token
      else
      end
      # @output.print token
      # @output.puts ' </name> '
      # @output.puts '</identifier>'
 
      case next_token
      when '['
        @output.print '<symbol> '
        @output.print next_token
        @output.puts ' </symbol>'
        @tokens.advance
        compileExpression
        puts_symbol
      when '('
        @output.print '<symbol> '
        @output.print next_token
        @output.puts ' </symbol>'
        @tokens.advance
        expressionList
        puts_symbol
      when '.'
        # @output.print '<symbol> '
        # @output.print next_token
        @name = @name + next_token
        # @output.puts ' </symbol>'
        @tokens.advance

        @name = @name + @tokens.identifier 
        puts_identifier
        puts_symbol
        compileExpressionList
        puts_symbol
        @vm_writer.writeCall(@name, @nArgs)
        @name = nil
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
        puts_string_constant
      when 'KEYWORD'
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
        else
          puts_symbol
          compileTerm
        end
      end
    end
#    @output.puts '</term>'
  end
 
  def compileExpressionList
    @nArgs = 0
#    @output.puts '<expressionList>'
    until (@tokens.tokenType == 'SYMBOL' && @tokens.symbol == ')')
      compileExpression
      puts_symbol if @tokens.symbol == ','
      @nArgs += 1
    end
#    @output.puts '</expressionList>'
  end
end

