# Python/Swift Performance Example in Nim

This is from [this blog post](https://tryolabs.com/blog/2020/04/02/swift-googles-bet-on-differentiable-programming/) which takes some
Python and converts it to Swift. It actually goes into a lot more
detail about some cool stuff in Swift, but this writeup is just to
convert one of the examples into Nim.

This goes from the original Python code running around 400 microseconds
per outer loop and then steps through converting the code to Nim and
getting the time down to 1 microsecond.

## Python

I don't have Swift installed on this machine, so we'll just
use Python3 and Python2 to get some base times for
[test.py](///test.py)  

Running `python3 testme.py` gives results like

```
0.0004899501800537109 0
0.0004971027374267578 3000
0.00047898292541503906 6000
0.0004780292510986328 9000
0.0004737377166748047 12000
0.0006122589111328125 15000
0.00047588348388671875 18000
0.00047278404235839844 21000
0.00048089027404785156 24000
0.0004620552062988281 27000
0.0004572868347167969 30000
0.0004642009735107422 33000
0.0004749298095703125 36000
0.0004658699035644531 39000
0.00047898292541503906 42000
```

Running `python2 testme.py` gives similar results, but with
a bit more variance.

```
(0.0005640983581542969, 0)
(0.0005300045013427734, 3000)
(0.0005359649658203125, 6000)
(0.0004429817199707031, 9000)
(0.0004470348358154297, 12000)
(0.0004429817199707031, 15000)
(0.0004398822784423828, 18000)
(0.00043201446533203125, 21000)
(0.00036215782165527344, 24000)
(0.0003619194030761719, 27000)
(0.0004220008850097656, 30000)
(0.00051116943359375, 33000)
(0.0004630088806152344, 36000)
(0.0004050731658935547, 39000)
(0.00037598609924316406, 42000)
```

The blog post says Python was getting about 360 microseconds per loop,
which is a bit faster than the numbers we are getting here.

## Nim - Take 1

Doing the bare minimum to convert this to Nim gives us [testme1.nim](///testme1.nim)

Run this with `nim c -r testme1.nim`. On my laptop this gives results like

```
(0.0003762245178222656, 0)
(0.0003671646118164062, 3000)
(0.0004091262817382812, 6000)
(0.0003590583801269531, 9000)
(0.0003628730773925781, 12000)
(0.0003619194030761719, 15000)
(0.0003750324249267578, 18000)
(0.0004041194915771484, 21000)
(0.0004241466522216797, 24000)
(0.0003650188446044922, 27000)
(0.0003719329833984375, 30000)
(0.0003449916839599609, 33000)
(0.0003769397735595703, 36000)
(0.0003671646118164062, 39000)
(0.0003621578216552734, 42000)
```

This is about 80% of the time of the original Python code.

## Nim - Take 2

The first take wasn't that much faster than Python because
the code was being compiled in debug mode. Compiling with
release mode will give us much better results.

Run this with `nim c -d:release -r testme2.nim`.

```
(8.797645568847656e-05, 0)
(6.413459777832031e-05, 3000)
(9.393692016601562e-05, 6000)
(6.580352783203125e-05, 9000)
(6.103515625e-05, 12000)
(6.198883056640625e-05, 15000)
(6.794929504394531e-05, 18000)
(6.413459777832031e-05, 21000)
(6.389617919921875e-05, 24000)
(6.508827209472656e-05, 27000)
(6.794929504394531e-05, 30000)
(7.605552673339844e-05, 33000)
(0.0001070499420166016, 36000)
(7.486343383789062e-05, 39000)
(6.580352783203125e-05, 42000)
```

Much faster, but slightly harder to read the output for comparison.

(note that there were no code changes, just the release flag)

## Nim - Take 3

In [testme3.nim](///testme3.nim) we take a bit more control over the formatting of the output.

Run this with `nim c -d:release -r testme3.nim`.

```
("0.0000880", 0)
("0.0000610", 3000)
("0.0000610", 6000)
("0.0000651", 9000)
("0.0000620", 12000)
("0.0000641", 15000)
("0.0000591", 18000)
("0.0000620", 21000)
("0.0000739", 24000)
("0.0000601", 27000)
("0.0000641", 30000)
("0.0000591", 33000)
("0.0000610", 36000)
("0.0000601", 39000)
("0.0000660", 42000)
```

This is about 15% of the time of the original Python code.

## Nim - Take 4

In [testme4.nim](///testme4.nim) we set the capacity of the
sequence that we are using instead of having it grow dynamically.

Run this with `nim c -d:release -r testme4.nim`.

```
("0.0000420", 0)
("0.0000372", 3000)
("0.0000319", 6000)
("0.0000348", 9000)
("0.0000360", 12000)
("0.0000429", 15000)
("0.0000470", 18000)
("0.0000482", 21000)
("0.0000479", 24000)
("0.0000520", 27000)
("0.0000451", 30000)
("0.0000641", 33000)
("0.0000482", 36000)
("0.0000479", 39000)
("0.0000579", 42000)
```

This is now close to 10% of the time of the original Python code.

## Nim - Take 5

In [testme5.nim](///testme5.nim) we switch from using a sequence
to using an array with the correct size and sticking the values
into the correct slots in the array.

Run this with `nim c -d:release -r testme5.nim`.

```
("0.0000279", 0)
("0.0000060", 3000)
("0.0000050", 6000)
("0.0000050", 9000)
("0.0000062", 12000)
("0.0000050", 15000)
("0.0000060", 18000)
("0.0000050", 21000)
("0.0000050", 24000)
("0.0000050", 27000)
("0.0000050", 30000)
("0.0000050", 33000)
("0.0000050", 36000)
("0.0000050", 39000)
("0.0000062", 42000)
```

Now we are down to around 5 microseconds after the first loop.

## Nim - Take 6

For [testme6.nim](///testme6.nim) we put the main logic into a
`proc` instead of having global/module level code. Nim is able
to perform additional optimizations on code that is not global.

Run this with `nim c -d:release -r testme6.nim`.

```
("0.0000160", 0)
("0.0000031", 3000)
("0.0000021", 6000)
("0.0000031", 9000)
("0.0000019", 12000)
("0.0000019", 15000)
("0.0000019", 18000)
("0.0000021", 21000)
("0.0000021", 24000)
("0.0000019", 27000)
("0.0000019", 30000)
("0.0000021", 33000)
("0.0000021", 36000)
("0.0000019", 39000)
("0.0000019", 42000)
```

Now we are down to around 2 microseconds after the first loop.

## Nim - Take 7

To squeeze out a bit more performance, we use a different compile
switch for Nim that turns off more safety checks. This has no code
changes from take 6, just the compile flag.

Run this with `nim c -d:danger -r testme7.nim`.

```
("0.0000460", 0)
("0.0000019", 3000)
("0.0000012", 6000)
("0.0000010", 9000)
("0.0000010", 12000)
("0.0000010", 15000)
("0.0000010", 18000)
("0.0000021", 21000)
("0.0000019", 24000)
("0.0000019", 27000)
("0.0000021", 30000)
("0.0000019", 33000)
("0.0000021", 36000)
("0.0000019", 39000)
("0.0000021", 42000)
```

Now we are down to between 1 and 2 microseconds after the first loop.

## Nim - Take 8

Our [last change](///testme6.nim) is one that I should have realized
earlier. We change from using `foldl` from the `sequtils` module to add
up the values to using the `sum` proc from the `math` module.

The original Python code uses the Python `sum` function, but the Swift
code was using `reduce` which must have been what I was looking at when
I decided to use `foldl`.

Run this with `nim c -d:danger -r testme8.nim`.

```
("0.0000010", 0)
("0.0000010", 3000)
("0.0000010", 6000)
("0.0000012", 9000)
("0.0000010", 12000)
("0.0000012", 15000)
("0.0000010", 18000)
("0.0000012", 21000)
("0.0000010", 24000)
("0.0000012", 27000)
("0.0000010", 30000)
("0.0000010", 33000)
("0.0000010", 36000)
("0.0000010", 39000)
("0.0000010", 42000)
```

Now we are consistently at 1 microsecond including the first loop. Nice!
