use lib "t/lib";
use Test::More tests=>5;

BEGIN{ use_ok( "Net::Jabber","Client" ); }

SKIP:
{
    my $sock = IO::Socket::INET->new(PeerAddr=>'obelisk.net:5222');
    skip "Cannot open connection (maybe a firewall?)",4 unless defined($sock);
    
    my $server = "obelisk.net";
    my $port = 5222;
    my $username = "test-netjabber";
    my $password = "test";
    my $resource = $$.time.qx(hostname);
    
    my $Connection = new Net::Jabber::Client();
    
    my $status = $Connection->Connect(hostname=>$server,
                                      port=>$port);
    ok( defined($status), "Connect" );
    exit(0) if !(defined($status));
    
    $Connection->SetCallBacks(message=>\&InMessage,
                              presence=>\&InPresence,
                              iq=>\&InIQ);
    
    my @result = $Connection->AuthSend(username=>$username,
                                       password=>$password,
                                       resource=>$resource);
    is( $result[0], "ok", "Authentication" );
    exit(0) if ($result[0] ne "ok");
    
    $Connection->RosterGet();
    $Connection->PresenceSend();
    
    $Connection->MessageSend(to=>$username."@".$server,
                             subject=>"test",
                             body=>"This is a test.");
    
    while(defined($Connection->Process())) { }

    print "not ok 4\n";
    print "not ok 5\n";
}


sub InMessage
{
    my $sid = shift;
    my $message = shift;

    is( $message->GetSubject(), "test", "Subject" );
    is( $message->GetBody(), "This is a test.", "Body" );

    exit(0);
}

