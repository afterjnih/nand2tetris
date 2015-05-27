class SymbolTable
  def initialize
    @class_scope = {}
    @subroutine_scope = {}
    @current_scope = @class_scope
  end

  def startSubroutine
    @subroutine_scope = {}
    @current_scope = @subroutine_scope
  end

  def add_hash(current_scope, name, type, kind)
    current_scope[name.to_sym] = { type: type, kind: kind,
                                   num: varCount(kind) }
  end

  def define(name, type, kind)
    if kind == 'STATIC' || kind == 'FIELD'
      add_hash(@class_scope, name, type, kind)
    else
      add_hash(@subroutine_scope, name, type, kind)
    end
  end

  def varCount(kind)
    count = 0
    @current_scope.each_value do |v|
      count += 1 if v[:kind] == kind
    end
    return count
  end

  def kindOf(name)
    if @current_scope[name.to_sym].nil?
      'NONE'
    else
      @current_scope[name.to_sym]
    end
  end

  def typeOf(name)
    @current_scope[name.to_sym][:type]
  end

  def indexOf(name)
    @current_scope[name.to_sym][:index]
  end
end
