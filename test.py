import io
import sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')


def pv_f(c, r, n, when=1):
    import numpy as np  #导入numpy库
    c = np.array(c)
    r = np.array(r)
    if when == 1:
        n = np.arange(1, n + 1)
    else:
        n = np.arange(0, n)
    pv = c / (1 + r)**n
    return pv.sum()


c = 20000
r = 0.05
n = 5
#调用前文定义的函数pv_f(c,r,n,when=1)
pv1 = pv_f(c, r, n, when=1)
print("普通年金现值（年末）：%.2f" % pv1)
#如果是预付年金，则when=0
pv2 = pv_f(c, r, n, when=0)
print("预付年金现值（年初）：%.2f" % pv2)
