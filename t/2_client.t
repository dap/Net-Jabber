BEGIN {print "1..5\n";}
END {print "not ok 1\n" unless $loaded;}
use Net::Jabber qw(Client);
$loaded = 1;
print "ok 1\n";

use strict;

my $server = "obelisk.net";
my $port = 5222;
my $username = "test-netjabber";
my $password = "test";
my $resource = $$.time.qx(hostname);

my $Connection = new Net::Jabber::Client();

my $status = $Connection->Connect(hostname => $server,
                                  port => $port,
				  connectiontype => "http");

if (!(defined($status))) {
  print "not ok 2\n";
  exit(0);
}
print "ok 2\n";

$Connection->SetCallBacks("message" => \&InMessage,
                          "presence" => \&InPresence,
                          "iq" => \&InIQ);

my @result = $Connection->AuthSend("username" => $username,
                                   "password" => $password,
                                   "resource" => $resource);

if ($result[0] ne "ok") {
  print "not ok 3\n";
  print "ERROR: Authorization failed: $result[0] - $result[1]\n";
  exit(0);
}
print "ok 3\n";

$Connection->RosterGet();
$Connection->PresenceSend();

$Connection->MessageSend(to=>$username."@".$server,
			 subject=>"test",
			 body=>"This is a test.");

while(defined($Connection->Process())) { }
print "not ok 4\n";
print "not ok 5\n";
exit(0);


sub InMessage{
  my $sid = shift;
  my $message = shift;

  if ($message->GetSubject() eq "test") {
    print "ok 4\n";
  }
  if ($message->GetBody() eq "This is a test.") {
    print "ok 5\n";
  }
  exit(0);
}

