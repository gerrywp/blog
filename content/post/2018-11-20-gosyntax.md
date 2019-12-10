+++
title = "GO语言圣经笔记"
date = "2018-11-20"
tags = [ "go" ]
categories = [ "golang" ]
+++

　　本书翻译的版本看的有些别扭，在此把相似的东西进行归类做好常用知识点的笔记！
<!--more-->
### fmt与格式化

#### Println
打印以空格间隔的一个或多个值，并添加换行符。
```go
fmt.Println("hello","世界")
```

#### [Printf](https://golang.org/pkg/fmt/ '点我访问')
对表达式产生格式化输出，输出到标准输出。该函数的首个参数是个格式字符串，指定后续参数如何被格式化！`Printf`有一大堆格式化符号，GO程序员称之为*动词(verb)*:

|转换字符|含义|
|:---|:---|
|%d|十进制数|
|%x,%o,%b|十六进制,八进制,二进制|
|%f,%g,%e|浮点数:3.141593 3.141592653589793 3.141593e+00|
|%t|布尔:true或false|
|%c|字符(rune)(Unicode码点)|
|%s|字符串|
|%q|带双引号的字符串"abc"或带单引号的字符'c'|
|%v|变量的自然形式(natural format)|
|%T|变量的类型|
|%%|百分号:转义百分号|
|%p|slice:第一个元素的地址 pointer:指针指向的地址|

>惯例：以字母f结尾的格式化函数，如`log.Printf`和`fmt.Errorf`都采用`fmt.Printf`的格式化准则；而以`ln`结尾的格式化函数，则遵循`Println`的方式，
以跟`%v`差不多的方式格式化参数。

```go
f 指 format
ln 指 line
```

```go
o := 0666// 0开头的八进制
fmt.Printf("%d %[1]o %#[1]o\n", o) // "438 666 0666"
x := int64(0xdeadbeef)
fmt.Printf("%d %[1]x %#[1]x %#[1]X\n", x)
```

**副词**:

1. 请注意fmt的两个使用技巧。通常Printf格式化字符串包含多个%参数时将会包含对应相同数量的额外操作数，但是%之后的[1]副词告诉Printf函数再次使用第一个操作数。第二，%后的#副词告诉Printf在用%o、%x或%X输出时生成0、0x或0X前缀。
2. 需要注意的是Printf函数中%v参数包含的#副词，它表示用和Go语言类似的语法打印值。对于结构体类型来说，将包含每个成员的名字。

#### Sprintf(Sprint)
将结果以字符串的形式返回！

#### Fprintf
Fprintf的前缀**F**表示文件(File)也表明格式化输出结果应该被写入第一个参数提供的文件中。`Printf`和
`Sprintf`实际上是对`Fprintf`的封装。  
在Printf函数中的第一个参数**os.Stdout**是\*os.File类型;在Sprintf函数中的第一个参数&buf是一个指向可以写入字节的内存缓冲区！

### 数据类型

|类型|等价类型|
|:---:|:---:|
|rune|int32|
|byte|uint8|

### new和make区别

1. new生成指定类型的指针变量，但是不初始化变量即不给变量分配内存
2. make生成指定类型变量，并初始化该变量

>总结：因此不成文的规定是new必须用在值类型上，make必须用在引用类型上

### 参数-按引用传递
考虑以下代码：

```go
func ChangeSlice(a []int) {
	for i := 0; i < len(a); i++ {
		a[i] = i * 2
	}
	a = a[1:]
}
```

本来的意图是丢弃掉a切片的第一位，将结果反应给实参。但是由于直接给引用类型变量a赋了一个新的值，因此a指向了一块
新的内存，造成原有的实参引用丢失。所以在函数内部重新给引用类型变量赋值要格外注意!在c++里面有一个指针常量的概念，
很遗憾golang里面没有！要达成修改实参的目的可以使用如下代码：

```go
func ChangeSlice(a []int) []int {
	for i := 0; i < len(a); i++ {
		a[i] = i * 2
	}
	//append扩容就会分配新的数组，所以切片最好赋值给另外一个切片，并返回新的切片。
	return append(a, 4, 5, 6, 7)//只能通过返回值的方式，切记切记！
}
```

### 反射(reflection)

有些情况下我们需要使用一个未知的类型(即没有明确的类型定义)，反射应运而生。

#### `reflect.Type`类型

函数`reflect.TypeOf()`接收任意类型并返回动态类型，

```go
reflect.TypeOf(3)
```

它标识了接口值的动态类型，类型描述信息如下图所示：
![Type结构图](../../pictures/20190722104901.png "点我访问")
它由两部分组成，type部分描述动态类型，value部分存储动态值。
`Type`满足`fmt.Stringer()`接口，`fmt`参数`%T`内部使用`reflect.TypeOf()`来输出

#### `reflect.Value`类型

此类型可以装载任意类型的值。函数`reflect.ValueOf()`接受任意类型，并返回装有动态值的`reflect.Value`:

```go
type IPerson interface{
Sleep()
}
type Student struct{
Name string
}
func (*Student) Sleep(){
}
func main(){
var ip1 IPerson
s1:=new(Student)
s1.Name="Gerry"
ip1=s1
rv:=reflect.ValueOf(ip1)
//打印动态值
fmt.Println(rv)//默认使用%v打印，结果&{Gerry}
}
```

`Reflect.Value`的零值

Value有三个methods可以校验是否0值：

1. `IsValid()`
2. `Kind()`
3. `String()`

```go
var ip2 IPerson
reflect.ValueOf(ip1).IsValid() //return false
reflect.ValueOf(ip1).Kind()  //return Invalid
reflect.ValueOf(ip1).String() //return "<invalid Value>" 
//考虑以下代码：(包含nil指针的非空动态值类型Value)
var ip2 IPerson
var s2 Student
ip2 = &s2
fmt.Println(reflect.ValueOf(ip2).IsValid()) // true
fmt.Println(reflect.ValueOf(ip2).Kind())  //ptr
fmt.Println(reflect.ValueOf(ip2).String()) // <*main.Student Value>
```

其它的方法全部会抛出`panic`异常。
`Value`类型也满足`fmt.Stringer()`接口，`String()`方法只返回其类型。默认fmt包的%v标志参数，会对`reflect.Values`特殊处理。

`interface()`方法，返回一个任意(interface{}类型)类型。
