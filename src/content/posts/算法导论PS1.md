---
title: 算法导论PS1
published: 2025-09-16
description: ''
image: ''
tags: []
category: ''
draft: false 
lang: ''
---
![6.006PS1-1-1](./6.006photos/6.006PS1-1-1.png)

(a) $f_2 < f_1 < f_4 < f_3$
(b) $f_1 < f_4 < f_3 < f_2$
(c) $f_4 < f_1 < f_3 < f_2$

比较无穷大的阶即可

![6.006PS1-1-2](./6.006photos/6.006PS1-1-2.png)

![6.006PS1-1-2b](./6.006photos/6.006PS1-1-2b.png)

(a) $\Theta(n)$, 等比求和
(b) $\Theta(n\log n)$, $y$迭代$\log n$次, 每次时间复杂度为$\Theta (n)$.
(c) $\Theta(n)$, 注意到原式等价于$T(n, n) = \Theta (n) + T(n/2, n/2)$