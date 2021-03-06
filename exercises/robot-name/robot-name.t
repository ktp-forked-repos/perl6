#!/usr/bin/env perl6
use v6;
use Test;
use lib $?FILE.IO.dirname;
use Robot;
plan 8;

subtest 'Class methods', {
  can-ok Robot, $_ for <name reset-name>;
}

srand 1;
my Robot:D $robot := Robot.new;
my Str:D @robot-names = $robot.name;
like @robot-names[0], /^^<[A..Z]>**2 <[0..9]>**3$$/, 'Name matches schema';

srand 2;
is $robot.name, @robot-names[0], 'Name is persistent';
srand 1;
@robot-names.push(Robot.new.name);
isnt @robot-names[1], @robot-names[0], 'New Robot cannot claim previous Robot name';

srand 1;
$robot.reset-name;
isnt $robot.name, @robot-names[0], "'reset-name' cannot use previous Robot name";

diag "\nCreating additional robots...";
my Promise:D $promise := start {until @robot-names.elems == ($Robot::test-all-names ?? 676000 !! 100) {
  @robot-names.push(Robot.new.name);
}};
loop {
  if $promise.Bool { last }
  else { sleep 1 }
  diag "@robot-names.elems.fmt() robots";
}
is @robot-names, @robot-names.unique, 'All names are unique';
subtest 'Randomness', {
  plan 2;
  isnt @robot-names[^100], @robot-names[^100].sort, 'Names not ordered';
  isnt @robot-names[^100], @robot-names[^100].sort.reverse, 'Names not reverse ordered';
}
if $Robot::test-all-names {
  throws-like {Robot.new}, Exception, 'Throw exception when out of names', message => /'All names used.'/;
}
else { skip 'All names test' }
