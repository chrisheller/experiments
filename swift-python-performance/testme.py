import time

result = []
for it in range(15):
    start = time.time()
    for _ in range(3000):
        result.append(it)
    sum_ = sum(result)
    end = time.time()
    print(end - start, sum_)
    result = []
