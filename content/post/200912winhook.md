+++
title = "SetWindowsHookEx"
date = "2020-09-12"
tags = [ "cpp" ]
categories = [ "windows" ]
+++

___SetWindowsHookEx___安装钩子程序，通过对操作系统消息的拦截,实现跨进程的操作。
<!--more-->

该方法有以下限制：

1. 有些钩子类型只能是线程的钩子，有些类型只能是全局的钩子。具体见msdn
2. 不能用于Console控制台应用程序，因为微软使用了一种完全不同的机制来实现Console程序
(此API只能挂接系统中的所有GUI线程，对于Windows console类的程序就无能为力了)

控制台应用可以通过`SetConsoleCtrlHandler`函数来处理，
这是一个控制台类型钩子，用来设置控制台的消息回调函数。

> Console程序的消息循环是在**Windows**的`kernel`中实现的，
因此我们想为Console程序设置钩子的话，必须在main函数中捕获消息循环。

```cpp
int main(int argc,char* argv[])
{
	g_hHook = SetWindowsHookEx(WH_MOUSE_LL,MouseProc,NULL,0);
	HANDLE hListenThread = (HANDLE) _beginthreadex(NULL,0,ListenTask,&sock,0,NULL);
	MSG	msg;
	BOOL bRet;
	while (bRet = ::GetMessage(&msg, NULL, 0, 0))
	{
		if (bRet == -1)
		{
			printf("GetMessage fail:errVal=%d]n", ::GetLastError());
			system("pause");
			break;
		}
		if (msg.message == UM_CLOSE && ::MessageBox(::GetConsoleWindow(), "Confirm exit yes or not", "CenterServer", MB_YESNO ) == IDYES)
		{
			g_bExit  =  true;
			break;
		}
	}
	::WaitForSingleObject(hListenThread,  INFINITE);
	::shutdown(sock,SD_BOTH);
	::closesocket(sock);
	::WSACleanup();
	UnhookWindowsHookEx(g_hHook);
	return 0;
}
```