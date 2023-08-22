---
title: AcWing 339. 圆形数字
date: 2023-08-22
tags: [数位dp, dp]
---

---
## 数位dp

## [AcWing 339. 圆形数字](https://www.acwing.com/problem/content/341/)

定义圆形数字如下：

把一个十进制数转换为一个无符号二进制数，若该二进制数中 0 的个数大于或等于 1 的个数，则它就是一个圆

形数字。现在给定两个正整数 a 和 b，请问在区间 [a,b] 内有多少个圆形数字。

### 输入格式
输入占一行，包含两个整数 a 和 b。

### 输出格式
输出一个整数，表示圆形数字的个数。

### 数据范围

+ 1 ≤ a < b ≤ 2 × 10^9

### 输入样例：
```
2 12
```
### 输出样例：
```
6
```
### 代码：
```cpp
// 数位 dp
#include <bits/stdc++.h>
#define endl '\n'
#define ios ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
using namespace std;

using i64 = long long;
const int N = 2e5 + 10;

int dp[50][1 << 10];
// val: 已经构造的数位, 模 k = val, 最总结果 == 0, 表示可以整除 k
// diff: 表示 0 与 1 的差, diff >= 0 表示 0 的个数大于等于 1 的个数
// 返回从 i 开始填数字
// is_limit 表示前面填的数字是否都是 n 对应位上, 如果为 true, 那么当前位至多为 int(s[i]), 否则至多为 9 
// is_num 表示前面是否填了数字(是否跳过), 如果为 true, 那么当前位可以从 0 开始, 如果为 false, 那么我们可以跳过, 或者从 1 开始填数字
int f(int i, int diff, bool is_limit, bool is_num, string s) {
    if (i == s.size())
        return is_num && diff >= 50; // 找到了一个合法数字
    if (!is_limit && is_num && dp[i][diff] != -1)
        return dp[i][diff];
    int res = 0;
    if (!is_num) // 可以跳过当前数位
        res = f(i + 1, diff, false, false, s);
    int down = 1 - is_num;
    int up = is_limit ? s[i] - '0' : 1; // 如果前面填的数字都和 n 的一样，那么这一位至多填数字 s[i] (否则就超过 n 啦)
    for (int d = down; d <= up ; d ++ )
        res += f(i + 1, diff + (d == 0 ? 1 : -1), is_limit && d == up, true, s);
    if (!is_limit && is_num)
        dp[i][diff] = res; // 记忆化
    return res;
}

int calc(int x) {
    int num[50];
    int len = 0;
    while (x) num[ ++ len] = x % 2, x /= 2; // 将数字转化为 r 进制
    string s = "";
    for (int i = len; i >= 1 ; i -- )
        s += num[i] + '0'; // 变为字符串, 正序
    int n = s.length();
    memset(dp, -1, sizeof dp);
    return f(0, 50, true, false, s);
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
---
```cpp
// 数位 dp
#include <bits/stdc++.h>
#define endl '\n'
#define ios ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
using namespace std;

using i64 = long long;
const int N = 2e5 + 10;

int dp[50][50][1 << 10];
// val: 已经构造的数位, 模 k = val, 最总结果 == 0, 表示可以整除 k
// cnt0: 0 的个数
// cnt1: 1 的个数
// 返回从 i 开始填数字
// is_limit 表示前面填的数字是否都是 n 对应位上, 如果为 true, 那么当前位至多为 int(s[i]), 否则至多为 9 
// is_num 表示前面是否填了数字(是否跳过), 如果为 true, 那么当前位可以从 0 开始, 如果为 false, 那么我们可以跳过, 或者从 1 开始填数字
int f(int i, int cnt0, int cnt1, bool is_limit, bool is_num, string s) {
    if (i == s.size())
        return is_num && cnt0 >= cnt1; // 找到了一个合法数字
    if (!is_limit && is_num && dp[i][cnt0][cnt1] != -1)
        return dp[i][cnt0][cnt1];
    int res = 0;
    if (!is_num) // 可以跳过当前数位
        res = f(i + 1, cnt0, cnt1, false, false, s);
    int down = 1 - is_num;
    int up = is_limit ? s[i] - '0' : 1; // 如果前面填的数字都和 n 的一样，那么这一位至多填数字 s[i] (否则就超过 n 啦)
    for (int d = down; d <= up ; d ++ )
        res += f(i + 1, cnt0 + (!d), cnt1 + (d == 1), is_limit && d == up, true, s);
    if (!is_limit && is_num)
        dp[i][cnt0][cnt1] = res; // 记忆化
    return res;
}

int calc(int x) {
    int num[50];
    int len = 0;
    while (x) num[ ++ len] = x % 2, x /= 2; // 将数字转化为 r 进制
    string s = "";
    for (int i = len; i >= 1 ; i -- )
        s += num[i] + '0'; // 变为字符串, 正序
    int n = s.length();
    memset(dp, -1, sizeof dp);
    return f(0, 0, 0, true, false, s);
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