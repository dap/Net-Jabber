
use Net::Jabber;
use strict;

if ($#ARGV < 4) {
  print "\nperl client.pl <server> <port> <username> <password> <resource> \n\n"
;
  exit(0);
}

my $server = $ARGV[0];
my $port = $ARGV[1];
my $username = $ARGV[2];
my $password = $ARGV[3];
my $resource = $ARGV[4];

my $client = new Net::Jabber::Client;

$client->SetCallBacks(message=>\&messageCB);

my $status = $client->Connect(hostname=>$server,
			      port=>$port);

if (!(defined($status))) {
  print "ERROR:  Jabber server $server is not answering.\n";
  print "        ($!)\n";
  exit(0);
}

print "Connected...\n";

my @result = $client->AuthSend(username=>$username,
			       password=>$password,
			       resource=>$resource);

if ($result[0] ne "ok") {
  print "ERROR: $result[0] $result[1]\n";
}

print "Logged in...\n";

$client->MessageSend(to=>"transport.test.foo",
		     body=>"this is a test... a successful test...");

$client->Process();

$client->Disconnect();


sub messageCB {
  my $message = new Net::Jabber::Message(@_);

  print "The body of the message should read:\n";
  print "  (THIS IS A TEST... A SUCCESSFUL TEST...)\n";
  print "\n";
  print "Recvd: ",$message->GetBody(),"\n";
}
