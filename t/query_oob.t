use lib "t/lib";
use Test::More tests=>23;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $query = new Net::Jabber::Query();
ok( defined($query), "new()" );
isa_ok( $query, "Net::Jabber::Query" );

testScalar($query,"XMLNS","jabber:iq:oob");

testScalar($query,"Desc","desc");
testScalar($query,"URL","url");

is( $query->GetXML(), "<query xmlns='jabber:iq:oob'><desc>desc</desc><url>url</url></query>", "GetXML()" );


my $query2 = new Net::Jabber::Query();
ok( defined($query2), "new()" );
isa_ok( $query2, "Net::Jabber::Query" );

testScalar($query2,"XMLNS","jabber:iq:oob");

$query2->SetOob(desc=>"desc",
                url=>"url"
                );

testPostScalar($query2,"Desc","desc");
testPostScalar($query2,"URL","url");

is( $query2->GetXML(), "<query xmlns='jabber:iq:oob'><desc>desc</desc><url>url</url></query>", "GetXML()" );

