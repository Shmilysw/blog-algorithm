---
title: AcWing 1273. 天才的记忆
date: 2023-09-19
tags: [RMQ, 倍增法]
---

---
## RMQ, 倍增法

## [AcWing 1273. 天才的记忆](https://www.acwing.com/problem/content/1275/)


从前有个人名叫 WNB，他有着天才般的记忆力，他珍藏了许多许多的宝藏。

在他离世之后留给后人一个难题（专门考验记忆力的啊！），如果谁能轻松回答出这个问题，便可以继承他的宝藏。

题目是这样的：给你一大串数字（编号为 1
 到 N
，大小可不一定哦！），在你看过一遍之后，它便消失在你面前，随后问题就出现了，给你 M
 个询问，每次询问就给你两个数字 A,B
，要求你瞬间就说出属于 A
 到 B
 这段区间内的最大数。

一天，一位美丽的姐姐从天上飞过，看到这个问题，感到很有意思（主要是据说那个宝藏里面藏着一种美容水，喝了可以让这美丽的姐姐更加迷人），于是她就竭尽全力想解决这个问题。

但是，她每次都以失败告终，因为这数字的个数是在太多了！

于是她请天才的你帮他解决。如果你帮她解决了这个问题，可是会得到很多甜头的哦！

### 输入格式
第一行一个整数 N 表示数字的个数。

接下来一行为 N 个数，表示数字序列。

第三行读入一个 M，表示你看完那串数后需要被提问的次数。

接下来 M行，每行都有两个整数 A, B。

### 输出格式
输出共 M 行，每行输出一个数，表示对一个问题的回答。

### 数据范围
+ 1 ≤ N ≤ 2×10^5,
+ 1 ≤ M ≤ 10^4,
+ 1 ≤ A ≤ B ≤ N。
### 输入样例：
```
6
34 1 8 123 3 2
4
1 2
1 5
3 4
2 3
```
### 输出样例：
```
34
123
123
8
```
---
```cpp
#include <bits/stdc++.h>
using namespace std;

const int N = 2e5 + 10, M = 18;

int n, m;
int w[N];
int f[N][M];

void init() {
    for (int j = 0; j < M ; j ++ ) {
        for (int i = 1; i + (1 << j) - 1 <= n ; i ++ ) {
            if (!j) f[i][j] = w[i];
            else f[i][j] = max(f[i][j - 1], f[i + (1 << j - 1)][j - 1]);
        }
    }
}

int query(int l, int r) {
    int len = r - l + 1;
    int k = log(len) / log(2);
    return max(f[l][k], f[r - (1 << k) + 1][k]);
}

int main() {
    scanf("%d", &n);
    for (int i = 1; i <= n ; i ++ ) {
        scanf("%d", &w[i]);
    }
    init();
    scanf("%d", &m);
    while (m -- ) {
        int l, r;
        scanf("%d%d", &l, &r);
        printf("%d\n", query(l, r));
    }
    return 0;
}
```