from __future__ import generators

def maingen():
    yield 5
    yield 20
    return
    yield 1000

def main():
    print "hi"
    #cc = callcc
    print "more"
    #yield

mg = maingen()
print mg
mg.next()
newg = mg
