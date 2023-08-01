---
title: Leetcode 2681. 英雄的力量
date: 2023-08-01
tags: [思维, 贡献法]
---

---
## 贡献法

## [Leetcode 2681. 英雄的力量](https://leetcode.cn/problems/power-of-heroes/description/)

`困难`

给你一个下标从 0 开始的整数数组 nums ，它表示英雄的能力值。如果我们选出一部分英雄，这组英雄的 力量 定义为：

+ i0 ，i1 ，... ik 表示这组英雄在数组中的下标。那么这组英雄的力量为 max(nums[i0],nums[i1] ... nums[ik])2 * min(nums[i0],nums[i1] ... nums[ik]) 。

请你返回所有可能的 非空 英雄组的 力量 之和。由于答案可能非常大，请你将结果对 10^9 + 7 取余。

### 示例 1：
```
输入：nums = [2,1,4]
输出：141
解释：
第 1 组：[2] 的力量为 22 * 2 = 8 。
第 2 组：[1] 的力量为 12 * 1 = 1 。
第 3 组：[4] 的力量为 42 * 4 = 64 。
第 4 组：[2,1] 的力量为 22 * 1 = 4 。
第 5 组：[2,4] 的力量为 42 * 2 = 32 。
第 6 组：[1,4] 的力量为 42 * 1 = 16 。
第​ ​​​​​​7 组：[2,1,4] 的力量为 42​​​​​​​ * 1 = 16 。
所有英雄组的力量之和为 8 + 1 + 64 + 4 + 32 + 16 + 16 = 141 。
```
### 示例 2：
```
输入：nums = [1,1,1]
输出：7
解释：总共有 7 个英雄组，每一组的力量都是 1 。所以所有英雄组的力量之和为 7 。
```
### 提示：
+ 1 <= nums.length <= 10^5
+ 1 <= nums[i] <= 10^9

```python
'''
每个下标 i 的贡献度 cur
cur = x ^ 2 * S 
    {: x * x * (x + S)
    }: Snew = 2 * S + x
'''
class Solution:
    def sumOfPower(self, nums: List[int]) -> int:
        nums.sort()
        MOD = 10 ** 9 + 7
        res = s = 0
        for x in nums:
            res = (res + x * x * (x + s)) % MOD
            s = (2 * s + x) % MOD
        return res
```
---
注意数据溢出（取模）
```cpp
typedef long long LL;
const int mod = 1e9 + 7;

class Solution {
public:
    int sumOfPower(vector<int>& nums) {
        int n = nums.size();
        sort(nums.begin(), nums.end());
        int res = 0, sum = 0;
        for (int i = 0; i < n; i ++ ) {
            res = (res + (LL)(nums[i]) * nums[i] % mod * (sum + nums[i])) % mod;
            sum = ((LL)(sum) * 2 % mod + nums[i]) % mod;
        }
        return res;
    }
};
```