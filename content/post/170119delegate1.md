+++
title = "委托和反射"
date = "2017-01-19"
tags = [ "vs" ]
categories = [ "csharp" ]
+++

反射的性能问题一直是广为诟病的，但反射所消耗的这一点性能并不算什么。因为通常情况下的业务逻辑都不会很复杂，我们只是使用反射
来处理一些常规编码难以迄及的特殊场景。
<!--more-->
### 反射

说反射性能低下是相对而言的，相对于function的直接调用，反射的性能确实有所下降。在这里不去讨论反射的原理知识，代码如下：

```cs
static void Main(String[] args)
{
    const int COUNTER=5000000;//计数次数
    //反射调用
    var methodInfo=typeof(SampleClass).GetMethod("Add");
    SampleClass sampleClass1=new SampleClass();
    for(Int32 i=0;i<COUNTER;i++)
    {
        methodInfo.Invoke(sampleClass1,1,2);//反射调用
    }
}

public class SampleClass
{
    public Int32 Add(Int32 i1,Int32 i2)
    {
        return i1+i2;
    }
}
```

无疑上面的代码效率是低下的，因为在循环里面使用了Invoke调用，Invoke的内部有以下几个地方严重影响性能。

1. 实参1,2传递给object[] parameters的形参，装箱(boxing) //装箱 耗时耗内存
2. 要将object[]类型的形参，拆箱(unboxing)成Add(Int32,Int32)可以调用的Int32类型的参数 //拆箱 耗时耗内存
3. Invoke内部会做参数的校验(validate) //耗时
4. CLR确保调用者(caller)拥有被调用成员的访问权限

当然如果不是因为大量的循环，其实以上三点所说的性能问题对于现如今的CPU根本就是九牛一毛。
总结：我们应该避免在复杂度较高的或大量循环里面使用反射的方法调用

进一步讨论，假如我们确实有这样的场景，必须要使用反射(runtime-动态调用),并且要用到big循环以及复杂度高的计算,那性能问题是不是就没有办法解决了？

### 委托(Delegate)
什么是委托？关键字 `delegate`

```cs
delegate void Feedback(Int32 i);
```
这就是委托,看起来是不是很简单？委托其实就是函数指针(c/c++),通过 `delegate`我们可以将函数当做参数传递。(不知道什么是函数指针，请百度)
`delegate`简单的背后，compilers(编译器csc.exe)和CLR(公共语言运行时)为我们做了大量的工作。当compilers看到以上的代码，它会将我们的代码
编译成如下的`class`

```cs
internal class Feedback : System.MulticastDelegate 
{
// Constructor
public Feedback(Object @object, IntPtr method);
// Method with same prototype as specified by the source code
public virtual void Invoke(Int32 value);
// Methods allowing the callback to be called asynchronously
public virtual IAsyncResult BeginInvoke(Int32 value,AsyncCallback callback, Object @object);
public virtual void EndInvoke(IAsyncResult result);
}
```

##### 比较Delegate.Invoke()、MethodInfo.Invoke()、Delegate.DynamicInvoke()

1. Delegate.Invoke()，因为已知了函数的参数类型，避免了装箱和拆箱(参数校验等)，所以在效率上快很多。
2. Delegate.DynamicInvoke()和MethodInfo.Invoke()有着同样的问题(装箱、参数校验),
而事实上Delegate.DynamicInvoke()更甚，操作更繁琐，效率低于MethodInfo.Invoke()一个数量级。

**使用delegate改进refelection method invoke**代码如下:

```cs
static void Main(String[] args)
{
    const int COUNTER=5000000;//计数次数
    //反射调用
    var methodInfo=typeof(SampleClass).GetMethod("Add");
    SampleClass sampleClass1=new SampleClass();
    var dlgService=(Func<Int32,Int32,Int32>)Delegate.CreateDelegate(typeof(Func<Int32,Int32,Int32>)
    ,sampleClass1,methodInfo);
    for(Int32 i=0;i<COUNTER;i++)
    {
        dlgService(1,2);//方式1
        //dlgService.Invoke(1,2) //方式2，与方式1等价，效率一样
    }
}

public class SampleClass
{
    public Int32 Add(Int32 i1,Int32 i2)
    {
        return i1+i2;
    }
}
```

以上代码使用了Func<T1,T2>泛型委托,简化了代码,当然还可以使用lambda表达式来处理

参考文献

> 《CLR VIA C#》
