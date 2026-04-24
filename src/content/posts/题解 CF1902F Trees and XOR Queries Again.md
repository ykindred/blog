---
title: 题解 CF1902F Trees and XOR Queries Again
published: 2026-04-24
description: ''
image: ''
tags: []
category: ''
draft: false 
lang: ''
---
https://codeforces.com/contest/1902/problem/F

### 题意
有一棵$n$个顶点的树, 每个节点有一个权$a_i$, 给定$q$个查询, 每次查询给定$x, y, k$, 判断$x$到$y$的简单路径上的点权集合是否存在某个子集异或和为$k$.
$2 \le n \le 2e5$, 
$0\le a_i\le 2^{20} - 1$, 
$1\le q\le 2e5$, 
$1\le x, y\le n$, 
$0\le k\le 2^{20} - 1$.

### 一些直觉
对于子集异或和的问题, 最好的方法就是使用线性基. 本题的问题在于: 如何维护出$x$到$y$的简单路径上的线性基? 我们会发现他等于$x$到$lca(x, y)$的线性基与$y$到$lca(x, y)$的线性基合并(合并的复杂度: $O(log^2 V)\approx 400$).

现在的问题在于, 我们很好维护$x$到根的线性基, 但是如何维护$x$到某个祖宗的线性基? 我们注意到线性基具有优先级这个概念, 越靠前的基越优先, 于是, 我们每次维护线性基的时候, 如果出现两个基都能当做某一位的主元, 那么让深度更大的基当做主元即可, 深度小的基往下消元. 这样, 深度大的基一定更靠前. 所以每次如果$lca(x, y)$的深度是$d$, 我们只需要用线性基中深度大于$d$的基去消$k$, 本题也就解决了.

### 解题过程
1. 读入, 预处理
2. 从根开始计算每个节点到根的简单路径上的线性基, 同时维护每个基对应的深度.
3. 对于每个查询, 先算出$x$到根的线性基与$y$到根线性基合并的结果. 然后用合并后的线性基中深度大于等于$lca(x, y)$的基去判断能否组成$k$即可.

### AC代码
[提交记录](https://codeforces.com/contest/1902/submission/372265592)
```cpp
#include <bits/stdc++.h>
using namespace std;
using ll = long long;
using i128 = __int128;
using ull = unsigned long long;
using u32 = unsigned;
using u64 = unsigned long long;
using u128 = __uint128_t;
constexpr int INF = 0x3f3f3f3f;
constexpr ll INFLL = 2e18;

/* const */
constexpr double EPS = 1e-8;
constexpr ll MOD = 998244353;
constexpr int N = 1e6 + 50;

/* struct */

/* variable */

/* function */

void preprocess() {}
void solution() {
    /* code here */
    int n;
    cin >> n;
    vector<int> arr(n);
    for (int i = 0; i < n; i++) {
        cin >> arr[i];
    }
    vector adj(n, vector<int>());
    for (int i = 0; i < n - 1; i++) {
        int u, v;
        cin >> u >> v;
        u--, v--;
        adj[u].emplace_back(v);
        adj[v].emplace_back(u);
    }
    vector<array<int, 22>> up(n);
    queue<int> q;
    q.emplace(0);
    vector<int> ord;
    vector<int> vis(n);
    vector<int> d(n);
    up[0][0] = 0;
    d[0] = 0;
    vis[0] = 1;
    while (!q.empty()) {
        auto x = q.front();
        q.pop();
        ord.emplace_back(x);
        for (const auto& y : adj[x]) {
            if (!vis[y]) {
                q.emplace(y);
                vis[y] = 1;
                up[y][0] = x;
                d[y] = d[x] + 1;
            }
        }
    }
    for (int j = 1; j <= 20; j++) {
        for (int i = 0; i < n; i++) {
            up[i][j] = up[up[i][j - 1]][j - 1];
        }
    }
    auto lca = [&](ll a, ll b) -> ll {
        if (d[a] < d[b]) {
            swap(a, b);
        }
        for (int i = 20; i >= 0; i--) {
            if (d[up[a][i]] >= d[b]) {
                a = up[a][i];
            }
        }
        for (int i = 20; i >= 0; i--) {
            if (up[a][i] != up[b][i]) {
                a = up[a][i], b = up[b][i];
            }
        }
        if (a != b) {
            a = up[a][0], b = up[b][0];
        }
        return a;
    };
    struct item {
        int b = 0;
        int d = 0;
    };
    using Base = array<item, 20>;
    vector<array<item, 20>> base(n);
    auto insert = [&](item t, Base& a) -> bool {
        for (int i = 19; i >= 0; i--) {
            if (t.b >> i & 1) {
                if (a[i].b) {
                    if (t.d > a[i].d) {
                        swap(t.b, a[i].b);
                        swap(t.d, a[i].d);
                    }
                    t.b ^= a[i].b;
                } else {
                    a[i] = t;
                    return true;
                }
            }
        }
        return false;
    };
    for (int i = 0; i < n; i++) {
        int v = ord[i];
        base[v] = base[up[v][0]];
        insert({ arr[v], d[v] }, base[v]);
    }


    auto join = [&](const Base& a, Base& b) {
        for (int i = 19; i >= 0; i--) {
            if (a[i].b) {
                insert(a[i], b);
            }
        }
    };
    int sq;
    cin >> sq;
    for (int i = 0; i < sq; i++) {
        ll u, v, k;
        cin >> u >> v >> k;
        u--, v--;
        Base b{};
        join(base[u], b);
        join(base[v], b);
        bool flag = 1;
        int now = d[lca(u, v)];
        for (int j = 19; j >= 0; j--) {
            if (k >> j & 1) {
                if (b[j].b && b[j].d >= now) {
                    k ^= b[j].b;
                } else {
                    cout << "NO\n";
                    flag = 0;
                    break;
                }
            }
        }
        if (flag) {
            cout << "YES\n";
        }
    }
}
int main() {
    ios::sync_with_stdio(0), cin.tie(0);
    int t = 1;
    // cin >> t;
    preprocess();
    for (int i = 1; i <= t; i++) {
        solution();
    }
}
/* by ykindred */
```