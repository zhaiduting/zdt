# Ubuntu 自动加载 HOME/.bash_aliases

if [ -n "$ZSH_VERSION" ]; then
    PS1='%1~ > '
else
    PS1='\W > '
fi

alias ll='ls -AlF --color=auto "$@"'
export LANG=zh_CN.UTF-8
