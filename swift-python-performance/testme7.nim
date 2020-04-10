import times, sequtils, strutils

proc testme() =
    var result : array[0..3000, int]
    for it in 0 ..< 15:
        let start = epochTime()
        for x in 0 ..< 3000:
            result[x] = it
        let summed = result.foldl(a+b)
        let ended = epochTime()
        echo (formatFloat(ended - start, ffDecimal, 7), summed)

when isMainModule:
    testme()
