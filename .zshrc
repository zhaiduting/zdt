
alias ll='ls -l "$@"'
PS1='%1~ > '
export LANG=zh_CN.UTF-8

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME='/Applications/Android Studio.app/Contents/jbr/Contents/Home'

export PATH=$PATH:$HOME/mytools
export PATH=$PATH:$HOME/go/bin