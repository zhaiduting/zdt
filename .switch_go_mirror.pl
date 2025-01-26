#!/usr/bin/perl

use strict;
use warnings;

my $CURRENT_MIRROR = "qiniu";
my %MIRROR_URLS    = (
    golang => {
        GOPROXY => "https://proxy.golang.org,direct",
        GOSUMDB => "sum.golang.org"
    },
    aliyun => {
        GOPROXY => "https://mirrors.aliyun.com/goproxy/,direct",
        GOSUMDB => "sum.golang.google.cn"
    },
    baidu => {
        GOPROXY => "https://goproxy.bj.bcebos.com/,direct",
        GOSUMDB => "sum.golang.google.cn"
    },
    goproxy => {
        GOPROXY => "https://goproxy.io,direct",
        GOSUMDB =>
          "gosum.io+ce6e7565+AY5qEHUk/qmHc5btzW45JVoENfazw8LielDsaI+lEbq6"
    },
    cn => {
        GOPROXY => "https://proxy.golang.com.cn,direct",
        GOSUMDB => "sum.golang.google.cn"
    },
    qiniu => {
        GO111MODULE => "on",
        GOPROXY     => "https://goproxy.cn,direct",
        GOSUMDB     => "sum.golang.google.cn"
    },
    gocenter => {
        GOPROXY => "https://gocenter.io,direct",
        GOSUMDB => "sum.golang.google.cn"
    },
);

my $SCRIPT_FILE = $0;

sub switch_go_mirror {
    my $mirror_param = shift;

    # If $mirror_param is empty, set it to $CURRENT_MIRROR
    if ( $mirror_param eq '' ) {
        $mirror_param = $CURRENT_MIRROR;
    }

    my $mirror_key = get_mirror_key($mirror_param);

    if ( $mirror_key eq 'RESET_MIRROR' ) {
        update_mirror_config('0');
        unset_go_mirror();
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
          : qq{echo "Using default URL."\n};
    }
}

sub export_mirror_to_shell {
    my $mirror_key     = shift;
    my $mirror_hashref = $MIRROR_URLS{$mirror_key};
    print qq{export $_="$mirror_hashref->{$_}"\n} for keys %$mirror_hashref;
}

sub echo_mirror_usage {
    my $p              = shift;
    my $mirror_options = join( '|', sort keys %MIRROR_URLS );
    print
qq{echo "Invalid parameter $p. Usage: switch_go_mirror [$mirror_options]"\n};
}

sub unset_go_mirror {
    my $first_mirror_settings = ( values %MIRROR_URLS )[0];
    print qq{unset "$_"\n} for keys %$first_mirror_settings;
}

switch_go_mirror( $ARGV[0] );    # Pass the command line argument directly

