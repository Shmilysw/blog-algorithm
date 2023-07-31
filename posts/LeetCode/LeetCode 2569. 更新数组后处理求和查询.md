---
title: LeetCode 2801. 统计范围内的步进数字数目
date: 2023-07-31
tags: [线段树, 算法]
---

---
## 模板

## 线段树

[这是个模板](https://flaribbit.github.io/vitepress-theme-sakura/)

```cpp
// 线段树
typedef long long LL;
const int N = 100010;

int n, m;
int w[N];

struct Node {
    int l, r;
    LL sum, add;
} tr[N * 4];

void pushup(int u) {
    tr[u].sum = tr[u << 1].sum + tr[u << 1 | 1].sum;
}

void pushdown(int u) {
    auto &root = tr[u], &left = tr[u << 1], &right = tr[u << 1 | 1];
    if (root.add) {
        left.add = 1 - left.add;
        left.sum = (left.r - left.l + 1) - left.sum;
        right.add = 1 - right.add;
        right.sum = (right.r - right.l + 1) - right.sum;
        root.add = 0;
    }
}

void build(int u, int l, int r) {
    if (l == r) tr[u] = {l, r, w[r], 0};
    else {
        tr[u] = {l, r, 0, 0};
        int mid = l + r >> 1;
        build(u << 1, l, mid), build(u << 1 | 1, mid + 1, r);
        pushup(u);
    }
}

LL query(int u, int l, int r) {
    if (tr[u].l >= l && tr[u].r <= r) return tr[u].sum;
    else {
        pushdown(u);
        int mid = tr[u].l + tr[u].r >> 1;
        LL sum = 0;
        if (l <= mid) sum = query(u << 1, l, r);
        if (r > mid) sum += query(u << 1 | 1, l, r);
        return sum;
    }
}

void modify(int u, int l, int r) {
    if (tr[u].l >= l && tr[u].r <= r) {
        tr[u].add = 1 - tr[u].add;
        tr[u].sum = (LL)(tr[u].r - tr[u].l + 1) - tr[u].sum;
    } else {
        pushdown(u);
        int mid = tr[u].l + tr[u].r >> 1;
        if (l <= mid) modify(u << 1, l, r);
        if (r > mid) modify(u << 1 | 1, l, r);
        pushup(u);
    }
}

class Solution {
public:
    vector<long long> handleQuery(vector<int>& a, vector<int>& b, vector<vector<int>>& q) {
        int n = a.size();
        LL sum = 0;
        for (int i = 0; i < n ; i ++ ) w[i + 1] = a[i];
        build(1, 1, n);
        vector<LL> res;
        for (int i = 0; i < n ; i ++ ) sum += b[i];
        for (auto &u: q) {
            if (u[0] == 1) modify(1, u[1] + 1, u[2] + 1);
            else if (u[0] == 2) sum += query(1, 1, n) * u[1];
            else res.push_back(sum);
        }
        return res;
    }
};
```