---
title: 笔记 FGIM (FGIM: a Fast Graph-based Indexes Merging Framework for Approximate Nearest Neighbor Search)
published: 2026-07-23
description: ''
image: ''
tags: []
category: ''
draft: false 
lang: ''
---
[链接](https://arxiv.org/pdf/2603.21710)

论文的核心思想: 多个PG -> 合并成一个近似k-NNG -> 精炼 -> 最终PG
FGIM的核心步骤如下:
1. PGs to k-NNG: 复用原索引内部边, 并通过cross-querying找到跨索引候选邻居
2. k-NNG refinement: 用精简版的NN-Descent修正不准确的跨图邻居, 并修复零入度节点
3. k-NNG to PG: 重新执行剪枝和连通性增强, 得到适合ANNS的图

## 问题定义
假设有两个向量集$X_1 = \set{x_1, x_2, ...}, X_2 = \set{y_1, y_2, ...}$, 分别有图索引$G_1, G_2$, 现在需要找出$X_1\cup X_2$的图索引$\hat{G}$.

论文希望优化三个目标:
1. 尽量降低合并已有图的成本. 也就是说, 尽量提高在全集上建图的成本减去合并已有图的成本.
2. 提高合并后的QPS
3. 提高合并后的Recall

## 核心观察
作者做了一个很关键的统计实验：把数据随机切成多个子集，分别建图，再和全集直接建出的图比较。结果发现，一部分原有邻居会继续保留；同时，在全集图中新出现的边中，跨子图边通常比新出现的子图内部边更多。

以两个子图为例, HNSW 中大约有一半原邻居能保留下来, 因此, 合理的策略是: 保留旧边+发现跨图边