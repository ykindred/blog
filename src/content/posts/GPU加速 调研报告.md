---
title: GPU加速 调研报告
published: 2026-07-21
description: ''
image: ''
tags: []
category: ''
draft: false 
lang: ''
---
## 调研背景与问题
本次调研为vsag GPU 索引构建加速与显存优化课题的相关调研, 主要关注两个问题:
1. VSAG现有索引构建过程中, 哪些模块适合GPU并行化
2. 整理已有的相关工作

## VSAG 目前已有的索引类型
1. 稠密向量图索引: HNSW, freshHNSW, HGraph, DiskANN
2. 稠密向量分桶索引: IVF
3. 分区索引: Pyramid
4. BruteForce
5. 稀疏向量倒排索引: SparseIndex、SINDI