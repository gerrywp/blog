+++
title = "keystonejs(1)隐晦配置"
date = "2017-10-27"
tags = [ "tag1" ]
categories = [ "javascript" ]
+++

keystonejs跨平台内容管理系统开发的又一利器。通过定义数据model层，即可完成一个企业型应用站点的开发，并自动生成后台管理界面。
我们需要做的只是做前端UI，给定模板套样式即可。下面一步一步学习并搭建一个站点起来，并进行二次开发，以一系列文章记录下来。
<!--more-->
### 环境的搭建

1. ubuntu 16.04x64 虚拟机一台
2. nodejs & mongodb
3. vscode工具

#### 安装nodejs
建议使用nvm来安装nodejs这样可以在不同的版本之间进行切换
```shell
# 直接使用apt安装
apt install nvm
nvm install node
# 遇到node包下载不下来的时候，可以根据提示使用 curl 命令将node包先下载到nvm安装目录下的cache文件夹下
nvm use node
```
#### 安装mongodb

* 在[mongodb官网下载中心](https://www.mongodb.com/download-center#community "点我访问"),获取所需版本的下载链接

```shell
cd ~
curl -o- https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-3.4.10.tgz | bash
# 解压缩
tar -zxvf mongodb-linux-x86_64-ubuntu1604-3.4.10.tgz
# 移动到/usr/local/mongodb
mv mongodb-linux-x86_64-ubuntu1604-3.4.10 /usr/local/mongodb
# 设定mongodb的环境变量
vim .bashrc
MONGODB_PATH=/usr/local/mongodb
PATH=${MONGODB_PATH}/bin:${PATH}
# 二进制文件的安装方式下，需要手动建数据库文件的存放路径，默认是/data/mongodb
mkdir -p /data/mongodb
# 改变目录所有者让其拥有写入权限
ls -al /data /data/mongodb
chgown -v username /data 
# 启动mongodb服务
mongod
```
备注：注意要手动闯将文件目录`/data/mongodb`并更改所有者

* 开机启动mongod服务(待补充)

将mongod配置成系统服务，完成开机自启动

#### 安装yeoman脚手架

```shell
npm install -g yo
```

#### 安装keystonejs yeoman生成器&创建项目

```shell
npm install -g generator-keystone
# 项目创建
cd ~/documents
mkdir myproject
cd myproject
yo keystone
# 根据提示自己输入一些配置
# 这里我选择的template engine为handlerbars
```

### 配置修改

默认的配置并不能满足我们的要求,我们需要customization。例如改下后台管理的路径等

#### 生成的后台管理界面url路径的更改

```shell
keystone.init({
  'name': 'My Project',
  'admin path': 'dyt'，
  'host':'127.0.0.1'，//设置本地ip
  'favicon': 'public/favicon.ico',
  'less': 'public',
  'static': ['public'],
  
  'views': 'templates/views',
  'view engine': 'jade',
  
  'auto update': true,
  'mongo': 'mongodb://localhost/my-project',
  
  'session': true,
  'auth': true,
  'user model': 'User',
  'cookie secret': '(your secret here)'
  
});
```
添加键值对`admin path`，值指定为你想要的任何名字,然后更改页面模板的登录/退出路径。 
修改`/views/index.hbs`页面里面的内容
```html
<p><a href="/keystone/signin" style="margin-right: 10px" class="btn btn-lg btn-primary">Sign in</a> to use the Admin UI.</p>
更改为
<p><a href="/dyt/signin" style="margin-right: 10px" class="btn btn-lg btn-primary">Sign in</a> to use the Admin UI.</p>
```
其它相关地方修改类同

#### 启动

* 手动启动

```shell
cd ~/documents/myproject
node keystone.js
```
访问`http://127.0.0.1:3000`站点

* 配置服务开机自启动(待续)

[keystonejs(2)dotenv等常用库](/javascript/keystonejs2.html '点我访问')
