package Net::Jabber::Message;

=head1 NAME

Net::Jabber::Message - Jabber Message Module

=head1 SYNOPSIS

  Net::Jabber::Message is a companion to the Net::Jabber module.
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber Message.

=head1 DESCRIPTION

  To initialize the Message with a Jabber <message/> you must pass it 
  the XML::Parser Tree array from the Net::Jabber::Client module.  In the
  callback function for the message:

    use Net::Jabber;

    sub message {
      new $message = new Net::Jabber::Message(@_);
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new message to send to the server:

    use Net::Jabber;

    $Mess = new Net::Jabber::Message();

  Now you can call the creation functions below to populate the tag before
  sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $from     = $Mess->GetFrom();
    $resource = $Mess->GetResource();
    $id       = $Mess->GetID();
    $type     = $Mess->GetType();
    $subject  = $Mess->GetSubject();
    $body     = $Mess->GetBody();
    @body     = $Mess->GetBody("full");
    $thread   = $Mess->GetThread();
    $priority = $Mess->GetPriority();
    $error    = $Mess->GetError();
    $errType  = $Mess->GetErrorType();
    @xTags    = $Mess->GetX();
    @xTags    = $Mess->GetX("my:namespace");

    $str      = $Mess->GetXML();
    @message  = $Mess->GetTree();

=head2 Creation functions

    $Mess->SetMessage(-TO=>"bob\@jabber.org/Working Bob",
		      -Subject=>"Lunch",
		      -BoDy=>"Let's go grab some lunch!",
		      -priority=>100);
    $Mess->SetTo("Test User");
    $Mess->SetSubject("This is a test");
    $Mess->SetBody("This is a test of the emergency broadcast system...");
    $Mess->SetThread("AE912B3");
    $Mess->SetPriority(1);

    $Mess->SetMessage(-to=>"bob\@jabber.org",
                      -errortype=>"denied",
                      -error=>"Permission Denied");
    $Mess->SetErrorType("denied");
    $Mess->SetError("Permission Denied");

=head1 METHODS

=head2 Retrieval functions

  GetTo() - returns a string with the Jabber Identifier of the 
            person who is going to receive the <message/>.

  GetFrom() - returns a string with the Jabber Identifier of the 
              person who sent the <message/>.

  GetResource() - returns a string with the Jabber Resource of the 
                  person who sent the <message/>.

  GetID() - returns an integer with the id of the <message/>.

  GetType() - returns a string with the type <message/> this is.

  GetSubject() - returns a string with the subject of the <message/>.

  GetBody(string) - returns the data in the <body/> tag depending on the
                    value of the string passed to it.  The string
                    represents the markup level to return.

                    none   returns a string with just the text of 
                           the <body/> (default)
                    full   returns an XML::Paser::Tree with everything
                           in the <body/>

  GetThread() - returns a string that represents the thread this
                <message/> belongs to.

  GetPriority() - returns an integer with the priority of the <message/>.

  GetError() - returns a string with the data of the <error/> tag.

  GetErrorType() - returns a string with the type of the <error/> tag.

  GetX(string) - returns an array of XML::Parser::Tree objects.  The string
                 can either be empty or the XML Namespace you are looking
                 for.  If empty then GetX returns every <x/> tag in the
                 <message/>.  If an XML Namespace is sent then GetX returns
                 every <x/> tag with that Namespace.

  GetXML() - returns the XML string that represents the <message/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Message.

  GetTree() - returns an array that contains the <message/> tag
                 in XML::Parser Tree format.

=head2 Creation functions

  SetMessage(to=>string,         - set multiple fields in the <message/>
             type=>string,         at one time.  This is a cumlative
             subject=>string,      and over writing action.  If you set
             body=>string,         the "to" attribute twice, the second
             thread=>string,       setting is what is used.  If you set
             priority=>integer,    the subject, and then set the body
             errortype=>string,    then both will be in the <message/>
             error=>string)        tag.  For valid settings read the
                                   specific Set functions below.

  SetTo(string) - sets the to attribute.  Must be a valid Jabber Identifier 
                  or the server will return an error message.
                  (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

  SetType(string) - sets the type attribute.  Valid settings are:

                    normal         defines a normal message
                    chat           defines a chat style message
                    groupchat      defines a chatroom message

  SetSubject(string) - sets the subject of the <message/>.

  SetBody(string) - sets the body of the <message/>.

  SetThread(string) - sets the thread of the <message/>.  You should
                      copy this out of the message being replied to so
                      that the thread is maintained.

  SetPriority(integer) - sets the priority of this <message/>.  The 
                         higher the priority the more likely the client
                         will deliver the message, even if the user has
                         specified no messages.

  SetErrorType(string) - sets the error type of the <message/>.

  SetError(string) - sets the error string of the <message/>.

=head1 AUTHOR

By Ryan Eatmon in December of 1999 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
#'

require 5.003;
use strict;
use Carp;
use vars qw($VERSION);

$VERSION = "0.8.1";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  if (@_ != ("")) {
    my @temp = @_;
    $self->{MESSAGE} = \@temp;
  } else {
    $self->{MESSAGE} = [ "message" , [{}]];
  }

  return $self;
}
##############################################################################
#
# GetTo - returns the Jabber Identifer of the person you are sending the
#         <message/> to.
#
#
##############################################################################
sub GetTo {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"","to");
}


##############################################################################
#
# GetFrom - returns the Jabber Identifer of the person who sent the 
#           <message/>
#
#
##############################################################################
sub GetFrom {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"","from");
}


##############################################################################
#
# GetResource - returns the Jabber Resource of the person who sent the 
#              <message/>
#
#
##############################################################################
sub GetResource {
  my $self = shift;
  my ($str) =
    (&Net::Jabber::GetXMLData("value",$self->{MESSAGE},"","from") =~ /^[^\/]+\/?(.*)$/);
  return $str;
}


##############################################################################
#
# GetID - returns the id of the <message/>
#
##############################################################################
sub GetID {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"","id");
}


##############################################################################
#
# GetType - returns the type of the <message/>
#
##############################################################################
sub GetType {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"","type");
}


##############################################################################
#
# GetSubject - returns the subject of the <message/>
#
##############################################################################
sub GetSubject {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"subject");
}


##############################################################################
#
# GetBody - returns the body of the <message/>
#
##############################################################################
sub GetBody {
  my $self = shift;
  my ($level) = @_;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"body")
    if (($level eq "none") || ($level eq ""));
  return &Net::Jabber::GetXMLData("tree",$self->{MESSAGE},"body")
    if ($level eq "full");
}


##############################################################################
#
# GetThread - returns the thread of the <message/>
#
##############################################################################
sub GetThread {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"thread");
}


##############################################################################
#
# GetPriority - returns the priority of the <message/>
#
##############################################################################
sub GetPriority {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"priority");
}


##############################################################################
#
# GetError - returns the text associated with the error
#
##############################################################################
sub GetError {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"error");
}


##############################################################################
#
# GetErrorType - returns the type of the error
#
##############################################################################
sub GetErrorType {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"error","type");
}


##############################################################################
#
# GetX - returns an array of XML::Parser::Tree objects of the <x/> tags
#
##############################################################################
sub GetX {
  my $self = shift;
  my ($xmlns) = @_;
  return &Net::Jabber::GetXMLData("tree array",$self->{MESSAGE},"x","xmlns",$xmlns);
}


##############################################################################
#
# GetXML -  returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  return &Net::Jabber::BuildXML(@{$self->{MESSAGE}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#              the object.
#
##############################################################################
sub GetTree {
  my $self = shift;

  return %{$self->{MESSAGE}};
}


##############################################################################
#
# SetMessage - takes a hash of all of the things you can set on a <message/>
#              and sets each one.
#
##############################################################################
sub SetMessage {
  my $self = shift;
  my %message;
  while($#_ >= 0) { $message{ lc pop(@_) } = pop(@_); }

  $self->SetTo($message{to}) if exists($message{to});
  $self->SetSubject($message{subject}) if exists($message{subject});
  $self->SetBody($message{body}) if exists($message{body});
  $self->SetThread($message{thread}) if exists($message{thread});
  $self->SetPriority($message{priority}) if exists($message{priority});
  $self->SetErrorType($message{errortype}) if exists($message{errortype});
  $self->SetError($message{error}) if exists($message{error});
}


##############################################################################
#
# SetTo - sets the to attribute in the <message/>
#
##############################################################################
sub SetTo {
  my $self = shift;
  my ($to) = @_;
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"","",{to=>$to});
}


##############################################################################
#
# SetSubject - sets the subject of the <message/>
#
##############################################################################
sub SetSubject {
  my $self = shift;
  my ($subject) = @_;
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"subject",$subject,{});
}


##############################################################################
#
# SetBody - sets the body of the <message/>
#
##############################################################################
sub SetBody {
  my $self = shift;
  my ($body) = @_;
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"body",$body,{});
}


##############################################################################
#
# SetThread - sets the thread of the <message/>
#
##############################################################################
sub SetThread {
  my $self = shift;
  my ($thread) = @_;
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"thread",$thread,{});
}


##############################################################################
#
# SetPriority - sets the priority of the <message/>
#
##############################################################################
sub SetErrorType {
  my $self = shift;
  my ($type) = @_;
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"error",,{type=>$type});
}


##############################################################################
#
# SetPriority - sets the priority of the <message/>
#
##############################################################################
sub SetError {
  my $self = shift;
  my ($error) = @_;
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"error",$error,{});
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for dbeugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug MESSAGE: $self\n";
  &Net::Jabber::printData("debug: \$self->{MESSAGE}->",$self->{MESSAGE});
}

1;
