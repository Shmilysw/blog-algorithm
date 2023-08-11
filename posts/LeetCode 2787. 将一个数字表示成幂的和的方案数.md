---
title: LeetCode 2787. 将一个数字表示成幂的和的方案数
date: 2023-08-11
tags: [dp, 01背包]
---

---
## dp | 01背包

## [LeetCode 2787. 将一个数字表示成幂的和的方案数](https://leetcode.cn/problems/ways-to-express-an-integer-as-sum-of-powers/)

给你两个 **正** 整数 `n` 和 `x` 。

请你返回将 `n` 表示成一些 **互不相同** 正整数的 `x` 次幂之和的方案数。换句话说，你需要返回互不相同整数、

 `[n1, n2, ..., nk]` 的集合数目，满足 `n = n1^x + n2^x + ... + nk^x` 。

由于答案可能非常大，请你将它对 `10^9 + 7` 取余后返回。

比方说，`n = 160` 且 `x = 3` ，一个表示 `n` 的方法是 `n = 2^3 + 3^3 + 5^3` 。

### 示例 1：
```
输入：n = 10, x = 2
输出：1
解释：我们可以将 n 表示为：n = 3^2 + 1^2 = 10 。
这是唯一将 10 表达成不同整数 2 次方之和的方案。
```
### 示例 2：
```
输入：n = 4, x = 1
输出：2
解释：我们可以将 n 按以下方案表示：
- n = 4^1 = 4 。
- n = 3^1 + 1^1 = 4 。
```
### 提示：
+ 1 <= n <= 300
+ 1 <= x <= 5

```cpp
// 01背包 朴素版 200ms
const int MOD = 1000000007;

class Solution {
public:
    int numberOfWays(int n, int x) {
        // 预处理 i 的 x 次幂
        long long p[n + 1];
        for (int i = 1; i <= n ; i ++ ) {
            p[i] = i;
            for (int j = 2; j <= x ; j ++ )
                p[i] *= i;
        }
        // 01 背包
        // f[i][j] 从前 i 个数中挑选若干个数，组成和为 j 的方案数
        long long f[n + 1][n + 1];
        memset(f, 0, sizeof f);
        // 初始化 从前 0 个数中挑选，组成和为 0 的方案数为 1 
        f[0][0] = 1;
        // for(int i = 0; i <= n ; i ++ ) f[i][0] = 1;
        for (int i = 1; i <= n ; i ++ ) {
            for (int j = 0; j <= n ; j ++ ) {
                f[i][j] = f[i - 1][j];
                if (j >= p[i])
                    f[i][j] = f[i][j] + f[i - 1][j - p[i]];
            }
        }
        return f[n][n] % MOD;
    }
};
```
---
```cpp
// 01背包 优化版 24ms
const int MOD = 1000000007;

class Solution {
public:
    int numberOfWays(int n, int x) {
        // 预处理 i 的 x 次幂
        long long p[n + 1];
        for (int i = 1; i <= n ; i ++ ) {
            p[i] = i;
            for (int j = 2; j <= x ; j ++ )
                p[i] *= i;
        }
        // 01 背包
        // f[i][j] 从前 i 个数中挑选若干个数，组成和为 j 的方案数
        long long f[n + 1];
        memset(f, 0, sizeof f);
        // 初始化 从前 0 个数中挑选，组成和为 0 的方案数为 1 
        f[0] = 1;
        // for(int i = 0; i <= n ; i ++ ) f[i][0] = 1;
        for (int i = 1; i <= n ; i ++ ) {
            for (int j = n; j >= p[i] ; j -- ) {
                f[j] = f[j] + f[j - p[i]];
            }
        }
        return f[n] % MOD;
    }
};
```