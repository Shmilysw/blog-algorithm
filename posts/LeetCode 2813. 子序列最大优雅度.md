---
title: LeetCode 2813. 子序列最大优雅度
date: 2023-08-07
tags: [反悔贪心]
---

---
## bfs + 二分

## [LeetCode 2813. 子序列最大优雅度](https://leetcode.cn/problems/maximum-elegance-of-a-k-length-subsequence/description/)

<font color=red>困难</font>

给你一个长度为 `n` 的二维整数数组 `items` 和一个整数 `k` 。

`items[i] = [profiti, categoryi]`，其中 `profiti` 和 `categoryi` 分别表示第 i 个项目的利润和类别。

现定义 `items` 的 子序列 的 优雅度 可以用 `total_profit + distinct_categories2` 计算，

其中 `total_profit` 是子序列中所有项目的利润总和，`distinct_categories` 是所选子序列所含的所有类别

中不同类别的数量。你的任务是从 `items` 所有长度为 `k` 的子序列中，找出 最大优雅度 。

用整数形式表示并返回 `items` 中所有长度恰好为 `k` 的子序列的最大优雅度。

注意：数组的子序列是经由原数组删除一些元素（可能不删除）而产生的新数组，且删除不改变其余元素相对顺

序。

### 示例 1：
```
输入：items = [[3,2],[5,1],[10,1]], k = 2
输出：17
解释：
在这个例子中，我们需要选出长度为 2 的子序列。
其中一种方案是 items[0] = [3,2] 和 items[2] = [10,1] 。
子序列的总利润为 3 + 10 = 13 ，子序列包含 2 种不同类别 [2,1] 。
因此，优雅度为 13 + 22 = 17 ，可以证明 17 是可以获得的最大优雅度。 
```

### 示例 2：
```
输入：items = [[3,1],[3,1],[2,2],[5,3]], k = 3
输出：19
解释：
在这个例子中，我们需要选出长度为 3 的子序列。 
其中一种方案是 items[0] = [3,1] ，items[2] = [2,2] 和 items[3] = [5,3] 。
子序列的总利润为 3 + 2 + 5 = 10 ，子序列包含 3 种不同类别 [1, 2, 3] 。 
因此，优雅度为 10 + 32 = 19 ，可以证明 19 是可以获得的最大优雅度。
```

### 示例 3：
```
输入：items = [[1,1],[2,1],[3,1]], k = 3
输出：7
解释：
在这个例子中，我们需要选出长度为 3 的子序列。
我们需要选中所有项目。
子序列的总利润为 1 + 2 + 3 = 6，子序列包含 1 种不同类别 [1] 。
因此，最大优雅度为 6 + 12 = 7 。
```

### 提示：
+ 1 <= items.length == n <= 10^5
+ items[i].length == 2
+ items[i][0] == profiti
+ items[i][1] == categoryi
+ 1 <= profiti <= 10^9
+ 1 <= categoryi <= n 
+ 1 <= k <= n

```python
"""
如何比较两种方案的优劣？

比较相对值，比算绝对值要方便
total_profit 
distinct_categories

找到一个 base
先选最大的 k 个利润，这可能是一个答案

考虑下一个项目要不要选

由于利润从大到小排序，利润和 total_profit 不会变大
所以重点就在 distinct_categories 能不能变大？
分类讨论：
1. 如果新添加的项目的类别之前选过了，那么 distinct_categories 不会变大
2. 如果新添加的项目的类别之前没选过（没出现过）
2.1 如果移除的项目的类别只有一个，那么 distinct_categories-1+1，不变，不行
2.2 如果移除的项目的类别有多个，那么 distinct_categories+1，这种情况就是可以的
    - 选一个利润最小的移除，用一个栈（数组）维护

"""
class Solution:
    def findMaximumElegance(self, items: List[List[int]], k: int) -> int:
        # 利润从大到小排序
        items.sort(key=lambda x: -x[0])
        ans = total_profit = 0
        vis = set()
        dup = []  # 重复类别的利润
        for i, (profit, category) in enumerate(items):
            if i < k:
                total_profit += profit
                if category not in vis:
                    vis.add(category)
                else:
                    dup.append(profit)
            elif dup and category not in vis:
                vis.add(category)
                total_profit -= dup.pop()
                total_profit += profit
            ans = max(ans, total_profit + len(vis) * len(vis))
        return ans
```
---
```cpp
class Solution {
public:
    long long findMaximumElegance(vector<vector<int>> &items, int k) {
        // 把利润从大到小排序
        sort(items.begin(), items.end(), [](const auto &a, const auto &b) {
            return a[0] > b[0];
        });
        long long ans = 0, total_profit = 0;
        unordered_set<int> vis;
        stack<int> duplicate; // 重复类别的利润
        for (int i = 0; i < items.size() ; i ++ ) {
            int profit = items[i][0], category = items[i][1];
            if (i < k) {
                total_profit += profit;
                if (!vis.insert(category).second) // 重复类别
                    duplicate.push(profit);
            } else if (!duplicate.empty() && vis.insert(category).second) {
                total_profit += profit - duplicate.top(); // 选一个重复类别中的最小利润替换
                duplicate.pop();
            } // else：比前面的利润小，而且类别还重复了，选它只会让 totalProfit 变小，vis.size() 不变，优雅度不会变大
            ans = max(ans, total_profit + (long long) vis.size() * (long long) vis.size());
        }
        return ans;
    }
};
```