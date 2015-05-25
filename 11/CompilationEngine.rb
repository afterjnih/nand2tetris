class CompilationEngine

  def initialize(tokens, output)
    @tokens = tokens
    @output = output
    compileClass
  end

  def puts_keyword
    @output.print '<keyword> '
    @output.print @tokens.keyWord
    @output.puts ' </keyword>'
    @tokens.advance
  end

  def puts_symbol
    @output.print '<symbol> '
    case @tokens.symbol
    when '<'
      @output.print '&lt;'
    when '>'
      @output.print '&gt;'
    when '&'
      @output.print '&amp;'
    else
      @output.print @tokens.symbol
    end
    @output.puts ' </symbol>'
    @tokens.advance
  end

  def puts_integer_constant
    @output.print '<integerConstant> '
    @output.print @tokens.intVal
    @output.puts ' </integerConstant>'
    @tokens.advance
  end

  def puts_string_constant
    @output.print '<stringConstant> '
    @output.print @tokens.stringVal
    @output.puts ' </stringConstant>'
    @tokens.advance
  end

  def puts_identifier
    @output.print '<identifier> '
    @output.print @tokens.identifier
    @output.puts ' </identifier>'
    @tokens.advance
  end

  def compileClass
    @output.puts '<class>'
    puts_keyword
    puts_identifier
    puts_symbol
    while @tokens.keyWord == 'static' || @tokens.keyWord == 'field'
      compileClassVarDec
    end

    while @tokens.keyWord == 'constructor' || @tokens.keyWord == 'function' || @tokens.keyWord == 'method'
      compileSubroutine
    end
    puts_symbol
    @output.puts '</class>'
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
    @output.puts '<subroutineDec>'
    puts_keyword
    @tokens.tokenType == 'IDENTIFIER' ? puts_identifier : puts_keyword
    puts_identifier
    puts_symbol
    compileParameterList
    puts_symbol

    @output.puts '<subroutineBody>'
    puts_symbol
    while @tokens.keyWord == 'var'
      compileVarDec
    end
    compileStatements
    puts_symbol
    @output.puts '</subroutineBody>'

    @output.puts '</subroutineDec>'
  end

  def compileParameterList
    @output.puts '<parameterList>'
    
    if @tokens.tokenType == 'KEYWORD' || @tokens.tokenType == 'IDENTIFIER'
      puts_keyword
      puts_identifier

      while @tokens.symbol == ','
        puts_symbol
        puts_keyword
        puts_identifier
      end
    end

    @output.puts '</parameterList>'
  end

  def compileVarDec
    @output.puts '<varDec>'
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
    @output.puts '</varDec>'
  end

  def compileStatements
    @output.puts '<statements>'
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
    @output.puts '</statements>'
  end

  def compileDo
    @output.puts '<doStatement>'
    puts_keyword

    puts_identifier
    if @tokens.symbol == '('
      puts_symbol
      compileExpressionList
      puts_symbol
    else
      puts_symbol
      puts_identifier
      puts_symbol

      compileExpressionList
      puts_symbol
    end
    puts_symbol

    @output.puts '</doStatement>'
  end

  def compileLet
    @output.puts '<letStatement>'
    puts_keyword
    puts_identifier
    if @tokens.tokenType == 'SYMBOL'
      if @tokens.symbol == '['
        puts_symbol
        compileExpression
        puts_symbol
      end
    end
    puts_symbol
    compileExpression
    puts_symbol
    @output.puts '</letStatement>'
  end

  def compileWhile
    @output.puts '<whileStatement>'
    puts_keyword
    puts_symbol
    compileExpression
    puts_symbol
    puts_symbol
    compileStatements
    puts_symbol
    @output.puts '</whileStatement>'
  end

  def compileReturn
    @output.puts '<returnStatement>'
    puts_keyword
    if @tokens.tokenType == 'SYMBOL'
      compileExpression unless @tokens.symbol == ';'
    else
      compileExpression
    end
    puts_symbol
    @output.puts '</returnStatement>'
  end

  def compileIf
    @output.puts '<ifStatement>'

    puts_keyword
    puts_symbol
    compileExpression
    puts_symbol
    puts_symbol
    compileStatements
    puts_symbol
    if @tokens.tokenType == 'KEYWORD'
      if @tokens.keyWord == 'else'
        puts_keyword
        puts_symbol
        compileStatements
        puts_symbol
      end
    end
    @output.puts '</ifStatement>'
  end

  def compileExpression
    @output.puts '<expression>'
    compileTerm
    if @tokens.tokenType == 'SYMBOL'
      if ['+', '-', '*', '/', '&', '|', '<', '>', '='].include?(@tokens.symbol)
        puts_symbol
        compileTerm
      end
    end
    @output.puts '</expression>'
  end

  def compileTerm
    @output.puts '<term>'
    if @tokens.tokenType == 'IDENTIFIER'
      token = @tokens.identifier
      @tokens.advance
      next_token = @tokens.symbol
      @output.print '<identifier> '
      @output.print token
      @output.puts ' </identifier>'
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
        @output.print '<symbol> '
        @output.print next_token
        @output.puts ' </symbol>'
        @tokens.advance

        puts_identifier
        puts_symbol
        compileExpressionList
        puts_symbol
      else
        @output.puts '</term>'
        return
      end
    else
      case  @tokens.tokenType
      when 'INT_CONST'
        puts_integer_constant
      when 'STRING_CONST'
        puts_string_constant
      when 'KEYWORD'
        puts_keyword
      when 'SYMBOL'
        if @tokens.symbol == '('
          puts_symbol
          compileExpression
          puts_symbol
        else
          puts_symbol
          compileTerm
        end
      end
    end
    @output.puts '</term>'
  end

  def compileExpressionList
    @output.puts '<expressionList>'
    until (@tokens.tokenType == 'SYMBOL' && @tokens.symbol == ')')
      compileExpression
      puts_symbol if @tokens.symbol == ','
    end
    @output.puts '</expressionList>'
  end
end
