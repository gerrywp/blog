+++
title = "线程安全与非线程安全"
date = "2017-12-03"
tags = [ "tag1" ]
categories = [ "csharp" ]
+++

　　c#的多线程编程由于其高级的语法糖(synax)而变化的相对简单，然而又有些神秘莫测。对于线程安全与否与同步(synchronize)经常有人将其混为一谈，其实这是2个不同的概念。
<!--more-->
### 非线程安全
先来说说线程安全的问题，Show your code(用代码说话)，以MSDN官网的
[List&lt;T&gt;](https://msdn.microsoft.com/library/6sh2ey19.aspx?f=255&MSPPError=-2147217396#Anchor_10 "点我访问")
为例：在`线程安全`这一小节，来自微软官网的描述，
> 公共静态 (Shared 在 Visual Basic 中) 这种类型的成员是线程安全。 但不保证所有实例成员都是线程安全的。

```cs
//创建控制台应用程序,并编写如下代码
static void Main(string[] args)
{
    do
    {
        ParallelList();
    } while (true);
}
static void ParallelList()
{
    List<Int32> list = new List<int>();//非线程安全的
    ParallelLoopResult result= Parallel.For(0, 100000, item =>
    {
        list.Add(item);
    });
    Console.WriteLine($"parallel is completed: {result.IsCompleted}! ");
}
```

1. 据官方文档可知，List<T>的实例成员就不是线程安全的。
2. 所以上述代码在死循环下会抛出异常，为什么会抛出异常不在这次的讨论范围内。
3. 所以对一个非线程安全的对象进行write操作(写操作包括更新、删除)在多次测试下是会抛出异常的，所以对非线程安全的对象进行写操作的代码是错误的代码！

### 线程安全
同样是上面的代码，经过MSDN的提醒「公共静态成员是线程安全的」，代码作如下调整

```cs
static List<Int32> list = new List<int>();//线程安全的
static void Main(string[] args)
{
    do
    {
        ParallelList(list);
    } while (true);
}
static void ParallelList(List<Int32> temp)
{
    //List<Int32> list = new List<int>();//非线程安全的
    ParallelLoopResult result= Parallel.For(0, 100000, item =>
    {
        temp.Add(item);
    });
    Console.WriteLine($"parallel is completed: {result.IsCompleted}! ");
}
```

1. 仅仅是将list变量提升为了公共Static变量
2. 上述代码无论怎么样运行都不会抛出异常，程序并不会挂掉！
3. 但是细心的你一定会发现，结果并不是我们想要的，因为list插入值并不对。
4. 这也是由此要引出多线程的同步的问题。
> 说明:线程安全的并不代表，操作就是合理的。按照所需业务来说，如果不是您期望的结果，这里就需要有lock，就需要有线程同步。

### 非线程安全就一定有问题吗？
上面已经讨论到了线程安全与非线程安全的概念问题，如果我们将非线程安全的代码作如下修改：

```cs
static void ParallelList()
{
    List<Int32> list = new List<int>();//非线程安全的
    for(Int32 i=0;i<10000;i++){
        list.Add(i);
    }
    ParallelLoopResult result= Parallel.For(0, 100000, item =>
    {
        Int32 currentItem=list[item];
    });
    Console.WriteLine($"parallel is completed: {result.IsCompleted}! ");
}
``` 

1. 仅仅将多线程的操作由write改为了read，这样多对一个非线程安全的对象实例也是没有任何问题的！

**综上所述：**

1. 即使线程安全的对象，在进行write写操作的时候,还是必须要使用lock锁同步来保证业务逻辑的一致性和正确性。
2. 即使是非线程安全的对象，当只进行read操作的时候，线程的安全与否已经不重要了！
