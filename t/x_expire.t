use lib "t/lib";
use Test::More tests=>18;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $x = new Net::Jabber::X();
ok( defined($x), "new()" );
isa_ok( $x, "Net::Jabber::X" );

testScalar($x,"XMLNS","jabber:x:expire");

testScalar($x,"Seconds","seconds");

is( $x->GetXML(), "<x seconds='seconds' xmlns='jabber:x:expire'/>", "GetXML()");

my $x2 = new Net::Jabber::X();
ok( defined($x2), "new()" );
isa_ok( $x2, "Net::Jabber::X" );

testScalar($x2,"XMLNS","jabber:x:expire");

$x2->SetExpire(seconds=>"seconds");

testPostScalar($x2,"Seconds","seconds");

is( $x2->GetXML(), "<x seconds='seconds' xmlns='jabber:x:expire'/>", "GetXML()");

