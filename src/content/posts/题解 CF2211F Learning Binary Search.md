---
title: 题解 CF2211F Learning Binary Search
published: 2026-04-24
description: ''
image: ''
tags: []
category: ''
draft: false 
lang: ''
---
## 前置
### 二分搜索树
把二分搜索的过程建成一棵二叉树即可. 此时每个节点对应唯一一个点`mid`, 也可以认为每个节点对应唯一一个二分搜索区间`[l, r]`. 二分搜索树共有`n`个节点.

### 范德蒙德恒等式
见"组合数学"板块. 我们有
$$
\sum_{i = 0}^N \binom{x + i}{x}\binom{y + N - i}{y} = \binom{x + y + N + 1}{x + y + 1}.
$$

### 曲棍球棒
$$
\sum_{i = 0}^N \binom{x + i}{x} = \binom{x + N + 1}{x + 1}
$$

## 题意
给定一个函数如下:
```pseudo
function f(a, k, l, r):
   if a does not contain k:
      return 0
   mid = floor((l+r) / 2)
   if a[mid]==k:
      return 1
   else if a[mid]<k:
      return 1+f(a, k, mid+1, r)
   else:
      return 1+f(a, k, l, mid-1)
```
对于所有的单调不减的且$1\le a_i \le m$的序列$a$和$1\le k \le m$, 求和, 模$676, 767, 677$.

## 解法
### 求和对象的改变
容易发现, 该函数即为二分搜索找到$k$的次数. 所以我们可以建立二分搜索树, 对于每个节点, 考虑有多少个$(a, k)$使得搜索在此处停止, 再乘以该节点的深度即可.

### 注意点1
注意到$[l, r]$会被访问, 当且仅当原数组中所有k都被包含在$[l, r]$中. 证明好证, 主要是难想到. 因为如果k被分割成两段, 那在分割点就已经返回了, 不会到下面. 同时, 注意到搜索在$[l, r]$处停止, 当且仅当$a_{mid} = k$. 也就是说, 当数组中$k$占据的区间为$[x, y]$时, 要求$l \le x\le y\le r$且$mid\in [x, y]$.

### 考虑容斥原理
先考虑$mid\in [x, y]$这个条件, 实际上要求$a_{mid} = k$. 他的种类数是(1)
$$
\binom{mid + k - 2}{k - 1}\binom{n - mid + m - k}{m - k}
$$

如果$l\ne 1$, 我们需要减去$l < x$的情况, 由于mid处已经是k了, $l < x$的情况说明$a_{l - 1} = k$且$a_{mid} = k$. 这种情况的种类数是(2):

$$
\binom{(l - 2) + k - 1}{k - 1}\binom{n - mid + m - k}{m - k}
$$

$r \ne n$时, 右边同理(3):
$$
\binom{mid + k - 2}{k - 1}\binom{(n - r - 1) + m - k}{m - k}
$$

如果$l\ne 1$且$r\ne n$, 我们还需要加上(4):
$$
\binom{l + k - 3}{k - 1}\binom{n - r + m - k - 1}{m - k}
$$

### 利用范德蒙德卷积进行变换
我们考虑对于所有的$k\in [1, m]$对上述式子求和. 利用范德蒙德卷积
$$
\sum_{i = 0}^{N}\binom{x + i}{x}\binom{y + N - i}{y} = \binom{x + y + N + 1}{x + y + 1}
$$

(1)式为:
$$
\binom{n + m - 1}{m - 1}
$$

(2)式为:
$$
\binom{l + n + m - mid - 2}{m - 1}
$$

(3)式为:
$$
\binom{mid + n + m - r - 2}{m - 1}
$$

(4)式为:
$$
\binom{l + n + m - r - 3}{m - 1}
$$

最后, 对于每个节点使用容斥统计即可.

## 代码
[提交记录](https://codeforces.com/contest/2211/submission/372357680)
```cpp
void solution() {
    /* code here */
    ll n, m;
    cin >> n >> m;
    mint ret = 0;
    auto dfs = [&](auto&& self, ll l, ll r, int d) -> void {
        if (l > r) {
            return;
        }
        ll mid = (l + r) / 2;
        ret += f.nCr(n + m - 1, m - 1) * d;
        if (l == 1 && r == n) {
            // mid - 1个位置填 [1, k]
            // n - mid个位置填 [k, m]
        } else if (l == 1) {
            ret -= f.nCr(mid + n - r + m - 2, m - 1) * d;
        } else if (r == n) {
            ret -= f.nCr(l - 2 + n - mid + m, m - 1) * d;
        } else {
            ret -= f.nCr(l - 2 + n - mid + m, m - 1) * d;
            ret -= f.nCr(mid + n - r + m - 2, m - 1) * d;
            ret += f.nCr(l + n - r + m - 3, m - 1) * d;
        }
        self(self, l, mid - 1, d + 1);
        self(self, mid + 1, r, d + 1);
    };
    dfs(dfs, 1, n, 1);
    cout << ret.val << '\n';
}
```
