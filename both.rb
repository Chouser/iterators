class StopIteration < Exception; end

class Gen
  def initialize(obj, itername, *initargs)
    @nextcc = callcc do |factory|
      consumer = callcc { |cc| factory.call cc }
      final = obj.send(itername, *initargs) { |*args|
        consumer = callcc { |cc| consumer.call cc, *args }
        @nextargs
      }
      nil
    end
  end

  def next(nextargs = nil)
    @nextargs = nextargs
    @nextcc or raise StopIteration
    @nextcc, rtn = callcc { |cc| @nextcc.call cc }
    puts ">> %s, %s" % [@nextcc, rtn]
    rtn
  end

  def each
    begin
      loop do
        @rtn = yield self.next
      end
    rescue StopIteration
    end
  end

  def sendto(con)
    begin
      con.next
      self.each do |*args|
        con.next(*args)
      end
    rescue StopIteration
    end
  end
  alias >> sendto
end

class Object
  def gen(name, *initargs)
    Gen.new(self, name, *initargs)
  end
end


class MyList
  def initialize
    @x = []
  end

  def each
    @x.each do |i|
      yield i
    end
  end

  def add(n=10000)
    n.times do
      @x << yield
    end
  end

  def double(con, gen)
    loop do
      x = con.call
      gen.call(x)
      gen.call(x*2)
    end
  end
end

x = MyList.new
(1..5).gen(:each).sendto(  x.gen(:add, 3)   )
p x

(10..15).gen(:each)  >>  x.gen(:add, 3)
p x
