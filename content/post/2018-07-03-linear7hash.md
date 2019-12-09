+++
title = "线性存储和hashcode"
date = "2018-07-03"
tags = [ "数据结构" ]
categories = [ "others" ]
+++

　　数组就是典型的线性结构。对数组中特定**值**的查询，线性查询无疑是最慢的查询方式，时间复杂度为O(n):n为数组长度。
最合适的算法自然就是使用散列表了(HashTable)。
<!--more-->
### 线性查询
假如有一个庞大的字符串数组，给定你一个字符串，让你在数组中查找它是否存在，如何处理？

#### 速度缓慢的线性查找
```csharp
String query="please"
String[] infiniteStr={"name","is","a","value","chinese","boy","good","like"};
  for(int i=0;i<infiniteStr.Length;i++){
    if(query==infiniteStr[i]){
      Console.WriteLine("Find it!");
    return;
  }
}
```

线性查询的直接表现形式就是，使用for循环比较待查找的字符串与数组项的匹配时间复杂度O(n)。常用的字符串的查找方法通常使用的都是线性查找：

```csharp
infiniteStr.IndexOf("name");
```
要达到一定的数量级散列才有价值，一般情况下对小型数组进行散列查询的情况比较少。

### Map(Think in java 17.9.2节)
在使用字典类型的数据的时候，散列查找突出了优势。
众所周知数组根据__下标__查询值的速度是最快的(时间复杂度O(1))，例如：
```csharp
String val=infiniteStr[5];
```
字典存储数据的结构为`Map<K,V>`通常K都是一个Object类型，所以对于给定值V的查询，瓶颈在于键的查询速度(由于键没有按照特定顺序保存，只能使用简单的**线性查询**)。
透过《Think In Java》里面**自定义SlowMap**可以看到查询的缓慢因素所在。

```java
//SlowMap.java
public V get(Object key){
  if(!keys.contains(key))
    return null;
  return values.get(keys.indexOf(key))//这里keys.indexOf(key)就是使用了线性查询，ArrayList源码里面的使用的就是for循环
}
```
散列：散列将键保存在某处，以便能够快速找到它！存储一组元素最快的数据结构是数组，所以使用它来表示键的信息(并不保存键本身)。因为数组最快的访问方式，
是使用下标访问，所以通过对键对象进行hash生成一个整数，将其作为数组的下标，这个数字就是**散列码**，由hashCode()方法生成并被使用！

### 散列(原理)

为解决数组容量被固定的问题，不同的键对象，可能产生相同的下标(这样会产生冲突)。因此数组多大就不重要了，任何键总能在数组中找到它的位置。  
于是查询一个值的过程首先就是计算散列码，然后使用散列码查询数组。如果能够保证没有冲突，就有了一个完美的**散列函数**。通常冲突由链表来处理：数组
并不保存值，而是保存值的链表。然后对***List***中的值使用 **equals()** 方法进行线性查询，这部分的查询自然比较慢，但是如果散列函数足够好，数组的每个位置
就只有较少的值。因此，不是查询整个***List***,而是快速地跳到数组的某个位置，对很少的元素进行比较。这就是HashMap会如此快的原因。
　　
