---
title: LeetCode 2569. 更新数组后处理求和查询
date: 2023-07-31
tags: [线段树]
---

---
## 线段树

## [LeetCode 2569. 更新数组后处理求和查询](https://leetcode.cn/problems/handling-sum-queries-after-update/)

`困难`

给你两个下标从 0 开始的数组 nums1 和 nums2 ，和一个二维数组 queries 表示一些操作。总共有 3 种类型的操作：

+ 1、操作类型 1 为 queries[i] = [1, l, r] 。你需要将 nums1 从下标 l 到下标 r 的所有 0 反转成 1 并且所有 1 反转成 0 。l 和 r 下标都从 0 开始。
+ 2、操作类型 2 为 queries[i] = [2, p, 0] 。对于 0 <= i < n 中的所有下标，令 nums2[i] = nums2[i] + nums1[i] * p 。
+ 3、操作类型 3 为 queries[i] = [3, 0, 0] 。求 nums2 中所有元素的和。

请你返回一个数组，包含所有第三种操作类型的答案。

### 示例 1：

```
输入：nums1 = [1,0,1], nums2 = [0,0,0], queries = [[1,1,1],[2,1,0],[3,0,0]]
输出：[3]
解释：第一个操作后 nums1 变为 [1,1,1] 。第二个操作后，nums2 变成 [1,1,1] ，所以第三个操作的答案为 3 。所以返回 [3] 。
```

### 示例 2：

```
输入：nums1 = [1], nums2 = [5], queries = [[2,0,0],[3,0,0]]
输出：[5]
解释：第一个操作后，nums2 保持不变为 [5] ，所以第二个操作的答案是 5 。所以返回 [5] 。
```

提示：

+ 1 <= nums1.length,nums2.length <= 10^5
+ nums1.length = nums2.length
+ 1 <= queries.length <= 10^5
+ queries[i].length = 3
+ 0 <= l <= r <= nums1.length - 1
+ 0 <= p <= 10^6
+ 0 <= nums1[i] <= 1
+ 0 <= nums2[i] <= 10^9

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