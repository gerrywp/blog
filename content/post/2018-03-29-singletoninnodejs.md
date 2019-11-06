+++
title = "nodejs如何创建单例实例"
date = "2018-03-29"
tags = [ "tag1" ]
categories = [ "javascript" ]
+++

　　How to create singleton in Node.js?这个问题实际是错误的！因为nodejs模块缓存的原因，require('')每次出来的都是单例的！
<!--more-->
### 单例模式

```js
var HelloWorld = (function () {

  this.greeting = “Hello, World”;

  return this;

})();

module.exports = HelloWorld;
```

模块缓存的作用，造成了每次require('helloworld.js')的时候返回的都是同一个对象！
[module-cache](https://nodejs.org/api/modules.html#modules_caching '点我访问')

>原文：Modules are cached after the first time they are loaded. This means (among other things) that every call to require('foo') will get exactly the same object returned, if it would resolve to the same file.

### 如何创建非单例模式？

不要暴露一个对象出来，而是暴露一个function出来并call它。

```js
function HelloWorld() {

  this.greeting = “Hello, World”;

  return this;

}

module.exports = HelloWorld;
```
>[How (not) to create a singleton in Node.js](https://medium.com/@iaincollins/how-not-to-create-a-singleton-in-node-js-bd7fde5361f5 '点我访问')
