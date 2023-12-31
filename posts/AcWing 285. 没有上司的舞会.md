---
title: AcWing 285. 没有上司的舞会
date: 2023-08-02
tags: [树形dp, dp]
---

---
## 树形dp

## [AcWing 285. 没有上司的舞会](https://www.acwing.com/problem/content/description/287/)

Ural 大学有 N 名职员，编号为 1 ∼ N。

他们的关系就像一棵以校长为根的树，父节点就是子节点的直接上司。

每个职员有一个快乐指数，用整数 Hi 给出，其中 1 ≤ i ≤ N。

现在要召开一场周年庆宴会，不过，没有职员愿意和直接上司一起参会。

在满足这个条件的前提下，主办方希望邀请一部分职员参会，使得所有参会职员的快乐指数总和最大，求这个最

大值。

### 输入格式

第一行一个整数 N。

接下来 N 行，第 i 行表示 i 号职员的快乐指数 Hi。

接下来 N − 1 行，每行输入一对整数 L, K，表示 K 是 L 的直接上司。（注意一下，后一个数是前一个数的父节

点，不要搞反）。

### 输出格式

输出最大的快乐指数。

### 数据范围

+ 1 ≤ N ≤ 6000
+ −128 ≤ Hi ≤ 127

输入样例：

```
7
1
1
1
1
1
1
1
1 3
2 3
6 4
7 4
4 5
3 5
```

### 输出样例：

```
5
```
---
```cpp
#include <bits/stdc++.h>
using namespace std;

const int N = 1e5 + 10, M = 2 * N;

int n;
int w[N];
int h[N], e[M], ne[M], idx;
bool st[N];
int f[N][2];

void add(int a, int b)
{
    e[idx] = b, ne[idx] = h[a], h[a] = idx ++ ;
}

void dfs(int u)
{
    f[u][1] = w[u];
    for (int i = h[u]; ~i ; i = ne[i])
    {
        int j = e[i];
        dfs(j);
        f[u][0] += max(f[j][0], f[j][1]);
        f[u][1] += f[j][0];
    }
}

int main()
{
    scanf("%d", &n);
    for (int i = 1; i <= n ; i ++ )
        scanf("%d", &w[i]);
    
    memset(h, -1, sizeof h);
    for (int i = 0; i < n - 1 ; i ++ )
    {
        int a, b;
        scanf("%d%d", &a, &b);
        add(b, a);
        st[a] = true;
    }
    
    int root = 1;
    while (st[root]) root ++ ;
    
    dfs(root);
    
    printf("%d\n", max(f[root][0], f[root][1]));
    
    return 0;
}
```