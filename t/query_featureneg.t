use lib "t/lib";
use Test::More tests=>19;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $query = new Net::Jabber::Query("feature");
ok( defined($query), "new()" );
isa_ok( $query, "Net::Jabber::Query" );

testScalar($query,"XMLNS","http://jabber.org/protocol/feature-neg");

is( $query->GetXML(), "<feature xmlns='http://jabber.org/protocol/feature-neg'/>", "GetXML()" );


my $query2 = new Net::Jabber::Query("feature");
ok( defined($query2), "new()" );
isa_ok( $query2, "Net::Jabber::Query" );

testScalar($query2,"XMLNS","http://jabber.org/protocol/feature-neg");

$query2->SetFeatureNeg();

is( $query2->GetXML(), "<feature xmlns='http://jabber.org/protocol/feature-neg'/>", "GetXML()" );


my $query3 = new Net::Jabber::Query("feature");
ok( defined($query3), "new()" );
isa_ok( $query3, "Net::Jabber::Query" );

testScalar($query3,"XMLNS","http://jabber.org/protocol/feature-neg");

my $xdata = $query3->NewX("jabber:x:data");

is( $query3->GetXML(), "<feature xmlns='http://jabber.org/protocol/feature-neg'><x xmlns='jabber:x:data'/></feature>", "GetXML()" );

