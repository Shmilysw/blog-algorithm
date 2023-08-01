---
title: LeetCode 2719. 统计整数数目
date: 2023-07-31
tags: [dp, 数位dp]
---

---

## 数位dp

## [2719. 统计整数数目](https://leetcode.cn/problems/count-of-integers/description/)

`困难`

给你两个数字字符串 num1 和 num2 ，以及两个整数 max_sum 和 min_sum 。如果一个整数 x 满足以下条件，我们称它是一个好整数：

+ num1 <= x <= num2

+ min_sum <= digit_sum(x) <= max_sum.

请你返回好整数的数目。答案可能很大，请返回答案对 109 + 7 取余后的结果。

注意，digit_sum(x) 表示 x 各位数字之和。

### 示例 1：
```
输入：num1 = "1", num2 = "12", min_num = 1, max_num = 8
输出：11
解释：总共有 11 个整数的数位和在 1 到 8 之间，分别是 1,2,3,4,5,6,7,8,10,11 和 12 。所以我们返回 11 。
```

### 示例 2：
```
输入：num1 = "1", num2 = "5", min_num = 1, max_num = 5
输出：5
解释：数位和在 1 到 5 之间的 5 个整数分别为 1,2,3,4 和 5 。所以我们返回 5 。
```

### 提示：

+ 1 <= num1 <= num2 <= 10^22
+ 1 <= min_sum <= max_sum <= 400

```cpp
const int mod = 1e9 + 7;
int dp[30][410][2], arr[30];
void add(int &a, int b) {
    a += b;
    if (a >= mod) a -= mod;
}
class Solution {
public:
    int calc(string &s, int low, int top) {
        int n = s.size();
        for (int i = 0; i < n ; i ++ ) arr[i] = s[i] - '0';
        for (int i = 0; i <= n ; i ++ )
            for (int j = 0; j <= top ; j ++ )
                for (int k = 0; k < 2 ; k ++ )
                    dp[i][j][k] = 0;
        
        dp[0][0][1] = 1;
        for (int i = 0; i < n ; i ++ ) {
            for (int j = 0; j <= top ; j ++ ) {
                for (int k = 0; k <= 9 && j + k <= top ; k ++ ) {
                    add(dp[i + 1][j + k][0], dp[i][j][0]);
                }
                for (int k = 0; k <= arr[i] && j + k <= top ; k ++ ) {
                    add(dp[i + 1][j + k][k == arr[i]], dp[i][j][1]);
                }
            }
        }
        int res = 0;
        for (int i = low; i <= top ; i ++ ) {
            for (int j = 0; j < 2 ; j ++ ) add(res, dp[n][i][j]);
        }
        return res;
    }
    int count(string num1, string num2, int min_sum, int max_sum) {
        int ans = calc(num2, min_sum, max_sum) - calc(num1, min_sum, max_sum);
        int tmp = 0;
        for (auto c: num1) {
            tmp += (c - '0');
        }
        if (min_sum <= tmp && tmp <= max_sum) ans ++ ;
        return (ans % mod + mod) % mod;
    }
};
```