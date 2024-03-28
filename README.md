![](https://cdn.learnku.com/uploads/images/202403/27/24833/n0B8VoBb6I.jpg)
## 命令说明
Mac终端敲入以下命令即可永久切换镜像
切换到阿里云：switch_brew_mirror 1
切换到清华：switch_brew_mirror 2
恢复默认配置：switch_brew_mirror 0
切换到xxx镜像：switch_brew_mirror xxx

## 添加自定义镜像的方法
只需将有效的 url 写入 MIRROR_URLS 的 xxx 下，之后就可以使用命令`switch_brew_mirror xxx`进行切换。如下所示
``` perl
my %MIRROR_URLS    = (
    aliyun => { … },
    tsinghua => { … },
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
1、将 [.switch_brew_mirror.pl](https://gitee.com/zhaiduting/zdt/blob/master/.switch_brew_mirror.pl ".switch_brew_mirror.pl") 脚本放入用户的 $HOME 目录；
2、编辑 $HOME/.zprofile 文件，末尾添加以下3行代码即可
``` shell
switch_brew_mirror() {
    eval "$(perl .switch_brew_mirror.pl "$1")"
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
Invalid parameter alibb. Usage: switch_brew_mirror [0|aliyun|tsinghua]
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
一开始我是打算用shell脚本来实现这个功能的，但是发现 source 命令读取shell脚本后，所有的函数都直接暴露到终端了。改用perl后就没这问题了，用户只需调用、也只能调用一个名为 switch_brew_mirror 的函数。

## 镜像资料
阿里镜像 https://developer.aliyun.com/mirror/homebrew
清华镜像 https://mirrors.tuna.tsinghua.edu.cn/help/homebrew
Homebrew https://brew.sh
