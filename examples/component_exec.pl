#!/bin/sh

exec perl -x $0

#!perl

use Net::Jabber;
use strict;

$SIG{HUP} = \&Stop;
$SIG{KILL} = \&Stop;
$SIG{TERM} = \&Stop;
$SIG{INT} = \&Stop;

my $Component = new Net::Jabber::Component();

$Component->SetCallBacks(message=>\&messageCB);

my $status = $Component->Connect(connectiontype=>"exec");

if (!(defined($status))) {
  print STDERR "ERROR:  Jabber server is not answering.\n";
  print STDERR "        ($!)\n";
  exit(0);
}

print STDERR "Connected...\n";

while(defined($Component->Process())) { }

print STDERR "The component has died a miserable death...\n";

exit(0);

sub Stop {
  $Component->Disconnect();
  print STDERR "Exit gracefully...\n";
  exit(0);
}


sub messageCB {
  my $sid = shift;
  my $message = new Net::Jabber::Message(@_);
  print STDERR "Recd: ",$message->GetXML(),"\n";

  my $reply = $message->Reply();
  $reply->SetMessage(body=>uc($message->GetBody()));
  $Component->Send($reply);

  print STDERR "Sent: ",$reply->GetXML(),"\n";
}
