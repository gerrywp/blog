+++
title = "javascript中精准的定时器"
date = "2017-04-21"
tags = [ "javascript" ]
categories = [ "javascript" ]
+++

今天偶然看到了一篇讲解javascript各定时器的文章。文章使用对话的方式阐述了`setInterval`不足，颇有意思。
但是觉得不太好理解，原文如下：  
[setTimeout那些事儿](http://imweb.io/topic/56ac67fbe39ca21162ae6c78 "点我访问")  
其中的第三点，咱们还是代码见(show you code)。
<!--more-->
### setInterval能够固定间隔触发吗？

习惯了使用setInterval()做定时任务的触发，但是此方法并不能保证2次调用之间的间隔时间是恒定的。以下场景:

```js
setInterval(function(){
  console.log('started!');
  var now=new Date();
  var future=now.setSeconds(now.getSeconds()+3);//3秒后
  while(true){
    now=new Date();
    if(now>future){
      break;
    }
  };
  console.log('ended!');
},3000);
```

以上代码使用while循环模拟了一个耗时操作，事实上`setInterval`并不知道main线程执行的代码需要多久执行完成。
所以以上代码会在输出'ended!'的同时，执行下一个函数并输出了`started!`。

倘若需要函数的2次调用之间间隔3秒，可以通过`setTimeout`的链式调用来实现。

```js
setTimeout(function(){
  console.log('started!');
  var now=new Date();
  var future=now.setSeconds(now.getSeconds()+3);//3秒后
  while(true){
    now=new Date();
    if(now>future){
      break;
    }
  };
  console.log('ended!');
  setTimeout(arguments.callee,3000);//arguments.callee代表当前正在执行的函数，也就是函数本身
},3000);
```

>结论:动手比较下以上代码的区别，不难看出问题所在！
