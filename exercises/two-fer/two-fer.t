#!/usr/bin/env perl6
use v6;
use Test;
use JSON::Fast;
use lib $?FILE.IO.dirname; #`[Look for the module inside the same directory as this test file.]
use TwoFer;
plan 3; #`[This is how many tests we expect to run.]

my $c-data = from-json $=pod.pop.contents;
# Go through the cases and check that &two-fer gives us the correct response.
for $c-data<cases>.values {
  is .<input><name> ??
    two-fer(.<input><name>) !!
    two-fer,
    |.<expected description>;
}

=head2 Canonical Data
=begin code
{
  "exercise": "two-fer",
  "version": "1.2.0",
  "cases": [
    {
      "description": "no name given",
      "property": "twoFer",
      "input": {
        "name": null
      },
      "expected": "One for you, one for me."
    },
    {
      "description": "a name given",
      "property": "twoFer",
      "input": {
        "name": "Alice"
      },
      "expected": "One for Alice, one for me."
    },
    {
      "description": "another name given",
      "property": "twoFer",
      "input": {
        "name": "Bob"
      },
      "expected": "One for Bob, one for me."
    }
  ]
}
=end code
