#!/usr/bin/perl

use strict;
use warnings;

my $BREW_MIRROR = "aliyun";
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

        print "Switched to $BREW_MIRROR mirror.\n";
    }
}

sub switch_brew_mirror {
    my $mirror_param = shift;

    if ($mirror_param == 1 or $mirror_param eq "aliyun") {
        $ENV{"HOMEBREW_API_DOMAIN"} = "https://mirrors.aliyun.com/homebrew-bottles/api";
        $ENV{"HOMEBREW_BREW_GIT_REMOTE"} = "https://mirrors.aliyun.com/homebrew/brew.git";
        $ENV{"HOMEBREW_CORE_GIT_REMOTE"} = "https://mirrors.aliyun.com/homebrew/homebrew-core.git";
        $ENV{"HOMEBREW_BOTTLE_DOMAIN"} = "https://mirrors.aliyun.com/homebrew/homebrew-bottles";
        update_brew_mirror_config("aliyun");
    }
    elsif ($mirror_param == 2 or $mirror_param eq "tsinghua") {
        $ENV{"HOMEBREW_API_DOMAIN"} = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
        $ENV{"HOMEBREW_BOTTLE_DOMAIN"} = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
        $ENV{"HOMEBREW_BREW_GIT_REMOTE"} = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
        $ENV{"HOMEBREW_CORE_GIT_REMOTE"} = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
        update_brew_mirror_config("tsinghua");
    }
    else {
        print "Invalid parameter. Usage: switch_brew_mirror [aliyun|tsinghua]\n";
        return 1;
    }
}

switch_brew_mirror($ARGV[0]);  # Pass the command line argument directly
