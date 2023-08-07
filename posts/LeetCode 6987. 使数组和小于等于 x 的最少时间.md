---
title: LeetCode 6987. 使数组和小于等于 x 的最少时间
date: 2023-08-07
tags: [dp, 贪心]
---

---
## dp

## [LeetCode 6987. 使数组和小于等于 x 的最少时间](https://leetcode.cn/problems/minimum-time-to-make-array-sum-at-most-x/)

<font color=red>困难</font>

给你两个长度相等下标从 0 开始的整数数组 nums1 和 nums2 。每一秒，对于所有下标 0 <= i < nums1.length ，nums1[i] 的值都增加 nums2[i] 。操作 完成后 ，你可以进行如下操作：

+ 选择任一满足 0 <= i < nums1.length 的下标 i ，并使 nums1[i] = 0 。
同时给你一个整数 x 。

请你返回使 nums1 中所有元素之和 小于等于 x 所需要的 最少 时间，如果无法实现，那么返回 -1 。

### 示例 1：
```
输入：nums1 = [1,2,3], nums2 = [1,2,3], x = 4
输出：3
解释：
第 1 秒，我们对 i = 0 进行操作，得到 nums1 = [0,2+2,3+3] = [0,4,6] 。
第 2 秒，我们对 i = 1 进行操作，得到 nums1 = [0+1,0,6+3] = [1,0,9] 。
第 3 秒，我们对 i = 2 进行操作，得到 nums1 = [1+1,0+2,0] = [2,2,0] 。
现在 nums1 的和为 4 。不存在更少次数的操作，所以我们返回 3 。
```

### 示例 2：
```
输入：nums1 = [1,2,3], nums2 = [3,3,3], x = 4
输出：-1
解释：不管如何操作，nums1 的和总是会超过 x 。
```

### 提示：
+ 1 <= nums1.length <= 10^3
+ 1 <= nums1[i] <= 10^3
+ 0 <= nums2[i] <= 10^3
+ nums1.length == nums2.length
+ 0 <= x <= 10^6

```python
"""
如何比较两种方案的优劣？

1. 答案最大是多少？  n
2. 从小到大枚举答案


t=1 选一个当前最高的，收菜
t=2 比较相对值，比算绝对值要方便

s1 = sum(nums1)
s2 = sum(nums2)

按照 nums2 从小到大排序，nums2 越小的，越早操作


第 t 秒，不做任何操作，元素和是 s1 + s2 * t
从 s1 + s2 * t 减去最大的

从 nums1 中选一个长度为 t 的子序列，子序列的第一个数变成 nums1[i]+nums2[i]
第 j 个数变成 nums1[i] + j*nums2[i]
最大化子序列改变后的元素和

选或不选

f[i+1][j] 前 i 个数中，选长为 j 的子序列，改变后的元素和的最大值
不选 f[i+1][j] = f[i][j]
选   f[i+1][j] = f[i][j-1] + nums1[i] + j * nums2[i]

f[j] = 0

f[j] = max(f[j], f[j-1] + nums1[i] + j * nums2[i])

if s1 + s2 * t - f[n][t] <= x:
    return t

"""
class Solution:
    def minimumTime(self, nums1: List[int], nums2: List[int], x: int) -> int:
        n = len(nums1)
        f = [0] * (n + 1)
        for a, b in sorted(zip(nums1, nums2), key=lambda z: z[1]):
            for j in range(n, 0, -1):
                f[j] = max(f[j], f[j-1] + a + j * b)
        
        s1 = sum(nums1)
        s2 = sum(nums2)
        for t in range(n + 1):
            if s1 + s2 * t - f[t] <= x:
                return t
        return -1

```