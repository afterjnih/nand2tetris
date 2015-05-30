class SymbolTable
  def initialize
    @class_scope = {}
    @subroutine_scope = {}
    @current_scope = @class_scope
    @another_scope = @subroutine_scope
  end

  def startSubroutine
    @subroutine_scope = {}
    @current_scope = @subroutine_scope
    @another_scope = @class_scope
  end

  def add_hash(current_scope, name, type, kind)
    current_scope[name.to_sym] = { type: type, kind: kind,
                                   index: varCount(kind) }
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
    if kind == 'STATIC' || kind == 'FIELD'
      @class_scope.each_value do |v|
        count += 1 if v[:kind] == kind
      end
    else
      @subroutine_scope.each_value do |v|
        count += 1 if v[:kind] == kind
      end
    end
    return count
  end

  def kindOf(name)
    if @current_scope[name.to_sym].nil?
      if @another_scope[name.to_sym].nil?
        'NONE'
      else
        @another_scope[name.to_sym][:kind]
      end
    else
      @current_scope[name.to_sym][:kind]
    end
  end

  def typeOf(name)
    if @current_scope[name.to_sym].nil?
        @another_scope[name.to_sym][:type]
    else
      @current_scope[name.to_sym][:type]
    end
  end

  def indexOf(name)
    if @current_scope[name.to_sym].nil?
      unless @another_scope[name.to_sym].nil?
        @another_scope[name.to_sym][:index]
      end
    else
      @current_scope[name.to_sym][:index]
    end
  end
end
