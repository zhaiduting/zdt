switch_brew_mirror() {
    eval "$(perl ~/.switch_brew_mirror.pl "$1")"
}; switch_brew_mirror

eval "$(/opt/homebrew/bin/brew shellenv)"

switch_go_mirror() {
    eval "$(perl ~/.switch_go_mirror.pl "$1")"
}; switch_go_mirror