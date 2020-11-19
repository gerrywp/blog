+++
title = "es6语法糖(syntax sugar)"
date = "2017-11-21"
tags = [ "js" ]
categories = [ "js" ]
+++

　　es6引入了大量的语法糖，其中有不少是不好理解的，一边实践一边用文字记录之。
<!--more-->
### import 和 export

`import` 和 `export` 这对孪生兄弟是要成对出现的，因为使用的时候，导入导出要分成2种情况，一种变量带大括号，一种不带括号，如下：

```js
import React from 'react';//不带大括号的
import {Component} from 'react';//带大括号的
export {variableName};
```

总结:`import`和`export`要带大括号就都带，要么都不带！

#### 具名变量

必须要建立变量与接口一一对应的关系

```js
//---myclass.js--- 
// 方式1
class MyClass {
    ...
}
export {MyClass};
// 方式2
export class MyClass {

}
// 方式3
class n{

}
export {n as MyClass}
//然后import的时候也要是具名的变量
import {MyClass} from './myclass.js'
```

#### 匿名变量(主要由export default)引起

```js
// ---myclass.js---
// 导出匿名的class
export default class MyClass {

}
class MyClass{

}
export default MyClass;// 导出匿名的class
// 因此import可以随意命名变量(这里是不能带大括号的)
import customName from './myclass.js'
```

说明：其实这只是一种偷懒的记忆方式，它们别样的语法有很多种，这里只记住常见的用法！