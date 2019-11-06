+++
title = "汇编指令lea"
date = "2013-14-04"
tags = [ "tag1" ]
categories = [ "windows" ]
+++

个别汇编指令英文全称说明，便于使用和记忆
<!--more-->
### lea (**Load Effective Address** 加载有效地址 )

```smalltalk
lea eax,[ecx+0x48]
```

说明: 将ecx+048这个结果作为一个地址传给eax(那么现在eax里面存的就是一个地址了)

### 赋值操作

```smalltalk
lea eax,pVariable
/*结果：将指针变量自身的地址赋值给了eax*/
```

说明:pVariable是一个指针变量。在高级语言的概念里,传递*指针*就是传递*地址*,上例的地址是指针自身的地址
处理方法：将lea指令换成mov指令

```smalltalk
mov eax,pVariable
//将pVariable指针指向的内容(一个内存地址)传递给eax
```
