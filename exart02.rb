class FibBasicIterator
  def initialize(start)
    @current = start
    @previous = 0
  end

  def getnext
    num = @current
    @current += @previous
    @previous = num
    return num
  end
end

iter = FibBasicIterator.new(1)  # No named params in Ruby
loop do                         # Infinite loop
  num = iter.getnext
  puts num
  break if num > 5
end
