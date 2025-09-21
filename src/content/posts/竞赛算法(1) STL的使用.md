---
title: 竞赛算法(1) STL的使用
published: 2025-09-21
description: ''
image: ''
tags: []
category: ''
draft: false 
lang: ''
---

## std::vector
### 构造
```cpp
// O(1)
std::vector<int> v1;

// O(n)
std::vector<int> v2(3);
std::vector<int> v3(3, 0);
std::vector<int> v4(v1);
std::vector<int> v5 = {1, 2, 3, 4, 5};
std::vector<int> v6(v5);
std::vector<int> v7(v5.begin() + 1, v5.begin() + 3); // v7 = {2, 3}
```

不要用`std::vector<bool>`, 应转而使用`std::vector<uint8_t>`或`std::vector<char>`

### 状态
```cpp
// O(1)
std::vector<int> v5 = {1, 2, 3, 4, 5};
v5.size(); // 5
v5.capacity(); // >= 5
v5.empty(); //false
v5.reserve(10); // 预留10的capacity, 减少扩容开销
```

capacity是实际空间, size是目前大小, 这个只要亲手写过线性表就知道了, 见[数据结构C1-线性表的实现](.././数据结构c1-线性表的实现/).

### 访问元素
```cpp
// O(1)
v5[3]; // 4, 下标访问
v5.front(); // 首元素引用, 1
v5.back(); // 末元素引用, 5
v5.data(); // 数组首元素指针
```

### 增(添加元素)
```cpp
v5.insert(v5.begin() + 3, 6); // v5: {1, 2, 3, 6, 4, 5}, 在第3个位置前插入6, O(n)

vector<vector<int>>v7;
v7.push_back(vector<int>(3)); // push_back里面放构造好的元素, 均摊O(1) + O(3)(构造成本)
v7.emplace_back(3); // emplace_back里面放构造函数的内容, 直接构造. 均摊O(1)
```

### 删(删除元素)
```cpp
v5.pop_back(); // 尾删, O(1)
v5.erase(pos); // pos为迭代器, 删除pos位置的元素, O(n)
v5.erase(pos1, pos2); // 两个迭代器, 删除[pos1, pos2)之间的元素.
v5.clear(); // 置空
```

### 改(修改元素)
```cpp
v5[3] = 6;
v5.front() = 6;
v5.back() = 6;      // v5: {6, 2, 6, 6, 4, 6}

// assign: 后面放构造函数, 相当于重构造
v4.assign(v5.begin() + 1, v5.begin() + 3); // v4: {2, 6}, 取子数组, O(子数组)
v5.assign(3, 6) // v5: {6, 6, 6}, O(n)

fill(v5.begin(), v5.end(), 7); // v5: {7, 7, 7}, 初始化, O(n)

v5.resize(8, 6); // v5: {7, 7, 7, 6, 6, 6, 6, 6}, 重分配大小, O(n)
```

### 查(查找元素)
```cpp
find(v5.begin(), v5.end(), 6); // v5.begin() + 3; 指向6第一次出现的位置
```

### 其他操作
```cpp
v5.assign({1, 3, 9, 6, 5, 4});
sort(v5.begin(), v5.end()); // v5: {1, 3, 4, 5, 6, 9}, O(nlogn)
sort(v5.rbegin(), v5.rend()); // v5: {9, 6, 5, 4, 3, 1}, O(nlogn), 等价于sort(v5.begin(), v5.end(), greater<int>());
sort(v5.begin(), v5.end()); // v5: {1, 3, 4, 5, 6, 9}
lower_bound(v5.begin(), v5.end(), 6); // v5.begin() + 4, (6所在迭代器). 返回第一个大于等于val的迭代器.
upper_bound(v5.begin(), v5.end(), 6); // v5.begin() + 5, (9所在迭代器). 返回第一个大于val的迭代器.

v5.assign({1, 1, 1, 2, 2, 3, 6, 6, 8, 8, 9, 9});
v5.erase(std::unique(v5.begin(), v5.end()), v5.end()); // v5: {1, 2, 3, 6, 8, 9}, 去除相邻重复, 一般排序后使用. O(n)

v5.erase(std::remove(v5.begin(), v5.end(), 2), v5.end()); // v5: {1, 3, 6, 8, 9}, 去除指定元素.

v4.assign({6, 6, 6});
v5.swap(v4); // v5: {6, 6, 6}, v4: {1, 3, 6, 8, 9}

v4.erase(std::unique(v4.begin(), v4.end(), [](int a, int b){return (a % 2 == 0) && (b % 2 == 0);}), v4.end()); // v4 = {1, 3, 6, 9}, 去除相邻的偶数. 总是保留满足判定条件的第一个.

v4.erase(std::remove_if(v4.begin(), v4.end(), [](int a){return a % 2 == 0;}), v4.end()); // v4 = {1, 3, 9}
```
`std::unique`和`std::remove`本身并不改变容器大小, 所以要配合erase使用.


## std::pair
### 构造
```cpp
std::pair<int, int>p1; // {0, 0}
```

### 修改与访问
```cpp
p1 = make_pair(2, 4); // {2, 4}
auto& [x, y] = p1; // x = 2, y = 4, C++17
p1.first; // 2
p1.second; // 4
```

### 其他注意事项
有序容器内pair会自动按先first升序, 然后second升序的顺序来储存. 无序容器需要手动定义hash

## std::map
