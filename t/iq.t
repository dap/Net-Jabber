use lib "t/lib";
use Test::More tests=>86;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

#------------------------------------------------------------------------------
# iq
#------------------------------------------------------------------------------
my $iq = new Net::Jabber::IQ();
ok( defined($iq), "new()");
isa_ok( $iq, "Net::Jabber::IQ");

testScalar($iq, "Error", "error");
testScalar($iq, "ErrorCode", "401");
testJID($iq, "From", "user1", "server1", "resource1");
testScalar($iq, "ID", "id");
testJID($iq, "To", "user2", "server2", "resource2");
testScalar($iq, "Type", "Type");

is( $iq->DefinedX("jabber:x:oob"), "", "not DefinedX - jabber:x:oob" );
is( $iq->DefinedX("jabber:x:roster"), "", "not DefinedX - jabber:x:roster" );

#------------------------------------------------------------------------------
# X
#------------------------------------------------------------------------------
my $xoob = $iq->NewX("jabber:x:oob");
ok( defined( $xoob ), "NewX - jabber:x:oob" );
isa_ok( $xoob, "Net::Jabber::X" );
is( $iq->DefinedX(), 1, "DefinedX" );
is( $iq->DefinedX("jabber:x:oob"), 1, "DefinedX - jabber:x:oob" );

#------------------------------------------------------------------------------
# X
#------------------------------------------------------------------------------
my @x = $iq->GetX();
is( $x[0], $xoob, "Is the first x the oob?");

#------------------------------------------------------------------------------
# X
#------------------------------------------------------------------------------
my $xroster = $iq->NewX("jabber:x:roster");
ok( defined( $xoob ), "NewX - jabber:x:roster" );
isa_ok( $xoob, "Net::Jabber::X" );
is( $iq->DefinedX(), 1, "DefinedX" );
is( $iq->DefinedX("jabber:x:oob"), 1, "DefinedX - jabber:x:oob" );
is( $iq->DefinedX("jabber:x:roster"), 1, "DefinedX - jabber:x:roster" );

#------------------------------------------------------------------------------
# X
#------------------------------------------------------------------------------
my @x2 = $iq->GetX();
is( $x2[0], $xoob, "Is the first x the oob?");
is( $x2[1], $xroster, "Is the second x the roster?");

#------------------------------------------------------------------------------
# X
#------------------------------------------------------------------------------
my @x3 = $iq->GetX("jabber:x:oob");
is( $#x3, 0, "filter on xmlns - only one x... right?");
is( $x3[0], $xoob, "Is the first x the oob?");

#------------------------------------------------------------------------------
# X
#------------------------------------------------------------------------------
my @x4 = $iq->GetX("jabber:x:roster");
is( $#x4, 0, "filter on xmlns - only one x... right?");
is( $x4[0], $xroster, "Is the first x the roster?");

is( $iq->DefinedX("jabber:x:testns"), "", "not DefinedX - jabber:x:testns" );

#------------------------------------------------------------------------------
# iq
#------------------------------------------------------------------------------
my $iq2 = new Net::Jabber::IQ();
ok( defined($iq2), "new()");
isa_ok( $iq2, "Net::Jabber::IQ");

#------------------------------------------------------------------------------
# defined
#------------------------------------------------------------------------------
is( $iq2->DefinedError(), '', "error not defined" );
is( $iq2->DefinedErrorCode(), '', "errorcode not defined" );
is( $iq2->DefinedFrom(), '', "from not defined" );
is( $iq2->DefinedID(), '', "id not defined" );
is( $iq2->DefinedTo(), '', "to not defined" );
is( $iq2->DefinedType(), '', "type not defined" );

#------------------------------------------------------------------------------
# set it
#------------------------------------------------------------------------------
$iq2->SetIQ(error=>"error",
            errorcode=>"401",
            from=>"user1\@server1/resource1",
            id=>"id",
            to=>"user2\@server2/resource2",
            type=>"type");

testPostScalar($iq, "Error", "error");
testPostScalar($iq, "ErrorCode", "401");
testPostJID($iq, "From", "user1", "server1", "resource1");
testPostScalar($iq, "ID", "id");
testPostJID($iq, "To", "user2", "server2", "resource2");
testPostScalar($iq, "Type", "Type");


my $iq3 = new Net::Jabber::IQ();
ok( defined($iq3), "new()");
isa_ok( $iq3, "Net::Jabber::IQ");

$iq3->SetIQ(error=>"error",
            errorcode=>"401",
            from=>"user1\@server1/resource1",
            id=>"id",
            to=>"user2\@server2/resource2",
            type=>"type");

my $query = $iq3->NewQuery("jabber:iq:auth");
ok( defined($query), "new()");
isa_ok( $query, "Net::Jabber::Query");

$query->SetAuth(username=>"user",
                password=>"pass");

is( $iq3->GetXML(), "<iq from='user1\@server1/resource1' id='id' to='user2\@server2/resource2' type='type'><error code='401'>error</error><query xmlns='jabber:iq:auth'><password>pass</password><username>user</username></query></iq>", "GetXML()");

my $reply = $iq3->Reply();

is( $reply->GetXML(), "<iq from='user2\@server2/resource2' id='id' to='user1\@server1/resource1' type='result'><query xmlns='jabber:iq:auth'/></iq>", "GetXML()");


