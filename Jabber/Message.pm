##############################################################################
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  You should have received a copy of the GNU Library General Public
#  License along with this library; if not, write to the
#  Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#  Boston, MA  02111-1307, USA.
#
#  Jabber
#  Copyright (C) 1998-1999 The Jabber Team http://jabber.org/
#
##############################################################################

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
      my $message = new Net::Jabber::Message(@_);
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

    $to         = $Mess->GetTo();
    $toJID      = $Mess->GetTo("jid");
    $from       = $Mess->GetFrom();
    $fromJID    = $Mess->GetFrom("jid");
    $sto        = $Mess->GetSTo();
    $stoJID     = $Mess->GetSTo("jid");
    $sfrom      = $Mess->GetSFrom();
    $sfromJID   = $Mess->GetSFrom("jid");
    $etherxTo   = $Mess->GetEtherxTo();
    $etherxFrom = $Mess->GetEtherxFrom();
    $resource   = $Mess->GetResource();
    $type       = $Mess->GetType();
    $subject    = $Mess->GetSubject();
    $body       = $Mess->GetBody();
    @body       = $Mess->GetBody("full");
    $thread     = $Mess->GetThread();
    $priority   = $Mess->GetPriority();
    $error      = $Mess->GetError();
    $errCode    = $Mess->GetErrorCode();
    @xTags      = $Mess->GetX();
    @xTags      = $Mess->GetX("my:namespace");
    @xTrees     = $Mess->GetXTrees();
    @xTrees     = $Mess->GetXTrees("my:namespace");

    $str        = $Mess->GetXML();
    @message    = $Mess->GetTree();

    $date       = $Mess->GetTimeStamp();

=head2 Creation functions

    $Mess->SetMessage(TO=>"bob\@jabber.org/Working Bob",
		      Subject=>"Lunch",
		      BoDy=>"Let's go grab some lunch!",
		      priority=>100);
    $Mess->SetTo("test\@jabber.org");
    $Mess->SetFrom("me\@jabber.org");
    $Mess->SetSTo("jabber.org");
    $Mess->SetSFrom("jabber.org");
    $Mess->SetEtherxTo("jabber.org");
    $Mess->SetEtherxFrom("transport.jabber.org");
    $Mess->SetType("groupchat");
    $Mess->SetSubject("This is a test");
    $Mess->SetBody("This is a test of the emergency broadcast system...");
    $Mess->SetThread("AE912B3");
    $Mess->SetPriority(1);

    $Mess->SetMessage(to=>"bob\@jabber.org",
                      errorcode=>403,
                      error=>"Permission Denied");
    $Mess->SetErrorCode(403);
    $Mess->SetError("Permission Denied");

    $X = $Mess->NewX("jabber:x:delay");
    $X = $Mess->NewX("my:namespace");
    $X = $Mess->NewX(Net::Jabber::X::XXXXX);

    $Reply = $Mess->Reply();
    $Reply = $Mess->Reply(template=>"client");
    $Reply = $Mess->Reply(template=>"transport");

=head2 Test functions

    $test = $Mess->DefinedTo();
    $test = $Mess->DefinedFrom();
    $test = $Mess->DefinedSTo();
    $test = $Mess->DefinedSFrom();
    $test = $Mess->DefinedEtherxTo();
    $test = $Mess->DefinedEtherxFrom();
    $test = $Mess->DefinedType();
    $test = $Mess->DefinedSubject();
    $test = $Mess->DefinedBody();
    $test = $Mess->DefinedThread();
    $test = $Mess->DefinedPriority();
    $test = $Mess->DefinedErrorCode();
    $test = $Mess->DefinedError();

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns either a string with the Jabber Identifier,
  GetTo("jid")   or a Net::Jabber::JID object for the person who is 
                 going to receive the <message/>.  To get the JID
                 object set the string to "jid", otherwise leave
                 blank for the text string.

  GetFrom()      -  returns either a string with the Jabber Identifier,
  GetFrom("jid")    or a Net::Jabber::JID object for the person who
                    sent the <message/>.  To get the JID object set 
                    the string to "jid", otherwise leave blank for the 
                    text string.

  GetSTo()      - returns either a string with the Jabber Identifier,
  GetSTo("jid")   or a Net::Jabber::JID object for the <host/> of the
                  component that is going to receive the <message/>.  
                  To get the JID object set the string to "jid", 
                  otherwise leave blank for the text string.

  GetSFrom()      -  returns either a string with the Jabber Identifier,
  GetSFrom("jid")    or a Net::Jabber::JID object for the <host/> of the
                     component that sent the <message/>.  To get the JID 
                     object set the string to "jid", otherwise leave 
                     blank for the text string.

  GetEtherxTo(string) - returns the etherx:to attribute.  This is for
                        Transport writers who need to communicate with
                        Etherx.

  GetEtherxFrom(string) -  returns the etherx:from attribute.  This is for
                           Transport writers who need to communicate with
                           Etherx.

  GetResource() - returns a string with the Jabber Resource of the 
                  person who sent the <message/>.

  GetType() - returns a string with the type <message/> this is.

  GetSubject() - returns a string with the subject of the <message/>.

  GetBody(string) - returns the data in the <body/> tag depending on the
                    value of the string passed to it.  The string
                    represents the mark up level to return.

                    none   returns a string with just the text of 
                           the <body/> (default)
                    full   returns an XML::Paser::Tree with everything
                           in the <body/>

  GetThread() - returns a string that represents the thread this
                <message/> belongs to.

  GetPriority() - returns an integer with the priority of the <message/>.

  GetError() - returns a string with the data of the <error/> tag.

  GetErrorCode() - returns a string with the code of the <error/> tag.

  GetX(string) - returns an array of Net::Jabber::X objects.  The string 
                 can either be empty or the XML Namespace you are looking
                 for.  If empty then GetX returns every <x/> tag in the 
                 <message/>.  If an XML Namespace is sent then GetX 
                 returns every <x/> tag with that Namespace.

  GetXTrees(string) - returns an array of XML::Parser::Tree objects.  The 
                      string can either be empty or the XML Namespace you 
                      are looking for.  If empty then GetXTrees returns
                      every <x/> tag in the <message/>.  If an XML
                      Namespace is sent then GetXTrees returns every
                      <x/> tag with that  Namespace.

  GetXML() - returns the XML string that represents the <message/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Message.

  GetTree() - returns an array that contains the <message/> tag
              in XML::Parser Tree format.

  GetTimeStamp() - returns a string that represents the time this message
                   object was created (and probably received) for sending
                   to the client.  If there is an <x/> delay tag then that
                   time is used to show when the message was sent.

=head2 Creation functions

  SetMessage(to=>string|JID,     - set multiple fields in the <message/>
             from=>string|JID,     at one time.  This is a cumulative
             sto=>string,          and over writing action.  If you set
             sfrom=>string,        the "to" attribute twice, the second
             etherxto=>string,     setting is what is used.  If you set
             etherxfrom=>string,   the subject, and then set the body
             type=>string,         then both will be in the <message/>
             subject=>string,      tag.  For valid settings read the
             body=>string,         specific Set functions below.
             thread=>string,
             priority=>integer,
             errorcode=>string,
             error=>string)

  SetTo(string) - sets the to attribute.  You can either pass a string
  SetTo(JID)      or a JID object.  They must be valid Jabber 
                  Identifiers or the server will return an error message.
                  (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

  SetFrom(string) - sets the from attribute.  You can either pass a string
  SetFrom(JID)      or a JID object.  They must be valid Jabber 
                    Identifiers or the server will return an error message.
                    (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

  SetSTo(string) - sets the sto attribute.  You can either pass a string
  SetSTo(JID)      or a JID object.  They must be valid Jabber 
                   Identifiers or the server will return an error message.
                   (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

  SetSFrom(string) - sets the sfrom attribute.  You can either pass a string
  SetSFrom(JID)      or a JID object.  They must be valid Jabber 
                     Identifiers or the server will return an error message.
                     (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

  SetEtherxTo(string) - sets the etherx:to attribute.  This is for
                        Transport writers who need to communicate with
                        Etherx.

  SetEtherxFrom(string) -  sets the etherx:from attribute.  This is for
                           Transport writers who need to communicate with
                           Etherx.

  SetType(string) - sets the type attribute.  Valid settings are:

                    chat           defines a chat style message
                    error          defines an error message
                    groupchat      defines a chatroom message
                    normal         defines a normal message (default)

  SetSubject(string) - sets the subject of the <message/>.

  SetBody(string) - sets the body of the <message/>.

  SetThread(string) - sets the thread of the <message/>.  You should
                      copy this out of the message being replied to so
                      that the thread is maintained.

  SetPriority(integer) - sets the priority of this <message/>.  The 
                         higher the priority the more likely the client
                         will deliver the message, even if the user has
                         specified no messages.

  SetErrorCode(string) - sets the error code of the <message/>.

  SetError(string) - sets the error string of the <message/>.

  NewX(string) - creates a new Net::Jabber::X object with the namespace
                 in the string.  In order for this function to work with
                 a custom namespace, you must define and register that  
                 namespace with the X module.  For more information
                 please read the documentation for Net::Jabber::X.

  Reply(template=>string,       - creates a new Message object and
        replytransport=>string)   populates the to/from and
                                  etherxto/etherxfrom fields based
                                  the value of template.  The following
                                  templates are available:

                                  client: (default)
                                       just sets the to/from

                                  transport:
                                  transport-reply:
                                       the transport will send the
                                       reply to the sender

                                  transport-filter:
                                       the transport will send the
                                       reply to the address from the
                                       to.  ie( bob%j.org@transport.j.org
                                       would send to bob@j.org)

                                  transport-filter-reply:
                                       the transport will send the
                                       reply to the address from the
                                       to.  ie( bob%j.org@transport.j.org
                                       would send to bob@j.org) and
                                       set the from to be 
                                       sender@replytransport.  That
                                       way a two way filter can occur.

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the <message/>, 
                0 otherwise.

  DefinedFrom() - returns 1 if the from attribute is defined in the 
                  <message/>, 0 otherwise.

  DefinedSTo() - returns 1 if the sto attribute is defined in the <message/>, 
                 0 otherwise.

  DefinedSFrom() - returns 1 if the sfrom attribute is defined in the 
                   <message/>, 0 otherwise.

  DefinedEtherxTo() - returns 1 if the etherx:to attribute is defined in 
                      the <message/>, 0 otherwise.

  DefinedEtherxFrom() - returns 1 if the etherx:from attribute is defined 
                        in the <message/>, 0 otherwise.

  DefinedType() - returns 1 if the type attribute is defined in the 
                  <message/>, 0 otherwise.

  DefinedSubject() - returns 1 if <subject/> is defined in the <message/>, 
                     0 otherwise.

  DefinedBody() - returns 1 if <body/> is defined in the <message/>, 
                  0 otherwise.

  DefinedThread() - returns 1 if <thread/> is defined in the <message/>, 
                    0 otherwise.

  DefinedPriority() - returns 1 if <priority/> is defined in the <message/>, 
                      0 otherwise.

  DefinedErrorCode() - returns 1 if <error/> is defined in the <message/>, 
                       0 otherwise.

  DefinedError() - returns 1 if the code attribute is defined in the 
                   <error/>, 0 otherwise.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.0019";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;
  $self->{TIMESTAMP} = &Net::Jabber::GetTimeStamp("local");

  bless($self, $proto);

  $self->{DEBUG} = new Net::Jabber::Debug(usedefault=>1,
                                          header=>"NJ::Message");

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{MESSAGE} = \@temp;
    my $xTree;
    foreach $xTree ($self->GetXTrees()) {
      my $xmlns = &Net::Jabber::GetXMLData("value",$xTree,"","xmlns");
      next if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});
      $self->AddX($xmlns,@{$xTree});
    }
  } else {
    $self->{MESSAGE} = [ "message" , [{}]];
    $self->{XTAGS} = [];
  }

  return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the delegate with the appropriate function
#            name and argument list.
#
##############################################################################
sub AUTOLOAD {
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "MESSAGE";
  
  return "message" if ($AUTOLOAD eq "GetTag");
  return &Net::Jabber::BuildXML(@{$self->{$treeName}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{$treeName}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{To}         = ["value","","to"];
$FUNCTIONS{get}->{From}       = ["value","","from"];
$FUNCTIONS{get}->{STo}        = ["value","","sto"];
$FUNCTIONS{get}->{SFrom}      = ["value","","sfrom"];
$FUNCTIONS{get}->{EtherxTo}   = ["value","","etherx:to"];
$FUNCTIONS{get}->{EtherxFrom} = ["value","","etherx:from"];
$FUNCTIONS{get}->{ID}         = ["value","","id"];
$FUNCTIONS{get}->{Type}       = ["value","","type"];
$FUNCTIONS{get}->{Subject}    = ["value","subject",""];
$FUNCTIONS{get}->{Thread}     = ["value","thread",""];
$FUNCTIONS{get}->{Priority}   = ["value","priority",""];
$FUNCTIONS{get}->{ErrorCode}  = ["value","error","code"];
$FUNCTIONS{get}->{Error}      = ["value","error",""];

$FUNCTIONS{set}->{EtherxTo}   = ["single","","","etherx:to","*"];
$FUNCTIONS{set}->{EtherxFrom} = ["single","","","etherx:from","*"];
$FUNCTIONS{set}->{ID}         = ["single","","","id","*"];
$FUNCTIONS{set}->{Type}       = ["single","","","type","*"];
$FUNCTIONS{set}->{Subject}    = ["single","subject","*","",""];
$FUNCTIONS{set}->{Body}       = ["single","body","*","",""];
$FUNCTIONS{set}->{Thread}     = ["single","thread","*","",""];
$FUNCTIONS{set}->{Priority}   = ["single","priority","*","",""];
$FUNCTIONS{set}->{ErrorCode}  = ["single","error","","code","*"];
$FUNCTIONS{set}->{Error}      = ["single","error","*","",""];

$FUNCTIONS{defined}->{To}         = ["existence","","to"];
$FUNCTIONS{defined}->{From}       = ["existence","","from"];
$FUNCTIONS{defined}->{STo}        = ["existence","","sto"];
$FUNCTIONS{defined}->{SFrom}      = ["existence","","sfrom"];
$FUNCTIONS{defined}->{EtherxTo}   = ["existence","","etherx:to"];
$FUNCTIONS{defined}->{EtherxFrom} = ["existence","","etherx:from"];
$FUNCTIONS{defined}->{ID}         = ["existence","","id"];
$FUNCTIONS{defined}->{Type}       = ["existence","","type"];
$FUNCTIONS{defined}->{Subject}    = ["existence","subject",""];
$FUNCTIONS{defined}->{Body}       = ["existence","body",""];
$FUNCTIONS{defined}->{Thread}     = ["existence","thread",""];
$FUNCTIONS{defined}->{Priority}   = ["existence","priority",""];
$FUNCTIONS{defined}->{ErrorCode}  = ["existence","error","code"];
$FUNCTIONS{defined}->{Error}      = ["existence","error",""];


##############################################################################
#
# GetResource - returns the Jabber Resource of the person who sent the 
#              <message/>
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
# GetBody - returns the body of the <message/>
#
##############################################################################
sub GetBody {
  my $self = shift;
  my ($level) = @_;
  $level = "" if !defined($level);
  return &Net::Jabber::GetXMLData("value",$self->{MESSAGE},"body")
    if (($level eq "none") || ($level eq ""));
  return &Net::Jabber::GetXMLData("tree",$self->{MESSAGE},"body")
    if ($level eq "full");
}


##############################################################################
#
# GetX - returns an array of Net::Jabber::X objects.  If a namespace is 
#        requested then only objects from that name space are returned.
#
##############################################################################
sub GetX {
  my $self = shift;
  my($xmlns) = @_;
  my @xTags;
  my $xTag;
  foreach $xTag (@{$self->{XTAGS}}) {
    push(@xTags,$xTag) if (($xmlns eq "") || ($xTag->GetXMLNS() eq $xmlns));
  }
  return @xTags;
}


##############################################################################
#
# GetXTrees - returns an array of XML::Parser::Tree objects of the <x/> tags
#
##############################################################################
sub GetXTrees {
  my $self = shift;
  $self->MergeX();
  my ($xmlns) = @_;
  my $xTree;
  my @xTrees;
  foreach $xTree (&Net::Jabber::GetXMLData("tree array",$self->{MESSAGE},"*","xmlns",$xmlns)) {
    push(@xTrees,$xTree);
  }
  return @xTrees;
}


##############################################################################
#
# GetXML -  returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  $self->MergeX();
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
  $self->MergeX();
  return %{$self->{MESSAGE}};
}


##############################################################################
#
# GetTimeStamp - returns a string with the time stamp of when this object
#                was created.
#
##############################################################################
sub GetTimeStamp {
  my $self = shift;

  my @xTags = $self->GetX("jabber:x:delay");
  if ($#xTags >= 0) {
    my $xTag = $xTags[0];
    $self->{TIMESTAMP} = &Net::Jabber::GetTimeStamp("utcdelaylocal",$xTag->GetStamp());
  }

  return $self->{TIMESTAMP};
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

  $self->SetID($message{id}) if exists($message{id});
  $self->SetTo($message{to}) if exists($message{to});
  $self->SetFrom($message{from}) if exists($message{from});
  $self->SetSTo($message{sto}) if exists($message{sto});
  $self->SetSFrom($message{sfrom}) if exists($message{sfrom});
  $self->SetEtherxTo($message{etherxto}) if exists($message{etherxto});
  $self->SetEtherxFrom($message{etherxfrom}) if exists($message{etherxfrom});
  $self->SetType($message{type}) if exists($message{type});
  $self->SetSubject($message{subject}) if exists($message{subject});
  $self->SetBody($message{body}) if exists($message{body});
  $self->SetThread($message{thread}) if exists($message{thread});
  $self->SetPriority($message{priority}) if exists($message{priority});
  $self->SetErrorCode($message{errorcode}) if exists($message{errorcode});
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
  if (ref($to) eq "Net::Jabber::JID") {
    $to = $to->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"","",{to=>$to});
}


##############################################################################
#
# SetFrom - sets the from attribute in the <message/>
#
##############################################################################
sub SetFrom {
  my $self = shift;
  my ($from) = @_;
  if (ref($from) eq "Net::Jabber::JID") {
    $from = $from->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"","",{from=>$from});
}


##############################################################################
#
# SetSTo - sets the sto attribute in the <message/>
#
##############################################################################
sub SetSTo {
  my $self = shift;
  my ($sto) = @_;
  if (ref($sto) eq "Net::Jabber::JID") {
    $sto = $sto->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"","",{sto=>$sto});
}


##############################################################################
#
# SetSFrom - sets the sfrom attribute in the <message/>
#
##############################################################################
sub SetSFrom {
  my $self = shift;
  my ($sfrom) = @_;
  if (ref($sfrom) eq "Net::Jabber::JID") {
    $sfrom = $sfrom->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{MESSAGE},"","",{sfrom=>$sfrom});
}


##############################################################################
#
# AddXML - adds the specfied XML into the outgoing XML whenever it's 
#          requested.
#
##############################################################################
sub AddXML {
  my $self = shift;
  my ($xml) = @_;

  require XML::Parser;
  my $parser = new XML::Parser(Style=>'Tree');
  my @trees = $parser->parse($xml);

  my $treeIndex;
  foreach $treeIndex (0..$#trees) {
    my $index;
    foreach $index (0..$#{$trees[$treeIndex]}) {
      $self->{MESSAGE}->[1]->[$#{$self->{MESSAGE}->[1]}+1] = $trees[$treeIndex]->[$index];      
    }
  }
}


##############################################################################
#
# AddTree - adds the specfied Tree into the outgoing XML whenever it's 
#           requested.
#
##############################################################################
sub AddTree {
  my $self = shift;
  my (@tree) = @_;

  my $index;
  foreach $index (0..$#tree) {
    $self->{MESSAGE}->[1]->[$#{$self->{MESSAGE}->[1]}+1] = $tree[$index];      
  }
}


##############################################################################
#
# NewX - calls AddX to create a new Net::Jabber::X object, sets the xmlns and 
#        returns a pointer to the new object.
#
##############################################################################
sub NewX {
  my $self = shift;
  my ($xmlns) = @_;
  return if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});
  my $xTag = $self->AddX($xmlns);
  $xTag->SetXMLNS($xmlns) if $xmlns ne "";
  return $xTag;
}


##############################################################################
#
# AddX - creates a new Net::Jabber::X object, pushes it on the list, and 
#        returns a pointer to the new object.  This is a private helper 
#        function. 
#
##############################################################################
sub AddX {
  my $self = shift;
  my ($xmlns,@xTree) = @_;
  return if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});
  $self->{DEBUG}->Log2("AddX: xmlns($xmlns) xTree(",\@xTree,")");
  my $xTag;
  eval("\$xTag = new ".$Net::Jabber::DELEGATES{x}->{$xmlns}->{parent}."(\@xTree);");
  $self->{DEBUG}->Log2("AddX: xTag(",$xTag,")");
  push(@{$self->{XTAGS}},$xTag);
  return $xTag;
}


##############################################################################
#
# MergeX - runs through the list of <x/> in the current message and replaces
#          them with the list of <x/> in the internal list.  If any old <x/>
#          in the <message/> are left, then they are removed.  If any new <x/>
#          are left in the interanl list, then they are added to the end of
#          the message.  This is a private helper function.  It should be 
#          used any time you need access the full <message/> so that all of
#          the <x/> tags are included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeX {
  my $self = shift;

  $self->{DEBUG}->Log2("MergeX: start");

  return if !(exists($self->{XTAGS}));

  $self->{DEBUG}->Log2("MergeX: xTags(",$self->{XTAGS},")");

  my $xTag;
  my @xTags;
  foreach $xTag (@{$self->{XTAGS}}) {
    push(@xTags,$xTag);
  }

  $self->{DEBUG}->Log2("MergeX: xTags(",\@xTags,")");
  $self->{DEBUG}->Log2("MergeX: Check the old tags");
  $self->{DEBUG}->Log2("MergeX: length(",$#{$self->{MESSAGE}->[1]},")");


  my $i;
  foreach $i (1..$#{$self->{MESSAGE}->[1]}) {
    $self->{DEBUG}->Log2("MergeX: i($i)");
    $self->{DEBUG}->Log2("MergeX: data(",$self->{MESSAGE}->[1]->[$i],")");

    if ((ref($self->{MESSAGE}->[1]->[($i+1)]) eq "ARRAY") &&
	exists($self->{MESSAGE}->[1]->[($i+1)]->[0]->{xmlns})) {
      $self->{DEBUG}->Log2("MergeX: found a namespace xmlns(",$self->{MESSAGE}->[1]->[($i+1)]->[0]->{xmlns},")");
      next if !exists($Net::Jabber::DELEGATES{x}->{$self->{MESSAGE}->[1]->[($i+1)]->[0]->{xmlns}});
      $self->{DEBUG}->Log2("MergeX: merge index($i)");
      my $xTag = pop(@xTags);
      $self->{DEBUG}->Log2("MergeX: merge xTag($xTag)");
      my @xTree = $xTag->GetTree();
      $self->{DEBUG}->Log2("MergeX: merge xTree(",\@xTree,")");
      $self->{MESSAGE}->[1]->[($i+1)] = $xTree[1];
    }
  }

  $self->{DEBUG}->Log2("MergeX: Insert new tags");
  foreach $xTag (@xTags) {
    $self->{DEBUG}->Log2("MergeX: new tag");
    my @xTree = $xTag->GetTree();
    $self->{MESSAGE}->[1]->[($#{$self->{MESSAGE}->[1]}+1)] = "x";
    $self->{MESSAGE}->[1]->[($#{$self->{MESSAGE}->[1]}+1)] = $xTree[1];
  }

  $self->{DEBUG}->Log2("MergeX: end");
}


##############################################################################
#
# Reply - returns a Net::Jabber::Message object with the proper fields
#         already populated for you.
#
##############################################################################
sub Reply {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $reply = new Net::Jabber::Message();

  if (($self->GetType() eq "") || ($self->GetType() eq "normal")) {
    my $subject = $self->GetSubject();
    $subject =~ s/re\:\s+//i;
    $reply->SetSubject("re: $subject");
  }
  $reply->SetThread($self->GetThread()) if ($self->GetThread() ne "");
  $reply->SetID($self->GetID()) if ($self->GetID() ne "");
  $reply->SetType($self->GetType()) if ($self->GetType() ne "");
  $reply->SetType($args{type}) if exists($args{type});


  if (exists($args{template})) {
    if (($args{template} eq "transport") || ($args{template} eq "transport-reply")) {
      my $fromJID = $self->GetFrom("jid");

      $reply->SetMessage(to=>$self->GetFrom(),
			 from=>$self->GetTo(),
			 etherxto=>$fromJID->GetServer(),
			 etherxfrom=>$self->GetEtherxTo(),
			);
    } else {
      if ($args{template} eq "transport-filter") {
	my $toJID = $self->GetTo("jid");
	my $fromJID = $self->GetFrom("jid");

	my $filterToJID = new Net::Jabber::JID($toJID->GetUserID());

	$reply->SetMessage(to=>$filterToJID,
			   from=>$fromJID,
			   etherxto=>$filterToJID->Server(),
			   etherxfrom=>$fromJID->Server());
      } else {
	if ($args{template} eq "transport-filter-reply") {
	  my $toJID = $self->GetTo("jid");
	  my $fromJID = $self->GetFrom("jid");
	  
	  my $filterToJID = new Net::Jabber::JID($toJID->GetUserID());
	  my $filterFromJID = new Net::Jabber::JID($fromJID->GetUserID()."\%".$fromJID->GetServer()."\@".$args{replytransport});
	  
	  $reply->SetMessage(to=>$filterToJID,
			     from=>$filterFromJID,
			     etherxto=>$filterToJID->Server(),
			     etherxfrom=>$self->GetEtherxTo());
	} else {
	  $reply->SetMessage(to=>$self->GetFrom(),
			     from=>$self->GetTo());
	}	
      }
    }
  } else {
    $reply->SetMessage(to=>$self->GetFrom(),
		       from=>$self->GetTo());
  }

  return $reply;
}


1;
