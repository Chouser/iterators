#!/usr/bin/env python

######### State machine class as Python-style iterator

class StateMach:
    state = None

    def __iter__(self):
        return self

    def next(self):
        if not self.state:
            self.state = self.initial
        self.state()
        return self

    def tofinal(self):
        while self.state != self.final:
            self.state()

    def initial(self):
        raise "State 'initial' should be overridden by subclass"

    def final(self):
        raise StopIteration


class LoopToSix(StateMach):
    def __init__(self):
        self.counter = 0
        self.state = self.start

    def start(self):
        print "Begin counting"
        self.state = self.count

    def count(self):
        print "Counted to %d" % self.counter
        if self.counter > 5:
            self.state = self.final


for sm in LoopToSix():
    sm.counter += 1
    print "I'm in state", sm.state

sm = LoopToSix()
sm.tofinal()
