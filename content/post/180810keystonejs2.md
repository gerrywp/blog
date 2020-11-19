+++
title = "keystonejs(2)dotenv等常用库"
date = "2018-08-10"
tags = [ "cms" ]
categories = [ "js" ]
+++

　　透过keystonejs接触了很多常用的库，查阅npm文档了解它们的基本用法。dotenv从.env文件中加载并设置环境变量。
<!--more-->
### dotenv

nodejs运行很多时候依靠环境变量在开发环境和生产环境做不同的适配。通过引入`dotenv`库，并添加.env文件，我们就可以自定义环境变量了！
例如，常用的cookie密钥就可以设置在.env文件中：

```js
// .env
//cookie密钥
COOKIE_SECRET={your secret key}
DEVOLOPMENT=true
```
express中的使用
```js
// app.js
require('dotenv').config()
if(process.env.COOKIE_SECRET){
  console.log(process.env.COOKIE_SECRET);
}
```

### debug

一个调试工具，可以通过环境变量的设置来输出自己模块日志。在当前模块中调用，并命名然后根据环境变量来确定是不是要启用调试日志！  

```js
// app.js
var debug = require('debug')('app');
var name='baung!';
debug('%o is running!',name);
```
在.env中配置环境变量`DEBUG`来启动调试日志！
```
//仅开启名称为app的模块日志
DEBUG=app
//开启除了名字为"express:*"的模块日志
DEBUG=*,-express:*
```
你可以通过"-"符号，排除指定的debuggers

### express-session
集成express管理session会话

### morgan

HTTP request logger中间件，用来记录http请求的详细信息，可以配置各种显示样式！
有以下几种`Predefined Formats`格式化选项可选： 
 
1. combined
2. common
3. dev
4. short
5. tiny
