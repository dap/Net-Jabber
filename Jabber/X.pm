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

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS %NAMESPACES);

$VERSION = "1.26";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };

  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  $self->{DEBUGHEADER} = "X";

  $self->{DATA} = {};
  $self->{CHILDREN} = {};

  $self->{TAG} = "x";

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::X") {
      return $_[0];
    } else {
      $self->{TREE} = shift;
      $self->{TAG} = $self->{TREE}->{$self->{TREE}->{root}."-tag"};
      $self->ParseXMLNS();
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

$FUNCTIONS{XMLNS}->{Get}        = "xmlns";
$FUNCTIONS{XMLNS}->{Set}        = ["scalar","xmlns"];
$FUNCTIONS{XMLNS}->{Defined}    = "xmlns";
$FUNCTIONS{XMLNS}->{Hash}       = "att";

$FUNCTIONS{X}->{Get}     = "__netjabber__:children:x";
$FUNCTIONS{X}->{Defined} = "__netjabber__:children:x";

#-----------------------------------------------------------------------------
# jabber:x:autoupdate
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:autoupdate"}->{JID}->{Get}        = "jid";
$NAMESPACES{"jabber:x:autoupdate"}->{JID}->{Set}        = ["jid","jid"];
$NAMESPACES{"jabber:x:autoupdate"}->{JID}->{Defined}    = "jid";
$NAMESPACES{"jabber:x:autoupdate"}->{JID}->{Hash}       = "data";

$NAMESPACES{"jabber:x:autoupdate"}->{Autoupdate}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:autoupdate"}->{Autoupdate}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:conference
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:conference"}->{JID}->{Get}        = "jid";
$NAMESPACES{"jabber:x:conference"}->{JID}->{Set}        = ["jid","jid"];
$NAMESPACES{"jabber:x:conference"}->{JID}->{Defined}    = "jid";
$NAMESPACES{"jabber:x:conference"}->{JID}->{Hash}       = "att";

$NAMESPACES{"jabber:x:conference"}->{Conference}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:conference"}->{Conference}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:data
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:data"}->{Instructions}->{Get}     = "instructions";
$NAMESPACES{"jabber:x:data"}->{Instructions}->{Set}     = ["scalar","instructions"];
$NAMESPACES{"jabber:x:data"}->{Instructions}->{Defined} = "instructions";
$NAMESPACES{"jabber:x:data"}->{Instructions}->{Hash}    = "child-data";

$NAMESPACES{"jabber:x:data"}->{Form}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:data"}->{Form}->{Set} = ["master"];

$NAMESPACES{"jabber:x:data"}->{Field}->{Get}     = "";
$NAMESPACES{"jabber:x:data"}->{Field}->{Set}     = ["add","X","__netjabber__:x:data:field"];
$NAMESPACES{"jabber:x:data"}->{Field}->{Defined} = "x";
$NAMESPACES{"jabber:x:data"}->{Field}->{Hash}    = "child-add";
$NAMESPACES{"jabber:x:data"}->{Field}->{Add}     = ["X","__netjabber__:x:data:field","Field","field"];

$NAMESPACES{"jabber:x:data"}->{Fields}->{Get} = ["__netjabber__:children:x","__netjabber__:x:data:field"];

$NAMESPACES{"jabber:x:data"}->{Reported}->{Get}     = ["__netjabber__:children:x","__netjabber__:x:data:reported"];
$NAMESPACES{"jabber:x:data"}->{Reported}->{Set}     = ["add","X","__netjabber__:x:data:reported"];
$NAMESPACES{"jabber:x:data"}->{Reported}->{Defined} = "x";
$NAMESPACES{"jabber:x:data"}->{Reported}->{Hash}    = "child-add";

$NAMESPACES{"jabber:x:data"}->{Reported}->{Add}     = ["X","__netjabber__:x:data:reported","Reported","reported"];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:reported
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{Get}     = "";
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{Set}     = ["add","X","__netjabber__:x:data:field"];
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{Defined} = "x";
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:x:data:reported"}->{Field}->{Add}     = ["X","__netjabber__:x:data:field","Field","field"];

$NAMESPACES{"__netjabber__:x:data:reported"}->{Fields}->{Get} = ["__netjabber__:children:x","__netjabber__:x:data:field"];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:field
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:data:field"}->{Desc}->{Get}        = "desc";
$NAMESPACES{"__netjabber__:x:data:field"}->{Desc}->{Set}        = ["scalar","desc"];
$NAMESPACES{"__netjabber__:x:data:field"}->{Desc}->{Defined}    = "desc";
$NAMESPACES{"__netjabber__:x:data:field"}->{Desc}->{Hash}       = "child-data";

$NAMESPACES{"__netjabber__:x:data:field"}->{Label}->{Get}        = "label";
$NAMESPACES{"__netjabber__:x:data:field"}->{Label}->{Set}        = ["scalar","label"];
$NAMESPACES{"__netjabber__:x:data:field"}->{Label}->{Defined}    = "label";
$NAMESPACES{"__netjabber__:x:data:field"}->{Label}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:data:field"}->{Type}->{Get}        = "type";
$NAMESPACES{"__netjabber__:x:data:field"}->{Type}->{Set}        = ["scalar","type"];
$NAMESPACES{"__netjabber__:x:data:field"}->{Type}->{Defined}    = "type";
$NAMESPACES{"__netjabber__:x:data:field"}->{Type}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:data:field"}->{Value}->{Get}        = "value";
$NAMESPACES{"__netjabber__:x:data:field"}->{Value}->{Set}        = ["array","value"];
$NAMESPACES{"__netjabber__:x:data:field"}->{Value}->{Defined}    = "value";
$NAMESPACES{"__netjabber__:x:data:field"}->{Value}->{Hash}       = "child-data";
$NAMESPACES{"__netjabber__:x:data:field"}->{Value}->{Remove}     = "value";

$NAMESPACES{"__netjabber__:x:data:field"}->{Var}->{Get}        = "var";
$NAMESPACES{"__netjabber__:x:data:field"}->{Var}->{Set}        = ["scalar","var"];
$NAMESPACES{"__netjabber__:x:data:field"}->{Var}->{Defined}    = "var";
$NAMESPACES{"__netjabber__:x:data:field"}->{Var}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:data:field"}->{Field}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:x:data:field"}->{Field}->{Set} = ["master"];

$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{Get}        = "";
$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{Set}        = ["add","X","__netjabber__:x:data:field:option"];
$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{Defined}    = "x";
$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{Hash}       = "child-add";

$NAMESPACES{"__netjabber__:x:data:field"}->{Option}->{Add} = ["X","__netjabber__:x:data:field:option","Option","option"];

$NAMESPACES{"__netjabber__:x:data:field"}->{Options}->{Get} = ["__netjabber__:children:x","__netjabber__:x:data:field:option"];

#-----------------------------------------------------------------------------
# __netjabber__:x:data:field:option
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Label}->{Get}        = "label";
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Label}->{Set}        = ["scalar","label"];
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Label}->{Defined}    = "label";
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Label}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:data:field:option"}->{Value}->{Get}        = "value";
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Value}->{Set}        = ["scalar","value"];
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Value}->{Defined}    = "value";
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Value}->{Hash}       = "child-data";

$NAMESPACES{"__netjabber__:x:data:field:option"}->{Option}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:x:data:field:option"}->{Option}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:delay
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:delay"}->{From}->{Get}        = "from";
$NAMESPACES{"jabber:x:delay"}->{From}->{Set}        = ["jid","from"];
$NAMESPACES{"jabber:x:delay"}->{From}->{Defined}    = "from";
$NAMESPACES{"jabber:x:delay"}->{From}->{Hash}       = "att";

$NAMESPACES{"jabber:x:delay"}->{Message}->{Get}        = "message";
$NAMESPACES{"jabber:x:delay"}->{Message}->{Set}        = ["scalar","message"];
$NAMESPACES{"jabber:x:delay"}->{Message}->{Defined}    = "message";
$NAMESPACES{"jabber:x:delay"}->{Message}->{Hash}       = "data";

$NAMESPACES{"jabber:x:delay"}->{Stamp}->{Get}        = "stamp";
$NAMESPACES{"jabber:x:delay"}->{Stamp}->{Set}        = ["timestamp","stamp"];
$NAMESPACES{"jabber:x:delay"}->{Stamp}->{Defined}    = "stamp";
$NAMESPACES{"jabber:x:delay"}->{Stamp}->{Hash}       = "att";

$NAMESPACES{"jabber:x:delay"}->{Delay}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:delay"}->{Delay}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:encrypted
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:encrypted"}->{Message}->{Get}        = "message";
$NAMESPACES{"jabber:x:encrypted"}->{Message}->{Set}        = ["scalar","message"];
$NAMESPACES{"jabber:x:encrypted"}->{Message}->{Defined}    = "message";
$NAMESPACES{"jabber:x:encrypted"}->{Message}->{Hash}       = "data";

$NAMESPACES{"jabber:x:encrypted"}->{Encrypted}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:encrypted"}->{Encrypted}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:event
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:event"}->{Composing}->{Get}        = "composing";
$NAMESPACES{"jabber:x:event"}->{Composing}->{Set}        = ["flag","composing"];
$NAMESPACES{"jabber:x:event"}->{Composing}->{Defined}    = "composing";
$NAMESPACES{"jabber:x:event"}->{Composing}->{Hash}       = "child-flag";

$NAMESPACES{"jabber:x:event"}->{Delivered}->{Get}        = "delivered";
$NAMESPACES{"jabber:x:event"}->{Delivered}->{Set}        = ["flag","delivered"];
$NAMESPACES{"jabber:x:event"}->{Delivered}->{Defined}    = "delivered";
$NAMESPACES{"jabber:x:event"}->{Delivered}->{Hash}       = "child-flag";

$NAMESPACES{"jabber:x:event"}->{Displayed}->{Get}        = "displayed";
$NAMESPACES{"jabber:x:event"}->{Displayed}->{Set}        = ["flag","displayed"];
$NAMESPACES{"jabber:x:event"}->{Displayed}->{Defined}    = "displayed";
$NAMESPACES{"jabber:x:event"}->{Displayed}->{Hash}       = "child-flag";

$NAMESPACES{"jabber:x:event"}->{ID}->{Get}        = "id";
$NAMESPACES{"jabber:x:event"}->{ID}->{Set}        = ["scalar","id"];
$NAMESPACES{"jabber:x:event"}->{ID}->{Defined}    = "id";
$NAMESPACES{"jabber:x:event"}->{ID}->{Hash}       = "child-data";

$NAMESPACES{"jabber:x:event"}->{Offline}->{Get}        = "offline";
$NAMESPACES{"jabber:x:event"}->{Offline}->{Set}        = ["flag","offline"];
$NAMESPACES{"jabber:x:event"}->{Offline}->{Defined}    = "offline";
$NAMESPACES{"jabber:x:event"}->{Offline}->{Hash}       = "child-flag";

$NAMESPACES{"jabber:x:event"}->{Event}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:event"}->{Event}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:expire
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:expire"}->{Seconds}->{Get}        = "seconds";
$NAMESPACES{"jabber:x:expire"}->{Seconds}->{Set}        = ["scalar","seconds"];
$NAMESPACES{"jabber:x:expire"}->{Seconds}->{Defined}    = "seconds";
$NAMESPACES{"jabber:x:expire"}->{Seconds}->{Hash}       = "att";

$NAMESPACES{"jabber:x:expire"}->{Expire}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:expire"}->{Expire}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:oob
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:oob"}->{Desc}->{Get}        = "desc";
$NAMESPACES{"jabber:x:oob"}->{Desc}->{Set}        = ["scalar","desc"];
$NAMESPACES{"jabber:x:oob"}->{Desc}->{Defined}    = "desc";
$NAMESPACES{"jabber:x:oob"}->{Desc}->{Hash}       = "child-data";

$NAMESPACES{"jabber:x:oob"}->{URL}->{Get}        = "url";
$NAMESPACES{"jabber:x:oob"}->{URL}->{Set}        = ["scalar","url"];
$NAMESPACES{"jabber:x:oob"}->{URL}->{Defined}    = "url";
$NAMESPACES{"jabber:x:oob"}->{URL}->{Hash}       = "child-data";

$NAMESPACES{"jabber:x:oob"}->{Oob}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:oob"}->{Oob}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:roster
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:roster"}->{Item}->{Get}        = "";
$NAMESPACES{"jabber:x:roster"}->{Item}->{Set}        = ["add","X","__netjabber__:x:roster:item"];
$NAMESPACES{"jabber:x:roster"}->{Item}->{Defined}    = "x";
$NAMESPACES{"jabber:x:roster"}->{Item}->{Hash}       = "child-add";

$NAMESPACES{"jabber:x:roster"}->{Item}->{Add} = ["X","__netjabber__:x:roster:item","Item","item"];

$NAMESPACES{"jabber:x:roster"}->{Items}->{Get} = ["__netjabber__:children:x","__netjabber__:x:roster:item"];

#-----------------------------------------------------------------------------
# __netjabber__:x:roster:item
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:roster:item"}->{Group}->{Get}        = "group";
$NAMESPACES{"__netjabber__:x:roster:item"}->{Group}->{Set}        = ["array","group"];
$NAMESPACES{"__netjabber__:x:roster:item"}->{Group}->{Defined}    = "group";
$NAMESPACES{"__netjabber__:x:roster:item"}->{Group}->{Hash}       = "child-data";

$NAMESPACES{"__netjabber__:x:roster:item"}->{JID}->{Get}        = "jid";
$NAMESPACES{"__netjabber__:x:roster:item"}->{JID}->{Set}        = ["jid","jid"];
$NAMESPACES{"__netjabber__:x:roster:item"}->{JID}->{Defined}    = "jid";
$NAMESPACES{"__netjabber__:x:roster:item"}->{JID}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:roster:item"}->{Name}->{Get}        = "name";
$NAMESPACES{"__netjabber__:x:roster:item"}->{Name}->{Set}        = ["scalar","name"];
$NAMESPACES{"__netjabber__:x:roster:item"}->{Name}->{Defined}    = "name";
$NAMESPACES{"__netjabber__:x:roster:item"}->{Name}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:roster:item"}->{Item}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:x:roster:item"}->{Item}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:signed
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:signed"}->{Signature}->{Get}        = "signature";
$NAMESPACES{"jabber:x:signed"}->{Signature}->{Set}        = ["scalar","signature"];
$NAMESPACES{"jabber:x:signed"}->{Signature}->{Defined}    = "signature";
$NAMESPACES{"jabber:x:signed"}->{Signature}->{Hash}       = "data";

$NAMESPACES{"jabber:x:signed"}->{Signed}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:signed"}->{Signed}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:x:sxpm
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:x:sxpm"}->{Data}->{Get}        = "data";
$NAMESPACES{"jabber:x:sxpm"}->{Data}->{Set}        = ["scalar","data"];
$NAMESPACES{"jabber:x:sxpm"}->{Data}->{Defined}    = "data";
$NAMESPACES{"jabber:x:sxpm"}->{Data}->{Hash}       = "child-data";

$NAMESPACES{"jabber:x:sxpm"}->{DataWidth}->{Get}        = "datawidth";
$NAMESPACES{"jabber:x:sxpm"}->{DataWidth}->{Set}        = ["scalar","datawidth"];
$NAMESPACES{"jabber:x:sxpm"}->{DataWidth}->{Defined}    = "datawidth";
$NAMESPACES{"jabber:x:sxpm"}->{DataWidth}->{Hash}       = "att-data-width";

$NAMESPACES{"jabber:x:sxpm"}->{DataX}->{Get}        = "datax";
$NAMESPACES{"jabber:x:sxpm"}->{DataX}->{Set}        = ["scalar","datax"];
$NAMESPACES{"jabber:x:sxpm"}->{DataX}->{Defined}    = "datax";
$NAMESPACES{"jabber:x:sxpm"}->{DataX}->{Hash}       = "att-data-x";

$NAMESPACES{"jabber:x:sxpm"}->{DataY}->{Get}        = "datay";
$NAMESPACES{"jabber:x:sxpm"}->{DataY}->{Set}        = ["scalar","datay"];
$NAMESPACES{"jabber:x:sxpm"}->{DataY}->{Defined}    = "datay";
$NAMESPACES{"jabber:x:sxpm"}->{DataY}->{Hash}       = "att-data-y";

$NAMESPACES{"jabber:x:sxpm"}->{Board}->{Get}        = "board";
$NAMESPACES{"jabber:x:sxpm"}->{Board}->{Set}        = ["scalar","board"];
$NAMESPACES{"jabber:x:sxpm"}->{Board}->{Defined}    = "board";
$NAMESPACES{"jabber:x:sxpm"}->{Board}->{Hash}       = "child-data";

$NAMESPACES{"jabber:x:sxpm"}->{BoardHeight}->{Get}        = "boardheight";
$NAMESPACES{"jabber:x:sxpm"}->{BoardHeight}->{Set}        = ["scalar","boardheight"];
$NAMESPACES{"jabber:x:sxpm"}->{BoardHeight}->{Defined}    = "boardheight";
$NAMESPACES{"jabber:x:sxpm"}->{BoardHeight}->{Hash}       = "att-board-height";

$NAMESPACES{"jabber:x:sxpm"}->{BoardWidth}->{Get}        = "boardwidth";
$NAMESPACES{"jabber:x:sxpm"}->{BoardWidth}->{Set}        = ["scalar","boardwidth"];
$NAMESPACES{"jabber:x:sxpm"}->{BoardWidth}->{Defined}    = "boardwidth";
$NAMESPACES{"jabber:x:sxpm"}->{BoardWidth}->{Hash}       = "att-board-width";

$NAMESPACES{"jabber:x:sxpm"}->{SXPM}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:x:sxpm"}->{SXPM}->{Set} = ["master"];

$NAMESPACES{"jabber:x:sxpm"}->{Map}->{Get}        = "";
$NAMESPACES{"jabber:x:sxpm"}->{Map}->{Set}        = ["add","X","__netjabber__:x:sxpm:map"];
$NAMESPACES{"jabber:x:sxpm"}->{Map}->{Defined}    = "x";
$NAMESPACES{"jabber:x:sxpm"}->{Map}->{Hash}       = "child-add";

$NAMESPACES{"jabber:x:sxpm"}->{Map}->{Add} = ["X","__netjabber__:x:sxpm:map","Map","map"];

$NAMESPACES{"jabber:x:sxpm"}->{Maps}->{Get} = ["__netjabber__:children:x","__netjabber__:x:sxpm:map"];

#-----------------------------------------------------------------------------
# __netjabber__:x:sxpm:map
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Char}->{Get}        = "char";
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Char}->{Set}        = ["scalar","char"];
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Char}->{Defined}    = "char";
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Char}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Color}->{Get}        = "color";
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Color}->{Set}        = ["scalar","color"];
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Color}->{Defined}    = "color";
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Color}->{Hash}       = "att";

$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Map}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:x:sxpm:map"}->{Map}->{Set} = ["master"];

1;
