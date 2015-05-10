require './Parser'
require './CodeWriter'

def convert(vm_file, code_writer)
  parser = Parser.new(vm_file)
  while parser.hasMoreCommands
    parser.advance
    case parser.commandType
    when 'C_ARITHMETIC'
      code_writer.writeArithmetic(parser.arg1)
    when 'C_PUSH'
      code_writer.writePushPop(parser.commandType, parser.arg1, parser.arg2)
    when 'C_POP'
    when 'C_LABEL'
    when 'C_GOTO'
    when 'C_IF'
    when 'C_FUNCTION'
    when 'C_RETURN'
    when 'C_CALL'
    end
  end
  code_writer.close
end

if File.ftype(ARGV[0]) == 'directory'
  code_writer = CodeWriter.new(ARGV[0].split(nil)[0] + '.asm')
  Dir.open(ARGV[0]).each do |f|
    convert(ARGV[0] + '/' + f, code_writer) unless (f == '.') || (f == '..')
  end
else
  code_writer = CodeWriter.new(ARGV[0].split('.')[0] + '.asm')
  convert(ARGV[0], code_writer)
end
