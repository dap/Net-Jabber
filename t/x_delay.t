use lib "t/lib";
use Test::More tests=>39;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $x = new Net::Jabber::X();
ok( defined($x), "new()" );
isa_ok( $x, "Net::Jabber::X" );

testScalar($x,"XMLNS","jabber:x:delay");

testJID($x, "From", "user", "server", "resource");
testSetScalar($x, "Message", "message");
testScalar($x, "Stamp", "stamp");

is( $x->GetXML(), "<x from='user\@server/resource' stamp='stamp' xmlns='jabber:x:delay'>message</x>", "GetXML()" );

$x->SetStamp();
is( $x->DefinedStamp, 1, "stamp defined" );
like( $x->GetStamp, qr/^\d\d\d\d\d\d\d\dT\d\d:\d\d:\d\d$/, "look like a stamp?");


my $x2 = new Net::Jabber::X();
ok( defined($x2), "new()" );
isa_ok( $x2, "Net::Jabber::X" );

testScalar($x2,"XMLNS","jabber:x:delay");

$x2->SetDelay(from=>"user\@server/resource",
                   message=>"message",
                   stamp=>"stamp");

testPostJID($x2, "From", "user", "server", "resource");
testPostScalar($x2, "Message", "message");
testPostScalar($x2, "Stamp", "stamp");

is( $x2->GetXML(), "<x from='user\@server/resource' stamp='stamp' xmlns='jabber:x:delay'>message</x>", "GetXML()" );

