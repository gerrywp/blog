+++
title = "nodejs之旅(6)热替换与热加载"
date = "2018-08-16"
tags = [ "node" ]
categories = [ "js" ]
+++

　　在开发阶段，我们希望每次更改了代码后页面立即做出相应改变，这种方式在webpack里面叫做
**热替换HMR**(hot module replacement)!在react开发中，希望每次更改代码的时候不要刷新整个页面，而是让网页中的React组件渲染代码替换成新的代码。这种方式就叫做热加载(hot load)。本文不使用`webpack-dev-server`的**hot**模式，
而是在自己搭建的expressjs服务器上，实现热更新和react组件的热加载！
<!--more-->
### 代码的热替换

为了使用热自动加载，我们需要两个express的中间件:

1. [webpack-dev-middleware](https://www.npmjs.com/package/webpack-dev-middleware '点我访问'),用于动态运行webpack生成打包后的内存文件。
2. [webpack-hot-middleware](https://www.npmjs.com/package/webpack-hot-middleware '点我访问'),用于处理来自浏览器的热加载请求。

具体参照插件文档，插件经常更新，使用方式也不尽相同,在expressjs中使用如下：

```js
var webpack = require('webpack');
var webpackConfig = require('./webpack.config');
var compiler = webpack(webpackConfig);
 
app.use(require("webpack-dev-middleware")(compiler, {
    noInfo: true, publicPath: webpackConfig.output.publicPath
}));
app.use(require("webpack-hot-middleware")(compiler));
```
其中值得注意的是`webpack-dev-middleware`使用的是webpack.config配置文件来打包文件！仅仅使用的是publicPath(与path是不同的，具体参考webpack文档)，
因为`webpack-dev-middleware`仅生成内存文件，文件路径就是`publicPath`指定的路径，因此我们的index.html的bundle.js路径要跟这个`publicPath`保持一致！

```html
// index.html
<script src="/bundle.js" />
```

```js
// webpack.config
entry:{
output:{
  publicPath:'/'
}
}
```
并且在webpack.config的plugins配置节配置:
```js
//webpack.config
plugins:[new webpack.HotModuleReplacementPlugin()]
```
entry节点要加入:
```js
entry: [
    ['webpack-hot-middleware/client', 'app.js']
]
```
至此我们的热更新已经配置完成了，此时我们修改reat组件，浏览器并不会自动刷新更新组件内容，通过提示得知
[react-hot-loader](https://www.npmjs.com/package/react-hot-loader '点我访问')派上了用场！
具体的配置按照文档配置来：

1. 在`bable-loader`配置节plugins添加对`react-hot-loader/babel`插件的使用
2. 需要将自己的根组件通过hot导出！
这里有个需要注意的问题，JSX语法的问题。
ES6对于只return一个对象的函数体，ES6允许简写省去return,直接用圆括号把返回的对象包起来就行!

```js
// App.js
import React from 'react'
import { hot } from 'react-hot-loader'
 
const App = () => <div>Hello World!</div>;

export default hot(module)(App)
```
这里我就犯了一个错误，组件一定要定义成一个function类型的对象，而不能直接定义成一个object类型的对象，这样在`ract-hot-loader`会报错
```js
//以下是不良好的书写习惯！直接是object变量,而非function变量
consst App= <div>Hello World!</div>;
export {App};
//这样的代码直接在react使用是没有问题的，但是使用了`react-hot-loader`就会报错了，请注意
```

### 原理解析

这里先从`webpack-dev-middleware`(以下简称dev中间件)说起，这个中间件做的工作其实很简单，就是根据webpack.config配置文件将模块进行打包。
作用类似于直接在命令行(command-line)输入`webpack`手动打包一样，不同点在于:

1. dev中间件可以动态配置，在服务器端启动后就进行打包，便于开发调试
2. dve中间件捕获源文件的改动自动进行打包！
3. dev中间件根据publicPath设置的路径，将bundle.js文件放在内存里。 并对比文件改动，只打包改动的文件，响应速度更快！
4. 使用`react-hot-loader/bable`对代码做支持热加载的预处理！
>说明： 此插件只实现了自动bundle，我们需要在浏览器手动刷新index.html页面来重新请求内存中的bundle.js文件以应用更新。

偷懒是工程师前进的一大步！我们希望dev中间件重新打包之后，浏览器能够自刷新，即能够主动再请求一次内存中的bundle.js文件，为此
`webpack-hot-middleware`热替换(以下简称hot中间件)应运而生！  
hot中间件做这件事的处理方式就使用到了`EventSource`[(典型的发布-订阅模式)](https://developer.mozilla.org/zh-CN/docs/Server-sent_events/EventSource '点我访问')

1. 服务器端bundle.js重新编译完成的时候发送通知，通知浏览器刷新
2. 浏览器订阅消息完成页面刷新

**首先处理第二步**-浏览器订阅服务器端消息 

这一步在dev中间件生成bundle.js的时候就应该完成，因此在打包的时候需要将hot中间件中已经写好的浏览器端client订阅代码打包进bundle.js,
因此在`webpack.config`文件entry中，我们指定的路径就是hot中间件提供的浏览器端的订阅消息代码路径。

```js
module.exports = {
  entry: ['/webpack-hot-middleware/client','app']
};
```
看`webpack-hot-middleware`源码包就知道，`/webpack-hot-middleware/client`路径就是将包里面的client.js文件(后缀名省略了)打包进bundle.js

在`plugins`节点添加`HotModuleReplacementPlugin`对包文件bundle.js进行热加载替换处理！
```js
plugins:[new webpack.HotModuleReplacementPlugin()]
```

**其次处理第一步**-服务器端发布bundle.js打包好的消息

```js
app.use(require("webpack-hot-middleware")(compiler));
```
hot中间件直接被当做expreejs中间件使用，透过webpack api直接通过`EventSource`发送消息出去！

### webpack-hot-middleware配置与webpack-dev-middleware配置的对应

同所有的发布-订阅一样，`EventSource`发布-订阅消息也需要一个地址(称为消息总线)

```js
// /webpack-hot-middleware/client.js
var options = {
  path: "/__webpack_hmr",
  timeout: 20 * 1000,
  overlay: true,
  reload: false,
  log: true,
  warn: true,
  name: '',
  autoConnect: true,
  overlayStyles: {},
  overlayWarnings: false,
  ansiColors: {}
};
```
我们看到的path就是消息总线的地址，默认为`/_webpack_hmr`,根据[文档](https://www.npmjs.com/package/webpack-hot-middleware#client '点我访问')描述，
这个path的配置有两种方式，一种是直接在webpack.config文件中配置url:
```js
//直接配置查询字符串
module.exports = {
  entry: ['/webpack-hot-middleware/client?path=/_eventstream_path','app']
};
```
另一种是在应用compiler中间件的时候指定options参数：
```js
var hotOptions={
path:'/_eventstream_path'
};
app.use(require("webpack-hot-middleware")(compiler));
```
> 一般使用默认配置即可，倘若要自定义的话一定要保证两者一致，这样`EventSource`才能发布-订阅到同一消息总线！(path - The path which the middleware will serve the event stream on, must match the client setting)

### webpack.config中使用process.env.NODE_ENV

先说最佳实践吧**不要在webpack.config**中使用`process.env.NODE_ENV`!
在webpack的配置文件中使用是读取不到process.env.NODE_ENV的，可以通过引入`dotenv`来访问！

```js
// webpack.config.js
require('dotenv').config();
let mode=process.env.NODE_ENV;
```
我们可以使用[DefinePlugin](https://webpack.docschina.org/plugins/define-plugin '点我访问')为所有依赖定义这个变量。
```js
new webpack.DefinePlugin({
    'process.env.NODE_ENV': JSON.stringify('production')})
```
这样任何位于 /src 的本地代码都可以关联到 process.env.NODE_ENV 环境变量。

> 注意，定义在插件里的自定义常量，使用了`JSON.stringify('production')`指定全局常量的值！为什么呢？

因为DefinePlugin()内部是使用这个对象来构建一个Object类型的字符串，如果直接给'production'的话，这个production就不是字符串了而是一个变量。

```js
return 'Object({process.env.NODE_ENV:"production"})'
```

官方文档有注意说明：因为这个插件直接执行文本替换，给定的值必须包含字符串本身内的实际引号。
通常，有两种方式来达到这个效果，使用 '"production"', 或者使用 JSON.stringify('production')。 
为什么要转成JSON字符串标准形式我们看如下代码演示：

```js
var objStr='Object({id:"name"})';
eval(objStr);
//下面的代码报错
var objStr='Object({id:name})';
eval(objStr);//错误
//改成
var name='pai';
var objStr='Object({id:name})';
eval(objStr);
```

### 局部刷新

开发React的时候深有体会，我只是改变了一个按钮组件代码，但是整个页面都自动刷新了。我们希望保存页面的状态，仅仅只是改变组件Reander的样式，
`react-hot-loader`(热加载)应运而生。
<待续！>


