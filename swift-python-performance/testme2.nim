import times, sequtils

var result : seq[int] = @[]
for it in 0 ..< 15:
    let start = epochTime()
    for _ in 0 ..< 3000:
        result.add(it)
    let summed = result.foldl(a+b)
    let ended = epochTime()
    echo (ended - start, summed)
    result = @[]
