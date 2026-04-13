+++
title = "nodejs之旅(2)"
date = "2018-03-27"
tags = [ "node" ]
categories = [ "js" ]
+++

　　express-handlebars服务端模板引擎的局部渲染。非SPA应用程序，在最原始的动态页面并使用了layout布局的情况下，
我们通常希望能够将index.hbs里面的UI结构和js逻辑部分组合在一起，并且需要将js逻辑统一放置到layout布局页的最底部。
handlebars的**Block Helper**能够帮我们解决这个问题！
<!--more-->
### Block Helper
通常我们的layout.hbs文件结构组织如下:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <!--引入css文件-->
    <link href="./*.css"/>
  </head>
  <body>
    <header></header>
    <main>
      { { {body} } }
    </main>
    <footer></footer>
    <!--javascript 脚本-->
    <script  src="./javascripts/jquery.min.js"/>
    <!--其它页面的脚本放置在这里-->
  </body>
</html>
```

index.hbs文件结构如下：

```html
<div class="container">
  <div class="row">
    <div class="col-12"></div>
  </div>
</div>
<script>
  $(function(){
    //do something here
  })();
</script>
```
很明显index.hbs页面需要在layout.hbs页面的jquery.js加载之后再加载。也就是在物理顺序上index.hbs页面的js逻辑代码，
要放置在laout.hbs中`<script>标签`最后面引入！  
handlebar的页面渲染流程：

```js
  app.get('/', function (req, res, next) {
    res.render('index');
});
```
1. handlebars引擎编译index.hbs生成局部hmtl模板
2. 引擎编译layout.hbs生成布局html模板
3. compine合并步骤(1)&步骤(2)的操作结果,使用步骤(1)结果替换掉步骤(2)中的占位符
4. 输出最终页面

解决问题的关键在于:  
使用handlebar引擎编译index.hbs的时候，**Block Helper**让引擎生成的js脚本不输出到局部的html模板中，
而是保存在[引擎全局对象]**memory script**上。等到步骤(3)的时候，用**memory script**替换掉步骤(2)中的script占位符即可！  
具体实现如下：  
在app.js中注册自定义**Block Helper**

```js
var sectionHelper={section:function(name,options){
  if(!this.renderSection)this.renderSection={};
  //将引擎渲染的代码块，保存到引擎对象上
  this.renderSection[name]=options.fn(this);
  return null;//让BlockHelper在此次不渲染
}};
app.engine('.hbs', exphbs({extname: '.hbs',helpers:sectionHelper}));
```

在index.hbs页面使用app.js中注册的section **Block Helper**
```html
<div class="container">
  <div class="row">
    <div class="col-12"></div>
  </div>
</div>
//使用注册过section block helper
{ { #section 'js' } }
<script>
  $(function(){
    //do something here
  })();
</script>
{ {/section} }
//此处只是生成了模板的内存数据，并不会在此处渲染html结构
```

在layout.hbs页面渲染index.hbs生成的模板内存数据
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <!--引入css文件-->
    <link href="./*.css"/>
  </head>
  <body>
    <header></header>
    <main>
      { { {body} } }
    </main>
    <footer></footer>
    <!--javascript 脚本-->
    <script  src="./javascripts/jquery.min.js"/>
    <!--其它页面的脚本放置在这里-->
    <!-- 渲染index.hbs页面的section模板到此位置-->
    { { {renderSection.js} } }
  </body>
</html>
```
### Windows下npm install sqlite3失败

在windows下做开发还是绕不开`Visual Studio开发环境`啊，使用`npm intall sqlite3`的时候，需要针对平台编译对应的sqlite3.node文件，因此
需要有`Visual Studio Build Tools`工具，不然会提示各种错误，最简单的方法就是下载windows下的node.exe安装包，安装的时候勾选如下图所示的选项
**Automatically install the necessary tools.**
![node安装](../../pictures/Snipaste_2024-12-17_20-58-52.png 'node安装')
该选项会安装Chocolatey和Visual Studio Build tools
![Visual Studio Installer](../../pictures/Snipaste_2024-12-17_21-02-53.png 'Visual Studio Installer')
安装了MSBuild后再安装npm install sqlite3就会自动编译并生成sqlite3.node文件。


> + 使用{ { { } } }语法原样输出handlebar-engine上下文context中的renderSection.js变量!  
> + `{ { {} } }`与`{ {} }`的区别，两者都是求值输出变量，前者对html标签不做转义处理，后者对html标签做了转义处理。
