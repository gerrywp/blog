+++
title = "nodejs之旅(5)-form表单"
date = "2018-08-13"
tags = [ "nodejs" ]
categories = [ "javascript" ]
+++

　　在web开发中，最重要的数据交互方式首推就该属表单了。html通过表单实现了客户端与服务器端数据的交互。谈及表单就不得不说`MIME`类型，此类型
关系到服务器端和浏览器端处理数据的方式和手段！
<!--more-->
### form的常用四种MIME类型

| MIME | 数据格式 |
| :--- | :--- |
| text/plain | name='pai'&id='id' |
| application/json;charset=utf-8 | {"name":"pai","id":"1"} | 
| application/x-www-form-urlencoded;charset=utf-8 | name='pai'&id='1' |  
| multipart/form-data | 带有boundary的附件上传形式 |  

在js前端使用`fetch`往服务器端发送数据的时候，通常指定的`Content-Type`数据类型就是MIME类型  

```js
var url='api/user';
fetch(url,{
  method:'POST',
  headers:{'Content-Type':'application/x-www-form-urlencoded;charset=utf-8'},
  credentials: 'same-origin',
  body:'name="pai"&id="1"'
})
```
因为使用了MIME类型为'application/x-www-form-urlencoded'，nodejs在服务器端接受数据的时候，会使用body.parse()根据数据类型处理数据，
因此我们编码的时候不需要再对数据进行解析！  

通常我们使用的`MIME`类型为`application/json`,服务器端会根据类型找到匹配的解析器！
```js
var url='api/user';
var data={name:'pai',id:'1'};
fetch(url,{
  method:'POST',
  headers:{'Content-Type':'application/json;charset=utf-8'},
  credentials: 'same-origin',
  body:JSON.stringify(data)
})
```
> `credentials: 'same-origin'`发送同源的cookie凭据需要添加此字段，值还有其他的类型。如果需要发送coolie凭据必须要添加此字段！

### multipart/form-data 上传附件的MIME类型

最重要的是使用多文件的附件上传的`Content-Type`类型，我们通过查看chrome或者fiddler的网络请求查看文件上传的表单请求的数据格式如下：

```html
Content-Type: multipart/form-data; boundary=aBoundaryString
(other headers associated with the multipart document as a whole)

--aBoundaryString
Content-Disposition: form-data; name="myFile"; filename="img.jpg"
Content-Type: image/jpeg

(data)
--aBoundaryString
Content-Disposition: form-data; name="myField"

(data)
--aBoundaryString
(more subparts)
--aBoundaryString--
```
我们可以构造如上所示的数据结构进行文件上传和表单字段的提交，但是过于麻烦！在js中我们可以通过`FormData`对象来构造以上形式的数据：

```js
var formData = new FormData();
var fileField = document.querySelector("input[type='file']");

formData.append('username', 'abc123');
formData.append('avatar', fileField.files[0]);
fetch(url,{
  method:'POST',
  credentials: 'same-origin',
  body:formData
})
```
在nodejs的服务器端，我们需要使用`multer`中间件处理文件的上传。

#### http-request在java中的应用

使用java模拟发送http请求，除了使用appache官网的`HttpClient`之外，
还可以使用`http-request`发送请求[Maven Central](https://search.maven.org/artifact/com.github.kevinsawicki/http-request/6.0/jar '点我访问')
在maven仓库中的位置如下，使用超级方便！
```xml
<dependency>
  <groupId>com.github.kevinsawicki</groupId>
  <artifactId>http-request</artifactId>
  <version>6.0</version>
</dependency>
```
