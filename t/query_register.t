use lib "t/lib";
use Test::More tests=>113;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $query = new Net::Jabber::Query();
ok( defined($query), "new()" );
isa_ok( $query, "Net::Jabber::Query" );

testScalar($query,"XMLNS","jabber:iq:register");

testScalar($query,"Address","address");
testScalar($query,"City","city");
testScalar($query,"Date","date");
testScalar($query,"Email","email");
testScalar($query,"First","first");
testScalar($query,"Instructions","instructions");
testScalar($query,"Key","key");
testScalar($query,"Last","last");
testScalar($query,"Misc","misc");
testScalar($query,"Name","name");
testScalar($query,"Nick","nick");
testScalar($query,"Password","password");
testScalar($query,"Phone","phone");
testFlag($query,"Registered");
testFlag($query,"Remove");
testScalar($query,"State","state");
testScalar($query,"Text","text");
testScalar($query,"URL","url");
testScalar($query,"Username","username");
testScalar($query,"Zip","zip");

is( $query->GetXML(), "<query xmlns='jabber:iq:register'><address>address</address><city>city</city><date>date</date><email>email</email><first>first</first><instructions>instructions</instructions><key>key</key><last>last</last><misc>misc</misc><name>name</name><nick>nick</nick><password>password</password><phone>phone</phone><registered/><remove/><state>state</state><text>text</text><url>url</url><username>username</username><zip>zip</zip></query>", "GetXML()" );


my $query2 = new Net::Jabber::Query();
ok( defined($query2), "new()" );
isa_ok( $query2, "Net::Jabber::Query" );

testScalar($query2,"XMLNS","jabber:iq:register");

$query2->SetRegister(address=>"address",
                     city=>"city",
                     date=>"date",
                     email=>"email",
                     first=>"first",
                     instructions=>"instructions",
                     key=>"key",
                     last=>"last",
                     misc=>"misc",
                     name=>"name",
                     nick=>"nick",
                     password=>"password",
                     phone=>"phone",
                     registered=>1,
                     remove=>1,
                     state=>"state",
                     text=>"text",
                     url=>"url",
                     username=>"username",
                     zip=>"zip",
                    );

testPostScalar($query2,"Address","address");
testPostScalar($query2,"City","city");
testPostScalar($query2,"Date","date");
testPostScalar($query2,"Email","email");
testPostScalar($query2,"First","first");
testPostScalar($query2,"Instructions","instructions");
testPostScalar($query2,"Key","key");
testPostScalar($query2,"Last","last");
testPostScalar($query2,"Misc","misc");
testPostScalar($query2,"Name","name");
testPostScalar($query2,"Nick","nick");
testPostScalar($query2,"Password","password");
testPostScalar($query2,"Phone","phone");
testPostFlag($query2,"Registered");
testPostFlag($query2,"Remove");
testPostScalar($query2,"State","state");
testPostScalar($query2,"Text","text");
testPostScalar($query2,"URL","url");
testPostScalar($query2,"Zip","zip");

is( $query2->GetXML(), "<query xmlns='jabber:iq:register'><address>address</address><city>city</city><date>date</date><email>email</email><first>first</first><instructions>instructions</instructions><key>key</key><last>last</last><misc>misc</misc><name>name</name><nick>nick</nick><password>password</password><phone>phone</phone><registered/><remove/><state>state</state><text>text</text><url>url</url><username>username</username><zip>zip</zip></query>", "GetXML()" );

