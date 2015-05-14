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
      code_writer.writeFunction(parser.arg1, parser.arg2)
    when 'C_RETURN'
      code_writer.writeReturn
    when 'C_CALL'
      code_writer.writeCall(parser.arg1, parser.arg2)
    end
  end
  # code_writer.close
end

if File.ftype(ARGV[0]) == 'directory'
  code_writer = CodeWriter.new(ARGV[0].split(nil)[0] + '.asm')
  code_writer.setFileName('Sys')
  convert(ARGV[0] + '/' + 'Sys.vm', code_writer)
  Dir.open(ARGV[0]).each do |f|
    next if (f == '.') || (f == '..') || (f == 'Sys.vm') || (f.split('.')[-1] != 'vm')
    code_writer.setFileName(f.split('.')[0])
    convert(ARGV[0] + '/' + f, code_writer)
  end
  code_writer.close
else
  code_writer = CodeWriter.new(ARGV[0].split('.')[0] + '.asm')
  code_writer.setFileName(ARGV[0].split('.')[0])
  convert(ARGV[0], code_writer)
  code_writer.close
end
