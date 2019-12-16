+++
title = "前端那些事儿"
date = "2017-11-24"
tags = [ "nodejs" ]
categories = [ "javascript" ]
+++

　　微软系软件开发使用的Visual Studio(VS) IDE强大到令人发指！隐藏了许多技术细节，必然很难定制。nodejs出现之前，创建一个asp.net mvc的项目，client(browser)和server(csharp+iis)是组织在一起的。很少有公司在做asp.net mvc项目的时候会定制msbuild去完成浏览器端代码的构建和发布，比如：
打包压缩js+css文件,拷贝文件到指定的dist目录,修改view或html文件中的js、css引用路径给路径添加上hash码，同时也拷贝到dist目录。但是通常情况下都是使用的IDE自动构建和一键式发布来deploy website应用。这种情况下想实现client端和server端的分而治之，压根是不可能实现的。nodejs的出现彻底改变了这一现状！
<!--more-->
### nodejs在client(browser)端的大放异彩

个人观点：nodejs的出现彻底颠覆以往了client(browser)的开发模式，相比于`java` `.net`它在server(pc服务器端)毫无优势可言,完全可以忽略！  

#### 旧的开发模式 jquery+html

1. 缺点: 缺少模块化，毫无维护性可言！
2. 优点: 简单上手快
3. 构建(build)和打包(bundle): **无**

#### 新的开发模式 react/angular/vue +nodejs

1. 优点： 模块化开发，维护方便，项目结构清晰，与server服务器端解耦
2. 缺点： 有一定技术要求
3. 构建(build)和打包(bundle): **有**

> 说明：下面着重讲下构建和打包，以及两者的区别和重要性！

nodejs出现之前，browser-server两端是没有解耦的，都是糅合开发。nodejs出现彻底打破了这一定律，让browser端的开发彻底从server端分离出去，让流程化走上了日程！三大具有代表性的browser框架： React、Angular、Vue使得browser端开发更具模块化结构更加清晰。

#### 什么是构建工具(build tool)?

构建让自browser端自动化成为可能。所谓构建就是按照一定的代码逻辑，完成项目文件的version-hash的替换。文件的合并、压缩、拷贝等等功能。这类型的工具一直就有，例如：  
java: `maven` `gradle`  
.net: `msbuild` `cmake`  
linux: `make`  

那么nodejs有哪些构建工具呢？  

nodejs: `gulp` `grunt`

#### 什么是模块打包工具(module bundle tool)

打包(package)就是字面意思,将各类型的文件组合到一起，便于分发！browser(浏览器)的模块打包和java等的打包概念还不太一样，这里单独说明。
为什么要打包？起初browser端html文件通过`<script>`标签一个个的引用js文件，通过`<link>`标签一个个的引用css文件，如果我们的项目足够大，
js文件有1000个，css文件有1000个。如果直接发布到服务器上，这样文件的请求压力十分巨大。所以在发布到服务器端的时候，需要将所有js和css文件合并到一起，打包的概念应运而生！  
常用的两个模块打包工具`webpack`和`browserify`  

`webpack`的核心是模块化的组织、模块化的依赖、模块化的打包,必须满足以下两点要求：
 
 1. 需要把各种资源（js/ts/css/html/ejs/img/fonts等等）都看成 module
 2. module 之间必须是互相依赖的
 
 这样webpack打包的时候就会把所有用的文件统统打包进一个文件(也可分片打包)
 
> webpack这种打包方式对browser端的意义重大，简化了资源请求次数！
将它应用在server端压根没有必要，混淆代码为了安全性？在这个开源代码的时代，谁会看你写的那些垃圾代码？

### react+express全栈糅合

react是一个browser浏览器端开发框架，通常创建一个全栈工程需要两个project：

1. 基于*react*开发的browser浏览器端html project 
2. 基于*express*开发的server服务器端webapi project

创建react项目最简单粗暴的方式就是使用`create-react-app`工具，此工具通过`webpack-dev-server`来启动react项目，express通过`node`来启动webapi的服务端。  

如何将2个项目有机的结合在一起，让2个webserver同时工作呢？

[fullstackreact](https://www.fullstackreact.com/articles/using-create-react-app-with-a-server/#the-rub- "点我访问")

### npx的正确使用

[npx是什么，为什么需要npx?](https://robin-front.github.io/2017/07/14/introducing-npx-an-npm-package-runner.html '点我访问')

```js
//直接运行本地webpack工具，并不会安装工具
npx webpack
```

> 参考文献
> [npm使用正确姿势](https://juejin.im/post/5ab3f77df265da2392364341 '点我访问')
