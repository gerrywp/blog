+++
title = "go语言开发windows服务程序"
date = "2020-05-27"
tags = [ "go" ]
categories = [ "golang" ]
+++

使用go语言原生的包，开发一个webapi应用的windows service服务。给客户软件提供版本升级，下载的功能。
<!--more-->

### 前言

1. windows操作系统
2. go version>1.11 能使用go module

### 初始化项目

```shell
cd d:\workspace
mkdir updater
cd updater
go mod init aiyoe.com/updater
```

使用的软件包：<http://github.com/kardianos/service>  
拷贝example下面的`main.go`文件到项目根目录  
基本的框架已经搭建完成，我们只需要引用net/http包，并添加请求处理程序即可。

### yaml文件

在项目的根目录下，创建待更新文件清单文件，如下：

**manifest.yml**

```yaml
---
  server:
    version: 1.0.0.1
    manifests:
      - name: ErpMain.exe
        version: 1.0.0.1
      - name: ErpUtils.dll
        version: 1.0.0.1
```

针对上述结构的`yml`文件，我们在项目根目录下新建对应的model，并将文件反序列化成对象实例

**models/svrconfig.go**

```go
package models

//SvrConfig model for manifets.yml
type SvrConfig struct {
	Server `yaml:"server"`
}

//Server section
type Server struct {
	Version   string `yaml:"version"`
	Manifests `yaml:",inline"`
}

//Manifests section
type Manifests struct {
	Files []FileInfo `yaml:"manifests" json:"Manifests"`
}

//FileInfo file objects array
type FileInfo struct {
	Name    string `yaml:"name"`
	Version string `yaml:"version"`
}
```

**注意**： 因为清单列表是一个对象数组，在yaml进行反序列化的时候，
`Server`结构里面的内嵌`Manifests`标签需要被忽略，因此必须给内嵌结构体添加字段Tag`yaml:",inline"`。(Json序列化同理)    
详情参考：<https://godoc.org/gopkg.in/yaml.v2#example-Unmarshal--Embedded>

### 服务器版本处理函数

在`run()`方法里面添加webapi处理函数
```go
func (p *program) run() {
	// Do work here
	pkgDir := path.Join(getCurrentDirectory(), "package")
	http.Handle("/file/", http.StripPrefix("/file", http.FileServer(http.Dir(pkgDir))))
	http.HandleFunc("/version", handler) // each request calls handler
	log.Fatal(http.ListenAndServe("localhost:80", nil))
}
// handler echoes the Path component of the request URL r.
func handler(w http.ResponseWriter, r *http.Request) {
	cp, _ := os.Getwd()
	logger.Infof("current path:%s", cp)
	ymlPath := getCurrentDirectory() + "/manifest.yml"
	if f, err := os.Open(ymlPath); err != nil {
		logger.Info(err)
		http.Error(w, err.Error(), 500)
	} else {
		config := &models.SvrConfig{}
		if err := yaml.NewDecoder(f).Decode(config); err != nil {
			fmt.Fprintf(w, err.Error())
			return
		}
		json.NewEncoder(w).Encode(*config)
	}
}
func getCurrentDirectory() string {
	dir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		log.Fatal(err)
	}
	return strings.Replace(dir, "\\", "/", -1)
}
```
webapi服务监听80端口,针对`/version`的请求直接返回`Json`对象给客户端  
**注意:**    
因为我们最终程序注册成windows服务运行，用相对文件路径`os.Open("./manifest.yml")`在调试状态能够找到文件，以服务的形式在当前目录是找不到配置文件的，
因此需要我们使用绝对路径定位配置文件。  
因为程序最终注册成windows service运行，`os.Getwd()`获取的路径为`c:\windows\system32`,在这个路径下面找.yml配置文件是找不到的。  
通过`getCurrentDirectory()`定位可执行文件路径，然后拼接成yml的绝对路径。

### 注册静态文件路由

在项目根目录下创建`package`文件夹，将需要更新的dll拷贝进去即可

```go
    pkgDir := path.Join(getCurrentDirectory(), "package")
    http.Handle("/file/", http.StripPrefix("/file", http.FileServer(http.Dir(pkgDir))))
```
使用以上代码注册了静态文件的路由，然后client可以直接通过`/file/文件名`的形式请求下载需更新的文件。

### 添加可执行文件参数标识

在**main**函数中添加如下代码

```go
func main(){
	svcFlag := flag.String("s", "", fmt.Sprintf("%s\r\n%s", "Control the system service.", service.ControlAction))
	flag.Parse()
	// ... other code
	if len(*svcFlag) != 0 {
		err = service.Control(s, *svcFlag)
		if err != nil {
			log.Printf("Valid actions: %q\n", service.ControlAction)
			log.Fatal(err)
		}
		return
	}
	// ... Other code
}
```

### 生成项目并部署

生成可执行文件
```shell
cd d:\workspace\updater
go build -o ErpUpdater main.go
```

```shell
# 以管理员身份运行以下命令
ErpUpdater -s Install
ErpUpdater -s Start
```

### 结束

打开浏览器访问<http://localhost:80/version>成功返回配置文件`json`格式字符串。



