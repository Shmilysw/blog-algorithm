---
title: LeetCode 2850. 将石头分散到网格图的最少移动次数
date: 2023-09-12
tags: [全排列]
---

---

## 全排列, next_permutation

## [LeetCode 2850. 将石头分散到网格图的最少移动次数](https://leetcode.cn/problems/minimum-moves-to-spread-stones-over-grid/)

<font color=#dca124>中等</font>

给你一个大小为 3 * 3 ，下标从 0 开始的二维整数矩阵 grid ，分别表示每一个格子里石头的数目。网格图中总共恰好有 9 个石头，一个格子里可能会有 多个 石头。

每一次操作中，你可以将一个石头从它当前所在格子移动到一个至少有一条公共边的相邻格子。

请你返回每个格子恰好有一个石头的 最少移动次数 。

### 示例 1：
```
输入：grid = [[1,1,0],[1,1,1],[1,2,1]]
输出：3
解释：让每个格子都有一个石头的一个操作序列为：
1 - 将一个石头从格子 (2,1) 移动到 (2,2) 。
2 - 将一个石头从格子 (2,2) 移动到 (1,2) 。
3 - 将一个石头从格子 (1,2) 移动到 (0,2) 。
总共需要 3 次操作让每个格子都有一个石头。
让每个格子都有一个石头的最少操作次数为 3 。
```
### 示例 2：
```
输入：grid = [[1,3,0],[1,0,0],[1,0,3]]
输出：4
解释：让每个格子都有一个石头的一个操作序列为：
1 - 将一个石头从格子 (0,1) 移动到 (0,2) 。
2 - 将一个石头从格子 (0,1) 移动到 (1,1) 。
3 - 将一个石头从格子 (2,2) 移动到 (1,2) 。
4 - 将一个石头从格子 (2,2) 移动到 (2,1) 。
总共需要 4 次操作让每个格子都有一个石头。
让每个格子都有一个石头的最少操作次数为 4 。
```
### 提示：
+ grid.length == grid[i].length == 3
+ 0 <= grid[i][j] <= 9
+ grid 中元素之和为 9 。


### 函数 

```
全排列是排列数学中常用的算法之一，而C++ STL中就提供了内置的全排列函数 next_permutation.
next_permutation是一个原地算法（会直接改变这个集合，而不是返回一个集合），
它对一个可以遍历的集合（如string，如vector），将迭代器范围 [first, last] 的排列 
排列到下一个排列（第一个是名词，第二个是动词，第三个是名词），其中所有排列的
集合默认按照operator < 或者 字典序 或者 按照输入到第三个参数 comp 的排列方法排列。
如果存在这样的“下一个排列”，返回true并执行排列，否则返回false。
```
---
```cpp
class Solution {
public:
    int minimumMoves(vector<vector<int>>& g) {
        // next_permutation 全排列
        int n = g.size(), m = g[0].size();
        vector<pair<int, int>> from, to;
        for (int i = 0; i < 3 ; i ++ ) {
            for (int j = 0; j < 3 ; j ++ ) {
                if (g[i][j] > 1) {
                    for (int k = 1; k < g[i][j] ; k ++ )
                        from.push_back({i, j});
                } else if (g[i][j] == 0) {
                    to.push_back({i, j});
                }
            }
        }
        int res = 2e9;
        do {
            int tmp = 0;
            for (int i = 0; i < from.size() ; i ++ ) {
                auto x = from[i].first, y = from[i].second;
                auto tx = to[i].first, ty = to[i].second;
                tmp += abs(x - tx) + abs(y - ty);
            }
            res = min(res, tmp);
        } while (next_permutation(from.begin(), from.end()));
        return res;
    }
};
```
---
```python
class Solution:
    def minimumMoves(self, grid: List[List[int]]) -> int:
        from_ = []
        to = []
        for i, row in enumerate(grid):
            for j, cnt in enumerate(row):
                if cnt > 1:
                    from_.extend([(i, j)] * (cnt - 1))
                elif cnt == 0:
                    to.append((i, j))

        ans = inf
        for from2 in permutations(from_):
            total = 0
            for (x1, y1), (x2, y2) in zip(from2, to):
                total += abs(x1 - x2) + abs(y1 - y2)
            ans = min(ans, total)
        return ans
```