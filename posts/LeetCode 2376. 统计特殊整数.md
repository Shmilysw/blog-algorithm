---
title: LeetCode 2376. 统计特殊整数
date: 2023-07-31
tags: [dp, 数位dp]
---

---
## 数位dp

## [LeetCode 2376. 统计特殊整数](https://leetcode.cn/problems/count-special-integers/)

<font color=red>困难</font>

如果一个正整数每一个数位都是 互不相同 的，我们称它是 特殊整数 。

给你一个 正 整数 n ，请你返回区间 [1, n] 之间特殊整数的数目。

### 示例 1：
```
输入：n = 20
输出：19
解释：1 到 20 之间所有整数除了 11 以外都是特殊整数。所以总共有 19 个特殊整数。
```

### 示例 2：
```
输入：n = 5
输出：5
解释：1 到 5 所有整数都是特殊整数。
```

### 示例 3：
```
输入：n = 135
输出：110
解释：从 1 到 135 总共有 110 个整数是特殊整数。
不特殊的部分数字为：22 ，114 和 131 。
```

### 提示：

+ 1 <= n <= 2 * 10^9

```cpp
class Solution {
public:
    // 返回从 i 开始填数字，能构造出的特殊整数的数目
    // is_limit 表示前面填的数字是否都是 n 对应位上的，如果为 true，那么当前位至多为 int(s[i])，否则至多为 9 
    // is_num 表示前面是否填了数字（是否跳过），如果为 true，那么当前为可以从 0 开始，如果为false，那么我们可以跳过，或者从 1 开始填数字
    // 时间复杂度，对于 DP 来说，等于状态个数 * 转移个数
    // O(len(s)) = O(log(n)) * O(digits)
    string s;
    int m;
    int countSpecialNumbers(int n) {
        s = to_string(n);
        m = s.length();
        memset(dp, -1, sizeof(dp));
        return f(0, 0, true, false);
    } 
    int dp[10][1 << 10];
    int f(int i, int mask, bool isLimit, bool isNum){
        if (i == m) return isNum;
        if (!isLimit && isNum && dp[i][mask] >= 0) return dp[i][mask];
        int res = 0;
        if (!isNum) res = f(i + 1, mask, false, false); // 可以跳过当前数位
        for (int d = 1 - isNum, up = isLimit ? s[i] - '0' : 9; d <= up; ++d) // 枚举要填入的数字 d
            if ((mask >> d & 1) == 0) // d 不在 mask 中
                res += f(i + 1, mask | (1 << d), isLimit && d == up, true);
        if (!isLimit && isNum) dp[i][mask] = res;
        return res;
    }
};
```
---
```cpp
class Solution {
public:
    int countSpecialNumbers(int n) {
        vector<int> nums;
        while (n) nums.push_back(n % 10), n /= 10;
        int res = 0;
        for (int i = 1; i < nums.size() ; i ++ ) {
            int t = 9;
            for (int j = 0, k = 9; j < i - 1 ; j ++ , k -- ) {
                t *= k;
            }
            res += t;
        }
        
        reverse(nums.begin(), nums.end());
        bool st[10] = {0};
        for (int i = 0; i < nums.size() ; i ++ ) {
            for (int j = !i; j < nums[i] ; j ++ ) {
                if (st[j]) continue;
                int t = 1;
                for (int k = 0, u = 9 - i; k < nums.size() - i - 1 ; k ++ , u -- ) {
                    t *= u;
                }
                res += t;
            }
            
            if (st[nums[i]]) break;
            st[nums[i]] = true;
        }
        
        set<int> hash(nums.begin(), nums.end());
        if (hash.size() == nums.size()) res ++ ;
        
        return res;
    }
};
```