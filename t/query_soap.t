use lib "t/lib";
use Test::More tests=>21;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $query = new Net::Jabber::Query("soap");
ok( defined($query), "new()" );
isa_ok( $query, "Net::Jabber::Query" );

testScalar($query,"XMLNS","http://www.jabber.org/protocol/soap");

testScalar($query,"Payload","<this>is a test</this>");

is( $query->GetXML(), "<soap xmlns='http://www.jabber.org/protocol/soap'><this>is a test</this></soap>", "GetXML()" );


my $query2 = new Net::Jabber::Query("soap");
ok( defined($query2), "new()" );
isa_ok( $query2, "Net::Jabber::Query" );

testScalar($query2,"XMLNS","http://www.jabber.org/protocol/soap");

$query2->SetSoap(payload=>"<new><test foo='1'/></new>");

testPostScalar($query2,"Payload","<new><test foo='1'/></new>");

is( $query2->GetXML(), "<soap xmlns='http://www.jabber.org/protocol/soap'><new><test foo='1'/></new></soap>", "GetXML()" );


my $node = new XML::Stream::Node("soap");
$node->put_attrib(xmlns=>"http://www.jabber.org/protocol/soap");
my $node1 = $node->add_child("foo");
$node1->put_attrib(gah=>2);
my $node2 = $node1->add_child("bar","This is parse test.");

my $query3 = new Net::Jabber::Query($node);

testPostScalar($query3,"Payload","<foo gah='2'><bar>This is parse test.</bar></foo>");

is( $query3->GetXML(), "<soap xmlns='http://www.jabber.org/protocol/soap'><foo gah='2'><bar>This is parse test.</bar></foo></soap>", "GetXML()" );


