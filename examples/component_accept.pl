
use Net::Jabber;
use strict;

if ($#ARGV < 2) {
  print "\nperl component_accept.pl <server> <port> <name> <secret> \n\n";
  exit(0);
}

my $server = $ARGV[0];
my $port = $ARGV[1];
my $name = $ARGV[2];
my $secret = $ARGV[3];

$SIG{HUP} = \&Stop;
$SIG{KILL} = \&Stop;
$SIG{TERM} = \&Stop;
$SIG{INT} = \&Stop;

my $Component = new Net::Jabber::Component();

$Component->SetCallBacks(message=>\&messageCB);

my $status = $Component->Connect(hostname=>$server,
				 port=>$port,
                                 componentname=>$name,
				 secret=>$secret);

if (!(defined($status))) {
  print "ERROR:  Jabber server is not answering.\n";
  print "        ($!)\n";
  exit(0);
}

print "Connected...\n";

while(defined($Component->Process())) { }

print "The component has died a miserable death...\n";

exit(0);

sub Stop {
  $Component->Disconnect();
  print "Exit gracefully...\n";
  exit(0);
}


sub messageCB {
  my $sid = shift;
  my $message = new Net::Jabber::Message(@_);
  print "Recd: ",$message->GetXML(),"\n";

  my $reply = $message->Reply();
  $reply->SetMessage(body=>uc($message->GetBody()));
  $Component->Send($reply);

  print "Sent: ",$reply->GetXML(),"\n";
}
