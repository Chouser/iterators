#!/usr/bin/env python
from __future__ import nested_scopes
from __future__ import generators

######### A -- Ruby-style iterator as implemented in python

def evens_to_tenA(sub):
    for i in range(0, 6):
        sub(i * 2)

n = 0
def mysub(even):
    print "%d(%d)" % (n, even),
    #n += 1  # python doesn't allow modifying the closure vars?
evens_to_tenA(mysub)
print

######### B -- Using a generator as a ruby-style iterator

def evens_to_tenB():
    for i in range(0, 6):
        yield i * 2

try:
    n = 0
    seq = evens_to_tenB()
    while 1:
        even = seq.next()
        print "%d(%d)" % (n, even),
        n += 1
except StopIteration:
    pass
print

######### C -- Using parallel generators as parallel ruby-style iterators

def zero_to_fiveC():
    for i in range(0, 6):
        yield i

def evens_to_tenC():
    for i in range(0, 6):
        yield i * 2

try:
    seq1, seq2 = zero_to_fiveC(), evens_to_tenC()
    while 1:
        n, even = seq1.next(), seq2.next()
        print "%d(%d)" % (n, even),
except StopIteration:
    pass
print

######### D -- python-style iterator
# You can also use a Python generator (above) as an iterator (instead
# of EvensToTenD below)

class EvensToTenD:
    def __init__(self):
        self.i = -1

    def __iter__(self):
        return self

    def next(self):
        self.i += 1
        if self.i > 5:
            raise StopIteration
        return self.i * 2

n = 0
for even in EvensToTenD():
    print "%d(%d)" % (n, even),
    n += 1
print


######### E -- parallel generators as python-style iterators

# The first generator that completes will raise StopIteration at
# gen.next().  We let this through so that the top-level for loop will
# catch the StopIteration and know to quit.

class MultiIter:
    def __init__(self, *iterlist):
        self.iterlist = iterlist

    def __iter__(self):
        return self

    def next(self):
        return [iter.next() for iter in self.iterlist]

def zero_to_fiveE():
    for i in range(0, 6):
        yield i

def evens_to_tenE():
    for i in range(0, 6):
        yield i * 2

for n, even in MultiIter(zero_to_fiveE(), evens_to_tenE()):
    print "%d(%d)" % (n, even),
print


#foo = loop [keygen, valuegen] { |k, v| "%s=%s" % [k, v] }

