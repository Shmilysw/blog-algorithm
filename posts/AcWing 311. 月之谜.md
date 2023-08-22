---
title: AcWing 311. 月之谜
date: 2023-08-22
tags: [数位dp, dp]
---

---
## 数位dp

## [AcWing 311. 月之谜](https://www.acwing.com/problem/content/313/)

如果一个十进制数能够被它的各位数字之和整除，则称这个数为“月之数”。

给定整数 L 和 R ，你需要计算闭区间 [L,R] 中有多少个“月之数”。

### 输入格式
输入占一行，包含两个整数 L 和 R。

### 输出格式
输出一个整数，表示月之数的个数。

### 数据范围
+ 1 ≤ L, R < 2^31

### 输入样例：
```
1 100
``` 
### 输出样例：
```
33
```
### 代码：
```cpp
// 数位 dp -> 模板来自于 灵茶山艾府
#include <bits/stdc++.h>
#define endl '\n'
#define ios ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
using namespace std;

using i64 = long long;
const int N = 2e5 + 10;

int dp[15][100][1 << 10];
// k: 取模 k 
// val: 已经构造的数位, 模 k = val, 最总结果 == 0, 表示可以整除 k
// sum: 各位数字和 -> sum == k 满足题目要求
// 返回从 i 开始填数字
// is_limit 表示前面填的数字是否都是 n 对应位上, 如果为 true, 那么当前位至多为 int(s[i]), 否则至多为 9 
// is_num 表示前面是否填了数字(是否跳过), 如果为 true, 那么当前位可以从 0 开始, 如果为 false, 那么我们可以跳过, 或者从 1 开始填数字
int f(int i, int sum, int val, bool is_limit, bool is_num, string s, int k) {
    if (i == s.size())
        return is_num && val == 0 && sum == k; // 找到了一个合法数字
    if (!is_limit && is_num && dp[i][val][sum] != -1)
        return dp[i][val][sum];
    int res = 0;
    if (!is_num) // 可以跳过当前数位
        res = f(i + 1, sum, val, false, false, s, k);
    int down = 1 - is_num;
    int up = is_limit ? s[i] - '0' : 9; // 如果前面填的数字都和 n 的一样，那么这一位至多填数字 s[i] (否则就超过 n 啦)
    for (int d = down; d <= up ; d ++ )
        res += f(i + 1, sum + d, (val * 10 + d) % k, is_limit && d == up, true, s, k);
    if (!is_limit && is_num)
        dp[i][val][sum] = res; // 记忆化
    return res;
}

int calc(int high) {
    auto s = to_string(high);
    int n = s.length();
    int res = 0;
    // 2^31 最大取模 9 * 10 左右, 全部枚举, 相加
    for (int i = 1; i <= 9 * 11 ; i ++ ) {
        memset(dp, -1, sizeof dp);
        res += f(0, 0, 0, true, false, s, i);
    }
    return res;
}

void solve() {
    int l, r;
    cin >> l >> r;
    cout << calc(r) - calc(l - 1) << endl;
}

int main() {
    ios;
    int T = 1;
    while (T -- ) solve();
    return 0;
}
```