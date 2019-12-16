+++
title = "背景图片全屏造成的滚动(滑动)卡顿"
date = "2017-04-08"
tags = [ "js" ]
categories = [ "javascript" ]
+++

web app中用到全屏幕的背景的图片需要占据整个视口(view-port)，必然会用到position:fixed的定位。
但是由此引发了一个问题，在PC端，没有任何问题，但是在手机端下滑的时候出现了页面卡顿的现象，这个是没法忍受的。
<!--more-->
**全屏background-image**

### 问题的重现

由于最开始使用的是在body标签底下，建立一个<div>来承载图片。  
html文档结构如下:  

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
</head>
<body>
<div class="full-bg"></div>
</body>
</html>
```

css样式表如下:  

```css
.full-bg{
position:fixed;
top:0;
right:0;
bottom:0;
left:0;
background-image:url(xxx.png);/*图片分辨率较大*/
background-position:50% 50%;
background-color:#fff;/*图片未加载出来的背景色*/
background-repeat:no-repeat;
background-size:cover;
/*兼容性代码*/
-webkit-background-size:cover;
-moz-background-size:cover;
-o-background-size:cover;
}
```

### 解决问题

1. 出现了上述问题就在考虑，为什么会出现这个问题？个人猜测`<div>`为fixed的元素，在滚动的时候会发生页面重绘。
又由于设置了背景图片，所以滚动的时候就会卡顿。上面的文档结构不好，**background-attachment**上场。
有了这个属性，我们完全可以将背景应用于body标签,并将div背景标签移除，css代码如下: 
 
```css
body{
position:relative;
top:0;
right:0;
bottom:0;
left:0;
background-image:url(xxx.png);/*图片分辨率较大*/
background-position:50% 50%;
background-color:#fff;/*图片未加载出来的背景色*/
background-repeat:no-repeat;
background-attachment:fixed; 
background-size:cover;
/*兼容性代码*/
-webkit-background-size:cover;
-moz-background-size:cover;
-o-background-size:cover;
}
```

2. 不要给绝对定位和fixed的元素设置背景图片，应使用如下结构，可解决问题。

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
</head>
<body>
<!--仅仅作定位使用-->
<div class="full-bg">
<!--给内层元素设置背景-->
    <div></div>
</div>
</body>
</html>
```

### html,body的高端和宽度100%

当设置的html,body的高端和宽度占满屏幕,css如下:

```css
html,body{
width:100%;
heigth:100%;
margin:0;
padding:0;
overflow:scroll;
-webkit-overflow:scroll;
-moz-overflow:scroll;
-o-overflow:scroll;
/*卡顿的话增加以下代码*/
-webkit-overflow-scrolling:touch;
}
```

**建议**：有人说使用了height:100%也会造成卡顿(个人实验并未出现卡顿)，博客上有人推荐使用min-height:100%

### ~~min-height:100%~~

~~对html,body使用min-height:100%;似乎只有html才管用，对于body并没有效，所以这个也没有多大作用。~~

### line-height和linebox的高度

在css中决定一个box的高度的是`line-height`属性

```css
font-size:0;
line-height:40px;
/*上:box有高度,下:box没有高度*/
font-size:14px;
line-height:0;
```
  
> 1. [http://sixrevisions.com/css/responsive-background-image/](http://sixrevisions.com/css/responsive-background-image/ "点我访问")
> 2. [https://segmentfault.com/a/1190000002404673](https://segmentfault.com/a/1190000002404673 "点我访问")
