require './JackTokenizer'
require './SymbolTable'
require './CompilationEngine'

if File.ftype(ARGV[0]) == 'directory'
  Dir.open(ARGV[0]).each do |f|
    next unless (f.split('.')[-1] == 'jack')
    p f
    output = File.open(f.split('.')[0] + '.vm', 'w')
    tokens = JackTokenizer.new(ARGV[0] + '/' + f)
    compilation_engine = CompilationEngine.new(tokens, output)
    compilation_engine.compileClass
  end
else
    output = File.open(ARGV[0].split('.')[0] + '.vm', 'w')
    tokens = JackTokenizer.new(ARGV[0])
    compilation_engine = CompilationEngine.new(tokens, output)
    compilation_engine.compileClass
end 
