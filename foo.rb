class Float
  attr_accessor :foo
end

x = 666.3

x.foo = 'howdy'

ObjectSpace.each_object { |obj| p obj.id, obj }

puts x
puts x.foo
