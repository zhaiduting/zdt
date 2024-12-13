![](https://cdn.learnku.com/uploads/images/202403/27/24833/n0B8VoBb6I.jpg)  
## 命令说明  
Mac终端敲入以下命令即可永久切换镜像（使用数字或镜像名称都可以）  
切换到阿里源：switch_brew_mirror 1  
切换到清华源：switch_brew_mirror 2  
切换到科大源：switch_brew_mirror 3  
重置为官方地址：switch_brew_mirror 0  
切换自定义镜像：switch_brew_mirror xxx  
  
## 添加自定义镜像的方法  
只需将有效的 url 写入 MIRROR_URLS 的 xxx 下，之后就可以使用命令`switch_brew_mirror xxx`进行切换。如下所示  
``` perl  
my %MIRROR_URLS    = (  
    aliyun => { … },  
    tsinghua => { … },  
    ustc => { … },  
    xxx => {  
        HOMEBREW_API_DOMAIN => "Valid URL1",  
        HOMEBREW_BOTTLE_DOMAIN => "Valid URL2",  
        HOMEBREW_BREW_GIT_REMOTE => "Valid URL3",  
        HOMEBREW_CORE_GIT_REMOTE => "Valid URL4",  
        …  
    }  
);  
```  
  
## 安装方法  
无需安装，步骤如下：  
1、将[github.com/zhaiduting/zdt/blob/main/.switch_brew_mirror.pl](https://github.com/zhaiduting/zdt/blob/main/.switch_brew_mirror.pl "https://github.com/zhaiduting/zdt/blob/main/.switch_brew_mirror.pl")脚本文件放入用户的 $HOME 目录（或改用 [gitee.com/~/.switch_brew_mirror.pl](https://gitee.com/zhaiduting/zdt/blob/main/.switch_brew_mirror.pl "gitee") ）
2、编辑 $HOME/.zprofile 文件，末尾添加以下3行代码即可  
``` shell  
switch_brew_mirror() {
    eval "$(perl ~/.switch_brew_mirror.pl "$1")"
}; switch_brew_mirror
```  
  
## Mac终端测试结果如下  
Last login: Wed Mar 27 10:57:45 on ttys002  
~ > echo $HOMEBREW_BREW_GIT_REMOTE  
https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git  
~ >  
~ > switch_brew_mirror 0  
Using Homebrew default URL.  
~ > echo $HOMEBREW_BREW_GIT_REMOTE  
  
~ > switch_brew_mirror alibb  
Invalid parameter alibb. Usage: switch_brew_mirror [0|aliyun|tsinghua|ustc]  
~ >  
~ > switch_brew_mirror aliyun  
Switched to aliyun mirror.  
~ > echo $HOMEBREW_BREW_GIT_REMOTE  
https://mirrors.aliyun.com/homebrew/brew.git  
~ >  
~ > switch_brew_mirror 2  
Switched to tsinghua mirror.  
~ > echo $HOMEBREW_BREW_GIT_REMOTE  
https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git  
~ >  
  
## 为什么使用 perl 脚本  
一开始是打算用shell脚本来实现这个功能的，但是发现 source 命令加载shell脚本后，所有的函数都直接暴露到终端了。改用perl后就没这问题了，用户只需调用、也只能调用一个名为 switch_brew_mirror 的函数。  
  
## 镜像资料  
阿里镜像 https://developer.aliyun.com/mirror/homebrew  
清华镜像 https://mirrors.tuna.tsinghua.edu.cn/help/homebrew  
科大源 https://mirrors.ustc.edu.cn/help/brew.git.html  
Homebrew https://brew.sh  

---
## 实现原理

以下代码在用户的shell环境中，定义了一个立即执行函数 switch_brew_mirror() 
```
switch_brew_mirror() {
    eval "$(perl ~/.switch_brew_mirror.pl "$1")"
}; switch_brew_mirror
```

switch_brew_mirror() 函数体仅一行代码，但是做了两件事：
1、调用 perl 执行脚本程序 `~/.switch_brew_mirror.pl`并将用户在终端的输入作为参数传递给这个脚本程序。
2、使用 eval 命令执行 perl 脚本程序打印出来的字符串。
```
// 如果用户在终端敲入以下命令，则  $1 值为 aliyun
switch_brew_mirror aliyun

// 也可以直接敲入数字（更简单）
// 例如以下命令，其中  $1 值为 2
switch_brew_mirror 2

// 如果用户没有敲入任何命令，则立即执行函数会把空值传递给 $1
// 后续脚本将使用 $CURRENT_MIRROR 的值取代空值
```

脚本 .switch_brew_mirror.pl 拿到用户在终端敲入的参数后去查找 my %MIRROR_URLS 中对应键位的值，如果找到，则打印找到的这组字符串。
```
// 假设 $1 值为 aliyun 则打印出以下一组字符串
export HOMEBREW_INSTALL_FROM_API="1"
export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"

```

注意 perl 脚本程序执行完毕后，打印出来的字符串会传回 shell 环境中的 switch_brew_mirror() 函数里。此函数使用 eval 命令执行这组字符串，这样一来，用户终端就拿到了 Homebrew 镜像需要使用的 url 了。

---
## 切换镜像后如何实现永久保存？

这个其实很简单，就是直接修改脚本程序本身的变量值 `my $CURRENT_MIRROR `。这个操作是通过调用函数`sub update_mirror_config`完成的。此函数的相关代码不多（第82行开始） https://gitee.com/zhaiduting/zdt/blob/main/.switch_brew_mirror.pl 

通常，保存设置信息应该使用新的配置文件，或者使用数据库。不过，这里的做法却更加简单。
