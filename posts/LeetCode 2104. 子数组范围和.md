---
title: LeetCode 2104. 子数组范围和
date: 2023-08-01
tags: [单调栈, 贡献法]
---

---
## 单调栈

## [LeetCode 2104. 子数组范围和](https://leetcode.cn/problems/sum-of-subarray-ranges/description/)

`中等`

给你一个整数数组 nums 。nums 中，子数组的 范围 是子数组中最大元素和最小元素的差值。

返回 nums 中 所有 子数组范围的 和 。

子数组是数组中一个连续 非空 的元素序列。

### 示例 1：
```
输入：nums = [1,2,3]
输出：4
解释：nums 的 6 个子数组如下所示：
[1]，范围 = 最大 - 最小 = 1 - 1 = 0 
[2]，范围 = 2 - 2 = 0
[3]，范围 = 3 - 3 = 0
[1,2]，范围 = 2 - 1 = 1
[2,3]，范围 = 3 - 2 = 1
[1,2,3]，范围 = 3 - 1 = 2
所有范围的和是 0 + 0 + 0 + 1 + 1 + 2 = 4
```
### 示例 2：
```
输入：nums = [1,3,3]
输出：4
解释：nums 的 6 个子数组如下所示：
[1]，范围 = 最大 - 最小 = 1 - 1 = 0
[3]，范围 = 3 - 3 = 0
[3]，范围 = 3 - 3 = 0
[1,3]，范围 = 3 - 1 = 2
[3,3]，范围 = 3 - 3 = 0
[1,3,3]，范围 = 3 - 1 = 2
所有范围的和是 0 + 0 + 0 + 2 + 0 + 2 = 4
```
### 示例 3：
```
输入：nums = [4,-2,-3,4,1]
输出：59
解释：nums 中所有子数组范围的和是 59
```

### 提示：

+ 1 <= nums.length <= 1000
+ -10^9 <= nums[i] <= 10^9

```cpp
class Solution {
public:
    long long subArrayRanges(vector<int>& nums) {
        // 单调栈 时间复杂度: O(n)
        int len = nums.size();
        // 分别存储左边的最小值、最大值、右边的最小值、最大值
        vector<int> lsmall(len), rsmall(len), llarge(len), rlarge(len);
        stack<int> stk;
        stk.push(-1);
        // 从左到右单调增栈，不能出栈时栈顶就是当前元素左侧最近的小于当前元素的节点
        for (int i = 0; i < len ; i ++ ) {
            while (stk.top() != -1 && nums[stk.top()] >= nums[i]) {
                stk.pop();
            }
            lsmall[i] = stk.top();
            stk.push(i);
        }
        // 从右到左单调增长，不能出栈时栈顶就是当前元素右侧最近的小于当前元素的节点
        stk = stack<int>();
        stk.push(len);
        for (int i = len - 1; i >= 0 ; i -- ) {
            while (stk.top() != len && nums[stk.top()] > nums[i]) {
                stk.pop();
            }
            rsmall[i] = stk.top();
            stk.push(i);
        }
        // 从左到右单调栈减，不能出栈时栈顶即为当前元素左侧最近的大于当前元素的节点
        stk = stack<int>();
        stk.push(-1);
        for (int i = 0; i < len ; i ++ ) {
            while (stk.top() != -1 && nums[stk.top()] <= nums[i]) {
                stk.pop();
            }
            llarge[i] = stk.top();
            stk.push(i);
        }
        // 从右到左单调减栈，不能出栈时栈顶就是当前元素右侧最近的大于当前元素的节点
        stk = stack<int>();
        stk.push(len);
        for (int i = len - 1; i >= 0 ; i -- ) {
            while (stk.top() != len && nums[stk.top()] < nums[i]) {
                stk.pop();
            }
            rlarge[i] = stk.top();
            stk.push(i);
        }
        // 计算结果
        long long res = 0;
        for (int i = 0; i < len ; i ++ ) {
            // i作为最大值使用了(i - llarge[i]) * (rlarge[i] - i)次 需要在结果中增加这些
            // 为什么是乘？ 因为对于左边的任一一个i到large[i]的中间，我们都可以选择任一一个i到rlarge[i]中间的任意一个下标作为右边界，即最终为乘法
            res += nums[i] * 1ll * (i - llarge[i]) * (rlarge[i] - i);
            res -= nums[i] * 1ll * (i - lsmall[i]) * (rsmall[i] - i);
        }
        return res;
    }
};
```