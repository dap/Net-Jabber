BEGIN {print "1..16\n";}
END {print "not ok 1\n" unless $loaded;}
use Net::Jabber qw(Client);
$loaded = 1;
print "ok 1\n";

my $message_node = new XML::Stream::Node("message");
print "not " unless defined($message_node);
print "ok 2\n";
print "not " unless (ref($message_node) eq "XML::Stream::Node");
print "ok 3\n";

$message_node->put_attrib(to=>"jer\@jabber.org",
                          from=>"reatmon\@jabber.org");
my $body_node = $message_node->add_child("body");
$body_node->add_cdata("body");
my $subject_node = $message_node->add_child("subject");
$subject_node->add_cdata("subject");

my $xdelay = $message_node->add_child("x");
$xdelay->put_attrib(xmlns=>"jabber:x:delay",
                    from=>"jabber.org",
                    stamp=>"stamp",
                    );
$xdelay->add_cdata("Delay1");

my $xdelay2 = $message_node->add_child("x");
$xdelay2->put_attrib(xmlns=>"jabber:x:delay",
                     from=>"jabber.org",
                     stamp=>"stamp",
                     );
$xdelay2->add_cdata("Delay2");

print "not " unless ($message_node->GetXML() eq "<message from='reatmon\@jabber.org' to='jer\@jabber.org'><body>body</body><subject>subject</subject><x from='jabber.org' stamp='stamp' xmlns='jabber:x:delay'>Delay1</x><x from='jabber.org' stamp='stamp' xmlns='jabber:x:delay'>Delay2</x></message>");
print "ok 4\n";

my $message = new Net::Jabber::Message($message_node);
print "not " unless defined($message);
print "ok 5\n";
print "not " unless (ref($message) eq "Net::Jabber::Message");
print "ok 6\n";

print "not " unless ($message->GetTo() eq "jer\@jabber.org");
print "ok 7\n";

print "not " unless ($message->GetFrom() eq "reatmon\@jabber.org");
print "ok 8\n";

print "not " unless ($message->GetSubject() eq "subject");
print "ok 9\n";

print "not " unless ($message->GetBody() eq "body");
print "ok 10\n";

my @xdelays = $message->GetX("jabber:x:delay");
print "not " unless ($#xdelays == 1);
print "ok 11\n";

my $xdelay1 = $xdelays[0];
print "not " unless defined($xdelay1);
print "ok 12\n";
print "not " unless (ref($xdelay1) eq "Net::Jabber::X");
print "ok 13\n";

print "not " unless ($xdelay1->GetFrom() eq "jabber.org");
print "ok 14\n";
print "not " unless ($xdelay1->GetStamp() eq "stamp");
print "ok 15\n";
print "not " unless ($xdelay1->GetMessage() eq "Delay1");
print "ok 16\n";

