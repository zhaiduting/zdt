switch_brew_mirror() {
    eval "$(perl ~/.switch_brew_mirror.pl "$1")"
}; switch_brew_mirror

eval "$(/opt/homebrew/bin/brew shellenv)"
