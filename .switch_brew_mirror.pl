#!/usr/bin/perl

use strict;
use warnings;

my $CURRENT_MIRROR = "tsinghua";
my %mirror_urls    = (
    aliyun => {
        HOMEBREW_API_DOMAIN =>
          "https://mirrors.aliyun.com/homebrew-bottles/api",
        HOMEBREW_BOTTLE_DOMAIN =>
          "https://mirrors.aliyun.com/homebrew/homebrew-bottles",
        HOMEBREW_BREW_GIT_REMOTE =>
          "https://mirrors.aliyun.com/homebrew/brew.git",
        HOMEBREW_CORE_GIT_REMOTE =>
          "https://mirrors.aliyun.com/homebrew/homebrew-core.git"
    },
    tsinghua => {
        HOMEBREW_API_DOMAIN =>
          "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api",
        HOMEBREW_BOTTLE_DOMAIN =>
          "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles",
        HOMEBREW_BREW_GIT_REMOTE =>
          "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git",
        HOMEBREW_CORE_GIT_REMOTE =>
          "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    }
);
my $script_file = $0;    # Current script file

sub switch_brew_mirror {
    my $mirror_param = shift;
    if ( $mirror_param eq '' ) {
        $mirror_param = $CURRENT_MIRROR;
    }
    my $mirror_key = get_mirror_key($mirror_param);
    if ( $mirror_key eq 'RESET_MIRROR' ) {
        update_mirror_config('0');
        unset_brew_mirror();
    }
    elsif ( $mirror_key eq 'PARAM_ERROR' ) {
        echo_mirror_usage($mirror_param);
    }
    else {
        update_mirror_config($mirror_key);
        export_mirror_to_shell($mirror_key);
    }
}

sub get_mirror_key {
    my $mirror_param = shift;
    if ( exists $mirror_urls{$mirror_param} ) {
        return $mirror_param;
    }
    elsif ( $mirror_param =~ /\D/ ) {
        return 'PARAM_ERROR';
    }
    elsif ( $mirror_param == 0 ) {
        return 'RESET_MIRROR';
    }

    my @sorted_keys = sort keys %mirror_urls;
    my $index       = int($mirror_param);
    if ( $index > 0 && $index <= @sorted_keys ) {
        return $sorted_keys[ $index - 1 ];
    }
    return 'PARAM_ERROR';
}

sub update_mirror_config {
    my $new_mirror = shift;
    if ( $new_mirror ne $CURRENT_MIRROR ) {
        local @ARGV = ($script_file);
        local $^I   = '';
        while (<>) {
            s/^my \$CURRENT_MIRROR = .*;/my \$CURRENT_MIRROR = "$new_mirror";/;
            print;
        }
        if ($new_mirror) {
            print qq{echo "Switched to $new_mirror mirror."\n};
        }
        else {
            print qq{echo "Using Homebrew default URL."\n};
        }
    }
}

sub export_mirror_to_shell {
    my $mirror_key     = shift;
    my $mirror_hashref = $mirror_urls{$mirror_key};
    foreach my $key ( keys %$mirror_hashref ) {
        my $value = $mirror_hashref->{$key};
        print qq{export $key="$value"\n};
    }
}

sub echo_mirror_usage {
    my $p              = shift;
    my $mirror_options = join( '|', ( 0, sort keys %mirror_urls ) );
    print
qq{echo "Invalid parameter $p. Usage: switch_brew_mirror [$mirror_options]"\n};
}

sub unset_brew_mirror() {
    my $first_mirror_settings = ( values %mirror_urls )[0];
    for my $key ( keys %$first_mirror_settings ) {
        print qq{unset "$key"\n};
    }
}
switch_brew_mirror( $ARGV[0] );    # Pass the command line argument directly

