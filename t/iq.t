use lib "t/lib";
use Test::More tests=>72;

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

#------------------------------------------------------------------------------
# X
#------------------------------------------------------------------------------
my $xoob = $iq->NewX("jabber:x:oob");
ok( defined( $xoob ), "NewX - jabber:x:oob" );
isa_ok( $xoob, "Net::Jabber::X" );

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

