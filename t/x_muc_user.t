use lib "t/lib";
use Test::More tests=>113;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $x = new Net::Jabber::X();
ok( defined($x), "new()" );
isa_ok( $x, "Net::Jabber::X" );

testScalar($x,"XMLNS",'http://jabber.org/protocol/muc#user');

testScalar($x,"Alt","alt");
testJID($x,"InviteFrom","user1", "server1", "resource1");
testJID($x,"InviteTo","user2", "server2", "resource2");
testScalar($x,"InviteReason","reason");
testJID($x,"ItemActorJID","user3", "server3", "resource3");
testScalar($x,"ItemAffiliation","affiliation");
testJID($x,"ItemJID","user4", "server4", "resource4");
testScalar($x,"ItemNick","nick");
testScalar($x,"ItemReason","reason");
testScalar($x,"ItemRole","role");
testScalar($x,"Password","password");
testScalar($x,"StatusCode","code");

is( $x->GetXML(), "<x xmlns='http://jabber.org/protocol/muc#user'><alt>alt</alt><invite from='user1\@server1/resource1' to='user2\@server2/resource2'><reason>reason</reason></invite><item affiliation='affiliation' jid='user4\@server4/resource4' nick='nick' role='role'><actor jid='user3\@server3/resource3'/><reason>reason</reason></item><password>password</password><status code='code'/></x>", "GetXML()");

my $x2 = new Net::Jabber::X();
ok( defined($x2), "new()" );
isa_ok( $x2, "Net::Jabber::X" );

testScalar($x2,"XMLNS","http://jabber.org/protocol/muc#user");

$x2->SetUser(alt=>"alt",
             invitefrom=>'user5@server5/resource5',
             invitereason=>"reason",
             inviteto=>'user6@server6/resource6',
             itemactorjid=>'user7@server7/resource7',
             itemaffiliation=>"affiliation",
             itemjid=>'user8@server8/resource8',
             itemnick=>"nick",
             itemreason=>"reason",
             itemrole=>"role",
             password=>"password",
             statuscode=>"code"
            );

testPostScalar($x2,"Alt","alt");
testPostJID($x2,"InviteFrom","user5", "server5", "resource5");
testPostJID($x2,"InviteTo","user6", "server6", "resource6");
testPostScalar($x2,"InviteReason","reason");
testPostJID($x2,"ItemActorJID","user7", "server7", "resource7");
testPostScalar($x2,"ItemAffiliation","affiliation");
testPostJID($x2,"ItemJID","user8", "server8", "resource8");
testPostScalar($x2,"ItemNick","nick");
testPostScalar($x2,"ItemReason","reason");
testPostScalar($x2,"ItemRole","role");
testPostScalar($x2,"Password","password");
testPostScalar($x2,"StatusCode","code");

is( $x2->GetXML(), "<x xmlns='http://jabber.org/protocol/muc#user'><alt>alt</alt><invite from='user5\@server5/resource5' to='user6\@server6/resource6'><reason>reason</reason></invite><item affiliation='affiliation' jid='user8\@server8/resource8' nick='nick' role='role'><actor jid='user7\@server7/resource7'/><reason>reason</reason></item><password>password</password><status code='code'/></x>", "GetXML()");

