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

package Net::Jabber::X;

=head1 NAME

Net::Jabber::X - Jabber X Module

=head1 SYNOPSIS

  Net::Jabber::X is a companion to the Net::Jabber module. It
  provides the user a simple interface to set and retrieve all
  parts of a Jabber X.

=head1 DESCRIPTION

  Net::Jabber::X differs from the other modules in that its behavior
  and available functions are based off of the XML namespace that is
  set in it.  The current supported namespaces are:

    jabber:x:autoupdate
    jabber:x:conference
    jabber:x:data
    jabber:x:delay
    jabber:x:encrypted
    jabber:x:event
    jabber:x:expire
    jabber:x:oob
    jabber:x:roster
    jabber:x:signed
    http://jabber.org/protocol/muc
    http://jabber.org/protocol/muc#user

  For more information on what these namespaces are for, visit
  http://www.jabber.org and browse the Jabber Programmers Guide.

  Each of these namespaces provide Net::Jabber::X with the functions
  to access the data.  By using the AUTOLOAD function the functions for
  each namespace is used when that namespace is active.

  To access a X object you must create an object and use the
  access functions there to get to the X.  To initialize the object with
  a Jabber packet you must pass it the XML::Stream hash from the
  Net::Jabber::Client module.

    my $mess = new Net::Jabber::Message(%hash);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above yourself, a Net::Jabber
  object is passed to the callback function for the message.  Also,
  the first argument to the callback functions is the session ID from
  XML::Streams.  There are some cases where you might want this
  information, like if you created a Client that connects to two servers
  at once, or for writing a mini server.

    use Net::Jabber qw(Client);

    sub messageCB {
      my ($Mess) = @_;
      my $x = $Mess->GetX("jabber:x:delay");
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new x to send to the server:

    use Net::Jabber qw(Client);

    my $message = new Net::Jabber::Message();
    my $x = $message->NewX("jabber:x:oob");

  Now you can call the creation functions for the X as defined in the
  proper namespace.  See below for the general <x/> functions broken down
  by namespace.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head1 METHODS

=head2 Generic Retrieval functions

  GetXMLNS() - returns a string with the namespace of the packet that
               the <x/> contains.

               $xmlns = $X->GetXMLNS();

  GetX(string) - since the behavior of this module depends on the
                 namespace, an X object may contain X objects. This
                 helps to leverage code reuse by making children
                 behave in the same manner.  More than likely this
                 function will never be called.

                 @x = GetX();
                 @x = GetX("jabber:x:delay");

=head2 Generic Creation functions

  SetXMLNS(string) - sets the xmlns of the <x/> to the string.

                     $X->SetXMLNS("jabber:x:delay");


In an effort to make maintaining this document easier, I am not going
to go into full detail on each of these functions.  Rather I will
present the functions in a list with a type in the first column to
show what they return, or take as arugments.  Here is the list of
types I will use:

  string  - just a string
  array   - array of strings
  flag    - this means that the specified child exists in the
            XML <child/> and acts like a flag.  get will return
            0 or 1.
  JID     - either a string or Net::Jabber::JID object.
  objects - creates new objects, or returns an array of
            objects.
  special - this is a special case kind of function.  Usually
            just by calling Set() with no arguments it will
            default the value to a special value, like OS or time.
            Sometimes it will modify the value you set, like
            in jabber:iq:version SetVersion() the function
            adds on the Net::Jabber version to the string
            just for advertisement purposes. =)
  master  - this desribes a function that behaves like the
            SetMessage() function in Net::Jabber::Message.
            It takes a hash and sets all of the values defined,
            and the Set returns a hash with the values that
            are defined in the object.

=head1 jabber:x:autoupdate

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  JID      GetJID()          SetJID()          DefinedJID()
  master   GetAutoupdate()   SetAutoupdate()

=head1 jabber:x:conference

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  JID      GetJID()          SetJID()          DefinedJID()
  master   GetConference()   SetConference()

=head1 jabber:x:data

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetInstructions() SetInstructions() DefinedInstructions()
  master   GetForm()         SetForm()
  objects                    AddField()
  objects                    AddReported()
  objects  GetFields()
  objects  GetReported()

=head1 jabber:x:data - field objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetDesc()         SetDesc()         DefinedDesc()
  string   GetLabel()        SetLabel()        DefinedLabel()
  string   GetType()         SetType()         DefinedType()
  string   GetValue()        SetValue()        DefinedValue()
  string   GetVar()          SetVar()          DefinedVar()
  master   GetField()        SetField()
  objects                    AddOption()
  objects  GetOptions()

=head1 jabber:x:data - reported field objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetFields()

=head1 jabber:x:data - field option objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetLabel()        SetLabel()        DefinedLabel()
  string   GetValue()        SetValue()        DefinedValue()
  master   GetOption()       SetOption()

=head1 jabber:x:delay

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  JID      GetFrom()         SetFrom()         DefinedFrom()
  string   GetMessage()      SetMessage()      DefinedMessage()
  string   GetStamp()        SetStamp()        DefinedStamp()
  master   GetDelay()        SetDelay()

=head1 jabber:x:encrypted

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetMessage()      SetMessage()      DefinedMessage()
  master   GetEncrypted()    SetEncrypted()

=head1 jabber:x:event

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  flag     GetComposing()    SetComposing()    DefinedComposing()
  flag     GetDelivered()    SetDelivered()    DefinedDelivered()
  flag     GetDisplayed()    SetDisplayed()    DefinedDisplayed()
  string   GetID()           SetID()           DefinedID()
  flag     GetOffline()      SetOffline()      DefinedOffline()
  master   GetEvent()        SetEvent()

=head1 jabber:x:expire

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetSeconds()      SetSeconds()      DefinedSeconds()
  master   GetExpire()       SetExpire()

=head1 jabber:x:oob

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetDesc()         SetDesc()         DefinedDesc()
  string   GetURL()          SetURL()          DefinedURL()
  master   GetOob()          SetOob()

=head1 jabber:x:roster

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects                    AddItem()
  objects  GetItems()

=head1 jabber:x:roster - item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  array    GetGroup()        SetGroup()        DefinedGroup()
  JID      GetJID()          SetJID()          DefinedJID()
  string   GetName()         SetName()         DefinedName()
  master   GetItem()         SetItem()

=head1 jabber:x:signed

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetSignature()    SetSignature()    DefinedSignature()
  master   GetSigned()       SetSigned()

=head1 http://jabber.org/protocol/muc

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetPassword()     SetPassword()     DefinedPassword()
  master   GetMUC()          SetMUC()

=head1 http://jabber.org/protocol/muc#user

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetAlt()          SetAlt()          DefinedAlt() 
  string   GetPassword()     SetPassword()     DefinedPassword()
  string   GetStatusCode()   SetStatusCode()   DefinedStatusCode()
  objects  GetInvite()       AddInvite()                     
  objects  GetItem()         AddItem()                       
  master   GetUser()         SetUser()

=head1 http://jabber.org/protocol/muc#user - invite objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  jid      GetFrom()         SetFrom()         DefinedFrom()
  string   GetReason()       SetReason()       DefinedReason()
  jid      GetTo()           SetTo()           DefinedTo()
  master   GetInvite()       SetInvite()

=head1 http://jabber.org/protocol/muc#user - item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  jid      GetActorJID()     SetActorJID()     DefinedActorJID()
  string   GetAffiliation()  SetAffiliation()  DefinedAffiliation()
  jid      GetJID()          SetJID()          DefinedJID()
  string   GetNick()         SetNick()         DefinedNick()  
  string   GetReason()       SetReason()       DefinedReason()
  string   GetRole()         SetRole()         DefinedRole()  
  master   GetItem()         SetItem()  

=head1 CUSTOM NAMESPACES

  Part of the flexability of this module is that you can define your own
  namespace.  For more information on this topic, please read the
  Net::Jabber::Namespaces man page.

=head1 AUTHOR

By Ryan Eatmon in May of 2001 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.006_001;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS %NAMESPACES);

$VERSION = "1.30";

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = { };

    $self->{VERSION} = $VERSION;

    bless($self, $proto);

    $self->{DEBUGHEADER} = "X";

    $self->{DATA} = {};
    $self->{CHILDREN} = {};

    $self->{TAG} = "x";

    if ("@_" ne (""))
    {
        if (ref($_[0]) eq "Net::Jabber::X")
        {
            return $_[0];
        }
        else
        {
            $self->{TREE} = shift;
            $self->{TAG} = $self->{TREE}->get_tag();
            $self->ParseXMLNS();
            $self->ParseTree();
        }
    }
    else
    {
        $self->{TREE} = new XML::Stream::Node($self->{TAG});
    }

    return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the main AutoLoad function in Jabber.pm
#
##############################################################################
sub AUTOLOAD
{
    my $self = shift;
    &Net::Jabber::AutoLoad($self,$AUTOLOAD,@_);
}

#$FUNCTIONS{XMLNS}->{XPath}->{Type}  = 'scalar';
$FUNCTIONS{XMLNS}->{XPath}->{Path}  = '@xmlns';
#$FUNCTIONS{XMLNS}->{XPath}->{Calls} = ['Get','Set','Define'];

$FUNCTIONS{X}->{XPath}->{Type}  = 'node';
$FUNCTIONS{X}->{XPath}->{Path}  = '*[@xmlns]';
$FUNCTIONS{X}->{XPath}->{Child} = 'X';
$FUNCTIONS{X}->{XPath}->{Calls} = ['Get','Defined'];

my $ns;

#-----------------------------------------------------------------------------
# jabber:x:autoupdate
#-----------------------------------------------------------------------------
$ns = "jabber:x:autoupdate";

$NAMESPACES{$ns}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{$ns}->{Autoupdate}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:conference
#-----------------------------------------------------------------------------
$ns = "jabber:x:conference";

$NAMESPACES{$ns}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{$ns}->{Conference}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:x:data
#-----------------------------------------------------------------------------
$ns = "jabber:x:data";

$NAMESPACES{$ns}->{Instructions}->{XPath}->{Path}  = 'instructions/text()';

$NAMESPACES{$ns}->{Form}->{XPath}->{Type}  = 'master';

$NAMESPACES{$ns}->{Field}->{XPath}->{Type}  = 'node';
$NAMESPACES{$ns}->{Field}->{XPath}->{Path}  = 'field';
$NAMESPACES{$ns}->{Field}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{$ns}->{Field}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Fields}->{XPath}->{Type}  = 'children';
$NAMESPACES{$ns}->{Fields}->{XPath}->{Path}  = 'field';
$NAMESPACES{$ns}->{Fields}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{$ns}->{Fields}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{$ns}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path}  = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['X','__netjabber__:x:data:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path}  = 'item';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['X','__netjabber__:x:data:item'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{$ns}->{Reported}->{XPath}->{Type}  = 'children';
$NAMESPACES{$ns}->{Reported}->{XPath}->{Path}  = 'reported';
$NAMESPACES{$ns}->{Reported}->{XPath}->{Child} = ['X','__netjabber__:x:data:reported'];
$NAMESPACES{$ns}->{Reported}->{XPath}->{Calls} = ['Add','Get','Defined'];

$NAMESPACES{$ns}->{Title}->{XPath}->{Path}  = 'title/text()';

$NAMESPACES{$ns}->{Type}->{XPath}->{Path}  = '@type';

$NAMESPACES{$ns}->{Data}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:x:data:item
#-----------------------------------------------------------------------------
$ns = "__netjabber__:x:data:item";

$NAMESPACES{$ns}->{Field}->{XPath}->{Type}  = 'node';
$NAMESPACES{$ns}->{Field}->{XPath}->{Path}  = 'field';
$NAMESPACES{$ns}->{Field}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{$ns}->{Field}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Fields}->{XPath}->{Type}  = 'children';
$NAMESPACES{$ns}->{Fields}->{XPath}->{Path}  = 'field';
$NAMESPACES{$ns}->{Fields}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{$ns}->{Fields}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:reported
#-----------------------------------------------------------------------------
$ns = "__netjabber__:x:data:reported";

$NAMESPACES{$ns}->{Field}->{XPath}->{Type}  = 'node';
$NAMESPACES{$ns}->{Field}->{XPath}->{Path}  = 'field';
$NAMESPACES{$ns}->{Field}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{$ns}->{Field}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Fields}->{XPath}->{Type}  = 'children';
$NAMESPACES{$ns}->{Fields}->{XPath}->{Path}  = 'field';
$NAMESPACES{$ns}->{Fields}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{$ns}->{Fields}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:field
#-----------------------------------------------------------------------------
$ns = "__netjabber__:x:data:field";

$NAMESPACES{$ns}->{Desc}->{XPath}->{Path}  = 'desc/text()';

$NAMESPACES{$ns}->{Label}->{XPath}->{Path}  = '@label';

$NAMESPACES{$ns}->{Required}->{XPath}->{Type}  = 'flag';
$NAMESPACES{$ns}->{Required}->{XPath}->{Path}  = 'required';

$NAMESPACES{$ns}->{Type}->{XPath}->{Path}  = '@type';

$NAMESPACES{$ns}->{Value}->{XPath}->{Type}  = 'array';
$NAMESPACES{$ns}->{Value}->{XPath}->{Path}  = 'value/text()';

$NAMESPACES{$ns}->{Var}->{XPath}->{Path}  = '@var';

$NAMESPACES{$ns}->{Field}->{XPath}->{Type}  = 'master';

$NAMESPACES{$ns}->{Option}->{XPath}->{Type}  = 'node';
$NAMESPACES{$ns}->{Option}->{XPath}->{Path}  = 'option';
$NAMESPACES{$ns}->{Option}->{XPath}->{Child} = ['X','__netjabber__:x:data:field:option'];
$NAMESPACES{$ns}->{Option}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Options}->{XPath}->{Type}  = 'children';
$NAMESPACES{$ns}->{Options}->{XPath}->{Path}  = 'option';
$NAMESPACES{$ns}->{Options}->{XPath}->{Child} = ['X','__netjabber__:x:data:field:option'];
$NAMESPACES{$ns}->{Options}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:field:option
#-----------------------------------------------------------------------------
$ns = "__netjabber__:x:data:field:option";

$NAMESPACES{$ns}->{Label}->{XPath}->{Path}  = '@label';

$NAMESPACES{$ns}->{Value}->{XPath}->{Path}  = 'value/text()';

$NAMESPACES{$ns}->{Option}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:delay
#-----------------------------------------------------------------------------
$ns = "jabber:x:delay";

$NAMESPACES{$ns}->{From}->{XPath}->{Type}  = 'jid';
$NAMESPACES{$ns}->{From}->{XPath}->{Path}  = '@from';

$NAMESPACES{$ns}->{Message}->{XPath}->{Path}  = 'text()';

$NAMESPACES{$ns}->{Stamp}->{XPath}->{Type} = 'timestamp';
$NAMESPACES{$ns}->{Stamp}->{XPath}->{Path} = '@stamp';

$NAMESPACES{$ns}->{Delay}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:encrypted
#-----------------------------------------------------------------------------
$ns = "jabber:x:encrypted";

$NAMESPACES{$ns}->{Message}->{XPath}->{Path}  = 'text()';

$NAMESPACES{$ns}->{Encrypted}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:event
#-----------------------------------------------------------------------------
$ns = "jabber:x:event";

$NAMESPACES{$ns}->{Composing}->{XPath}->{Type}  = 'flag';
$NAMESPACES{$ns}->{Composing}->{XPath}->{Path}  = 'composing';

$NAMESPACES{$ns}->{Delivered}->{XPath}->{Type}  = 'flag';
$NAMESPACES{$ns}->{Delivered}->{XPath}->{Path}  = 'delivered';

$NAMESPACES{$ns}->{Displayed}->{XPath}->{Type}  = 'flag';
$NAMESPACES{$ns}->{Displayed}->{XPath}->{Path}  = 'displayed';

$NAMESPACES{$ns}->{ID}->{XPath}->{Type}  = 'scalar';
$NAMESPACES{$ns}->{ID}->{XPath}->{Path}  = 'id/text()';

$NAMESPACES{$ns}->{Offline}->{XPath}->{Type}  = 'flag';
$NAMESPACES{$ns}->{Offline}->{XPath}->{Path}  = 'offline';

$NAMESPACES{$ns}->{Event}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:expire
#-----------------------------------------------------------------------------
$ns = "jabber:x:expire";

$NAMESPACES{$ns}->{Seconds}->{XPath}->{Path}  = '@seconds';

$NAMESPACES{$ns}->{Expire}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:oob
#-----------------------------------------------------------------------------
$ns = "jabber:x:oob";

$NAMESPACES{$ns}->{Desc}->{XPath}->{Path}  = 'desc/text()';

$NAMESPACES{$ns}->{URL}->{XPath}->{Path}  = 'url/text()';

$NAMESPACES{$ns}->{Oob}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:roster
#-----------------------------------------------------------------------------
$ns = "jabber:x:roster";

$NAMESPACES{$ns}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path}  = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['X','__netjabber__:x:roster:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path}  = 'item';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['X','__netjabber__:x:roster:item'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:roster:item
#-----------------------------------------------------------------------------
$ns = "__netjabber__:x:roster:item";

$NAMESPACES{$ns}->{Group}->{XPath}->{Type}  = 'array';
$NAMESPACES{$ns}->{Group}->{XPath}->{Path}  = 'group/text()';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path}  = '@name';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:signed
#-----------------------------------------------------------------------------
$ns = "jabber:x:signed";

$NAMESPACES{$ns}->{Signature}->{XPath}->{Path}  = 'text()';

$NAMESPACES{$ns}->{Signed}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/muc
#-----------------------------------------------------------------------------
$ns = "http://jabber.org/protocol/muc";

$NAMESPACES{$ns}->{Password}->{XPath}->{Path} = "password/text()";

$NAMESPACES{$ns}->{MUC}->{XPath}->{Type} = "master";

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/muc#user
#-----------------------------------------------------------------------------
$ns = "http://jabber.org/protocol/muc#user";

$NAMESPACES{$ns}->{Alt}->{XPath}->{Path} = 'alt/text()';

$NAMESPACES{$ns}->{Invite}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Invite}->{XPath}->{Path} = 'invite';
$NAMESPACES{$ns}->{Invite}->{XPath}->{Child} = ['X','__netjabber__:x:muc:invite'];
$NAMESPACES{$ns}->{Invite}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['X','__netjabber__:x:muc:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Password}->{XPath}->{Path} = 'password/text()';

$NAMESPACES{$ns}->{StatusCode}->{XPath}->{Path} = 'status/@code';

$NAMESPACES{$ns}->{User}->{XPath}->{Type} = "master";

#-----------------------------------------------------------------------------
# __netjabber__:x:muc:invite
#-----------------------------------------------------------------------------
$ns = "__netjabber__:x:muc:invite";

$NAMESPACES{$ns}->{From}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{From}->{XPath}->{Path} = '@from';

$NAMESPACES{$ns}->{Reason}->{XPath}->{Path} = 'reason/text()';

$NAMESPACES{$ns}->{To}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{To}->{XPath}->{Path} = '@to';

$NAMESPACES{$ns}->{Invite}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:x:muc:item
#-----------------------------------------------------------------------------
$ns = "__netjabber__:x:muc:item";

$NAMESPACES{$ns}->{ActorJID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{ActorJID}->{XPath}->{Path} = 'actor/@jid';

$NAMESPACES{$ns}->{Affiliation}->{XPath}->{Path} = '@affiliation';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Nick}->{XPath}->{Path} = '@nick';

$NAMESPACES{$ns}->{Reason}->{XPath}->{Path} = 'reason/text()';

$NAMESPACES{$ns}->{Role}->{XPath}->{Path} = '@role';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'master';


1;
