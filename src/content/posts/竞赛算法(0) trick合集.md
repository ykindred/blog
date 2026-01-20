---
title: 竞赛算法(0) trick合集
published: 2025-12-03
description: ''
image: ''
tags: []
category: ''
draft: true
lang: ''
---
## 区间建图
[1, n + 1)的区间覆盖问题可以转化为图上问题, 具体来说就是将每个[l, r + 1)区间看作从l到r + 1的有向边, 覆盖问题即转化为路径问题.
1. [2125D](https://codeforces.com/contest/2125/problem/D)

## 分类
将某个集合分成几类, 然后思考这几类之间如何互相转化.
1. [2180C](https://codeforces.com/contest/2180/problem/C)(分成松紧两类)
2. [2152D](https://codeforces.com/contest/2152/problem/D)(分成2整幂(不能增加位数), 2整幂+1(若先除二则不能增加位数, 否则能增加位数), 其他(无论怎样都能增加位数)三类)