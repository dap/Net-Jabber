use lib "t/lib";
use Test::More tests=>55;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $query = new Net::Jabber::Query();
ok( defined($query), "new()" );
isa_ok( $query, "Net::Jabber::Query" );

testScalar($query,"XMLNS","jabber:iq:auth");

testScalar($query,"Digest","digest");
testScalar($query,"Hash","hash");
testScalar($query,"Password","password");
testScalar($query,"Resource","resource");
testScalar($query,"Sequence","sequence");
testScalar($query,"Token","token");
testScalar($query,"Username","username");

is( $query->GetXML(), "<query xmlns='jabber:iq:auth'><digest>digest</digest><hash>hash</hash><password>password</password><resource>resource</resource><sequence>sequence</sequence><token>token</token><username>username</username></query>", "GetXML()" );

my $query2 = new Net::Jabber::Query();
ok( defined($query2), "new()" );
isa_ok( $query2, "Net::Jabber::Query" );

testScalar($query2,"XMLNS","jabber:iq:auth");

testNotDefined($query2,"Digest");
testNotDefined($query2,"Hash");
testNotDefined($query2,"Password");
testNotDefined($query2,"Resource");
testNotDefined($query2,"Sequence");
testNotDefined($query2,"Token");
testNotDefined($query2,"Username");

$query2->SetAuth(digest=>"digest",
                 hash=>"hash",
                 password=>"password",
                 resource=>"resource",
                 sequence=>"sequence",
                 token=>"token",
                 username=>"username");

testPostScalar($query,"Digest","digest");
testPostScalar($query,"Hash","hash");
testPostScalar($query,"Password","password");
testPostScalar($query,"Resource","resource");
testPostScalar($query,"Sequence","sequence");
testPostScalar($query,"Token","token");
testPostScalar($query,"Username","username");

is( $query2->GetXML(), "<query xmlns='jabber:iq:auth'><digest>digest</digest><hash>hash</hash><password>password</password><resource>resource</resource><sequence>sequence</sequence><token>token</token><username>username</username></query>", "GetXML()" );

