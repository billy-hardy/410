class Env < Hash
  def initialize(keys=[], vals=[], outer=nil)
    @outer = outer
    keys.zip(vals).each{|p| store(*p)}
  end
  def [](name)  super(name) || @outer[name]  end
  def set(name, value) key?(name) ? store(name, value) : @outer.set(name, value)  end
end

def display(list)
  display_rec(list)
  puts ""
end

def display_rec(list, indent=0)
  print "("
  list.each do |x|
    if x.is_a? Array
      display_rec(x, indent+1)
    else
      unless list.index(x) == list.length-1
        print x.to_s + " "
      else
        print x
      end
    end
  end
  print ")"
end

def my_reduce(x)

end

def add_globals(env)
  ops = [:+, :-, :*, :/, :>, :<, :>=, :<=, :==]
  ops.each{|op|  env[op] = lambda{|*x| x[1..-1].inject{|sum, n| sum.send(x[0], n)}}}
  env.update({ :length => lambda{|x| x.length}, :cons => lambda{|x, y| [x]+y},
               :car => lambda{|x| x[0]}, :cdr => lambda{|x| x[1..-1]},
               :append => lambda{|x,y| x+y}, :list => lambda{|*xs| xs},
               :list? => lambda{|x| x.is_a? Array}, :null? => lambda{|x| x==nil},
               :symbol? => lambda{|x| x.is_a? Symbol}, :not => lambda{|x| !x},
               :display => lambda{|x| display(x)}, :reduce => lambda{|x| my_reduce(x)}})
end

def eval(x, env)
  return env[x] if x.is_a? Symbol
  return x if !x.is_a? Array
  return nil if x == []
  if x[0] == :quote then x[1..-1]
  elsif x[0] == :if
      _, test, conseq, alt = x
    eval(eval(test, env) ? conseq : alt, env)
  elsif x[0] == :set! then env.set(x[1], eval(x[2], env))
  elsif x[0] == :define then env[x[1]] = eval(x[2], env)
  elsif x[0] == :lambda
    _, vars, exp = x
    Proc.new{|*args| eval(exp, Env.new(vars, args, env))}
  elsif x[0] == :begin
    x[1..-1].inject([nil, env]){|val_env, exp| [eval(exp, val_env[1]), val_env[1]]}[0]
  elsif x[0] == :callcc
    f = eval(x[1], env)
    callcc {|cont| f.call( lambda{|x| cont.call(x)} ) }
  else
    exps = x.map{|exp| eval(exp, env)}
    exps[0].call(*exps[1..-1])
  end
end

def atom(s)
  return "[" if s=='('
  return "]" if s==')'
  return s if s =~ /^-?\d+$/ || s =~ /^-?\d*\.\d+$/
  ':'+s
end

def parse(src)
  tokens = src.gsub('(', ' ( ').gsub(')', ' ) ').split
  Kernel.eval(tokens.map{|s| atom(s)}.join(' ').gsub(' ]',']').gsub(/([^\[]) /,'\1, '))
end

def repl(env)
  while true
    begin
      print "risp>"
      code = parse(gets.chomp)
      ret = eval(code, env)
      unless ret == nil
        puts "==> " + ret.to_s
      else
        puts "==> nil"
      end
#    rescue NoMethodError => e
#      puts e.to_s
    rescue SyntaxError
      puts "Invalid syntax"
    end
  end
end

if ARGV.size > 0
  src = open(ARGV[0], 'r'){|f| f.read }
  p(eval(parse(src), add_globals(Env.new)))
else
  repl(add_globals(Env.new))
end
