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
  set in it.  The current list of supported namespaces is:

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
    jabber:x:sxpm

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

=head1 jabber:x:sxpm

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetData()         SetData()         DefinedData()
  string   GetDataWidth()    SetDataWidth()    DefinedDataWidth()
  string   GetDataX()        SetDataX()        DefinedDataX()
  string   GetDataY()        SetDataY()        DefinedDataY()
  string   GetBoard()        SetBoard()        DefinedBoard()
  string   GetBoardHeight()  SetBoardHeight()  DefinedBoardHeight()
  string   GetBoardWidth()   SetBoardWidth()   DefinedBoardWidth()
  master   GetSXPM()         SetSXPM()
  objects                    AddMap()
  objects  GetMaps()

=head1 jabber:x:sxpm - map objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetChar()         SetChar()         DefinedChar()
  string   GetColor()        SetColor()        DefinedColor()
  master   GetMap()          SetMap()


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

$VERSION = "1.27";

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

#-----------------------------------------------------------------------------
# jabber:x:autoupdate
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:autoupdate"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"jabber:x:autoupdate"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"jabber:x:autoupdate"}->{Autoupdate}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:conference
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:conference"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"jabber:x:conference"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"jabber:x:conference"}->{Conference}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:x:data
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:data"}->{Instructions}->{XPath}->{Path}  = 'instructions/text()';

$NAMESPACES{"jabber:x:data"}->{Form}->{XPath}->{Type}  = 'master';

$NAMESPACES{"jabber:x:data"}->{Field}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:x:data"}->{Field}->{XPath}->{Path}  = 'field';
$NAMESPACES{"jabber:x:data"}->{Field}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{"jabber:x:data"}->{Field}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:x:data"}->{Fields}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:x:data"}->{Fields}->{XPath}->{Path}  = 'field';
$NAMESPACES{"jabber:x:data"}->{Fields}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{"jabber:x:data"}->{Fields}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{"jabber:x:data"}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:x:data"}->{Item}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:x:data"}->{Item}->{XPath}->{Child} = ['X','__netjabber__:x:data:item'];
$NAMESPACES{"jabber:x:data"}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:x:data"}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:x:data"}->{Items}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:x:data"}->{Items}->{XPath}->{Child} = ['X','__netjabber__:x:data:item'];
$NAMESPACES{"jabber:x:data"}->{Items}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{"jabber:x:data"}->{Reported}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:x:data"}->{Reported}->{XPath}->{Path}  = 'reported';
$NAMESPACES{"jabber:x:data"}->{Reported}->{XPath}->{Child} = ['X','__netjabber__:x:data:reported'];
$NAMESPACES{"jabber:x:data"}->{Reported}->{XPath}->{Calls} = ['Add','Get','Defined'];

$NAMESPACES{"jabber:x:data"}->{Title}->{XPath}->{Path}  = 'title/text()';

$NAMESPACES{"jabber:x:data"}->{Type}->{XPath}->{Path}  = '@type';

$NAMESPACES{"jabber:x:data"}->{Data}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:x:data:item
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:data:item"}->{Field}->{XPath}->{Type}  = 'node';
$NAMESPACES{"__netjabber__:x:data:item"}->{Field}->{XPath}->{Path}  = 'field';
$NAMESPACES{"__netjabber__:x:data:item"}->{Field}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{"__netjabber__:x:data:item"}->{Field}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"__netjabber__:x:data:item"}->{Fields}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:x:data:item"}->{Fields}->{XPath}->{Path}  = 'field';
$NAMESPACES{"__netjabber__:x:data:item"}->{Fields}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{"__netjabber__:x:data:item"}->{Fields}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:reported
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{XPath}->{Type}  = 'node';
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{XPath}->{Path}  = 'field';
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"__netjabber__:x:data:reported"}->{Fields}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:x:data:reported"}->{Fields}->{XPath}->{Path}  = 'field';
$NAMESPACES{"__netjabber__:x:data:reported"}->{Fields}->{XPath}->{Child} = ['X','__netjabber__:x:data:field'];
$NAMESPACES{"__netjabber__:x:data:reported"}->{Fields}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:field
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:data:field"}->{Desc}->{XPath}->{Path}  = 'desc/text()';

$NAMESPACES{"__netjabber__:x:data:field"}->{Label}->{XPath}->{Path}  = '@label';

$NAMESPACES{"__netjabber__:x:data:field"}->{Required}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"__netjabber__:x:data:field"}->{Required}->{XPath}->{Path}  = 'required';

$NAMESPACES{"__netjabber__:x:data:field"}->{Type}->{XPath}->{Path}  = '@type';

$NAMESPACES{"__netjabber__:x:data:field"}->{Value}->{XPath}->{Type}  = 'array';
$NAMESPACES{"__netjabber__:x:data:field"}->{Value}->{XPath}->{Path}  = 'value/text()';

$NAMESPACES{"__netjabber__:x:data:field"}->{Var}->{XPath}->{Path}  = '@var';

$NAMESPACES{"__netjabber__:x:data:field"}->{Field}->{XPath}->{Type}  = 'master';

$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{XPath}->{Type}  = 'node';
$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{XPath}->{Path}  = 'option';
$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{XPath}->{Child} = ['X','__netjabber__:x:data:field:option'];
$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"__netjabber__:x:data:field"}->{Options}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:x:data:field"}->{Options}->{XPath}->{Path}  = 'option';
$NAMESPACES{"__netjabber__:x:data:field"}->{Options}->{XPath}->{Child} = ['X','__netjabber__:x:data:field:option'];
$NAMESPACES{"__netjabber__:x:data:field"}->{Options}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:field:option
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Label}->{XPath}->{Path}  = '@label';

$NAMESPACES{"__netjabber__:x:data:field:option"}->{Value}->{XPath}->{Path}  = 'value/text()';

$NAMESPACES{"__netjabber__:x:data:field:option"}->{Option}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:delay
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:delay"}->{From}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"jabber:x:delay"}->{From}->{XPath}->{Path}  = '@from';

$NAMESPACES{"jabber:x:delay"}->{Message}->{XPath}->{Path}  = 'text()';

$NAMESPACES{"jabber:x:delay"}->{Stamp}->{XPath}->{Type} = 'timestamp';
$NAMESPACES{"jabber:x:delay"}->{Stamp}->{XPath}->{Path} = '@stamp';

$NAMESPACES{"jabber:x:delay"}->{Delay}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:encrypted
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:encrypted"}->{Message}->{XPath}->{Path}  = 'text()';

$NAMESPACES{"jabber:x:encrypted"}->{Encrypted}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:event
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:event"}->{Composing}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:x:event"}->{Composing}->{XPath}->{Path}  = 'composing';

$NAMESPACES{"jabber:x:event"}->{Delivered}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:x:event"}->{Delivered}->{XPath}->{Path}  = 'delivered';

$NAMESPACES{"jabber:x:event"}->{Displayed}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:x:event"}->{Displayed}->{XPath}->{Path}  = 'displayed';

$NAMESPACES{"jabber:x:event"}->{ID}->{XPath}->{Type}  = 'scalar';
$NAMESPACES{"jabber:x:event"}->{ID}->{XPath}->{Path}  = 'id/text()';

$NAMESPACES{"jabber:x:event"}->{Offline}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:x:event"}->{Offline}->{XPath}->{Path}  = 'offline';

$NAMESPACES{"jabber:x:event"}->{Event}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:expire
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:expire"}->{Seconds}->{XPath}->{Path}  = '@seconds';

$NAMESPACES{"jabber:x:expire"}->{Expire}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:oob
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:oob"}->{Desc}->{XPath}->{Path}  = 'desc/text()';

$NAMESPACES{"jabber:x:oob"}->{URL}->{XPath}->{Path}  = 'url/text()';

$NAMESPACES{"jabber:x:oob"}->{Oob}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:roster
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:roster"}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:x:roster"}->{Item}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:x:roster"}->{Item}->{XPath}->{Child} = ['X','__netjabber__:x:roster:item'];
$NAMESPACES{"jabber:x:roster"}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:x:roster"}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:x:roster"}->{Items}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:x:roster"}->{Items}->{XPath}->{Child} = ['X','__netjabber__:x:roster:item'];
$NAMESPACES{"jabber:x:roster"}->{Items}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:roster:item
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:roster:item"}->{Group}->{XPath}->{Type}  = 'array';
$NAMESPACES{"__netjabber__:x:roster:item"}->{Group}->{XPath}->{Path}  = 'group/text()';

$NAMESPACES{"__netjabber__:x:roster:item"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"__netjabber__:x:roster:item"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"__netjabber__:x:roster:item"}->{Name}->{XPath}->{Path}  = '@name';

$NAMESPACES{"__netjabber__:x:roster:item"}->{Item}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:signed
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:signed"}->{Signature}->{XPath}->{Path}  = 'text()';

$NAMESPACES{"jabber:x:signed"}->{Signed}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:x:sxpm
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:sxpm"}->{Data}->{XPath}->{Path}  = 'data/text()';

$NAMESPACES{"jabber:x:sxpm"}->{DataWidth}->{XPath}->{Path}  = 'data/@width';

$NAMESPACES{"jabber:x:sxpm"}->{DataX}->{XPath}->{Path}  = 'data/@x';

$NAMESPACES{"jabber:x:sxpm"}->{DataY}->{XPath}->{Path}  = 'data/@y';

$NAMESPACES{"jabber:x:sxpm"}->{Board}->{XPath}->{Path}  = 'board/text()';

$NAMESPACES{"jabber:x:sxpm"}->{BoardHeight}->{XPath}->{Path}  = 'board/@height';

$NAMESPACES{"jabber:x:sxpm"}->{BoardWidth}->{XPath}->{Path}  = 'board/@width';

$NAMESPACES{"jabber:x:sxpm"}->{SXPM}->{XPath}->{Type}  = 'master';

$NAMESPACES{"jabber:x:sxpm"}->{Map}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:x:sxpm"}->{Map}->{XPath}->{Path}  = 'map';
$NAMESPACES{"jabber:x:sxpm"}->{Map}->{XPath}->{Child} = ['X','__netjabber__:x:sxpm:map'];
$NAMESPACES{"jabber:x:sxpm"}->{Map}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:x:sxpm"}->{Maps}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:x:sxpm"}->{Maps}->{XPath}->{Path}  = 'map';
$NAMESPACES{"jabber:x:sxpm"}->{Maps}->{XPath}->{Child} = ['X','__netjabber__:x:sxpm:map'];
$NAMESPACES{"jabber:x:sxpm"}->{Maps}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:x:sxpm:map
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Char}->{XPath}->{Path}  = '@char';

$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Color}->{XPath}->{Path}  = '@color';

$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Map}->{XPath}->{Type}  = 'master';

1;
