BEGIN {print "1..25\n";}
END {print "not ok 1\n" unless $loaded;}
use Net::Jabber qw(Client);
$loaded = 1;
print "ok 1\n";

#my $debug = new Net::Jabber::Debug(level=>99,setdefault=>1);

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

my $xdata = $message_node->add_child("x");
$xdata->put_attrib(xmlns=>"jabber:x:data");
$xdata->add_child("instructions","fill this out");
my $field1 = $xdata->add_child("field");
$field1->put_attrib(type=>"hidden",
                    var=>"formnum");
$field1->add_child("value","value1");

my $field2 = $xdata->add_child("field");
$field2->put_attrib(type=>"list-single",
                    var=>"mylist");
$field2->add_child("value","male");
$field2->add_child("value","test");
$field2->add_child("required");
my $option1 = $field2->add_child("option");
$option1->put_attrib(label=>"Male");
$option1->add_child("value","male");
my $option2 = $field2->add_child("option");
$option2->put_attrib(label=>"Female");
$option2->add_child("value","female");

print "not " unless ($message_node->GetXML() eq "<message from='reatmon\@jabber.org' to='jer\@jabber.org'><body>body</body><subject>subject</subject><x xmlns='jabber:x:data'><instructions>fill this out</instructions><field type='hidden' var='formnum'><value>value1</value></field><field type='list-single' var='mylist'><value>male</value><value>test</value><required/><option label='Male'><value>male</value></option><option label='Female'><value>female</value></option></field></x></message>");
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

my @xdatas = $message->GetX("jabber:x:data");
print "not " unless ($#xdatas == 0);
print "ok 11\n";

my $xdata1 = $xdatas[0];
print "not " unless defined($xdata1);
print "ok 12\n";
print "not " unless (ref($xdata1) eq "Net::Jabber::X");
print "ok 13\n";

print "not " unless ($xdata1->GetInstructions() eq "fill this out");
print "ok 14\n";

my @fields = $xdata1->GetFields();
print "not " unless ($#fields == 1);
print "ok 15\n";

my $listField = $fields[1];
print "not " unless ($listField->GetVar() eq "mylist");
print "ok 16\n";

print "not " unless ($listField->GetType() eq "list-single");
print "ok 17\n";

my @values = $listField->GetValue();
print "not " unless ($values[0] eq "male");
print "ok 18\n";
print "not " unless ($values[1] eq "test");
print "ok 19\n";

print "not " unless $listField->GetRequired();
print "ok 20\n";

my @options = $listField->GetOptions();
print "not " unless ($#options == 1);
print "ok 21\n";

my $listOption1 = $options[0];
my $listOption2 = $options[1];

print "not " unless ($listOption1->GetLabel() eq "Male");
print "ok 22\n";
print "not " unless ($listOption1->GetValue() eq "male");
print "ok 23\n";
print "not " unless ($listOption2->GetLabel() eq "Female");
print "ok 24\n";
print "not " unless ($listOption2->GetValue() eq "female");
print "ok 25\n";

