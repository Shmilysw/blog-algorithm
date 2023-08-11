---
title: LeetCode 2786. 访问数组中的位置使分数最大
date: 2023-08-11
tags: [dp, 记忆化搜索]
---

---
## dp | 记忆化搜索

## [LeetCode 2786. 访问数组中的位置使分数最大](https://leetcode.cn/problems/visit-array-positions-to-maximize-score/)

<font color=#dca124>中等</font>

给你一个下标从 `0` 开始的整数数组 `nums` 和一个正整数 `x` 。

你 一开始 在数组的位置 `0` 处，你可以按照下述规则访问数组中的其他位置：

+ 如果你当前在位置 `i` ，那么你可以移动到满足 `i < j` 的 任意 位置 `j` 。
+ 对于你访问的位置 `i` ，你可以获得分数 `nums[i]` 。
+ 如果你从位置 `i` 移动到位置 `j` 且 `nums[i]` 和 `nums[j]` 的 奇偶性 不同，那么你将失去分数 `x` 。

请你返回你能得到的 最大 得分之和。

注意 ，你一开始的分数为 `nums[0]` 。

### 示例 1：
```
输入：nums = [2,3,6,1,9,2], x = 5
输出：13
解释：我们可以按顺序访问数组中的位置：0 -> 2 -> 3 -> 4 。
对应位置的值为 2 ，6 ，1 和 9 。因为 6 和 1 的奇偶性不同，所以下标从 2 -> 3 让你失去 x = 5 分。
总得分为：2 + 6 + 1 + 9 - 5 = 13 。
```
### 示例 2：
```
输入：nums = [2,4,6,8], x = 3
输出：20
解释：数组中的所有元素奇偶性都一样，所以我们可以将每个元素都访问一次，而且不会失去任何分数。
总得分为：2 + 4 + 6 + 8 = 20 。
```
### 提示：
+ 2 <= nums.length <= 10^5
+ 1 <= nums[i], x <= 10^6

```python
# dp 选或不选 
'''
1. 杖举选哪个  选或不选

不需要知道精确的信息：nums[i]
只需要知道 nums[i] 的奇偶性

杖举选哪个 适用于需要完全知道子序列相邻两数的信息
          最长递增子序列 O(n^2)

选或不选   1. 适用于子序列相邻数字无关
          2. 子序列相邻数字弱关联（奇偶性就只需要知道 0 或 1 的信息）
'''
class Solution:
    def maxScore(self, nums: List[int], x: int) -> int:
        n = len(nums)
        f = [-inf, -inf]
        f[nums[0] & 1] = nums[0]
        for i in range(1, n):
            d = nums[i] & 1
            f[d] = max(f[d] + nums[i], f[d ^ 1] + nums[i] - x)
        return max(f[0], f[1])
```
---
```python
# 记忆化搜索
'''
1. 杖举选哪个  选或不选

不需要知道精确的信息：nums[i]
只需要知道 nums[i] 的奇偶性

杖举选哪个 适用于需要完全知道子序列相邻两数的信息
          最长递增子序列 O(n^2)

选或不选   1. 适用于子序列相邻数字无关
          2. 子序列相邻数字弱关联（奇偶性就只需要知道 0 或 1 的信息）
'''
class Solution:
    def maxScore(self, nums: List[int], x: int) -> int:
        n = len(nums)
        @cache
        def dfs(i: int, j: int) -> int:
            if i == n:
                return 0
            v = nums[i]
            res = dfs(i + 1, v & 1) + v
            if v & 1 != j:
                res -= x
            return max(res, dfs(i + 1, j))
        return dfs(1, nums[0] & 1) + nums[0]
```
---
```cpp
class Solution {
public:
    // 记忆化搜索
    int n, x;
    vector<int> nums;
    long long dp[100001][2];
    long long dfs(int i, int j) {
        if (i == n)
            return 0;
        if (dp[i][j] != -1)
            return dp[i][j];
        long long res = INT_MIN / 2;
        // 选 或 不选
        if (j != (nums[i] & 1))
            res = max(res, dfs(i + 1, nums[i] & 1) + nums[i] - x);
        else 
            res = max(res, dfs(i + 1, nums[i] & 1) + nums[i]);
        res = max(res, dfs(i + 1, j));
        dp[i][j] = res;
        return res;
    }
    long long maxScore(vector<int>& nums, int x) {
        n = nums.size();
        this->nums = nums;
        this->x = x;
        memset(dp, -1, sizeof(dp));
        return dfs(1, nums[0] & 1) + nums[0]; 
    }
};
```