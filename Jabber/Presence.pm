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

package Net::Jabber::Presence;

=head1 NAME

Net::Jabber::Presence - Jabber Presence Module

=head1 SYNOPSIS

  Net::Jabber::Presence is a companion to the Net::Jabber module.  
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber Presence.

=head1 DESCRIPTION

  To initialize the Presence with a Jabber <presence/> you must pass it 
  the XML::Parser Tree array from the Net::Jabber::Client module.  In the
  callback function for the presence:

    use Net::Jabber;

    sub presence {
      my $presence = new Net::Jabber::Presence(@_);
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new presence to send to the server:

    use Net::Jabber;

    $Pres = new Net::Jabber::Presence();

  Now you can call the creation functions below to populate the tag before
  sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $to         = $Pres->GetTo();
    $toJID      = $Pres->GetTo("jid");
    $from       = $Pres->GetFrom();
    $fromJID    = $Pres->GetFrom("jid");
    $sto        = $Pres->GetSTo();
    $stoJID     = $Pres->GetSTo("jid");
    $sfrom      = $Pres->GetSFrom();
    $sfromJID   = $Pres->GetSFrom("jid");
    $etherxTo   = $Pres->GetEtherxTo();
    $etherxFrom = $Pres->GetEtherxFrom();
    $type       = $Pres->GetType();
    $status     = $Pres->GetStatus();
    $priority   = $Pres->GetPriority();
    $show       = $Pres->GetShow();
    @xTags      = $Pres->GetX();
    @xTags      = $Pres->GetX("my:namespace");
    @xTrees     = $Pres->GetXTrees();
    @xTrees     = $Pres->GetXTrees("my:namespace");

    $str        = $Pres->GetXML();
    @presence   = $Pres->GetTree();

=head2 Creation functions

    $Pres->SetPresence(TYPE=>"online",
		       StatuS=>"Open for Business",
		       iCoN=>"normal");
    $Pres->SetTo("bob\@jabber.org");
    $Pres->SetFrom("jojo\@jabber.org");
    $Pres->SetSTo("jabber.org");
    $Pres->SetSFrom("jabber.org");
    $Pres->SetEtherxTo("jabber.org");
    $Pres->SetEtherxFrom("transport.jabber.org");
    $Pres->SetType("unavailable");
    $Pres->SetStatus("Taking a nap");
    $Pres->SetPriority(10);
    $Pres->SetShow("away");

    $X = $Pres->NewX("jabber:x:delay");
    $X = $Pres->NewX("my:namespace");

    $Reply = $Pres->Reply();
    $Reply = $Pres->Reply(template=>"client");
    $Reply = $Pres->Reply(template=>"transport",
                          type=>"subscribed");

=head2 Test functions

    $test = $Pres->DefinedTo();
    $test = $Pres->DefinedFrom();
    $test = $Pres->DefinedSTo();
    $test = $Pres->DefinedSFrom();
    $test = $Pres->DefinedEtherxTo();
    $test = $Pres->DefinedEtherxFrom();
    $test = $Pres->DefinedType();
    $test = $Pres->DefinedStatus();
    $test = $Pres->DefinedPriority();
    $test = $Pres->DefinedShow();

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns either a string with the Jabber Identifier,
  GetTo("jid")   or a Net::Jabber::JID object for the person who is 
                 going to receive the <presence/>.  To get the JID
                 object set the string to "jid", otherwise leave
                 blank for the text string.

  GetFrom()      -  returns either a string with the Jabber Identifier,
  GetFrom("jid")    or a Net::Jabber::JID object for the person who
                    sent the <presence/>.  To get the JID object set 
                    the string to "jid", otherwise leave blank for the 
                    text string.

  GetSTo()      - returns either a string with the Jabber Identifier,
  GetSTo("jid")   or a Net::Jabber::JID object for the <host/> component
                  who is going to receive the <presence/>.  To get the 
                  JID object set the string to "jid", otherwise leave
                  blank for the text string.

  GetSFrom()      -  returns either a string with the Jabber Identifier,
  GetSFrom("jid")    or a Net::Jabber::JID object for the <host/> 
                     component who sent the <presence/>.  To get the 
                     JID object set the string to "jid", otherwise 
                     leave blank for the text string.

  GetEtherxTo(string) - returns the etherx:to attribute.  This is for
                        Transport writers who need to communicate with
                        Etherx.

  GetEtherxFrom(string) -  returns the etherx:from attribute.  This is for
                           Transport writers who need to communicate with
                           Etherx.

  GetType() - returns a string with the type <presence/> this is.

  GetStatus() - returns a string with the current status of the resource.

  GetPriority() - returns an integer with the priority of the resource
                  The default is 0 if there is no priority in this presence.

  GetShow() - returns a string with the state the client should show.

  GetX(string) - returns an array of Net::Jabber::X objects.  The string can 
                 either be empty or the XML Namespace you are looking for.  
                 If empty then GetX returns every <x/> tag in the 
                 <presence/>.  If an XML Namespace is sent then GetX 
                 returns every <x/> tag with that Namespace.

  GetXTrees(string) - returns an array of XML::Parser::Tree objects.  The 
                      string can either be empty or the XML Namespace you 
                      are looking for.  If empty then GetXTrees returns every 
                      <x/> tag in the <presence/>.  If an XML Namespace is 
                      sent then GetXTrees returns every <x/> tag with that 
                      Namespace.

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetPresence(to=>string|JID     - set multiple fields in the <presence/>
              from=>string|JID,    at one time.  This is a cumulative
              sto=>string,         and over writing action.  If you set
              sfrom=>string,       the "to" attribute twice, the second
              etherxto=>string,    setting is what is used.  If you set
              etherxfrom=>string,  the status, and then set the priority
              type=>string,        then both will be in the <presence/>
              status=>string,      tag.  For valid settings read the
              priority=>integer,   specific Set functions below.
	      meta=>string, 
	      icon=>string,
              show=>string,
              loc=>string)

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

                    available       available to receive messages; default
                    unavailable     unavailable to receive anything
                    subscribe       ask the recipient to subscribe you
                    subscribed      tell the sender they are subscribed
                    unsubscribe     ask the recipient to unsubscribe you
                    unsubscribed    tell the sender they are unsubscribed
                    probe           probe

  SetStatus(string) - sets the status tag to be whatever string the user
                      wants associated with that resource.

  SetPriority(integer) - sets the priority of this resource.  The highest
                         resource attached to the jabber account is the
                         one that receives the messages.

  SetShow(string) - sets the name of the default symbol to display for this
                    resource.

  NewX(string) - creates a new Net::Jabber::X object with the namespace
                 in the string.  In order for this function to work with
                 a custom namespace, you must define and register that  
                 namespace with the X module.  For more information
                 please read the documentation for Net::Jabber::X.

  Reply(template=>string, - creates a new Presence object and
        type=>string)       populates the to/from and
                            etherxto/etherxfrom fields based
                            the value of template.  The following
                            templates are available:

                            client: (default)
                                 just sets the to/from

                            transport:
                            transport-reply:
                                 the transport will send the
                                 reply to the sender

                            The type will be set in the <presence/>.

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the <presence/>, 
                0 otherwise.

  DefinedFrom() - returns 1 if the from attribute is defined in the 
                  <presence/>, 0 otherwise.

  DefinedEtherxTo() - returns 1 if the etherx:to attribute is defined in 
                      the <presence/>, 0 otherwise.

  DefinedEtherxFrom() - returns 1 if the etherx:from attribute is defined 
                        in the <presence/>, 0 otherwise.

  DefinedType() - returns 1 if the type attribute is defined in the 
                  <presence/>, 0 otherwise.

  DefinedStatus() - returns 1 if <status/> is defined in the <presence/>, 
                    0 otherwise.

  DefinedPriority() - returns 1 if <priority/> is defined in the 
                      <presence/>, 0 otherwise.

  DefinedShow() - returns 1 if <show/> is defined in the <presence/>, 
                  0 otherwise.

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

  bless($self, $proto);

  $self->{DEBUG} = new Net::Jabber::Debug(usedefault=>1,
					  header=>"NJ::Presence");

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{PRESENCE} = \@temp;
    my $xTree;
    foreach $xTree ($self->GetXTrees()) {
      my $xmlns = &Net::Jabber::GetXMLData("value",$xTree,"","xmlns");
      next if !exists($Net::Jabber::DELEGATES{x}->{$xmlns});
      $self->AddX($xmlns,@{$xTree}) if ($xmlns ne "");
    }
  } else {
    $self->{PRESENCE} = [ "presence" , [{}] ];
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
  my $treeName = "PRESENCE";
  
  return "presence" if ($AUTOLOAD eq "GetTag");
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
$FUNCTIONS{get}->{Status}     = ["value","status",""];
$FUNCTIONS{get}->{Show}       = ["value","show",""];

$FUNCTIONS{set}->{EtherxTo}   = ["single","","","etherx:to","*"];
$FUNCTIONS{set}->{EtherxFrom} = ["single","","","etherx:from","*"];
$FUNCTIONS{set}->{ID}         = ["single","","","id","*"];
$FUNCTIONS{set}->{Type}       = ["single","","","type","*"];
$FUNCTIONS{set}->{Status}     = ["single","status","*","",""];
$FUNCTIONS{set}->{Show}       = ["single","show","*","",""];

$FUNCTIONS{defined}->{To}         = ["existence","","to"];
$FUNCTIONS{defined}->{From}       = ["existence","","from"];
$FUNCTIONS{defined}->{STo}        = ["existence","","sto"];
$FUNCTIONS{defined}->{SFrom}      = ["existence","","sfrom"];
$FUNCTIONS{defined}->{EtherxTo}   = ["existence","","etherx:to"];
$FUNCTIONS{defined}->{EtherxFrom} = ["existence","","etherx:from"];
$FUNCTIONS{defined}->{ID}         = ["existence","","id"];
$FUNCTIONS{defined}->{Type}       = ["existence","","type"];
$FUNCTIONS{defined}->{Status}     = ["existence","status",""];
$FUNCTIONS{defined}->{Priority}   = ["existence","priority",""];
$FUNCTIONS{defined}->{Show}       = ["existence","show",""];


##############################################################################
#
# GetPriority - returns the priority of the <presence/>
#
##############################################################################
sub GetPriority {
  my $self = shift;
  my $priority = &Net::Jabber::GetXMLData("value",$self->{PRESENCE},"priority");
  $priority = 0 if ($priority eq "");
  return $priority;
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
  foreach $xTree (&Net::Jabber::GetXMLData("tree array",$self->{PRESENCE},"*","xmlns",$xmlns)) {
    push(@xTrees,$xTree);
  }
  return @xTrees;
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  $self->MergeX();
  return &Net::Jabber::BuildXML(@{$self->{PRESENCE}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#               the object.
#
##############################################################################
sub GetTree {
  my $self = shift;
  $self->MergeX();
  return @{$self->{PRESENCE}};
}


##############################################################################
#
# SetPresence - takes a hash of all of the things you can set on a <presence/>
#               and sets each one.
#
##############################################################################
sub SetPresence {
  my $self = shift;
  my %presence;
  while($#_ >= 0) { $presence{ lc pop(@_) } = pop(@_); }

  $self->SetID($presence{id}) if exists($presence{id});
  $self->SetTo($presence{to}) if exists($presence{to});
  $self->SetFrom($presence{from}) if exists($presence{from});
  $self->SetSTo($presence{sto}) if exists($presence{sto});
  $self->SetSFrom($presence{sfrom}) if exists($presence{sfrom});
  $self->SetEtherxTo($presence{etherxto}) if exists($presence{etherxto});
  $self->SetEtherxFrom($presence{etherxfrom}) if exists($presence{etherxfrom});
  $self->SetType($presence{type}) if exists($presence{type});
  $self->SetStatus($presence{status}) if exists($presence{status});
  $self->SetPriority($presence{priority}) if exists($presence{priority});
  $self->SetShow($presence{show}) if exists($presence{show});
}


##############################################################################
#
# SetTo - sets the to attribute in the <presence/>
#
##############################################################################
sub SetTo {
  my $self = shift;
  my ($to) = @_;
  if (ref($to) eq "Net::Jabber::JID") {
    $to = $to->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{PRESENCE},"","",{to=>$to});
}


##############################################################################
#
# SetFrom - sets the from attribute in the <presence/>
#
##############################################################################
sub SetFrom {
  my $self = shift;
  my ($from) = @_;
  if (ref($from) eq "Net::Jabber::JID") {
    $from = $from->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{PRESENCE},"","",{from=>$from});
}


##############################################################################
#
# SetSTo - sets the sto attribute in the <presence/>
#
##############################################################################
sub SetSTo {
  my $self = shift;
  my ($sto) = @_;
  if (ref($sto) eq "Net::Jabber::JID") {
    $sto = $sto->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{PRESENCE},"","",{sto=>$sto});
}


##############################################################################
#
# SetSFrom - sets the sfrom attribute in the <presence/>
#
##############################################################################
sub SetSFrom {
  my $self = shift;
  my ($sfrom) = @_;
  if (ref($sfrom) eq "Net::Jabber::JID") {
    $sfrom = $sfrom->GetJID("full");
  }
  &Net::Jabber::SetXMLData("single",$self->{PRESENCE},"","",{sfrom=>$sfrom});
}


##############################################################################
#
# SetPriority - sets the priority of the <presence/>
#
##############################################################################
sub SetPriority {
  my $self = shift;
  my ($priority) = @_;
  $priority = 0 if ($priority eq "");
  &Net::Jabber::SetXMLData("single",$self->{PRESENCE},"priority",$priority,{});
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
# MergeX - runs through the list of <x/> in the current presence and replaces
#          them with the list of <x/> in the internal list.  If any old <x/>
#          in the <presence/> are left, then they are removed.  If any new <x/>
#          are left in the interanl list, then they are added to the end of
#          the presence.  This is a private helper function.  It should be 
#          used any time you need access the full <presence/> so that all of
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
  $self->{DEBUG}->Log2("MergeX: length(",$#{$self->{PRESENCE}->[1]},")");

  my $i;
  foreach $i (1..$#{$self->{PRESENCE}->[1]}) {
    $self->{DEBUG}->Log2("MergeX: i($i)");
    $self->{DEBUG}->Log2("MergeX: data(",$self->{PRESENCE}->[1]->[$i],")");

    if ((ref($self->{PRESENCE}->[1]->[($i+1)]) eq "ARRAY") &&
	exists($self->{PRESENCE}->[1]->[($i+1)]->[0]->{xmlns})) {
      $self->{DEBUG}->Log2("MergeX: found a namespace xmlns(",$self->{PRESENCE}->[1]->[($i+1)]->[0]->{xmlns},")");
      next if !exists($Net::Jabber::DELEGATES{x}->{$self->{PRESENCE}->[1]->[($i+1)]->[0]->{xmlns}});
      $self->{DEBUG}->Log2("MergeX: merge index($i)");
      my $xTag = pop(@xTags);
      $self->{DEBUG}->Log2("MergeX: merge xTag($xTag)");
      my @xTree = $xTag->GetTree();
      $self->{DEBUG}->Log2("MergeX: merge xTree(",\@xTree,")");
      $self->{PRESENCE}->[1]->[$i] = $xTree[0];
      $self->{PRESENCE}->[1]->[($i+1)] = $xTree[1];
    }
  }

  $self->{DEBUG}->Log2("MergeX: Insert new tags");
  foreach $xTag (@xTags) {
    $self->{DEBUG}->Log2("MergeX: new tag");
    my @xTree = $xTag->GetTree();
    $self->{PRESENCE}->[1]->[($#{$self->{PRESENCE}->[1]}+1)] = $xTree[0];
    $self->{PRESENCE}->[1]->[($#{$self->{PRESENCE}->[1]}+1)] = $xTree[1];
  }

  $self->{DEBUG}->Log2("MergeX: end");
}


##############################################################################
#
# Reply - returns a Net::Jabber::Presence object with the proper fields
#         already populated for you.
#
##############################################################################
sub Reply {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  my $reply = new Net::Jabber::Presence();

  $reply->SetID($self->GetID()) if ($self->GetID() ne "");
  $reply->SetType(exists($args{type}) ? $args{type} : "");

  if (exists($args{template})) {
    if ($args{template} eq "transport") {
      my $fromJID = $self->GetFrom("jid");
      
      $reply->SetPresence(to=>$self->GetFrom(),
			  from=>$self->GetTo(),
			  etherxto=>$fromJID->GetServer(),
			  etherxfrom=>$self->GetEtherxTo(),
			 );
    } else {
      $reply->SetPresence(to=>$self->GetFrom(),
			  from=>$self->GetTo());
    }
  } else {
    $reply->SetPresence(to=>$self->GetFrom(),
			from=>$self->GetTo());
  }

  return $reply;
}


1;
