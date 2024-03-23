#!/usr/bin/perl

use strict;
use warnings;

my $BREW_MIRROR = "2";
my %mirror_urls;

$mirror_urls{'1'} = $mirror_urls{'aliyun'} = {
    HOMEBREW_API_DOMAIN => "https://mirrors.aliyun.com/homebrew-bottles/api",
    HOMEBREW_BOTTLE_DOMAIN => "https://mirrors.aliyun.com/homebrew/homebrew-bottles",
    HOMEBREW_BREW_GIT_REMOTE => "https://mirrors.aliyun.com/homebrew/brew.git",
    HOMEBREW_CORE_GIT_REMOTE => "https://mirrors.aliyun.com/homebrew/homebrew-core.git"
};

$mirror_urls{'2'} = $mirror_urls{'tsinghua'} = {
    HOMEBREW_API_DOMAIN => "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api",
    HOMEBREW_BOTTLE_DOMAIN => "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles",
    HOMEBREW_BREW_GIT_REMOTE => "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git",
    HOMEBREW_CORE_GIT_REMOTE => "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
};

my $script_file = $0;  # Current script file

sub update_brew_mirror_config {
    my $new_mirror = shift;
    if ($new_mirror ne $BREW_MIRROR) {
        $BREW_MIRROR = $new_mirror;
        local @ARGV = ($script_file);
        local $^I = '.bak';  # Create a backup file with .bak extension
        while (<>) {
            s/^my \$BREW_MIRROR = .*;/my \$BREW_MIRROR = "$new_mirror";/;
            print;
        }
        print qq{echo "Switched to $BREW_MIRROR mirror.\n"}
    }
}

sub export_mirror_to_shell {
    my $mirror_key = shift;
    my $mirror_hashref = $mirror_urls{$mirror_key};
    foreach my $key (keys %$mirror_hashref) {
        my $value = $mirror_hashref->{$key};
        print qq{export $key="$value"\n};
    }
}

sub switch_brew_mirror {
    my $mirror_param = shift || $BREW_MIRROR;
    if (exists $mirror_urls{$mirror_param}) {
        update_brew_mirror_config($mirror_param);
        export_mirror_to_shell($mirror_param);
    } else {
        print qq{echo "Invalid parameter. Usage: switch_brew_mirror [aliyun|tsinghua]\n"};
        return 1;
    }
}

switch_brew_mirror($ARGV[0]);  # Pass the command line argument directly
