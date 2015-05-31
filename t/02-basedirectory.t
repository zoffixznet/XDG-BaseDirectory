#!perl6

use v6;
use lib 'lib';

use Test;

use XDG::BaseDirectory;

my $obj;

lives-ok { $obj = XDG::BaseDirectory.new }, " new XDG::BaseDirectory";

isa-ok($obj, XDG::BaseDirectory, "right sort of thing");

ok($obj.can(Q[xdg-data-home]), Q[can xdg-data-home]);
ok($obj.can(Q[xdg-data-dirs]), Q[can xdg-data-dirs]);
ok($obj.can(Q[xdg-config-home]), Q[can xdg-config-home]);
ok($obj.can(Q[xdg-config-dirs]), Q[can xdg-config-dirs]);
ok($obj.can(Q[xdg-cache-home]), Q[can xdg-cache-home]);
ok($obj.can(Q[save-config-path]), Q[can save-config-path]);
ok($obj.can(Q[save-data-path]), Q[can save-data-path]);
ok($obj.can(Q[load-config-paths]), Q[can load-config-paths]);
ok($obj.can(Q[load-first-config]), Q[can load-first-config]);
ok($obj.can(Q[load-data-paths]), Q[can load-data-paths]);

my $base = $*CWD.child('.test_' ~ $*PID);

$base.mkdir;

%*ENV<XDG_CONFIG_HOME> = $base.child('.config').Str;
%*ENV<XDG_DATA_HOME> = $base.child($*SPEC.catfile('.local', 'share')).Str;

isa-ok($obj.xdg-config-home, IO::Path, 'xdg-config-home is an IO::Path');
isa-ok($obj.xdg-data-home, IO::Path, 'xdg-data-home is an IO::Path');
is($obj.xdg-config-home.Str, $base.child('.config').Str, 'xdg-config-home is the right path');
is($obj.xdg-data-home.Str, $base.child($*SPEC.catfile('.local', 'share')).Str, 'xdg-data-home is the right path');

ok(my $scp = $obj.save-config-path('foo', 'bar'), 'save-config-path');
isa-ok($scp, IO::Path, 'and it is an IO::Path');
ok($scp.Str.IO.d, 'and the directory exists');
ok($scp.d, 'and the directory exists');






END {
   if $base.e {
      $base.rmdir;
   }
}



done();
