
Ruby generator as iterator:

    def meth(fargs)
        ...
        yield A_z
    end

    obj.meth(args) { | F_z |
        ...
    }

Python generator as iterator:

    def meth(fargs):
        ...
        yield A_z

    for F_z in itergen(obj.meth(args)):
        ...

Name arguments:

####### Forward: (ret1, ret2,...)func(arg1,arg2,...):

    def (list)split(pattern, string):
        while ...
            ...
            list.push(item:chunk)
        ...
        return

    def (list)sort(list)
        while ...
            list.push(item)list.remove(index)

    def munge(string):
        (list)split(pattern:":", string)
        (list)sort(list)
        print(list)

    #...or munge could be...
    def munge(string):
        print(list)sort(list)split(pattern:":", string)

####### Reverse: (arg1,arg2,...)func(ret1, ret2,...):

    def (pattern, string)split(list):
        while ...
            ...
            (item:chunk)list.push
        ...
        return

    def (list)sort(list)
        while ...
            (index)list.remove(item)list.push

    def (string)munge:
        (pattern:":", string)split(list)
        (list)sort(list)
        (list)print

    #...or munge could be...
    def munge(string):
        (pattern:":", string)split(list)sort(list)print



