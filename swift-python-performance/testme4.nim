import times, sequtils, strutils

var result = newSeqOfCap[int](3000)
for it in 0 ..< 15:
    let start = epochTime()
    for _ in 0 ..< 3000:
        result.add(it)
    let summed = result.foldl(a+b)
    let ended = epochTime()
    echo (formatFloat(ended - start, ffDecimal, 7), summed)
    result.setLen(0)
