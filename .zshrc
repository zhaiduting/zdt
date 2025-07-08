
alias adb_wifi='adb -s $(adb devices | grep _adb-tls-connect | cut -f1)'
alias ll='ls -l "$@"'
PS1='%1~ > '
export LANG=zh_CN.UTF-8

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:$HOME/mytools
export PATH=$PATH:$HOME/go/bin