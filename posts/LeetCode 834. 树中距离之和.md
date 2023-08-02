---
title: LeetCode 834. 树中距离之和
date: 2023-08-02
tags: [树形dp, dp]
---

---
## 树形dp

## [LeetCode 834. 树中距离之和](https://leetcode.cn/problems/sum-of-distances-in-tree/description/)

给定一个无向、连通的树。树中有 n 个标记为 0...n-1 的节点以及 n-1 条边 。

给定整数 n 和数组 edges ， edges[i] = [ai, bi]表示树中的节点 ai 和 bi 之间有一条边。

返回长度为 n 的数组 answer ，其中 answer[i] 是树中第 i 个节点与所有其他节点之间的距离之和。

### 示例 1:
```
输入: n = 6, edges = [[0,1],[0,2],[2,3],[2,4],[2,5]]
输出: [8,12,6,10,10,10]
解释: 树如图所示。
我们可以计算出 dist(0,1) + dist(0,2) + dist(0,3) + dist(0,4) + dist(0,5) 
也就是 1 + 1 + 2 + 2 + 2 = 8。 因此，answer[0] = 8，以此类推。
```
### 示例 2:
```
输入: n = 1, edges = []
输出: [0]
```
### 示例 3:
```
输入: n = 2, edges = [[1,0]]
输出: [1,1]
```

### 提示:
+ 1 <= n <= 3 * 10^4
+ edges.length == n - 1
+ edges[i].length == 2
+ 0 <= ai, bi < n
+ ai != bi
+ 给定的输入保证为有效的树

```cpp
// 换根dp
/*
    ans[0] 表示根节点的子树的节点个数
    size[] -> 当前节点为根的子树的节点个数
    size[u] += size[j]
    ans[j] = ans[u] + n - 2 * size[j]
*/

const int N = 3e4 + 10, M = 2 * N;

class Solution {
public:
    int n;
    int h[N], e[M], ne[M], idx;
    vector<int> ans;
    vector<int> size;
    void add(int a, int b) {
        e[idx] = b, ne[idx] = h[a], h[a] = idx ++ ;
    }
    void dfs1(int u, int fa, int depth) {
        ans[0] += depth;
        for (int i = h[u]; ~i ; i = ne[i]) {
            int j = e[i];
            if (j == fa) continue;
            dfs1(j, u, depth + 1);
            size[u] += size[j]; 
        }
    }
    void dfs2(int u, int fa) {
        for (int i = h[u]; ~i ; i = ne[i]) {
            int j = e[i];
            if (j == fa) continue;
            ans[j] = ans[u] + n - 2 * size[j];
            dfs2(j, u);
        }
    }
    vector<int> sumOfDistancesInTree(int n, vector<vector<int>>& edges) {
        memset(h, -1, sizeof h);
        this->n = n;
        ans = vector<int>(n, 0);
        size = vector<int>(n, 1);
        for (auto &e: edges) {
            int x = e[0], y = e[1];
            add(x, y), add(y, x);
        }
        dfs1(0, -1, 0); // 计算size
        dfs2(0, -1); // 计算ans
        return ans;
    }
};
```