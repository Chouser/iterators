class FibLimitIterator:
    def __init__(self, start, limit):  # Constructor
        self.current = start
        self.limit = limit
        self.previous = 0

    def next(self):
        num = self.current
        self.current += self.previous
        self.previous = num
        if num > self.limit:
            raise StopIteration
        return num

    def __iter__(self):
        return self

iter = FibLimitIterator(start=1, limit=5)
try:
    while 1:                            # 1 means true in Python
        num = iter.next()
        print num
except StopIteration:
    # Iterator is done, so just continue
    pass

for num in FibLimitIterator(start=1, limit=5):
    print num
    if num > 5:
        break
