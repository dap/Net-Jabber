use lib "t/lib";
use Test::More tests=>89;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $query = new Net::Jabber::Query();
ok( defined($query), "new()" );
isa_ok( $query, "Net::Jabber::Query" );

testScalar($query,"XMLNS","jabber:iq:autoupdate");

my $dev = $query->AddDev();
ok( defined($dev), "new()" );
isa_ok( $dev, "Net::Jabber::Query" );

testScalar($dev,"Desc","desc");
testScalar($dev,"Priority","priority");
testScalar($dev,"URL","url");
testScalar($dev,"Version","version");

my $beta = $query->AddBeta();
ok( defined($beta), "new()" );
isa_ok( $beta, "Net::Jabber::Query" );

testScalar($beta,"Desc","desc");
testScalar($beta,"Priority","priority");
testScalar($beta,"URL","url");
testScalar($beta,"Version","version");

my $release = $query->AddRelease();
ok( defined($release), "new()" );
isa_ok( $release, "Net::Jabber::Query" );

testScalar($release,"Desc","desc");
testScalar($release,"Priority","priority");
testScalar($release,"URL","url");
testScalar($release,"Version","version");

is( $query->GetXML(), "<query xmlns='jabber:iq:autoupdate'><dev priority='priority'><desc>desc</desc><url>url</url><version>version</version></dev><beta priority='priority'><desc>desc</desc><url>url</url><version>version</version></beta><release priority='priority'><desc>desc</desc><url>url</url><version>version</version></release></query>", "GetXML()" );


my $query2 = new Net::Jabber::Query();
ok( defined($query2), "new()" );
isa_ok( $query2, "Net::Jabber::Query" );

testScalar($query2,"XMLNS","jabber:iq:autoupdate");

my $dev2 = $query2->AddDev(desc=>"desc",
                           priority=>"priority",
                           url=>"url",
                           version=>"version");
ok( defined($dev2), "new()" );
isa_ok( $dev2, "Net::Jabber::Query" );

testPostScalar($dev2,"Desc","desc");
testPostScalar($dev2,"Priority","priority");
testPostScalar($dev2,"URL","url");
testPostScalar($dev2,"Version","version");

my $beta2 = $query2->AddBeta(desc=>"desc",
                             priority=>"priority",
                             url=>"url",
                             version=>"version");
ok( defined($beta2), "new()" );
isa_ok( $beta2, "Net::Jabber::Query" );

testPostScalar($beta2,"Desc","desc");
testPostScalar($beta2,"Priority","priority");
testPostScalar($beta2,"URL","url");
testPostScalar($beta2,"Version","version");

my $release2 = $query2->AddRelease(desc=>"desc",
                                   priority=>"priority",
                                   url=>"url",
                                   version=>"version");
ok( defined($release2), "new()" );
isa_ok( $release2, "Net::Jabber::Query" );

testPostScalar($release2,"Desc","desc");
testPostScalar($release2,"Priority","priority");
testPostScalar($release2,"URL","url");
testPostScalar($release2,"Version","version");

is( $query2->GetXML(), "<query xmlns='jabber:iq:autoupdate'><dev priority='priority'><desc>desc</desc><url>url</url><version>version</version></dev><beta priority='priority'><desc>desc</desc><url>url</url><version>version</version></beta><release priority='priority'><desc>desc</desc><url>url</url><version>version</version></release></query>", "GetXML()" );

my @releases = $query2->GetReleases();
is( $#releases, 2, "are there three releases?" );
is( $releases[0]->GetXML(), "<dev priority='priority'><desc>desc</desc><url>url</url><version>version</version></dev>", "GetXML()" );
is( $releases[1]->GetXML(), "<beta priority='priority'><desc>desc</desc><url>url</url><version>version</version></beta>", "GetXML()" );
is( $releases[2]->GetXML(), "<release priority='priority'><desc>desc</desc><url>url</url><version>version</version></release>", "GetXML()" );


