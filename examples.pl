#!/usr/bin/env perl
use strict;

######### A -- Ruby-style iterator as implemented in perl
package A;

sub evens_to_ten {
    my ($sub) = @_;
    foreach my $i (0..5) {
        &$sub($i * 2);
    }
}

my $n = 0;
evens_to_ten sub {
    my ($even) = @_;
    printf "%d(%d) ", $n, $even;
    $n += 1;
};
print "\n";


######### B -- Ruby-style iterator using prototype and extra argument
package B;

sub evens_to_x (&$) {
    my ($sub, $x) = @_;
    foreach my $i (0..$x) {
        &$sub($i * 2);
    }
}

my $n = 0;
evens_to_x {
    my ($even) = @_;
    printf "%d(%d) ", $n, $even;
    $n += 1;
} 5;
print "\n";


######## C -- Python-style iterator object in perl
#
# man perlsyn: foreach probably won't do what you expect if VAR is a
# tied or other special variable.   Don't do that either.
#

package EvensToTenC;

sub iterator {
    tie (my @foo, 'EvensToTenC');
    return \@foo
}

sub TIEARRAY {
    my ($class, $bound) = @_;
    return bless {
        NEXT => 0,
        I => -2,
    }, $class;
}

sub FETCHSIZE { 6; }

sub FETCH {
    my ($self, $i) = @_;
    $i == $self->{NEXT} or die "Iterating out of order";
    $self->{NEXT} = $i + 1;
    return $self->{I} += 2;
}

package C;

my $n = 0;
foreach (@{iterator EvensToTenC}) {
    printf "%d(%d) ", $n, $_;
    $n += 1;
}
print "\n";

my @b = map { $_ * 2 } @{iterator EvensToTenC};
print @b;


########## objects using closure

sub newFoo {
    my ($low, $high) = @_;
    my $index = 0;

    return {
        'low' => sub { $low },
        'high' => sub { $high },
        'index' => sub { $index },
        'next' => sub {
            $index += 1
        }
    }
}

my $x = newFoo(0,5);
my $y = newFoo(6,10);
print $x->{'low'}, "\n";
print $y->{'low'}, "\n";
