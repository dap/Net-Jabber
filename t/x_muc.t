use lib "t/lib";
use Test::More tests=>7;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $x = new Net::Jabber::X();
ok( defined($x), "new()" );
isa_ok( $x, "Net::Jabber::X" );

testScalar($x,"XMLNS","http://jabber.org/protocol/muc");

is( $x->GetXML(), "<x xmlns='http://jabber.org/protocol/muc'/>", "GetXML()");

