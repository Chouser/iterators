def fiblist(start, length):
    current = start
    previous = 0
    list = []
    while len(list) < length:
        num = current
        current += previous
        previous = num
        list.append(num)
    return list

list = fiblist(start=1, length=6)
# Note: the length had to be specified already.

for num in list:
    print num
