#############################################################################
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
  the XML::Stream has.  For example:

    my $presence = new Net::Jabber::Presence(%hash);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above yourself, a Net::Jabber::Presence
  object is passed to the callback function for the message.  Also,
  the first argument to the callback functions is the session ID from
  XML::Streams.  There are some cases where you might want this
  information, like if you created a Client that connects to two servers
  at once, or for writing a mini server.

    use Net::Jabber qw(Client);

    sub presence {
      my ($sid,$Pres) = @_;
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new presence to send to the server:

    use Net::Jabber qw(Client);

    $Pres = new Net::Jabber::Presence();

  Now you can call the creation functions below to populate the tag
  before sending it.

  For more information about the array format being passed to the
  CallBack please read the Net::Jabber::Client documentation.

=head1 METHODS

=head2 Retrieval functions

  GetTo()      - returns the value in the to='' attribute for the
  GetTo("jid")   <presence/>.  If you specify "jid" as an argument
                 then a Net::Jabber::JID object is returned and
                 you can easily parse the parts of the JID.

                 $to    = $Pres->GetTo();
                 $toJID = $Pres->GetTo("jid");

  GetFrom()      - returns the value in the from='' attribute for the
  GetFrom("jid")   <presence/>.  If you specify "jid" as an argument
                   then a Net::Jabber::JID object is returned and
                   you can easily parse the parts of the JID.

                   $from    = $Pres->GetFrom();
                   $fromJID = $Pres->GetFrom("jid");

  GetType() - returns the type='' attribute of the <presence/>.  Each
              presence is one of seven types:

                available       available to receive messages; default
                unavailable     unavailable to receive anything
                subscribe       ask the recipient to subscribe you
                subscribed      tell the sender they are subscribed
                unsubscribe     ask the recipient to unsubscribe you
                unsubscribed    tell the sender they are unsubscribed
                probe           probe

              $type = $Pres->GetType();

  GetStatus() - returns a string with the current status of the resource.

                $status = $Pres->GetStatus();

  GetPriority() - returns an integer with the priority of the resource
                  The default is 0 if there is no priority in this
                  presence.

                  $priority = $Pres->GetPriority();

  GetShow() - returns a string with the state the client should show.

              $show = $Pres->GetShow();

=head2 Creation functions

  SetPresence(to=>string|JID     - set multiple fields in the <presence/>
              from=>string|JID,    at one time.  This is a cumulative
              type=>string,        and over writing action.  If you set
              status=>string,      the "to" attribute twice, the second
              priority=>integer,   setting is what is used.  If you set
              meta=>string,        the status, and then set the priority
              icon=>string,        then both will be in the <presence/>
              show=>string,        tag.  For valid settings read the
              loc=>string)         specific Set functions below.

                        $Pres->SetPresence(TYPE=>"away",
					   StatuS=>"Out for lunch");

  SetTo(string) - sets the to attribute.  You can either pass a string
  SetTo(JID)      or a JID object.  They must be valid Jabber 
                  Identifiers or the server will return an error message.
                  (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

                  $Pres->SetTo("bob\@jabber.org");

  SetFrom(string) - sets the from='' attribute.  You can either pass
  SetFrom(JID)      a string or a JID object.  They must be valid Jabber
                    Identifiers or the server will return an error
                    message. (ie.  jabber:bob@jabber.org/Work)
                    This field is not required if you are writing a
                    Client since the server will put the JID of your
                    connection in there to prevent spamming.

                    $Pres->SetFrom("jojo\@jabber.org");

  SetType(string) - sets the type attribute.  Valid settings are:

                    available      available to receive messages; default
                    unavailable    unavailable to receive anything
                    subscribe      ask the recipient to subscribe you
                    subscribed     tell the sender they are subscribed
                    unsubscribe    ask the recipient to unsubscribe you
                    unsubscribed   tell the sender they are unsubscribed
                    probe          probe

                    $Pres->SetType("unavailable");

  SetStatus(string) - sets the status tag to be whatever string the user
                      wants associated with that resource.

                      $Pres->SetStatus("Taking a nap");

  SetPriority(integer) - sets the priority of this resource.  The highest
                         resource attached to the jabber account is the
                         one that receives the messages.

                         $Pres->SetPriority(10);

  SetShow(string) - sets the name of the icon or string to display for
                    this resource.

                    $Pres->SetShow("away");

  Reply(hash) - creates a new Presence object and populates the to/from
                fields.  If you specify a hash the same as with SetPresence
                then those values will override the Reply values.

                $Reply = $Pres->Reply();
                $Reply = $Pres->Reply(type=>"subscribed");

=head2 Test functions

  DefinedTo() - returns 1 if the to attribute is defined in the
                <presence/>, 0 otherwise.

                $test = $Pres->DefinedTo();

  DefinedFrom() - returns 1 if the from attribute is defined in the
                  <presence/>, 0 otherwise.

                  $test = $Pres->DefinedFrom();

  DefinedType() - returns 1 if the type attribute is defined in the
                  <presence/>, 0 otherwise.

                   $test = $Pres->DefinedType();

  DefinedStatus() - returns 1 if <status/> is defined in the
                    <presence/>, 0 otherwise.

                    $test = $Pres->DefinedStatus();

  DefinedPriority() - returns 1 if <priority/> is defined in the
                      <presence/>, 0 otherwise.

                      $test = $Pres->DefinedPriority();

  DefinedShow() - returns 1 if <show/> is defined in the <presence/>,
                  0 otherwise.

                  $test = $Pres->DefinedShow();

=head1 AUTHOR

By Ryan Eatmon in May of 2001 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.26";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };

  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  $self->{DEBUGHEADER} = "Presence";

  $self->{DATA} = {};
  $self->{CHILDREN} = {};

  $self->{TAG} = "presence";

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::Presence") {
      return $_[0];
    } else {
      $self->{TREE} = shift;
      $self->ParseTree();
      delete($self->{TREE});
    }
  }

  return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the main AutoLoad function in Jabber.pm
#
##############################################################################
sub AUTOLOAD {
  my $self = shift;
  &Net::Jabber::AutoLoad($self,$AUTOLOAD,@_);
}

$FUNCTIONS{Error}->{Get}        = "error";
$FUNCTIONS{Error}->{Set}        = ["scalar","error"];
$FUNCTIONS{Error}->{Defined}    = "error";
$FUNCTIONS{Error}->{Hash}       = "child-data";

$FUNCTIONS{ErrorCode}->{Get}        = "errorcode";
$FUNCTIONS{ErrorCode}->{Set}        = ["scalar","errorcode"];
$FUNCTIONS{ErrorCode}->{Defined}    = "errorcode";
$FUNCTIONS{ErrorCode}->{Hash}       = "att-error-code";

$FUNCTIONS{From}->{Get}        = "from";
$FUNCTIONS{From}->{Set}        = ["jid","from"];
$FUNCTIONS{From}->{Defined}    = "from";
$FUNCTIONS{From}->{Hash}       = "att";

$FUNCTIONS{ID}->{Get}        = "id";
$FUNCTIONS{ID}->{Set}        = ["scalar","id"];
$FUNCTIONS{ID}->{Defined}    = "id";
$FUNCTIONS{ID}->{Hash}       = "att";

$FUNCTIONS{Priority}->{Get}        = "priority";
$FUNCTIONS{Priority}->{Set}        = ["scalar","priority"];
$FUNCTIONS{Priority}->{Defined}    = "priority";
$FUNCTIONS{Priority}->{Hash}       = "child-data";

$FUNCTIONS{Show}->{Get}        = "show";
$FUNCTIONS{Show}->{Set}        = ["scalar","show"];
$FUNCTIONS{Show}->{Defined}    = "show";
$FUNCTIONS{Show}->{Hash}       = "child-data";

$FUNCTIONS{Status}->{Get}        = "status";
$FUNCTIONS{Status}->{Set}        = ["scalar","status"];
$FUNCTIONS{Status}->{Defined}    = "status";
$FUNCTIONS{Status}->{Hash}       = "child-data";

$FUNCTIONS{To}->{Get}        = "to";
$FUNCTIONS{To}->{Set}        = ["jid","to"];
$FUNCTIONS{To}->{Defined}    = "to";
$FUNCTIONS{To}->{Hash}       = "att";

$FUNCTIONS{Type}->{Get}        = "type";
$FUNCTIONS{Type}->{Set}        = ["scalar","type"];
$FUNCTIONS{Type}->{Defined}    = "type";
$FUNCTIONS{Type}->{Hash}       = "att";

$FUNCTIONS{X}->{Get}     = "__netjabber__:children:x";
$FUNCTIONS{X}->{Defined} = "__netjabber__:children:x";

$FUNCTIONS{Presence}->{Get} = "__netjabber__:master";
$FUNCTIONS{Presence}->{Set} = ["master"];

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

  $reply->SetPresence((($self->GetFrom() ne "") ?
		       (to=>$self->GetFrom()) :
		       ()
		      ),
		      (($self->GetTo() ne "") ?
		       (from=>$self->GetTo()) :
		       ()
		      ),
		     );

  $reply->SetPresence(%args);

  return $reply;
}


1;
