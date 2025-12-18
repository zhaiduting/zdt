if [ -n "$ZSH_VERSION" ]; then
    PS1='%1~ > '
    alias ll='ls -l "$@"'
else
    PS1='\W > '
fi
export LANG=zh_CN.UTF-8
