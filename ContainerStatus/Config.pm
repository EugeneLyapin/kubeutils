package ContainerStatus::Config;

use 5.008008;
use strict;
use Exporter;
use base qw( Exporter );
use JSON::PP;
use ContainerStatus::Debug;

our @EXPORT = qw(
            getConf
        );

sub getConf {
    my %opts = ();
    my $TIMEOUT = $ENV{TIMEOUT} || 300;
    my $DELAY = $ENV{DELAY} || 30;
    my $CYCLES = int($TIMEOUT*2/$DELAY);
    my $RUNNING_CYCLES = $ENV{RUNNING_CYCLES} || int($TIMEOUT/($DELAY*2));
    my $NAMESPACE = $ENV{NAMESPACE} || 'default';
    my $PROJECT_NAME = $ENV{PROJECT_NAME} || undef;
    my $AWS_CLUSTER = $ENV{AWS_CLUSTER} || undef;
    my $TOKEN = $ENV{TOKEN} || undef;
    errx('PROJECT_NAME is not defined') if not defined $PROJECT_NAME;
    errx('Number of watch cycles is low. Increase TIMEOUT and/or reduce DELAY') if $CYCLES <= 1;
    errx('Number of running cycles is low. Increase TIMEOUT and/or reduce DELAY') if $RUNNING_CYCLES <= 1;
    my $kubeargs = "--namespace $NAMESPACE -l app=$ENV{PROJECT_NAME}";
    $kubeargs .= " --token=$TOKEN" if defined $TOKEN;
    $kubeargs .= " --cluster $AWS_CLUSTER" if defined $AWS_CLUSTER;
    my $conf = {
        TIMEOUT => $TIMEOUT,
        DELAY => $DELAY,
        CYCLES => $CYCLES,
        RUNNING_CYCLES => $RUNNING_CYCLES,
    };

    debug(encode_json($conf));

    # do not show sensitive data
    $conf->{kubeargs} = $kubeargs;
    return $conf;
}

1;
