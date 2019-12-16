+++
title = "setTimeout定时器的使用"
date = "2017-03-01"
tags = [ "js" ]
categories = [ "javascript" ]
+++

增量随机，很好实现。那如果要实现时间间隔随机，应该如何处理？我们可以使用setTimeout递归调用来实现
<!--more-->
### setTimeout(fn(param){},ms,argument)

可以使用外层函数将`setTimeout`封装，并使用`setTimeout`调用外层函数

```js
function animatedFn(){
  let [vector,timerId]=[Math.random()*5000,null];
  console.log('***');
  timerId=setTimeout((pValue)=>{
    console.log('interval time is:'+pValue);
    animatedFn();//递归调用
  },vector,vector)
}
```

参数：

1. fn(param){},定时器回调函数可以带参数
2. ms,定时器下次启动，时间间隔(单位:毫秒)
3. argument,回调函数的实参(argument)
