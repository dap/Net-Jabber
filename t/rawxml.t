use lib "t/lib";
use Test::More tests=>28;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $message = new Net::Jabber::Message();
ok( defined($message), "new()");
isa_ok( $message, "Net::Jabber::Message");

testScalar($message, "Body", "body");
testJID($message, "From", "user1", "server1", "resource1");
testScalar($message, "Subject", "subject");
testJID($message, "To", "user2", "server2", "resource2");

$message->InsertRawXML("<foo>bar</foo>");
$message->InsertRawXML("<bar>foo</bar>");

is( $message->GetXML(), "<message from='user1\@server1/resource1' to='user2\@server2/resource2'><body>body</body><subject>subject</subject><foo>bar</foo><bar>foo</bar></message>", "GetXML()" );

$message->ClearRawXML();

is( $message->GetXML(), "<message from='user1\@server1/resource1' to='user2\@server2/resource2'><body>body</body><subject>subject</subject></message>", "GetXML()" );

$message->InsertRawXML("<bar>foo</bar>");

is( $message->GetXML(), "<message from='user1\@server1/resource1' to='user2\@server2/resource2'><body>body</body><subject>subject</subject><bar>foo</bar></message>", "GetXML()" );

