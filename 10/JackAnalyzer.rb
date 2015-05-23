require './JackTokenizer'
require './CompilationEngine'

if File.ftype(ARGV[0]) == 'directory'
  Dir.open(ARGV[0]).each do |f|
    next unless (f.split('.')[-1] == 'jack')
    p f
    output = File.open(f.split('.')[0] + '.xml', 'w')
    tokens = JackTokenizer.new(ARGV[0] + '/' + f)
    CompilationEngine.new(tokens, output)
  end
else
    output = File.open(ARGV[0].split('.')[0] + '.xml', 'w')
    tokens = JackTokenizer.new(ARGV[0])
    CompilationEngine.new(tokens, output)
  # tokens = JackTokenizer.new(ARGV[0])
  # tokenizer_output = File.open(ARGV[0].split('.')[0] + '.xml', 'w')
  # tokenizer_output.puts '<tokens>'
  # while tokens.hasMoreToken
  #   case tokens.tokenType
  #   when 'KEYWORD'
  #     tokenizer_output.print '<keyword> '
  #     tokenizer_output.print tokens.keyWord
  #     tokenizer_output.puts ' </keyword>'
  #   when 'SYMBOL'
  #     tokenizer_output.print '<symbol> '
  #     case tokens.symbol
  #     when '<'
  #       tokenizer_output.print '&lt;'
  #     when '>'
  #       tokenizer_output.print '&gt;'
  #     when '&'
  #       tokenizer_output.print '&amp;'
  #     else
  #       tokenizer_output.print tokens.symbol
  #     end
  #     tokenizer_output.puts ' </symbol>'
  #   when 'IDENTIFIER'
  #     tokenizer_output.print '<identifier> '
  #     tokenizer_output.print tokens.identifier
  #     tokenizer_output.puts ' </identifier>'
  #   when 'INT_CONST'
  #     tokenizer_output.print '<integerConstant> '
  #     tokenizer_output.print tokens.intVal
  #     tokenizer_output.puts ' </integerConstant>'
  #   when 'STRING_CONST'
  #     tokenizer_output.print '<stringConstant> '
  #     tokenizer_output.print tokens.stringVal
  #     tokenizer_output.puts ' </stringConstant>'
  #   end
  #   tokens.advance
  # end
  # tokenizer_output.puts '</tokens>'
  # tokenizer_output.close
end 
