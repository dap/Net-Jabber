use lib "t/lib";
use Test::More tests=>60;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

require "t/mytestlib.pl";

my $query = new Net::Jabber::Query();
ok( defined($query), "new()" );
isa_ok( $query, "Net::Jabber::Query" );

testScalar($query,"XMLNS","http://jabber.org/protocol/disco#info");

testScalar($query,"Node","node");

is( $query->GetXML(), "<query node='node' xmlns='http://jabber.org/protocol/disco#info'/>", "GetXML()" );


my $query2 = new Net::Jabber::Query();
ok( defined($query2), "new()" );
isa_ok( $query2, "Net::Jabber::Query" );

testScalar($query2,"XMLNS","http://jabber.org/protocol/disco#info");

$query2->SetDiscoInfo(node=>'node');

testPostScalar($query2,"Node","node");

is( $query2->GetXML(), "<query node='node' xmlns='http://jabber.org/protocol/disco#info'/>", "GetXML()" );


my $query3 = new Net::Jabber::Query();
ok( defined($query3), "new()" );
isa_ok( $query3, "Net::Jabber::Query" );

testScalar($query3,"XMLNS","http://jabber.org/protocol/disco#info");

testScalar($query3,"Node","node");

my $item = $query3->AddIdentity();
isa_ok( $item, "Net::Jabber::Query" );

testScalar($item,"Category","category1");
testScalar($item,"Name","name1");
testScalar($item,"Type","type1");


is( $query3->GetXML(), "<query node='node' xmlns='http://jabber.org/protocol/disco#info'><identity category='category1' name='name1' type='type1'/></query>", "GetXML()" );

my $feature = $query3->AddFeature();
isa_ok( $feature, "Net::Jabber::Query" );

testScalar($feature,"Var","var1");


is( $query3->GetXML(), "<query node='node' xmlns='http://jabber.org/protocol/disco#info'><identity category='category1' name='name1' type='type1'/><feature var='var1'/></query>", "GetXML()" );

my $item2 = $query3->AddIdentity(category=>"category2",
                                 name=>"name2",
                                 type=>"type2"
                                );
isa_ok( $item2, "Net::Jabber::Query" );

testPostScalar($item2,"Category","category2");
testPostScalar($item2,"Name","name2");
testPostScalar($item2,"Type","type2");


is( $query3->GetXML(), "<query node='node' xmlns='http://jabber.org/protocol/disco#info'><identity category='category1' name='name1' type='type1'/><feature var='var1'/><identity category='category2' name='name2' type='type2'/></query>", "GetXML()" );

my $feature2 = $query3->AddFeature(var=>"var2");
isa_ok( $feature2, "Net::Jabber::Query" );

testPostScalar($feature2,"Var","var2");


is( $query3->GetXML(), "<query node='node' xmlns='http://jabber.org/protocol/disco#info'><identity category='category1' name='name1' type='type1'/><feature var='var1'/><identity category='category2' name='name2' type='type2'/><feature var='var2'/></query>", "GetXML()" );


my @idents = $query3->GetIdentities();
is($#idents,1,"two identities");

is( $idents[0]->GetXML(), "<identity category='category1' name='name1' type='type1'/>","item 1 - GetXML()");
is( $idents[1]->GetXML(), "<identity category='category2' name='name2' type='type2'/>","item 2 - GetXML()");

my @feats = $query3->GetFeatures();
is($#feats,1,"two features");

is( $feats[0]->GetXML(), "<feature var='var1'/>","item 1 - GetXML()");
is( $feats[1]->GetXML(), "<feature var='var2'/>","item 2 - GetXML()");



