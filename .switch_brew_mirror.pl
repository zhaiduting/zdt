#!/usr/bin/perl

use strict;
use warnings;

my $CURRENT_MIRROR = "aliyun";
my %MIRROR_URLS    = (
    aliyun => {
        HOMEBREW_INSTALL_FROM_API => 1,
        HOMEBREW_API_DOMAIN       =>
          "https://mirrors.aliyun.com/homebrew-bottles/api",
        HOMEBREW_BREW_GIT_REMOTE =>
          "https://mirrors.aliyun.com/homebrew/brew.git",
        HOMEBREW_CORE_GIT_REMOTE =>
          "https://mirrors.aliyun.com/homebrew/homebrew-core.git",
        HOMEBREW_BOTTLE_DOMAIN =>
          "https://mirrors.aliyun.com/homebrew/homebrew-bottles"
    },
    tsinghua => {
        HOMEBREW_API_DOMAIN =>
          "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api",
        HOMEBREW_BOTTLE_DOMAIN =>
          "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles",
        HOMEBREW_BREW_GIT_REMOTE =>
          "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git",
        HOMEBREW_CORE_GIT_REMOTE =>
          "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git",
        HOMEBREW_PIP_INDEX_URL => "https://pypi.tuna.tsinghua.edu.cn/simple"
    },
    ustc => {
        HOMEBREW_BREW_GIT_REMOTE => "https://mirrors.ustc.edu.cn/brew.git",
        HOMEBREW_CORE_GIT_REMOTE =>
          "https://mirrors.ustc.edu.cn/homebrew-core.git",
        HOMEBREW_BOTTLE_DOMAIN =>
          "https://mirrors.ustc.edu.cn/homebrew-bottles",
        HOMEBREW_API_DOMAIN =>
          "https://mirrors.ustc.edu.cn/homebrew-bottles/api"
    }
);

my $SCRIPT_FILE = $0;

sub switch_brew_mirror {
    my $mirror_param = shift;

    # If $mirror_param is empty, set it to $CURRENT_MIRROR
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
    return 'RESET_MIRROR' if $mirror_param eq '0';
    return $mirror_param  if exists $MIRROR_URLS{$mirror_param};
    return 'PARAM_ERROR'
      if !defined($mirror_param)
      || $mirror_param =~
      /\D/;    # Check if $mirror_param is not defined or not numeric

    my @sorted_keys = sort keys %MIRROR_URLS;
    my $index       = int($mirror_param);
    return ( $index > 0 && $index <= @sorted_keys )
      ? $sorted_keys[ $index - 1 ]
      : 'PARAM_ERROR';
}

sub update_mirror_config {
    my $new_mirror = shift;
    if ( $new_mirror ne $CURRENT_MIRROR ) {
        local @ARGV = ($SCRIPT_FILE);
        local $^I   = '';
        while (<>) {
            s/^my \$CURRENT_MIRROR = .*;/my \$CURRENT_MIRROR = "$new_mirror";/;
            print;
        }
        print $new_mirror
          ? qq{echo "Switched to $new_mirror mirror."\n}
          : qq{echo "Using Homebrew default URL."\n};
    }
}

sub export_mirror_to_shell {
    my $mirror_key     = shift;
    my $mirror_hashref = $MIRROR_URLS{$mirror_key};
    print qq{export $_="$mirror_hashref->{$_}"\n} for keys %$mirror_hashref;
}

sub echo_mirror_usage {
    my $p              = shift;
    my $mirror_options = join( '|', ( 0, sort keys %MIRROR_URLS ) );
    print
qq{echo "Invalid parameter $p. Usage: switch_brew_mirror [$mirror_options]"\n};
}

sub unset_brew_mirror {
    my $first_mirror_settings = ( values %MIRROR_URLS )[0];
    print qq{unset "$_"\n} for keys %$first_mirror_settings;
}

switch_brew_mirror( $ARGV[0] );    # Pass the command line argument directly

