#!/usr/local/bin/ruby -w

######### A -- standard ruby iterator

def evens_to_tenA
  6.times do |i|
    yield i * 2
  end
end

n = 0
evens_to_tenA do |even|
  print "%d(%d) " % [n, even]
  n += 1
end
puts


######### B -- standard ruby iterator with more accurate names

def evens_to_tenB(&sub)
  6.times do |i|
    sub.call(i * 2)
  end
end

n = 0
evens_to_tenB do |even|
  print "%d(%d) " % [n, even]
  n += 1
end
puts


######## C -- parallel iterators using threads (concept by Matz, ruby-talk:5252)
require 'thread'

# Matz's solution failed to yield the last item of each iterator.  I changed
# the exit condition to fix this.  -- chouser
def combine(*args)
  queues = []
  threads = []
  for it in args
    queue = SizedQueue.new(1)
    th = Thread.start(it, queue) do |i,q|
      self.send(it) do |x|
        q.push x
      end
    end
    queues.push queue
    threads.push th
  end
  loop do
    ary = []
    for q in queues
      ary.push q.pop
    end
    yield ary
    for th in threads
      return if q.empty?
    end
  end
end
public :combine

def zero_to_fiveC(&sub)
  6.times do |i|
    sub.call(i)
  end
end

def evens_to_tenC(&sub)
  6.times do |i|
    sub.call(i * 2)
  end
end

combine( :zero_to_fiveC, :evens_to_tenC ) do |n, even|
  print "%d(%d) " % [n, even]
end
puts


######## D -- parallel iterators using Continuations

def zero_to_fiveD(consumer)
  consumer = callcc { |cc| consumer.call cc }
  6.times do |i|
    consumer = callcc { |cc| consumer.call cc, i }
  end
  nil
end

def evens_to_tenD(consumer)
  consumer = callcc { |cc| consumer.call cc }
  6.times do |i|
    consumer = callcc { |cc| consumer.call cc, i*2 }
  end
  nil
end

seq1 = callcc { |cc| zero_to_fiveD cc }
seq2 = callcc { |cc| evens_to_tenD cc }

loop do
  break unless seq1 and seq2
  seq1, n    = callcc { |cc| seq1.call cc }
  seq2, even = callcc { |cc| seq2.call cc }
  print "%d(%d) " % [n, even]
end
puts


######## E -- method applying callcc to use standard ruby iterators in parallel

def combine2(*iternames)
  rtn = nil
  seqlist = iternames.map { |itername|
    callcc do |factory|
      consumer = callcc { |cc| factory.call cc }
      return send(itername) { |*args|
        consumer = callcc { |cc| consumer.call cc, *args }
        rtn
      }
    end
  }

  loop do
    pairlist = seqlist.map { |seq| callcc { |cc| seq.call cc } }
    seqlist = pairlist.map { |pair| pair.first }
    rtn = yield(*pairlist.map { |pair| pair.last })
  end
end

def zero_to_fiveE
  6.times do |i|
    yield i
  end
end

def evens_to_tenE
  6.times do |i|
    yield i * 2
  end
end

combine2(:zero_to_fiveE, :evens_to_tenE) do |n, even|
  print "%d(%d) " % [n, even]
end
puts


######## F

class StopIteration < Exception; end

class Gen
  def initialize(obj, itername, *initargs)
    @nextcc = callcc do |factory|
      consumer = callcc { |cc| factory.call cc }
      final = obj.send(itername, *initargs) { |*args|
        consumer = callcc { |cc| consumer.call cc, *args }
        @rtn
      }
      nil
    end
  end

  def next
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

  def consume(gen)
    begin
      loop do
        self.next(gen.next)
      end
    rescue StopIteration
    end
  end
end

class Object
  def gen(name, *initargs)
    Gen.new(self, name, *initargs)
  end
end

def combineF(*genlist)
  begin
    loop do
      rtn = yield(*genlist.map { |gen| gen.next })
    end
  rescue StopIteration
  end
end

class Counters
  def initialize(start)
    @start = start
  end

  def zero_to_xF(x)
    x.times do |i|
      y = yield @start + i
      puts y
    end
    'zippy'
  end

  def evens_to_xF(x)
    x.times do |i|
      yield @start + i * 2
    end
  end
end

combineF((4..10).gen(:each), 8.gen(:times)) do |i, j|
  puts "%s, %s" % [i, j]
  'zip'
end

puts Counters.new(2).gen(:zero_to_xF, 4).each { |i|
  puts i
  'hi %s' % [i*10]
}
