require './Parser'
require './CodeWriter'

def convert(vm_file, code_writer)
  parser = Parser.new(vm_file)
  while parser.hasMoreCommands
    parser.advance
    case parser.commandType
    when 'C_ARITHMETIC'
      code_writer.writeArithmetic(parser.arg1)
    when 'C_PUSH', 'C_POP'
      code_writer.writePushPop(parser.commandType, parser.arg1, parser.arg2)
    when 'C_LABEL'
      code_writer.writeLabel(parser.arg1)
    when 'C_GOTO'
      code_writer.writeGoto(parser.arg1)
    when 'C_IF'
      code_writer.writeIf(parser.arg1)
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
    code_writer.setFileName(f.split('.')[0])
    convert(ARGV[0] + '/' + f, code_writer) unless (f == '.') || (f == '..')
  end
else
  code_writer = CodeWriter.new(ARGV[0].split('.')[0] + '.asm')
  code_writer.setFileName(ARGV[0].split('.')[0])
  convert(ARGV[0], code_writer)
end
