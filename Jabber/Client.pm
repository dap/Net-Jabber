package Net::Jabber::Client;

=head1 NAME

Net::Jabber::Client - Jabber Client Library

=head1 SYNOPSIS

  Net::Jabber::Client is a module that provides a developer easy access
  to the Jabber Instant Messaging protocol.

=head1 DESCRIPTION

  Client.pm seeks to provide enough high level APIs and automation of 
  the low level APIs that writing a Jabber Client in Perl is trivial.
  For those that wish to work with the low level you can do that too, 
  but those functions are covered in the documentation for each module.

  Net::Jabber::Client provides functions to connect to a Jabber server,
  login, send and receive messages, set personal information, create
  a new user account, manage the roster, and disconnect.  You can use
  all or none of the functions, there is no requirement.

  For more information on how the details for how Net::Jabber is written
  please see the help for Net::Jabber itself.

=head2 Basic Functions

    use Net::Jabber;

    $Con = new Net::Jabber::Client();

    $Con->Connect(name=>"jabber.org");

    $Con->SetCallBacks(message=>\&messageCallBack,
		       iq=>\&handleTheIQTag);

    $Con->Process();
    $Con->Process(5);

    $Con->Send($object);
    $Con->Send("<tag>XML</tag>");

    $Con->Disconnect();

=head2 ID Functions

    $id         = $Con->SendWithID($sendObj);
    $id         = $Con->SendWithID("<tag>XML</tag>");
    $receiveObj = $Con->SendAndReceiveWithID($sendObj);
    $receiveObj = $Con->SendAndReceiveWithID("<tag>XML</tag>");
    $yesno      = $Con->ReceivedID($id);
    $receiveObj = $Con->GetID($id);    
    $receiveObj = $Con->WaitForID($id);

    $Con->IgnoreIDs();
    $Con->WatchIDs();

=head2 Message Functions

    $Con->MessageSend(to=>"bob@jabber.org",
		      subject=>"Lunch",
		      body=>"Let's go grab some...\n";
		      thread=>"ABC123",
		      priority=>10);

=head2 Presence Functions

    $Con->PresenceSend();

=head2 IQ::Auth Functions

    @result = $Con->AuthSend();
    @result = $Con->AuthSend(username=>"bob",
			     password=>"bobrulez",
			     resource=>"Bob");

=head2 IQ::Info Functions

    n/a

=head2 IQ::Register Functions

    @result = $Con->RegisterSend(usersname=>"newuser",
				 resource=>"New User",
				 password=>"imanewbie");

=head2 IQ::Resource Functions

    n/a

=head2 IQ::Roster Functions

    $Con->RosterGet();
    $Con->RosterAdd(jid=>"bob@jabber.org");
    $Con->RosterRemove(jid=>"bob@jabber.org");


=head2 X Functions

    $Con->SetXDelegates("com:bar:foo"=>"Foo::Bar");

=head1 METHODS

=head2 Basic Functions

    Connect(name=>string,  - opens a connection to the server listed in
	    port=>integer)   the name value, on the port listed.  The
                             defaults for the two are localhost and 5222.

    SetCallBacks(message=>function,  - sets the callback functions for
                 presence=>function,   the top level tags listed.  The
		 iq=>function)         available tags to look for are
                                       <message/>, <presence/>, and
                                       <iq/>.  If a packet is received
                                       with an ID then it is not sent
                                       to these functions, instead it
                                       is inserted into a LIST and can
                                       be retrieved by some functions
                                       we will mention later.

    Process(integer) - takes the timeout period as an argument.  If no
                       timeout is listed then the function blocks until
                       a packet is received.  Otherwise it waits that
                       number of seconds and then exits so your program
                       can continue doing useful things.  NOTE: This is
                       important for GUIs.  You need to leave time to
                       process GUI commands even if you are waiting for
                       packets.

    Send(object) - takes either a Net::Jabber::xxxxx object or an XML
    Send(string)   string as an argument and sends it to the server.

    Disconnect() - closes the connection to the server.

=head2 ID Functions

    SendWithID(object) - takes either a Net::Jabber::xxxxx object or an
    SendWithID(string)   XML string as an argument, adds the next
                         available ID number and sends that packet to
                         the server.  Returns the ID number assigned.
    
    SendAndReceiveWithID(object) - uses SendWithID and WaitForID to
    SendAndReceiveWithID(string)   provide a complete way to send and
                                   receive packets with IDs.  Can take
                                   either a Net::Jabber::xxxxx object
                                   or an XML string.  Returns the
                                   proper Net::Jabber::xxxxx object
                                   based on the type of packet received.

    ReceivedID(integer) - returns 1 if a packet has been received with
                          specified ID, 0 otherwise.

    GetID(integer) - returns the proper Net::Jabber::xxxxx object based
                     on the type of packet received with the specified
                     ID.  If the ID has been received the GetID returns
                     0.

    WaitForID(integer) - blocks until a packet with the ID is received.
                         Returns the proper Net::Jabber::xxxxx object
                         based on the type of packet received

    IgnoreIDs() - tells the client to stop putting IDs in a seperate array
                  and just pass the object to the specified callback.
                  This is useful for writing a daemon to listen to a
                  Jabber account and respond back with an ID on
                  a <message/>.

    WatchIDs() - tells the client to start putting IDs in a seperate array
                 and not pass the object to the specified callback.  If
                 you call IgnoreIDs(), this function turns ID handling 
                 back on.

=head2 Message Functions

    MessageSend(hash) - takes the hash and passes it to SetMessage in
                        Net::Jabber::Message (refer there for valid
                        settings).  Then it sends the message to the
                        server.

=head2 Presence Functions

#todo: document PresenceSend

=head2 IQ::Auth Functions

    AuthSend(username=>string, - takes all of the information and
             password=>string,   builds a Net::Jabber::IQ::Auth packet.
             resource=>string)   It then sends that packet to the
    AuthSend()                   server with an ID and waits for that
                                 ID to return.  Then it looks in
                                 resulting packet and determines if
                                 authentication was successful for not.
                                 If no hash is passed then it tries
                                 to open an anonymous session.  The
                                 array returned from AuthSend looks
                                 like this:
                                   [ type , message ]
                                 If type is "ok" then authentication
                                 was successful, otherwise message
                                 contains a little more detail about the
                                 error.

=head2 IQ::Info Functions

    n/a

=head2 IQ::Register Functions

    RegisterSend(username=>string, - takes all of the information and
                 password=>string,   builds a Net::Jabber::IQ::Register
                 resource=>string)   packet.  It then sends that packet
                                     to the server with an ID and waits
                                     for that ID to return.  Then it
                                     looks in resulting packet and
                                     determines if registration was
                                     successful for not.  The array
                                     returned from RegisterSend looks
                                     like this:
                                       [ type , message ]
                                     If type is "ok" then registration
                                     was successful, otherwise message
                                     contains a little more detail about the
                                     error.

=head2 IQ::Resource Functions

    n/a

=head2 IQ::Roster Functions

    RosterGet() - sends an empty Net::Jabber::IQ::Roster tag to the
                  server so the server will send the Roster to the
                  client.

    RosterAdd(jid=>string) - sends a packet asking that the jid be
                             added to the user's roster.

    RosterRemove(jid=>string) - sends a packet asking that the jid be
                             removed from the user's roster.

=head2 X Functions

    SetXDelegates(hash) - the hash gets sent to the 
                          Net::Jabber::X::SetDelegates function.  For 
                          more information about this function, read 
                          the manpage for Net::Jabber::X.

=head1 AUTHOR

Revised by Ryan Eatmon in December 1999.

By Thomas Charron in July of 1999 for http://jabber.org..

Based on a screenplay by Jeremie Miller in May of 1999
for http://jabber.org/

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
#use strict;
use Carp;
use Data::Dumper;
use XML::Stream;
use vars qw($VERSION);

$VERSION = "0.8.1";
my $PROTOCOL = '19990505';

BEGIN {
}

sub new {
  my $proto = shift;
  my $self = { };

  $self->{SERVER} = {"name" => "127.0.0.1", 
		     "port" => 5222};

  $self->{STREAM} = new XML::Stream;

  $self->{VERSION} = $VERSION;
  
  $self->{LIST}->{currentID} = 0;

  $self->{IGNOREIDS} = 0;
  
  bless($self, $proto);
  return $self;
}


###########################################################################
#
# Connect - Takes a has and opens the connection to the specified server.
#           Registers CallBack as the main callback for all packets from
#           the server.
#
#           NOTE:  Need to add some error handling if the connection is
#           not made because the server name is wrong or whatnot.
#
###########################################################################
sub Connect {
  my $self = shift;

  while($#_ >= 0) { $self->{SERVER}{ lc pop(@_) } = pop(@_); }

  $self->{STREAM}->
    Connect(name=>$self->{SERVER}->{name},
	    port=>$self->{SERVER}->{port},
	    namespace=>"jabber:client"
	   ) || die("Cannot connect to ".$self->{SERVER}->{name}.":".$self->{SERVER}->{port}.": $!");
  $self->{STREAM}->OnNode(sub{ $self->CallBack(@_) });
}


###########################################################################
#
# CallBack - Central callback function.  If a packet comes back with an ID
#            then the packet is not returned as normal, instead it is 
#            inserted in the LIST and stored until the user wants to fetch
#            it.  Next the function checks if a callback exists for this
#            tag, if it does then that callback is called, otherwise the
#            function drops the packet since it does not know how to handle
#            it.
#
#            NOTE:  This might need to be changed if popular vote demands
#            it.  Maybe we should store the dropped packets in an array
#            and let the user have access to them.  The only problem is
#            memory overflow if the list is never cleaned out.
#
###########################################################################
sub CallBack {
  my $self = shift;
  my (@object) = @_;

  if (($self->{IGNOREIDS} == 0) && exists($object[1]->[0]->{id})) {
    my $NJObject;
    $NJObject = new Net::Jabber::IQ(@object) 
      if ($object[0] eq "iq");
    $NJObject = new Net::Jabber::Presence(@object) 
      if ($object[0] eq "presence");
    $NJObject = new Net::Jabber::Message(@object) 
      if ($object[0] eq "message");
    $self->GotID($object[1]->[0]->{id},$NJObject);
  } else {
    if (exists($self->{CB}->{$object[0]})) {
      &{$self->{CB}->{$object[0]}}(@object);
    }
  }
}


###########################################################################
#
# SetCallBacks - Takes a hash with top level tags to look for as the keys
#                and pointers to functions as the values.  The functions
#                are called and passed the XML::Parser::Tree objects
#                generated by XML::Stream.
#
###########################################################################
sub SetCallBacks {
  my $self = shift;
  while($#_ >= 0) { $self->{CB}{ pop(@_) } = pop(@_); }
}


###########################################################################
#
#  Process - If a timeout value is specified then the function will wait
#            that long before returning.  This is useful for apps that
#            need to handle other processing while still waiting for
#            packets.  If no timeout is listed then the function waits
#            until a packet is returned.  Either way the function exits 
#            as soon as a packet is returned.
#
###########################################################################
sub Process {
  my $self = shift;
  my ($timeout) = @_;
  my ($status);

  if ($timeout eq "") {
    while(($status = $self->{STREAM}->Process()) == 0) {
      sleep(1);
    }
    return $status;
  } else {
    return $self->{STREAM}->Process($timeout);
  }
}


###########################################################################
#
# Send - Takes either XML or a Net::Jabber::xxxx object and sends that
#        packet to the server.
#
###########################################################################
sub Send {
  my $self = shift;
  my $object = shift;

  if (ref($object) eq "") {
    $self->SendXML($object);
  } else {
    $self->SendXML($object->GetXML());
  }
}


###########################################################################
#
# SendXML - Sends the XML packet to the server
#
###########################################################################
sub SendXML {
  my $self = shift;

  $self->{STREAM}->Send(@_);
}


###########################################################################
#
# Disconnect - Sends the string to close the connection cleanly.
#
###########################################################################
sub Disconnect {
  my $self = shift;

  $self->{STREAM}->Disconnect();
}


###########################################################################
#
# SendWithID - Take either XML or a Net::Jabber::xxxx object and send it
#              with the next available ID number.  Then return that ID so
#              the client can track it.
#
###########################################################################
sub SendWithID {
  my $self = shift;
  my ($object) = @_;

  #------------------------------------------------------------------------
  # Take the current XML stream and insert an id attrib at the top level.
  #------------------------------------------------------------------------
  my $currentID = $self->{LIST}->{currentID};

  my $xml;
  if (ref($object) eq "") {
    $xml = $object;
    $xml =~ s/^(\<[^\>]+)(\>)/$1 id\=\'$currentID\'$2/;
  } else {
    $object->SetID($currentID);
    $xml = $object->GetXML();
  }

  #------------------------------------------------------------------------
  # Send the new XML string.
  #------------------------------------------------------------------------
  $self->SendXML($xml);

  #------------------------------------------------------------------------
  # Increment the currentID and return the ID number we just assigned.
  #------------------------------------------------------------------------
  $self->{LIST}->{currentID}++;
  return $currentID;
}


###########################################################################
#
# SendAndReceiveWithID - Take either XML or a Net::Jabber::xxxxx object and
#                        send it with the next ID.  Then wait for that ID
#                        to come back and return the response in a
#                        Net::Jabber::xxxx object.
#
###########################################################################
sub SendAndReceiveWithID {
  my $self = shift;
  my ($object) = @_;

  my $id = $self->SendWithID($object);
  return $self->WaitForID($id);
}


###########################################################################
#
# ReceivedID - returns 1 if a packet with the ID has been received, or 0
#              if it has not.
#
###########################################################################
sub ReceivedID {
  my $self = shift;
  my ($id) = @_;

  return 1 if exists($self->{LIST}->{$id});
  return 0;
}


###########################################################################
#
# GetID - Return the Net::Jabber::xxxxx object that is stored in the LIST
#         that matches the ID if that ID exists.  Otherwise return 0.
#
###########################################################################
sub GetID {
  my $self = shift;
  my ($id) = @_;

  return $self->{LIST}->{$id} if $self->ReceivedID($id);
  return 0;
}


###########################################################################
#
# WaitForID - Keep looping and calling Process(1) to poll every second
#             until the response from the server occurs.
#
###########################################################################
sub WaitForID {
  my $self = shift;
  my ($id) = @_;
  
  while(!$self->ReceivedID($id)) {
    $self->Process(1);
  }
  return $self->GetID($id);
}


###########################################################################
#
# GotID - Callback to store the Net::Jabber::xxxxx object in the LIST at
#         the ID index.  This is a private helper function.
#
###########################################################################
sub GotID {
  my $self = shift;
  my ($id,$object) = @_;

  $self->{LIST}->{$id} = $object;
}


###########################################################################
#
# IgnoreIDs - tell the CallBack function to not pay attention to IDs and
#             pass the object to the specified callback function.
#
###########################################################################
sub IgnoreIDs {
  my $self = shift;
  $self->{IGNOREIDS} = 1;
}


###########################################################################
#
# WatchIDs - tell the CallBack function to pay attention to IDs and not
#            pass the object to the specified callback function.
#
###########################################################################
sub WatchIDs {
  my $self = shift;
  $self->{IGNOREIDS} = 0;
}




###########################################################################
#
# MessageSend - Takes the same hash that Net::Jabber::Message->SetMessage
#               takes and sends the message to the server.
#
###########################################################################
sub MessageSend {
  my $self = shift;

  my $mess = new Net::Jabber::Message();
  $mess->SetMessage(@_);
  $self->Send($mess);
}


###########################################################################
#
# PresenceSend #todo
#
###########################################################################
sub PresenceSend {
  my $self = shift;

  my $presence = new Net::Jabber::Presence();
  $self->Send($presence);
}


###########################################################################
#
# AuthSend - This is a self contained function to send a login iq tag with
#            an id.  Then wait for a reply what the same id to come back 
#            and tell the caller what the result was.
#
###########################################################################
sub AuthSend {
  my $self = shift;

  #------------------------------------------------------------------------
  # Create a Net::Jabber::IQ object to send to the server
  #------------------------------------------------------------------------
  my $IQLogin = new Net::Jabber::IQ;
  my $IQAuth = $IQLogin->NewQuery("auth");
  $IQAuth->SetAuth(@_);

  #------------------------------------------------------------------------
  # Send the IQ with the next available ID and wait for a reply with that 
  # id to be received.  Then grab the IQ reply.
  #------------------------------------------------------------------------
  $IQLogin = $self->SendAndReceiveWithID($IQLogin);
  
  #------------------------------------------------------------------------
  # From the reply IQ determine if we were successful or not.  If yes then 
  # return "".  If no then return error string from the reply.
  #------------------------------------------------------------------------
  return ( $IQLogin->GetErrorType() , $IQLogin->GetError() )
    if ($IQLogin->GetType() eq "error");
  return ("ok","");
}


###########################################################################
#
# RegisterSend - This is a self contained function to send a registration
#                iq tag with an id.  Then wait for a reply what the same
#                id to come back and tell the caller what the result was.
#
###########################################################################
sub RegisterSend {
  my $self = shift;

  #------------------------------------------------------------------------
  # Create a Net::Jabber::IQ object to send to the server
  #------------------------------------------------------------------------
  my $IQ = new Net::Jabber::IQ;
  my $IQRegister = $IQ->NewQuery("register");
  $IQRegister->SetRegister(@_);

  #------------------------------------------------------------------------
  # Send the IQ with the next available ID and wait for a reply with that 
  # id to be received.  Then grab the IQ reply.
  #------------------------------------------------------------------------
  $IQ = $self->SendAndReceiveWithID($IQ);
  
  #------------------------------------------------------------------------
  # From the reply IQ determine if we were successful or not.  If yes then 
  # return "".  If no then return error string from the reply.
  #------------------------------------------------------------------------
  return ( $IQ->GetErrorType() , $IQ->GetError() )
    if ($IQ->GetType() eq "error");
  return ("ok","");
}


###########################################################################
#
# RosterAdd - Takes the Jabber ID of the user to add to their Roster and
#             sends the IQ packet to the server.
#
###########################################################################
sub RosterAdd {
  my $self = shift;

  my $iq = new Net::Jabber::IQ;
  my $roster = $iq->NewQuery("roster");
  my $item = $roster->AddItem();
  $item->SetItem(@_,
		 subscription=>"to");
  $self->Send($iq);
}


###########################################################################
#
# RosterAdd - Takes the Jabber ID of the user to remove from their Roster
#             and sends the IQ packet to the server.
#
###########################################################################
sub RosterRemove {
  my $self = shift;

  my $iq = new Net::Jabber::IQ;
  my $roster = $iq->NewQuery("roster");
  my $item = $roster->AddItem();
  $item->SetItem(@_,
		 subscription=>"remove");
  $self->Send($iq);
}


###########################################################################
#
# RosterGet - Sends an empty IQ to the server to request that the user's
#             Roster be sent to them.
#
###########################################################################
sub RosterGet {
  my $self = shift;

  my $iq = new Net::Jabber::IQ;
  $iq->SetIQ(type=>"get",
	     query=>"roster");
  $self->Send($iq);
}



###########################################################################
#
# SetXDelegates - Sets the delegates for the <x/> that you might see during
#                 the session.
#
###########################################################################
sub SetXDelegates {
  my $self = shift;

  my $x = new Net::Jabber::X;
  $x->SetDelegates(@_);
}

1;
