class FibBasicIterator:
    def __init__(self, start):  # Constructor
        self.current = start
        self.previous = 0

    def next(self):
        num = self.current
        self.current += self.previous
        self.previous = num
        return num

    def __iter__(self):
        return self

iter = FibBasicIterator(start=1)
while 1:                        # 1 means true in Python
    num = iter.next()
    print num
    if num > 5:
        break

for num in FibBasicIterator(start=1):
    print num
    if num > 5:
        break
