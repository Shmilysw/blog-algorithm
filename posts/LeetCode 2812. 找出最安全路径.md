---
title: LeetCode 2812. 找出最安全路径
date: 2023-08-07
tags: [bfs, 二分]
---

---
## bfs + 二分

## [LeetCode 2812. 找出最安全路径](https://leetcode.cn/problems/find-the-safest-path-in-a-grid/description/)

<font color=#dca124>中等</font>

给你一个下标从 0 开始、大小为 n x n 的二维矩阵 grid ，其中 (r, c) 表示：

+ 如果 grid[r][c] = 1 ，则表示一个存在小偷的单元格
+ 如果 grid[r][c] = 0 ，则表示一个空单元格

你最开始位于单元格 (0, 0) 。在一步移动中，你可以移动到矩阵中的任一相邻单元格，包括存在小偷的单元格。

矩阵中路径的 安全系数 定义为：从路径中任一单元格到矩阵中任一小偷所在单元格的 最小 曼哈顿距离。

返回所有通向单元格 (n - 1, n - 1) 的路径中的 最大安全系数 。

单元格 (r, c) 的某个 相邻 单元格，是指在矩阵中存在的 (r, c + 1)、(r, c - 1)、(r + 1, c) 和 (r - 1, c) 之一。

两个单元格 (a, b) 和 (x, y) 之间的 曼哈顿距离 等于 | a - x | + | b - y | ，其中 |val| 表示 val 的绝对值。

### 示例 1：
```
输入：grid = [[1,0,0],[0,0,0],[0,0,1]]
输出：0
解释：从 (0, 0) 到 (n - 1, n - 1) 的每条路径都经过存在小偷的单元格 (0, 0) 和 (n - 1, n - 1) 。
```

### 示例 2：
```
输入：grid = [[0,0,1],[0,0,0],[0,0,0]]
输出：2
解释：
上图所示路径的安全系数为 2：
- 该路径上距离小偷所在单元格（0，2）最近的单元格是（0，0）。它们之间的曼哈顿距离为 | 0 - 0 | + | 0 - 2 | = 2 。
可以证明，不存在安全系数更高的其他路径。
```

### 示例 3：
```
输入：grid = [[0,0,0,1],[0,0,0,0],[0,0,0,0],[1,0,0,0]]
输出：2
解释：
上图所示路径的安全系数为 2：
- 该路径上距离小偷所在单元格（0，3）最近的单元格是（1，2）。它们之间的曼哈顿距离为 | 0 - 1 | + | 3 - 2 | = 2 。
- 该路径上距离小偷所在单元格（3，0）最近的单元格是（3，2）。它们之间的曼哈顿距离为 | 3 - 3 | + | 0 - 2 | = 2 。
可以证明，不存在安全系数更高的其他路径。
```

### 提示：
+ 1 <= grid.length == n <= 400
+ grid[i].length == n
+ grid[i][j] 为 0 或 1
+ grid 至少存在一个小偷

```cpp
/*
多源 bfs + 二分
以所有小偷所在位置为源点跑多源bfs，这样就求出了矩阵各个位置的安全系数，然后二分枚举答案；
设当前枚举值为res，判断当前枚举值是否可行：通过bfs判断(0,0)与(n−1,n−1)之间是否存在这样的路径，
使得该路径上任意位置的安全系数都不小于res。
*/
typedef pair<int, int> PII;
class Solution {
public:
    int maximumSafenessFactor(vector<vector<int>>& grid) {
        int n = grid.size(), m = grid[0].size();
        int dir[4][2] = {0, 1, 1, 0, -1, 0, 0, -1};
        int dis[n][m];
        memset(dis, -1, sizeof dis);
        queue<PII> q;
        for (int i = 0; i < n ; i ++ ) {
            for (int j = 0; j < m ; j ++ ) {
                if (grid[i][j] == 1) {
                    q.push({i, j});
                    dis[i][j] = 0;
                }
            }
        }
        // 多源 bfs
        while (!q.empty()) {
            PII p = q.front();
            q.pop();
            int i = p.first, j = p.second;
            for (int k = 0; k < 4 ; k ++ ) {
                int ii = i + dir[k][0], jj = j + dir[k][1];
                if (ii < 0 || jj < 0 || ii >= n || jj >= m || dis[ii][jj] >= 0)
                    continue;
                q.push({ii, jj});
                dis[ii][jj] = dis[i][j] + 1;
            }
        }
        // check
        auto check = [&](int lim) {
            bool vis[n][m];
            memset(vis, false, sizeof vis);
            queue<PII> q;
            q.push({0, 0});
            vis[0][0] = true;
            while (!q.empty()) {
                PII p = q.front();
                q.pop();
                int i = p.first, j = p.second;
                for (int k = 0; k < 4 ; k ++ ) {
                    int ii = i + dir[k][0], jj = j + dir[k][1];
                    if (ii < 0 || jj < 0 || ii >= n || jj >= m || dis[ii][jj] < lim || vis[ii][jj])
                        continue;
                    q.push({ii, jj});
                    vis[ii][jj] = true;
                }
            }
            return vis[n - 1][m - 1];
        };
        // 二分
        // 判断(0, 0) (n - 1, m - 1)位置
        int left = 0, right = min(dis[0][0], dis[n - 1][m - 1]);
        while (left < right) {
            int mid = left + right + 1 >> 1;
            if (check(mid)) left = mid;
            else right = mid - 1;
        }
        return left;
    }
};
```