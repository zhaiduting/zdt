switch_brew_mirror() {
    case "$1" in
        1 | aliyun)
            export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api"
            export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
            export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
            export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
            echo "Switched to Aliyun mirror."
            ;;
        2 | tsinghua)
            export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
            export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
            export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
            export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
            echo "Switched to Tsinghua mirror."
            ;;
        *)
            echo "Invalid parameter. Usage: switch_brew_mirror [aliyun|tsinghua]"
            return 1
            ;;
    esac
}

switch_brew_mirror "aliyun" > /dev/null
