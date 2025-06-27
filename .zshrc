
alias ll='ls -l "$@"'
PS1='%1~ > '

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH=$PATH:$HOME/mytools
export PATH=$PATH:$HOME/go/bin