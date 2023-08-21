---
title: LeetCode 2827. 范围中美丽整数的数目
date: 2023-08-21
tags: [dp, 数位dp]
---

---

## 数位dp

## [LeetCode 2827. 范围中美丽整数的数目](https://leetcode.cn/problems/number-of-beautiful-integers-in-the-range/description/)

<font color=red>困难</font>

给你正整数 low ，high 和 k 。

如果一个数满足以下两个条件，那么它是 美丽的 ：

+ 偶数数位的数目与奇数数位的数目相同。
+ 这个整数可以被 k 整除。

请你返回范围 [low, high] 中美丽整数的数目。

### 示例 1：
```输入：low = 10, high = 20, k = 3
输出：2
解释：给定范围中有 2 个美丽数字：[12,18]
- 12 是美丽整数，因为它有 1 个奇数数位和 1 个偶数数位，而且可以被 k = 3 整除。
- 18 是美丽整数，因为它有 1 个奇数数位和 1 个偶数数位，而且可以被 k = 3 整除。
以下是一些不是美丽整数的例子：
- 16 不是美丽整数，因为它不能被 k = 3 整除。
- 15 不是美丽整数，因为它的奇数数位和偶数数位的数目不相等。
给定范围内总共有 2 个美丽整数。
```
### 示例 2：
```
输入：low = 1, high = 10, k = 1
输出：1
解释：给定范围中有 1 个美丽数字：[10]
- 10 是美丽整数，因为它有 1 个奇数数位和 1 个偶数数位，而且可以被 k = 1 整除。
给定范围内总共有 1 个美丽整数。
```
### 示例 3：
```
输入：low = 5, high = 5, k = 2
输出：0
解释：给定范围中有 0 个美丽数字。
- 5 不是美丽整数，因为它的奇数数位和偶数数位的数目不相等。
```

### 提示：
+ 0 < low <= high <= 10^9
+ 0 < k <= 20


### 模板
```cpp
class Solution {
public:
    int dp[10][25][1 << 10];
    // val: 已经构造的数位, 模 k = val, 最总结果 == 0, 表示可以整除 k
    // diff: 奇数和偶数的个数, 初始为 n 防止数组越界
    // 返回从 i 开始填数字
    // is_limit 表示前面填的数字是否都是 n 对应位上, 如果为 true, 那么当前位至多为 int(s[i]), 否则至多为 9 
    // is_num 表示前面是否填了数字(是否跳过), 如果为 true, 那么当前位可以从 0 开始, 如果为 false, 那么我们可以跳过, 或者从 1 开始填数字
    int f(int i, int val, int diff, bool is_limit, bool is_num, string s, int k) {
        if (i == s.size())
            return is_num && val == 0 && diff == s.size(); // 找到了一个合法数字
        if (!is_limit && is_num && dp[i][val][diff] != -1)
            return dp[i][val][diff];
        int res = 0;
        if (!is_num) // 可以跳过当前数位
            res = f(i + 1, val, diff, false, false, s, k);
        int down = 1 - is_num;
        int up = is_limit ? s[i] - '0' : 9; // 如果前面填的数字都和 n 的一样，那么这一位至多填数字 s[i] (否则就超过 n 啦)
        for (int d = down; d <= up ; d ++ )
            res += f(i + 1, (val * 10 + d) % k, diff + (d % 2 == 1 ? 1 : -1), is_limit && d == up, true, s, k);
        if (!is_limit && is_num)
            dp[i][val][diff] = res; // 记忆化
        return res;
    }
    int calc(int high, int k) {
        auto s = to_string(high);
        int n = s.length();
        memset(dp, -1, sizeof dp);
        return f(0, 0, n, true, false, s, k);
    }
    int numberOfBeautifulIntegers(int low, int high, int k) {
        return calc(high, k) - calc(low - 1, k);
    }
};
```