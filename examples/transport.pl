
use Net::Jabber;
use strict;

if ($#ARGV < 3) {
  print "\nperl transport.pl <server> <port> <secret> <transportname> \n\n
";
  exit(0);
}

my $server = $ARGV[0];
my $port = $ARGV[1];
my $secret = $ARGV[2];
my $transportname = $ARGV[3];

$SIG{HUP} = \&Stop;
$SIG{KILL} = \&Stop;
$SIG{TERM} = \&Stop;
$SIG{INT} = \&Stop;

my $trans = new Net::Jabber::Transport();

$trans->SetCallBacks(message=>\&messageCB);

my $status;

$status = $trans->Connect(hostname=>$server,
			  transportname=>$transportname,
			  secret=>$secret);

if (!(defined($status))) {
  print "ERROR:  Jabber server is not answering.\n";
  print "        ($!)\n";
  exit(0);
}

print "Connected...\n";

while(defined($trans->Process())) { }

print "The transport has died a miserable death...\n";

exit(0);

sub Stop {
  $trans->Disconnect();
  print "Exit gracefully...\n";
  exit(0);
}


sub messageCB {
  my $message = new Net::Jabber::Message(@_);
  print "Recd: ",$message->GetXML(),"\n";

  my $reply = new Net::Jabber::Message();
  
  my $fromJID = $message->GetFrom("jid");

  $reply->SetMessage(to=>$message->GetFrom(),
		     from=>$message->GetTo(),
		     etherxto=>$fromJID->GetServer(),
		     etherxfrom=>$message->GetEtherxTo(),
		    );

  $reply->SetMessage(thread=>$message->GetThread()) 
    if ($message->GetThread() ne "");

  $reply->SetMessage(type=>$message->GetType());
  $reply->SetMessage(subject=>"re: ".$message->GetSubject());
  $reply->SetMessage(body=>uc($message->GetBody()));
    
  $trans->Send($reply);

  print "Sent: ",$reply->GetXML(),"\n";
}
