class SymbolTable
  def initialize
    @class_scope = {}
    @subroutine_scope = {}
    @current_scope = @class_scope
  end

  def startSubroutine
    @subroutin_scope = {}
    @current_scope = @subroutin_scope
  end

  def add_hash(current_scope, name, type, kind)
    begin
      if current_scope.values.last[:kind] == kind
        current_scope[name.to_sym] = { type: type, kind: kind,
                                       num: current_scope.values.last[:num] + 1 }
      else
        current_scope[name.to_sym] = { type: type, kind: kind, num: 0 }
      end
    rescue NoMethodError
      current_scope[name.to_sym] = { type: type, kind: kind, num: 0 }
    end
  end

  def define(name, type, kind)
    if kind == STATIC || kind == FIELD
      add_hash(@class_scope, name, type, kind)
    else
      add_hash(@subroutine_scope, name, type, kind)
    end
  end

  def varCount(kind)
    count = 0
    @current_scope.each_value do |v|
      count += 1 if v[:property] == kind
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
    @current_scopep[name.to_sym][:index]
  end
end
