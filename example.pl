use Net::Jabber;
use Data::Dumper;
$Connection = new Net::Jabber::Client;

$Connection->Server("Name" => "jabber.org",
                     "Port" => 5222);

$Connection->SetCallBacks("message" => \&InMessage,
	"status" => \&InStatus, "connect" => \&InConnect,
	"roster" => \&InRoster);

$Connection->Connect();

$Connection->login("UserName" => "tcharron",
                   "Password" => "baker12",
                   "Nick"     => "PerlTest");

$Connection->SendStatus("I'm HERE!", "online", "online", "");

$Connection->SendXML("<roster><get group='Main'/></roster>\n");

$Connection->Process();

sub InMessage
{
  $Message = Net::Jabber::Message->new(@_);
  $From = $Message->GetFrom();
  $Nick = $Message->GetNick();
  $Subject = $Message->GetSubject();
  $Say = $Message->GetSay();
  print "---\nMessage From $From ($Nick)\nSubject $Subject\n---\n$Say\n---\n";
}


sub InStatus
{
  $Status = new Net::Jabber::Status(@_);
  $From = $Status->GetFrom();
  $Nick = $Status->GetNick();
  $Type = $Status->GetType();
  $Icon = $Status->GetIcon();
  $Say = $Status->GetSay();
  print "---\nGot Status from $From ($Nick)\n$Icon - $Type\n---\n$Say\n---\n";

}

sub InRoster
{
  $Roster = new Net::Jabber::Roster(@_);
  print "---\nRoster Recieved.\n----------\n";
  foreach $user ($Roster->GetUsers())
  {
    print "$user\n";
  }
  print "---\n";
}

sub InConnect 
{
  print "---\nConnected\n---\n";
}
