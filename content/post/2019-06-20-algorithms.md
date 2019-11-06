+++
title = "数据结构"
date = "2019-06-20"
tags = [ "tag1" ]
categories = [ "others" ]
+++

　　算法心得，使用golang实现常用的算法。算法导论中阐述了经典常用的数据结构和典型算法。
<!--more-->
### 排序

#### 插入排序(InsertionSort)O(n<sup>2</sup>)

解决问题思路：  
给定任意数组a1,a2,...,an  
1. 从第一个元素开始，该元素可以认为已经被排序
2. 取出下一个元素，在已经排序的元素序列中从后向前扫描
3. 如果该元素（已排序）大于新元素，将该元素移到下一位置
4. 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置
5. 将新元素插入到该位置后
6. 重复步骤2~5

```go
func InsertionSort(arr []int) {
	for i := 1; i < len(arr); i++ {
		for j := i - 1; j >= 0 && arr[j+1] < arr[j]; j-- {
			arr[j+1], arr[j] = arr[j], arr[j+1]
		}
		fmt.Printf("%v : %v\n", i, arr)
	}
}
```
说明：外层循环从数组的第二个元素开始(下标为1),依次与左侧数组部分进行比较。golang语法可以直接交换数组变量值，因此可以少定义一个temp临时变量。  
备注：内存循环j:=i-1从后往前扫描，并且左右数组的当前元素与key关键元素的比较要放在for的condition条件里面。当key值大于左侧数组最后一个元素时候，不需要进入循环体内部！
for循环执行步骤  
1. 初始化变量
2. 条件判断
3. 进入循环体
4. 执行post重新赋值变量
5. **倘若循环体里面使用了break的话，会直接退出循环，这样一来post是没有执行操作的，与未使用break的时候，条件变量是不一样的！**

```go
func main(){
	for ; i < 5; i++ {
		if i == 4 {
			break
		}
	}
	fmt.Println(i) //此时i=4
	for ; i < 5; i++ {
		if i == 4 {
		}
	}
	fmt.Println(i) //此时i=5
}
```

#### 归并排序(MergeSort)O(nlog<sup>n</sup>)
1. 递归实现

```go
func MergeSort(src []int) []int {
	length := len(src)
	if length <= 1 {
		return src
	}
	left := MergeSort(src[:length/2])
	right := MergeSort(src[length/2:])
	return merge(left, right)
}

func merge(left, right []int) (result []int) {
	l, r := 0, 0
	for l < len(left) && r < len(right) {
		if left[l] < right[r] {
			result = append(result, left[l])
			l++
		} else {
			result = append(result, right[r])
			r++
		}

	}
	result = append(result, left[l:]...)
	result = append(result, right[r:]...)
	return
}
```

2. 循环实现

```go
func MergeSort(arr []int) {
	l := len(arr)
	b := make([]int, l)
	for seg := 1; seg < l; seg *= 2 {
		for start := 0; start < l; start += seg * 2 {
			low, mid, high := start, min(start+seg, l), min(start+seg*2, l)
			k := low
			start1, end1 := low, mid
			start2, end2 := mid, high
			for start1 < end1 && start2 < end2 {
				if arr[start1] < arr[start2] {
					b[k] = arr[start1]
					k++
					start1++
				} else {
					b[k] = arr[start2]
					k++
					start2++
				}
			}
			for start1 < end1 {
				b[k] = arr[start1]
				k++
				start1++
			}
			for start2 < end2 {
				b[k] = arr[start2]
				k++
				start2++
			}
		}
		arr, b = b, arr
	}
	copy(b, arr)
}

func min(x, y int) int {
	if x < y {
		return x
	}
	return y
}
```
>提示：arr,b=b,arr交换的是引用类型(指针)。因此arr指向了一块新的临时内存temp(arr=b=new(["memory:temp"])),b指向了arr(形参)指向的内存，任何对b的修改
最终都反应到了arr实参上的修改。copy(b,arr)是必须的，将最终结果拷贝到(b=arr)所指向的内存地址，即改变了形参的值！

#### 快速排序(QickSort)

1. 平均时间复杂度O(nlg<sup>n</sup>)

```go
func QickSort(a []int, p, q int) {
	if p >= q {
		return
	}
	key := a[p]
	i := p
	for j := p + 1; j <= q; j++ {
		if a[j] < key {
			i++
			temp := a[j]
			a[j] = a[i]
			a[i] = temp
		}
	}
	a[p], a[i] = a[i], a[p]
	QickSort(a, p, i-1)
	QickSort(a, i+1, q)
}
```
