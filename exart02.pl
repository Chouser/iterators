#!/usr/bin/perl -w
use strict;

package FibBasicIterator;

sub new {
    my ($class, $start) = @_;
    bless my $self = {
        'current' => $start,
        'previous' => 0,
    };
}

sub getnext {
    my ($self) = @_;
    my $num = $self->{'current'};
    $self->{'current'} += $self->{'previous'};
    $self->{'previous'} = $num;
    return $num;
}

package main;

my $iter = FibBasicIterator->new(1);    # No named params in Perl
while (1) {                             # 1 means true in Perl
    my $num = $iter->getnext();
    print "$num\n";
    last if $num > 5;
}
