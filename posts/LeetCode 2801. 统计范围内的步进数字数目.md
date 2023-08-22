---
title: LeetCode 2801. 统计范围内的步进数字数目
date: 2023-07-31
tags: [dp, 数位dp]
---

---
## 数位dp

## [LeetCode 2801. 统计范围内的步进数字数目](https://leetcode.cn/problems/count-stepping-numbers-in-range/)

<font color=red>困难</font>

给你两个正整数 low 和 high ，都用字符串表示，请你统计闭区间 [low, high] 内的 步进数字 数目。

如果一个整数相邻数位之间差的绝对值都 恰好 是 1 ，那么这个数字被称为 步进数字 。

请你返回一个整数，表示闭区间 [low, high] 之间步进数字的数目。

由于答案可能很大，请你将它对 1e9 + 7 取余 后返回。

注意：步进数字不能有前导 0 。

### 示例 1：
```
输入：low = "1", high = "11"
输出：10
解释：区间 [1,11] 内的步进数字为 1 ，2 ，3 ，4 ，5 ，6 ，7 ，8 ，9 和 10 。总共有 10 个步进数字。所以输出为 10 。
```
### 示例 2：
```
输入：low = "90", high = "101"
输出：2
解释：区间 [90,101] 内的步进数字为 98 和 101 。总共有 2 个步进数字。所以输出为 2 。
```

### 提示：

+ 1 <= int(low) <= int(high) < 10^100
+ 1 <= low.length, high.length <= 100
+ low 和 high 只包含数字。
+ low 和 high 都不含前导 0 。


### 代码：
```cpp
class Solution {
public:
    const int MOD = 1e9 + 7;
    int dp[110][1 << 10];
    // pre: 表示当前位前一位的填了什么数字
    // 返回从 i 开始填数字
    // is_limit 表示前面填的数字是否都是 n 对应位上, 如果为 true, 那么当前位至多为 int(s[i]), 否则至多为 9 
    // is_num 表示前面是否填了数字(是否跳过), 如果为 true, 那么当前位可以从 0 开始, 如果为 false, 那么我们可以跳过, 或者从 1 开始填数字
    int f(int i, int pre, bool is_limit, bool is_num, string &s) {
        if (i == s.size())
            return is_num; // 找到了一个合法数字
        if (!is_limit && is_num && dp[i][pre]!= -1)
            return dp[i][pre];
        int res = 0;
        if (!is_num) // 可以跳过当前数位
            res = f(i + 1, pre, false, false, s);
        int down = 1 - is_num;
        int up = is_limit ? s[i] - '0' : 9; // 如果前面填的数字都和 n 的一样，那么这一位至多填数字 s[i] (否则就超过 n 啦)
        for (int d = down; d <= up ; d ++ )
            if (!is_num || abs(d - pre) == 1)
                res = (res + f(i + 1, d, is_limit && d == up, true, s)) % MOD;
        if (!is_limit && is_num)
            dp[i][pre] = res; // 记忆化
        return res;
    }
    int calc(string &s) {
        int n = s.length();
        memset(dp, -1, sizeof dp);
        return f(0, 0, true, false, s);
    }
    bool valid(string &s) {
        for (int i = 1; i < s.length() ; i ++ )
            if (abs(int(s[i]) - int(s[i - 1])) != 1)
                return false;
        return true;
    }
    int countSteppingNumbers(string low, string high) {
        return (calc(high) - calc(low) + MOD + valid(low)) % MOD;
    }
};
```
---
```python
# 灵神
class Solution:
    def countSteppingNumbers(self, low: str, high: str) -> int:
        MOD = 10 ** 9 + 7
        def calc(s: str) -> int:
            @cache  # 记忆化搜索
            def f(i: int, pre: int, is_limit: bool, is_num: bool) -> int:
                if i == len(s):
                    return int(is_num)  # is_num 为 True 表示得到了一个合法数字
                res = 0
                if not is_num:  # 可以跳过当前数位
                    res = f(i + 1, pre, False, False)
                low = 0 if is_num else 1  # 如果前面没有填数字，必须从 1 开始（因为不能有前导零）
                up = int(s[i]) if is_limit else 9  # 如果前面填的数字都和 n 的一样，那么这一位至多填 s[i]（否则就超过 s 啦）
                for d in range(low, up + 1):  # 枚举要填入的数字 d
                    if not is_num or abs(d - pre) == 1:  # 第一位数字随便填，其余必须相差 1
                        res += f(i + 1, d, is_limit and d == up, True)
                return res % MOD
            return f(0, 0, True, False)
        return (calc(high) - calc(str(int(low) - 1))) % MOD
```
---