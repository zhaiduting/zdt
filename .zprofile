BREW_MIRROR="aliyun"

update_brew_mirror_config() {
    local new_mirror=$1
    if [ "$new_mirror" != "$BREW_MIRROR" ]; then
	BREW_MIRROR=$new_mirror
        sed -i '' "s/^BREW_MIRROR=.*/BREW_MIRROR=\"$new_mirror\"/" ~/.zprofile
	echo "Switched to $BREW_MIRROR mirror."
    fi
}

switch_brew_mirror() {
    local mirror_param=$1

    case "$mirror_param" in
        1 | aliyun)
            export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api"
            export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
            export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
            export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
            update_brew_mirror_config "aliyun"
            ;;
        2 | tsinghua)
            export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
            export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
            export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
            export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
            update_brew_mirror_config "tsinghua"
            ;;
        *)
            echo "Invalid parameter. Usage: switch_brew_mirror [aliyun|tsinghua]"
            return 1
            ;;
    esac
}

switch_brew_mirror "$BREW_MIRROR"
