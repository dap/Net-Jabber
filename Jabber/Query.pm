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

package Net::Jabber::Query;

=head1 NAME

Net::Jabber::Query - Jabber Query Library

=head1 SYNOPSIS

  Net::Jabber::Query is a companion to the Net::Jabber::IQ module. It
  provides the user a simple interface to set and retrieve all
  parts of a Jabber IQ Query.

=head1 DESCRIPTION

  Net::Jabber::Query differs from the other modules in that its behavior
  and available functions are based off of the XML namespace that is
  set in it.  The current list of supported namespaces is:

    jabber:iq:agent
    jabber:iq:agents
    jabber:iq:auth
    jabber:iq:autoupdate
    jabber:iq:browse
    jabber:iq:conference
    jabber:iq:filter
    jabber:iq:gateway
    jabber:iq:last
    jabber:iq:oob
    jabber:iq:pass
    jabber:iq:register
    jabber:iq:roster
    jabber:iq:rpc
    jabber:iq:search
    jabber:iq:time
    jabber:iq:version

  For more information on what these namespaces are for, visit 
  http://www.jabber.org and browse the Jabber Programmers Guide.

  Each of these namespaces provide Net::Jabber::Query with the functions
  to access the data.  By using the AUTOLOAD function the functions for
  each namespace is used when that namespace is active.

  To access a Query object you must create an IQ object and use the
  access functions there to get to the Query.  To initialize the IQ with
  a Jabber <iq/> you must pass it the XML::Stream hash from the
  Net::Jabber::Client module.

    my $iq = new Net::Jabber::IQ(%hash);

  There has been a change from the old way of handling the callbacks.
  You no longer have to do the above yourself, a Net::Jabber::IQ
  object is passed to the callback function for the message.  Also,
  the first argument to the callback functions is the session ID from
  XML::Streams.  There are some cases where you might want this
  information, like if you created a Client that connects to two servers
  at once, or for writing a mini server.

    use Net::Jabber qw(Client);

    sub iqCB {
      my ($IQ) = @_;
      my $query = $IQ->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available for
  that namespace.

  To create a new iq to send to the server:

    use Net::Jabber;

    my $iq = new Net::Jabber::IQ();
    $query = $iq->NewQuery("jabber:iq:register");

  Now you can call the creation functions for the Query as defined in the
  proper namespaces.  See below for the general <query/> functions, and
  in each query module for those functions.

  For more information about the array format being passed to the
  CallBack please read the Net::Jabber::Client documentation.

=head1 METHODS

=head2 Retrieval functions

  GetXMLNS() - returns a string with the namespace of the query that
               the <iq/> contains.

               $xmlns  = $IQ->GetXMLNS();

  GetQuery() - since the behavior of this module depends on the
               namespace, a Query object may contain Query objects.
               This helps to leverage code reuse by making children
               behave in the same manner.  More than likely this
               function will never be called.

               @query = GetQuery()

=head2 Creation functions

  SetXMLNS(string) - sets the xmlns of the <query/> to the string.

                     $query->SetXMLNS("jabber:iq:roster");


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

=head1 jabber:iq:agent

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  flag     GetAgents()       SetAgents()       DefinedAgents()
  string   GetDescription()  SetDescription()  DefinedDesrciption()
  JID      GetJID()          SetJID()          DefinedJID()
  string   GetName()         SetName()         DefinedName()
  flag     GetGroupChat()    SetGroupChat()    DefinedGroupChat()
  flag     GetRegister()     SetRegister()     DefinedRegister()
  flag     GetSearch()       SetSearch()       DefinedSearch()
  string   GetService()      SetService()      DefinedService()
  string   GetTransport()    SetTransport()    DefinedTransport()
  master   GetAgent()        SetAgent()

=head1 jabber:iq:agents

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects                    AddAgent()        DefinedAgent()
  master   GetAgents()

=head1 jabber:iq:auth

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetDigest()       SetDigest()       DefinedDigest()
  string   GetHash()         SetHash()         DefiendHash()
  string   GetPassword()     SetPassword()     DefinedPassword()
  string   GetResource()     SetResource()     DefinedResource()
  string   GetSequence()     SetSequence()     DefinedSequence()
  string   GetToken()        SetToken()        DefinedToken()
  string   GetUsername()     SetUsername()     DefinedUsername()
  master   GetAuth()         SetAuth()

=head1 jabber:iq:autoupdate

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetReleases()
  objects                    AddBeta()
  objects                    AddDev()
  objects                    AddRelease()

=head1 jabber:iq:autoupdate - release objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetDesc()         SetDesc()         DefinedDesc()
  string   GetPriority()     SetPriority()     DefinedPriority()
  string   GetURL()          SetURL()          DefinedURL()
  string   GetVersion()      SetVersion()      DefinedVersion()
  master   GetRelease()      SetRelease()

=head1 jabber:iq:browse

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  JID      GetJID()          SetJID()          DefinedJID()
  string   GetName()         SetName()         DefinedName()
  string   GetType()         SetType()         DefinedType()
  array    GetNS()           SetNS()           DefinedNS()
  master   GetBrowse()       SetBrowse()
  objects                    AddItem()
  objects  GetItems()

=head1 jabber:iq:browse - item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  JID      GetJID()          SetJID()          DefinedJID()
  string   GetName()         SetName()         DefinedName()
  string   GetType()         SetType()         DefinedType()
  array    GetNS()           SetNS()           DefinedNS()
  master   GetBrowse()       SetBrowse()
  objects                    AddItem()
  objects  GetItems()

=head1 jabber:iq:conference

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetID()           SetID()           DefinedID()
  string   GetName()         SetName()         DefinedName()
  array    GetNick()         SetNick()         DefinedNick()
  flag     GetPrivacy()      SetPrivacy()      DefinedPrivacy()
  string   GetSecret()       SetSecret()       DefinedSecret()
  master   GetConference()   SetConference()

=head1 jabber:iq:filter

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects                    AddRule()
  objects  GetRules()

=head1 jabber:iq:filter - rule objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetBody()         SetBody()         DefinedBody()
  string   GetContinued()    SetContinued()    DefinedContinued()
  string   GetDrop()         SetDrop()         DefinedDrop()
  string   GetEdit()         SetEdit()         DefinedEdit()
  string   GetError()        SetError()        DefinedError()
  string   GetFrom()         SetFrom()         DefinedFrom()
  string   GetOffline()      SetOffline()      DefinedOffline()
  string   GetReply()        SetReply()        DefinedReply()
  string   GetResource()     SetResource()     DefinedResource()
  string   GetShow()         SetShow()         DefinedShow()
  string   GetSize()         SetSize()         DefinedSize()
  string   GetSubject()      SetSubject()      DefinedSubject()
  string   GetTime()         SetTime()         DefinedTime()
  string   GetType()         SetType()         DefinedType()
  string   GetUnavailable()  SetUnavailable()  DefinedUnavailable()
  master   GetConference()   SetConference()

=head1 jabber:iq:gateway

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  JID      GetJID()          SetJID()          DefinedJID()
  string   GetDesc()         SetDesc()         DefinedDesc()
  string   GetPrompt()       SetPrompt()       DefinedPrompt()
  master   GetGateway()      SetGateway()

=head1 jabber:iq:last

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetMessage()      SetMessage()      DefinedMessage()
  string   GetSeconds()      SetSeconds()      DefinedSeconds()
  master   GetLast()         SetLast()

=head1 jabber:iq:oob

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetDesc()         SetDesc()         DefinedDesc()
  string   GetURL()          SetURL()          DefinedURL()
  master   GetOob()          SetOob()

=head1 jabber:iq:pass

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetClient()       SetClient()       DefinedClient()
  string   GetClientPort()   SetClientPort()   DefinedClientPort()
  string   GetClose()        SetClose()        DefinedClose()
  string   GetExpire()       SetExpire()       DefinedExpire()
  string   GetOneShot()      SetOneShot()      DefinedOneShot()
  string   GetProxy()        SetProxy()        DefinedProxy()
  string   GetProxyPort()    SetProxyPort()    DefinedProxyPort()
  string   GetServer()       SetServer()       DefinedServer()
  string   GetServerPort()   SetServerPort()   DefinedServerPort()
  master   GetPass()         SetPass()

=head1 jabber:iq:register

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetAddress()      SetAddress()      DefinedAddress()
  string   GetCity()         SetCity()         DefinedCity()
  string   GetDate()         SetDate()         DefinedDate()
  string   GetEmail()        SetEmail()        DefinedEmail()
  string   GetFirst()        SetFirst()        DefinedFirst()
  string   GetInstructions() SetInstructions() DefinedInstructions()
  string   GetKey()          SetKey()          DefinedKey()
  string   GetLast()         SetLast()         DefinedLast()
  string   GetMisc()         SetMisc()         DefinedMisc()
  string   GetName()         SetName()         DefinedName()
  string   GetNick()         SetNick()         DefinedNick()
  string   GetPassword()     SetPassword()     DefinedPassword()
  string   GetPhone()        SetPhone()        DefinedPhone()
  flag     GetRegistered()   SetRegistered()   DefinedRegistered()
  flag     GetRemove()       SetRemove()       DefinedRemove()
  string   GetState()        SetState()        DefinedState()
  string   GetText()         SetText()         DefinedText()
  string   GetURL()          SetURL()          DefinedURL()
  string   GetUsername()     SetUsername()     DefinedUsername()
  string   GetZip()          SetZip()          DefinedZip()
  master   GetRegister()     SetRegister()

=head1 jabber:iq:roster

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects                    AddItem()
  objects  GetItems()

=head1 jabber:iq:roster - item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetAsk()          SetAsk()          DefinedAsk()
  array    GetGroup()        SetGroup()        DefinedGroup()
  JID      GetJID()          SetJID()          DefinedJID()
  string   GetName()         SetName()         DefinedName()
  string   GetSubscription() SetSubscription() DefinedSubscription()
  master   GetItem()         SetItem()

=head1 jabber:iq:rpc

  Type     Get               Set               Defined
  =======  ================  ================  ==================
TODO

=head1 jabber:iq:search

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetEmail()        SetEmail()        DefinedEmail()
  string   GetFirst()        SetFirst()        DefinedFirst()
  string   GetFamily()       SetFamily()       DefinedFamily()
  string   GetGiven()        SetGiven()        DefinedGiven()
  string   GetInstructions() SetInstructions() DefinedInstructions()
  string   GetKey()          SetKey()          DefinedKey()
  string   GetLast()         SetLast()         DefinedLast()
  string   GetName()         SetName()         DefinedName()
  string   GetNick()         SetNick()         DefinedNick()
  flag     GetTruncated()    SetTruncated()    DefinedTruncated()
  master   GetSearch()       SetSearch()
  objects                    AddItem()
  objects  GetItems()

=head1 jabber:iq:search - item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetEmail()        SetEmail()        DefinedEmail()
  string   GetFirst()        SetFirst()        DefinedFirst()
  string   GetFamily()       SetFamily()       DefinedFamily()
  string   GetGiven()        SetGiven()        DefinedGiven()
  JID      GetJID()          SetJID()          DefinedJID()
  string   GetKey()          SetKey()          DefinedKey()
  string   GetLast()         SetLast()         DefinedLast()
  string   GetName()         SetName()         DefinedName()
  string   GetNick()         SetNick()         DefinedNick()
  master   GetSearch()       SetSearch()

=head1 jabber:iq:time

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  special  GetDisplay()      SetDisplay()      DefinedDisplay()
  special  GetTZ()           SetTZ()           DefinedTZ()
  special  GetUTC()          SetUTC()          DefinedUTC()
  master   GetTime()         SetTime()

=head1 jabber:iq:version

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetName()         SetName()         DefinedName()
  special  GetOS()           SetOS()           DefinedOS()
  special  GetVer()          SetVer()          DefinedVer()
  master   GetVersion()      SetVersion()

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
use vars qw($VERSION %FUNCTIONS %NAMESPACES $AUTOLOAD);

$VERSION = "1.0025";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };

  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  $self->{DEBUGHEADER} = "Query";

  $self->{DATA} = {};
  $self->{CHILDREN} = {};

  $self->{TAG} = "query";

  if ("@_" ne ("")) {
    if (ref($_[0]) eq "Net::Jabber::Query") {
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

$FUNCTIONS{XMLNS}->{Get}     = "xmlns";
$FUNCTIONS{XMLNS}->{Set}     = ["scalar","xmlns"];
$FUNCTIONS{XMLNS}->{Defined} = "xmlns";
$FUNCTIONS{XMLNS}->{Hash}    = "att";

$FUNCTIONS{X}->{Get}     = "__netjabber__:children:x";
$FUNCTIONS{X}->{Defined} = "__netjabber__:children:x";

$FUNCTIONS{Query}->{Get}     = "__netjabber__:children:query";
$FUNCTIONS{Query}->{Defined} = "__netjabber__:children:query";

#-----------------------------------------------------------------------------
# jabber:iq:agent
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:agent"}->{Agents}->{Get}     = "agents";
$NAMESPACES{"jabber:iq:agent"}->{Agents}->{Set}     = ["flag","agents"];
$NAMESPACES{"jabber:iq:agent"}->{Agents}->{Defined} = "agents";
$NAMESPACES{"jabber:iq:agent"}->{Agents}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:agent"}->{Description}->{Get}     = "description";
$NAMESPACES{"jabber:iq:agent"}->{Description}->{Set}     = ["scalar","description"];
$NAMESPACES{"jabber:iq:agent"}->{Description}->{Defined} = "description";
$NAMESPACES{"jabber:iq:agent"}->{Description}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:agent"}->{JID}->{Get}     = "jid";
$NAMESPACES{"jabber:iq:agent"}->{JID}->{Set}     = ["jid","jid"];
$NAMESPACES{"jabber:iq:agent"}->{JID}->{Defined} = "jid";
$NAMESPACES{"jabber:iq:agent"}->{JID}->{Hash}    = "att";

$NAMESPACES{"jabber:iq:agent"}->{Name}->{Get}     = "name";
$NAMESPACES{"jabber:iq:agent"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"jabber:iq:agent"}->{Name}->{Defined} = "name";
$NAMESPACES{"jabber:iq:agent"}->{Name}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:agent"}->{GroupChat}->{Get}     = "groupchat";
$NAMESPACES{"jabber:iq:agent"}->{GroupChat}->{Set}     = ["flag","groupchat"];
$NAMESPACES{"jabber:iq:agent"}->{GroupChat}->{Defined} = "groupchat";
$NAMESPACES{"jabber:iq:agent"}->{GroupChat}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:agent"}->{Register}->{Get}     = "register";
$NAMESPACES{"jabber:iq:agent"}->{Register}->{Set}     = ["flag","register"];
$NAMESPACES{"jabber:iq:agent"}->{Register}->{Defined} = "register";
$NAMESPACES{"jabber:iq:agent"}->{Register}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:agent"}->{Search}->{Get}     = "search";
$NAMESPACES{"jabber:iq:agent"}->{Search}->{Set}     = ["flag","search"];
$NAMESPACES{"jabber:iq:agent"}->{Search}->{Defined} = "search";
$NAMESPACES{"jabber:iq:agent"}->{Search}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:agent"}->{Service}->{Get}     = "service";
$NAMESPACES{"jabber:iq:agent"}->{Service}->{Set}     = ["scalar","service"];
$NAMESPACES{"jabber:iq:agent"}->{Service}->{Defined} = "service";
$NAMESPACES{"jabber:iq:agent"}->{Service}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:agent"}->{Transport}->{Get}     = "transport";
$NAMESPACES{"jabber:iq:agent"}->{Transport}->{Set}     = ["scalar","transport"];
$NAMESPACES{"jabber:iq:agent"}->{Transport}->{Defined} = "transport";
$NAMESPACES{"jabber:iq:agent"}->{Transport}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:agent"}->{Agent}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:agent"}->{Agent}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:agents
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{Get}     = ["__netjabber__:children:query","jabber:iq:agent"];
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{Set}     = ["add","Query","jabber:iq:agent"];
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{Defined} = ["__netjabber__:children:query","jabber:iq:agent"];
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{Hash}    = "child-add";

$NAMESPACES{"jabber:iq:agents"}->{Agent}->{Add} = ["Query","jabber:iq:agent","Agent","agent"];

$NAMESPACES{"jabber:iq:agents"}->{Agents}->{Get} = ["__netjabber__:children:query","jabber:iq:agent"];

#-----------------------------------------------------------------------------
# jabber:iq:auth
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:auth"}->{Digest}->{Get}     = "digest";
$NAMESPACES{"jabber:iq:auth"}->{Digest}->{Set}     = ["scalar","digest"];
$NAMESPACES{"jabber:iq:auth"}->{Digest}->{Defined} = "digest";
$NAMESPACES{"jabber:iq:auth"}->{Digest}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:auth"}->{Hash}->{Get}     = "hash";
$NAMESPACES{"jabber:iq:auth"}->{Hash}->{Set}     = ["scalar","hash"];
$NAMESPACES{"jabber:iq:auth"}->{Hash}->{Defined} = "hash";
$NAMESPACES{"jabber:iq:auth"}->{Hash}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:auth"}->{Password}->{Get}     = "password";
$NAMESPACES{"jabber:iq:auth"}->{Password}->{Set}     = ["scalar","password"];
$NAMESPACES{"jabber:iq:auth"}->{Password}->{Defined} = "password";
$NAMESPACES{"jabber:iq:auth"}->{Password}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:auth"}->{Resource}->{Get}     = "resource";
$NAMESPACES{"jabber:iq:auth"}->{Resource}->{Set}     = ["scalar","resource"];
$NAMESPACES{"jabber:iq:auth"}->{Resource}->{Defined} = "resource";
$NAMESPACES{"jabber:iq:auth"}->{Resource}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:auth"}->{Sequence}->{Get}     = "sequence";
$NAMESPACES{"jabber:iq:auth"}->{Sequence}->{Set}     = ["scalar","sequence"];
$NAMESPACES{"jabber:iq:auth"}->{Sequence}->{Defined} = "sequence";
$NAMESPACES{"jabber:iq:auth"}->{Sequence}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:auth"}->{Token}->{Get}     = "token";
$NAMESPACES{"jabber:iq:auth"}->{Token}->{Set}     = ["scalar","token"];
$NAMESPACES{"jabber:iq:auth"}->{Token}->{Defined} = "token";
$NAMESPACES{"jabber:iq:auth"}->{Token}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:auth"}->{Username}->{Get}     = "username";
$NAMESPACES{"jabber:iq:auth"}->{Username}->{Set}     = ["scalar","username"];
$NAMESPACES{"jabber:iq:auth"}->{Username}->{Defined} = "username";
$NAMESPACES{"jabber:iq:auth"}->{Username}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:auth"}->{Auth}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:auth"}->{Auth}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:autoupdate
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:autoupdate:release",0];
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{Set}     = ["add","Query","__netjabber__:iq:autoupdate:release"];
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:autoupdate:release"];
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{Hash}    = "child-add";
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{Add} = ["Query","__netjabber__:iq:autoupdate:release","Release","beta"];

$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:autoupdate:release",0];
$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{Set}     = ["add","Query","__netjabber__:iq:autoupdate:release"];
$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:autoupdate:release"];
$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{Hash}    = "child-add";
$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{Add} = ["Query","__netjabber__:iq:autoupdate:release","Release","dev"];

$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:autoupdate:release",0];
$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{Set}     = ["add","Query","__netjabber__:iq:autoupdate:release"];
$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:autoupdate:release"];
$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{Hash}    = "child-add";
$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{Add} = ["Query","__netjabber__:iq:autoupdate:release","Release","release"];

$NAMESPACES{"jabber:iq:autoupdate"}->{Releases}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:autoupdate:release"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:autoupdate:release
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Desc}->{Get}     = "desc";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Desc}->{Set}     = ["scalar","desc"];
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Desc}->{Defined} = "desc";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Desc}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Priority}->{Get}     = "priority";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Priority}->{Set}     = ["scalar","priority"];
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Priority}->{Defined} = "priority";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Priority}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{URL}->{Get}     = "url";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{URL}->{Set}     = ["scalar","url"];
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{URL}->{Defined} = "url";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{URL}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Version}->{Get}     = "version";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Version}->{Set}     = ["scalar","version"];
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Version}->{Defined} = "version";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Version}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Release}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Release}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:browse
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:browse"}->{JID}->{Get}     = "jid";
$NAMESPACES{"jabber:iq:browse"}->{JID}->{Set}     = ["jid","jid"];
$NAMESPACES{"jabber:iq:browse"}->{JID}->{Defined} = "jid";
$NAMESPACES{"jabber:iq:browse"}->{JID}->{Hash}    = "att";

$NAMESPACES{"jabber:iq:browse"}->{Name}->{Get}     = "name";
$NAMESPACES{"jabber:iq:browse"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"jabber:iq:browse"}->{Name}->{Defined} = "name";
$NAMESPACES{"jabber:iq:browse"}->{Name}->{Hash}    = "att";

$NAMESPACES{"jabber:iq:browse"}->{Type}->{Get}     = "type";
$NAMESPACES{"jabber:iq:browse"}->{Type}->{Set}     = ["scalar","type"];
$NAMESPACES{"jabber:iq:browse"}->{Type}->{Defined} = "type";
$NAMESPACES{"jabber:iq:browse"}->{Type}->{Hash}    = "att";

$NAMESPACES{"jabber:iq:browse"}->{NS}->{Get}     = "ns";
$NAMESPACES{"jabber:iq:browse"}->{NS}->{Set}     = ["array","ns"];
$NAMESPACES{"jabber:iq:browse"}->{NS}->{Defined} = "ns";
$NAMESPACES{"jabber:iq:browse"}->{NS}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:browse"}->{Browse}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:browse"}->{Browse}->{Set} = ["master"];

$NAMESPACES{"jabber:iq:browse"}->{Item}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:browse"];
$NAMESPACES{"jabber:iq:browse"}->{Item}->{Set}     = ["add","Query","__netjabber__:iq:browse","ns"];
$NAMESPACES{"jabber:iq:browse"}->{Item}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:browse"];
$NAMESPACES{"jabber:iq:browse"}->{Item}->{Hash}    = "child-add";

$NAMESPACES{"jabber:iq:browse"}->{Item}->{Add} = ["Query","__netjabber__:iq:browse","Browse"];

$NAMESPACES{"jabber:iq:browse"}->{Items}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:browse"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:browse
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:browse"}->{JID}->{Get}     = "jid";
$NAMESPACES{"__netjabber__:iq:browse"}->{JID}->{Set}     = ["jid","jid"];
$NAMESPACES{"__netjabber__:iq:browse"}->{JID}->{Defined} = "jid";
$NAMESPACES{"__netjabber__:iq:browse"}->{JID}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:browse"}->{Name}->{Get}     = "name";
$NAMESPACES{"__netjabber__:iq:browse"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"__netjabber__:iq:browse"}->{Name}->{Defined} = "name";
$NAMESPACES{"__netjabber__:iq:browse"}->{Name}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:browse"}->{Type}->{Get}     = "type";
$NAMESPACES{"__netjabber__:iq:browse"}->{Type}->{Set}     = ["scalar","type"];
$NAMESPACES{"__netjabber__:iq:browse"}->{Type}->{Defined} = "type";
$NAMESPACES{"__netjabber__:iq:browse"}->{Type}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:browse"}->{NS}->{Get}     = "ns";
$NAMESPACES{"__netjabber__:iq:browse"}->{NS}->{Set}     = ["array","ns"];
$NAMESPACES{"__netjabber__:iq:browse"}->{NS}->{Defined} = "ns";
$NAMESPACES{"__netjabber__:iq:browse"}->{NS}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:browse"}->{Browse}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:browse"}->{Browse}->{Set} = ["master"];

$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:browse"];
$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{Set}     = ["add","Query","__netjabber__:iq:browse","ns"];
$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:browse"];
$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{Hash}    = "child-add";

$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{Add} = ["Query","__netjabber__:iq:browse","Browse"];

$NAMESPACES{"__netjabber__:iq:browse"}->{Items}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:browse"];

#-----------------------------------------------------------------------------
# jabber:iq:conference
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:conference"}->{ID}->{Get}     = "id";
$NAMESPACES{"jabber:iq:conference"}->{ID}->{Set}     = ["scalar","id"];
$NAMESPACES{"jabber:iq:conference"}->{ID}->{Defined} = "id";
$NAMESPACES{"jabber:iq:conference"}->{ID}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:conference"}->{Name}->{Get}     = "name";
$NAMESPACES{"jabber:iq:conference"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"jabber:iq:conference"}->{Name}->{Defined} = "name";
$NAMESPACES{"jabber:iq:conference"}->{Name}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:conference"}->{Nick}->{Get}     = "nick";
$NAMESPACES{"jabber:iq:conference"}->{Nick}->{Set}     = ["array","nick"];
$NAMESPACES{"jabber:iq:conference"}->{Nick}->{Defined} = "nick";
$NAMESPACES{"jabber:iq:conference"}->{Nick}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:conference"}->{Privacy}->{Get}     = "privacy";
$NAMESPACES{"jabber:iq:conference"}->{Privacy}->{Set}     = ["flag","privacy"];
$NAMESPACES{"jabber:iq:conference"}->{Privacy}->{Defined} = "privacy";
$NAMESPACES{"jabber:iq:conference"}->{Privacy}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:conference"}->{Secret}->{Get}     = "secret";
$NAMESPACES{"jabber:iq:conference"}->{Secret}->{Set}     = ["scalar","secret"];
$NAMESPACES{"jabber:iq:conference"}->{Secret}->{Defined} = "secret";
$NAMESPACES{"jabber:iq:conference"}->{Secret}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:conference"}->{Conference}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:conference"}->{Conference}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:filter
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:filter:rule"];
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{Set}     = ["add","Query","__netjabber__:iq:filter:rule"];
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:filter:rule"];
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{Hash}    = "child-add";

$NAMESPACES{"jabber:iq:filter"}->{Rule}->{Add} = ["Query","__netjabber__:iq:filter:rule","Rule","rule"];

$NAMESPACES{"jabber:iq:filter"}->{Rules}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:filter:rule"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:filter:rule
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Body}->{Get}     = "body";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Body}->{Set}     = ["scalar","body"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Body}->{Defined} = "body";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Body}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Continued}->{Get}     = "continued";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Continued}->{Set}     = ["scalar","continued"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Continued}->{Defined} = "continued";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Continued}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Drop}->{Get}     = "drop";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Drop}->{Set}     = ["scalar","drop"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Drop}->{Defined} = "drop";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Drop}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Edit}->{Get}     = "edit";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Edit}->{Set}     = ["scalar","edit"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Edit}->{Defined} = "edit";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Edit}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Error}->{Get}     = "error";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Error}->{Set}     = ["scalar","error"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Error}->{Defined} = "error";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Error}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{From}->{Get}     = "from";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{From}->{Set}     = ["scalar","from"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{From}->{Defined} = "from";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{From}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Offline}->{Get}     = "offline";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Offline}->{Set}     = ["scalar","offline"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Offline}->{Defined} = "offline";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Offline}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Reply}->{Get}     = "reply";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Reply}->{Set}     = ["scalar","reply"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Reply}->{Defined} = "reply";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Reply}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Resource}->{Get}     = "resource";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Resource}->{Set}     = ["scalar","resource"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Resource}->{Defined} = "resource";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Resource}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Show}->{Get}     = "show";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Show}->{Set}     = ["scalar","show"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Show}->{Defined} = "show";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Show}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Size}->{Get}     = "size";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Size}->{Set}     = ["scalar","size"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Size}->{Defined} = "size";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Size}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Subject}->{Get}     = "subject";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Subject}->{Set}     = ["scalar","subject"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Subject}->{Defined} = "subject";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Subject}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Time}->{Get}     = "time";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Time}->{Set}     = ["scalar","time"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Time}->{Defined} = "time";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Time}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Type}->{Get}     = "type";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Type}->{Set}     = ["scalar","type"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Type}->{Defined} = "type";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Type}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Unavailable}->{Get}     = "unavailable";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Unavailable}->{Set}     = ["scalar","unavailable"];
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Unavailable}->{Defined} = "unavailable";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Unavailable}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Rule}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Rule}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:gateway
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:gateway"}->{JID}->{Get}     = "jid";
$NAMESPACES{"jabber:iq:gateway"}->{JID}->{Set}     = ["jid","jid"];
$NAMESPACES{"jabber:iq:gateway"}->{JID}->{Defined} = "jid";
$NAMESPACES{"jabber:iq:gateway"}->{JID}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:gateway"}->{Desc}->{Get}     = "desc";
$NAMESPACES{"jabber:iq:gateway"}->{Desc}->{Set}     = ["scalar","desc"];
$NAMESPACES{"jabber:iq:gateway"}->{Desc}->{Defined} = "desc";
$NAMESPACES{"jabber:iq:gateway"}->{Desc}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:gateway"}->{Prompt}->{Get}     = "prompt";
$NAMESPACES{"jabber:iq:gateway"}->{Prompt}->{Set}     = ["scalar","prompt"];
$NAMESPACES{"jabber:iq:gateway"}->{Prompt}->{Defined} = "prompt";
$NAMESPACES{"jabber:iq:gateway"}->{Prompt}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:gateway"}->{Gateway}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:gateway"}->{Gateway}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:last
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:last"}->{Message}->{Get}     = "message";
$NAMESPACES{"jabber:iq:last"}->{Message}->{Set}     = ["scalar","message"];
$NAMESPACES{"jabber:iq:last"}->{Message}->{Defined} = "message";
$NAMESPACES{"jabber:iq:last"}->{Message}->{Hash}    = "data";

$NAMESPACES{"jabber:iq:last"}->{Seconds}->{Get}     = "seconds";
$NAMESPACES{"jabber:iq:last"}->{Seconds}->{Set}     = ["scalar","seconds"];
$NAMESPACES{"jabber:iq:last"}->{Seconds}->{Defined} = "seconds";
$NAMESPACES{"jabber:iq:last"}->{Seconds}->{Hash}    = "att";

$NAMESPACES{"jabber:iq:last"}->{Last}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:last"}->{Last}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:oob
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:oob"}->{Desc}->{Get}     = "desc";
$NAMESPACES{"jabber:iq:oob"}->{Desc}->{Set}     = ["scalar","desc"];
$NAMESPACES{"jabber:iq:oob"}->{Desc}->{Defined} = "desc";
$NAMESPACES{"jabber:iq:oob"}->{Desc}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:oob"}->{URL}->{Get}     = "url";
$NAMESPACES{"jabber:iq:oob"}->{URL}->{Set}     = ["scalar","url"];
$NAMESPACES{"jabber:iq:oob"}->{URL}->{Defined} = "url";
$NAMESPACES{"jabber:iq:oob"}->{URL}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:oob"}->{Oob}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:oob"}->{Oob}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:pass
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:pass"}->{Client}->{Get}     = "client";
$NAMESPACES{"jabber:iq:pass"}->{Client}->{Set}     = ["scalar","client"];
$NAMESPACES{"jabber:iq:pass"}->{Client}->{Defined} = "client";
$NAMESPACES{"jabber:iq:pass"}->{Client}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:pass"}->{ClientPort}->{Get}     = "clientport";
$NAMESPACES{"jabber:iq:pass"}->{ClientPort}->{Set}     = ["scalar","clientport"];
$NAMESPACES{"jabber:iq:pass"}->{ClientPort}->{Defined} = "clientport";
$NAMESPACES{"jabber:iq:pass"}->{ClientPort}->{Hash}    = "att-client-port";

$NAMESPACES{"jabber:iq:pass"}->{Close}->{Get}     = "close";
$NAMESPACES{"jabber:iq:pass"}->{Close}->{Set}     = ["scalar","close"];
$NAMESPACES{"jabber:iq:pass"}->{Close}->{Defined} = "close";
$NAMESPACES{"jabber:iq:pass"}->{Close}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:pass"}->{Expire}->{Get}     = "expire";
$NAMESPACES{"jabber:iq:pass"}->{Expire}->{Set}     = ["scalar","expire"];
$NAMESPACES{"jabber:iq:pass"}->{Expire}->{Defined} = "expire";
$NAMESPACES{"jabber:iq:pass"}->{Expire}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:pass"}->{OneShot}->{Get}     = "oneshot";
$NAMESPACES{"jabber:iq:pass"}->{OneShot}->{Set}     = ["scalar","oneshot"];
$NAMESPACES{"jabber:iq:pass"}->{OneShot}->{Defined} = "oneshot";
$NAMESPACES{"jabber:iq:pass"}->{OneShot}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:pass"}->{Proxy}->{Get}     = "proxy";
$NAMESPACES{"jabber:iq:pass"}->{Proxy}->{Set}     = ["scalar","proxy"];
$NAMESPACES{"jabber:iq:pass"}->{Proxy}->{Defined} = "proxy";
$NAMESPACES{"jabber:iq:pass"}->{Proxy}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:pass"}->{ProxyPort}->{Get}     = "proxyport";
$NAMESPACES{"jabber:iq:pass"}->{ProxyPort}->{Set}     = ["scalar","proxyport"];
$NAMESPACES{"jabber:iq:pass"}->{ProxyPort}->{Defined} = "proxyport";
$NAMESPACES{"jabber:iq:pass"}->{ProxyPort}->{Hash}    = "att-proxy-port";

$NAMESPACES{"jabber:iq:pass"}->{Server}->{Get}     = "server";
$NAMESPACES{"jabber:iq:pass"}->{Server}->{Set}     = ["scalar","server"];
$NAMESPACES{"jabber:iq:pass"}->{Server}->{Defined} = "server";
$NAMESPACES{"jabber:iq:pass"}->{Server}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:pass"}->{ServerPort}->{Get}     = "serverport";
$NAMESPACES{"jabber:iq:pass"}->{ServerPort}->{Set}     = ["scalar","serverport"];
$NAMESPACES{"jabber:iq:pass"}->{ServerPort}->{Defined} = "serverport";
$NAMESPACES{"jabber:iq:pass"}->{ServerPort}->{Hash}    = "att-server-port";

$NAMESPACES{"jabber:iq:pass"}->{Pass}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:pass"}->{Pass}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:register
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:register"}->{Address}->{Get}     = "address";
$NAMESPACES{"jabber:iq:register"}->{Address}->{Set}     = ["scalar","address"];
$NAMESPACES{"jabber:iq:register"}->{Address}->{Defined} = "address";
$NAMESPACES{"jabber:iq:register"}->{Address}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{City}->{Get}     = "city";
$NAMESPACES{"jabber:iq:register"}->{City}->{Set}     = ["scalar","city"];
$NAMESPACES{"jabber:iq:register"}->{City}->{Defined} = "city";
$NAMESPACES{"jabber:iq:register"}->{City}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Date}->{Get}     = "date";
$NAMESPACES{"jabber:iq:register"}->{Date}->{Set}     = ["scalar","date"];
$NAMESPACES{"jabber:iq:register"}->{Date}->{Defined} = "date";
$NAMESPACES{"jabber:iq:register"}->{Date}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Email}->{Get}     = "email";
$NAMESPACES{"jabber:iq:register"}->{Email}->{Set}     = ["scalar","email"];
$NAMESPACES{"jabber:iq:register"}->{Email}->{Defined} = "email";
$NAMESPACES{"jabber:iq:register"}->{Email}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{First}->{Get}     = "first";
$NAMESPACES{"jabber:iq:register"}->{First}->{Set}     = ["scalar","first"];
$NAMESPACES{"jabber:iq:register"}->{First}->{Defined} = "first";
$NAMESPACES{"jabber:iq:register"}->{First}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Instructions}->{Get}     = "instructions";
$NAMESPACES{"jabber:iq:register"}->{Instructions}->{Set}     = ["scalar","instructions"];
$NAMESPACES{"jabber:iq:register"}->{Instructions}->{Defined} = "instructions";
$NAMESPACES{"jabber:iq:register"}->{Instructions}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Key}->{Get}     = "key";
$NAMESPACES{"jabber:iq:register"}->{Key}->{Set}     = ["scalar","key"];
$NAMESPACES{"jabber:iq:register"}->{Key}->{Defined} = "key";
$NAMESPACES{"jabber:iq:register"}->{Key}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Last}->{Get}     = "last";
$NAMESPACES{"jabber:iq:register"}->{Last}->{Set}     = ["scalar","last"];
$NAMESPACES{"jabber:iq:register"}->{Last}->{Defined} = "last";
$NAMESPACES{"jabber:iq:register"}->{Last}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Misc}->{Get}     = "misc";
$NAMESPACES{"jabber:iq:register"}->{Misc}->{Set}     = ["scalar","misc"];
$NAMESPACES{"jabber:iq:register"}->{Misc}->{Defined} = "misc";
$NAMESPACES{"jabber:iq:register"}->{Misc}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Name}->{Get}     = "name";
$NAMESPACES{"jabber:iq:register"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"jabber:iq:register"}->{Name}->{Defined} = "name";
$NAMESPACES{"jabber:iq:register"}->{Name}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Nick}->{Get}     = "nick";
$NAMESPACES{"jabber:iq:register"}->{Nick}->{Set}     = ["scalar","nick"];
$NAMESPACES{"jabber:iq:register"}->{Nick}->{Defined} = "nick";
$NAMESPACES{"jabber:iq:register"}->{Nick}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Password}->{Get}     = "password";
$NAMESPACES{"jabber:iq:register"}->{Password}->{Set}     = ["scalar","password"];
$NAMESPACES{"jabber:iq:register"}->{Password}->{Defined} = "password";
$NAMESPACES{"jabber:iq:register"}->{Password}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Phone}->{Get}     = "phone";
$NAMESPACES{"jabber:iq:register"}->{Phone}->{Set}     = ["scalar","phone"];
$NAMESPACES{"jabber:iq:register"}->{Phone}->{Defined} = "phone";
$NAMESPACES{"jabber:iq:register"}->{Phone}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Registered}->{Get}     = "registered";
$NAMESPACES{"jabber:iq:register"}->{Registered}->{Set}     = ["flag","registered"];
$NAMESPACES{"jabber:iq:register"}->{Registered}->{Defined} = "registered";
$NAMESPACES{"jabber:iq:register"}->{Registered}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:register"}->{Remove}->{Get}     = "remove";
$NAMESPACES{"jabber:iq:register"}->{Remove}->{Set}     = ["flag","remove"];
$NAMESPACES{"jabber:iq:register"}->{Remove}->{Defined} = "remove";
$NAMESPACES{"jabber:iq:register"}->{Remove}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:register"}->{State}->{Get}     = "state";
$NAMESPACES{"jabber:iq:register"}->{State}->{Set}     = ["scalar","state"];
$NAMESPACES{"jabber:iq:register"}->{State}->{Defined} = "state";
$NAMESPACES{"jabber:iq:register"}->{State}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Text}->{Get}     = "text";
$NAMESPACES{"jabber:iq:register"}->{Text}->{Set}     = ["scalar","text"];
$NAMESPACES{"jabber:iq:register"}->{Text}->{Defined} = "text";
$NAMESPACES{"jabber:iq:register"}->{Text}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{URL}->{Get}     = "url";
$NAMESPACES{"jabber:iq:register"}->{URL}->{Set}     = ["scalar","url"];
$NAMESPACES{"jabber:iq:register"}->{URL}->{Defined} = "url";
$NAMESPACES{"jabber:iq:register"}->{URL}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Username}->{Get}     = "username";
$NAMESPACES{"jabber:iq:register"}->{Username}->{Set}     = ["scalar","username"];
$NAMESPACES{"jabber:iq:register"}->{Username}->{Defined} = "username";
$NAMESPACES{"jabber:iq:register"}->{Username}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Zip}->{Get}     = "zip";
$NAMESPACES{"jabber:iq:register"}->{Zip}->{Set}     = ["scalar","zip"];
$NAMESPACES{"jabber:iq:register"}->{Zip}->{Defined} = "zip";
$NAMESPACES{"jabber:iq:register"}->{Zip}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:register"}->{Register}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:register"}->{Register}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:roster
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:roster"}->{Item}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:roster:item"];
$NAMESPACES{"jabber:iq:roster"}->{Item}->{Set}     = ["add","Query","__netjabber__:iq:roster:item"];
$NAMESPACES{"jabber:iq:roster"}->{Item}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:roster:item"];
$NAMESPACES{"jabber:iq:roster"}->{Item}->{Hash}    = "child-add";

$NAMESPACES{"jabber:iq:roster"}->{Item}->{Add} = ["Query","__netjabber__:iq:roster:item","Item","item"];

$NAMESPACES{"jabber:iq:roster"}->{Items}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:roster:item"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:roster:item
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Ask}->{Get}     = "ask";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Ask}->{Set}     = ["scalar","ask"];
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Ask}->{Defined} = "ask";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Ask}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Group}->{Get}     = "group";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Group}->{Set}     = ["array","group"];
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Group}->{Defined} = "group";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Group}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:roster:item"}->{JID}->{Get}     = "jid";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{JID}->{Set}     = ["jid","jid"];
$NAMESPACES{"__netjabber__:iq:roster:item"}->{JID}->{Defined} = "jid";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{JID}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Name}->{Get}     = "name";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Name}->{Defined} = "name";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Name}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Subscription}->{Get}     = "subscription";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Subscription}->{Set}     = ["scalar","subscription"];
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Subscription}->{Defined} = "subscription";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Subscription}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Item}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Item}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:rpc
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:methodCall",0];
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{Set}     = ["add","Query","__netjabber__:iq:rpc:methodCall"];
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:methodCall"];
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{Hash}    = "child-add";
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{Add}     = ["Query","__netjabber__:iq:rpc:methodCall","MethodCall","methodCall"];

$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:methodResponse",0];
$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{Set}     = ["add","Query","__netjabber__:iq:rpc:methodResponse"];
$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:methodResponse"];
$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{Hash}    = "child-add";
$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{Add}     = ["Query","__netjabber__:iq:rpc:methodResponse","MethodResponse","methodResponse"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:methodCall
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodName}->{Get}     = "methodName";
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodName}->{Set}     = ["scalar","methodName"];
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodName}->{Defined} = "methodName";
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodName}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:params",0];
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{Set}     = ["add","Query","__netjabber__:iq:rpc:params"];
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:params"];
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{Add}     = ["Query","__netjabber__:iq:rpc:params","Params","params"];

$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodCall}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodCall}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:methodResponse
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:params",0];
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{Set}     = ["add","Query","__netjabber__:iq:rpc:params"];
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{Defined} = "__netjabber__:children:query";
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{Add}     = ["Query","__netjabber__:iq:rpc:params","Params","params"];

$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:fault",0];
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{Set}     = ["add","Query","__netjabber__:iq:rpc:fault"];
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:fault"];
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{Add}     = ["Query","__netjabber__:iq:rpc:fault","Fault","fault"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:fault
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:value",0];
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{Set}     = ["add","Query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{Add}     = ["Query","__netjabber__:iq:rpc:value","Value","value"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:params
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:param"];
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{Set}     = ["add","Query","__netjabber__:iq:rpc:param"];
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:param"];
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{Add}     = ["Query","__netjabber__:iq:rpc:param","Param","param"];

$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Params}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:rpc:param"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:param
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:value",0];
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{Set}     = ["add","Query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{Add}     = ["Query","__netjabber__:iq:rpc:value","Value","value"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:value
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Value}->{Get}     = "value";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Value}->{Set}     = ["scalar","value"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Value}->{Defined} = "value";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Value}->{Hash}    = "data";

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{I4}->{Get}     = "i4";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{I4}->{Set}     = ["scalar","i4"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{I4}->{Defined} = "i4";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{I4}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Boolean}->{Get}     = "boolean";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Boolean}->{Set}     = ["scalar","boolean"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Boolean}->{Defined} = "boolean";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Boolean}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{String}->{Get}     = "string";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{String}->{Set}     = ["scalar","string"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{String}->{Defined} = "string";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{String}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Double}->{Get}     = "double";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Double}->{Set}     = ["scalar","double"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Double}->{Defined} = "double";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Double}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{DateTime}->{Get}     = "dateTime.iso8601";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{DateTime}->{Set}     = ["scalar","dateTime.iso8601"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{DateTime}->{Defined} = "dateTime.iso8601";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{DateTime}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Base64}->{Get}     = "base64";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Base64}->{Set}     = ["scalar","base64"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Base64}->{Defined} = "base64";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Base64}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:struct",0];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{Set}     = ["add","Query","__netjabber__:iq:rpc:struct"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:struct"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{Add}     = ["Query","__netjabber__:iq:rpc:struct","Struct","struct"];

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:array",0];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{Set}     = ["add","Query","__netjabber__:iq:rpc:array"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:array"];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{Add}     = ["Query","__netjabber__:iq:rpc:array","Array","array"];

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Value}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Value}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:struct
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:struct:member"];
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{Set}     = ["add","Query","__netjabber__:iq:rpc:struct:member"];
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:struct:member"];
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{Add}     = ["Query","__netjabber__:iq:rpc:struct:member","Member","member"];

$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Members}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:rpc:struct:member"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:struct:member
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Name}->{Get}     = "name";
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Name}->{Defined} = "name";
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Name}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:value",0];
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{Set}     = ["add","Query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{Add}     = ["Query","__netjabber__:iq:rpc:value","Value","value"];

$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Member}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Member}->{Set} = ["master"];


#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:array
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:array:data"];
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{Set}     = ["add","Query","__netjabber__:iq:rpc:array:data"];
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:array:data"];
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{Add}     = ["Query","__netjabber__:iq:rpc:array:data","Data","data"];

$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Datas}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:rpc:array:data"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:array:data
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:rpc:value",0];
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{Set}     = ["add","Query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:rpc:value"];
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{Hash}    = "child-add";
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{Add}     = ["Query","__netjabber__:iq:rpc:value","Value","value"];


#-----------------------------------------------------------------------------
# jabber:iq:search
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:search"}->{Email}->{Get}     = "email";
$NAMESPACES{"jabber:iq:search"}->{Email}->{Set}     = ["scalar","email"];
$NAMESPACES{"jabber:iq:search"}->{Email}->{Defined} = "email";
$NAMESPACES{"jabber:iq:search"}->{Email}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{First}->{Get}     = "first";
$NAMESPACES{"jabber:iq:search"}->{First}->{Set}     = ["scalar","first"];
$NAMESPACES{"jabber:iq:search"}->{First}->{Defined} = "first";
$NAMESPACES{"jabber:iq:search"}->{First}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Family}->{Get}     = "family";
$NAMESPACES{"jabber:iq:search"}->{Family}->{Set}     = ["scalar","family"];
$NAMESPACES{"jabber:iq:search"}->{Family}->{Defined} = "family";
$NAMESPACES{"jabber:iq:search"}->{Family}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Given}->{Get}     = "given";
$NAMESPACES{"jabber:iq:search"}->{Given}->{Set}     = ["scalar","given"];
$NAMESPACES{"jabber:iq:search"}->{Given}->{Defined} = "given";
$NAMESPACES{"jabber:iq:search"}->{Given}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Instructions}->{Get}     = "instructions";
$NAMESPACES{"jabber:iq:search"}->{Instructions}->{Set}     = ["scalar","instructions"];
$NAMESPACES{"jabber:iq:search"}->{Instructions}->{Defined} = "instructions";
$NAMESPACES{"jabber:iq:search"}->{Instructions}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Key}->{Get}     = "key";
$NAMESPACES{"jabber:iq:search"}->{Key}->{Set}     = ["scalar","key"];
$NAMESPACES{"jabber:iq:search"}->{Key}->{Defined} = "key";
$NAMESPACES{"jabber:iq:search"}->{Key}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Last}->{Get}     = "last";
$NAMESPACES{"jabber:iq:search"}->{Last}->{Set}     = ["scalar","last"];
$NAMESPACES{"jabber:iq:search"}->{Last}->{Defined} = "last";
$NAMESPACES{"jabber:iq:search"}->{Last}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Name}->{Get}     = "name";
$NAMESPACES{"jabber:iq:search"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"jabber:iq:search"}->{Name}->{Defined} = "name";
$NAMESPACES{"jabber:iq:search"}->{Name}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Nick}->{Get}     = "nick";
$NAMESPACES{"jabber:iq:search"}->{Nick}->{Set}     = ["scalar","nick"];
$NAMESPACES{"jabber:iq:search"}->{Nick}->{Defined} = "nick";
$NAMESPACES{"jabber:iq:search"}->{Nick}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:search"}->{Truncated}->{Get}     = "truncated";
$NAMESPACES{"jabber:iq:search"}->{Truncated}->{Set}     = ["flag","truncated"];
$NAMESPACES{"jabber:iq:search"}->{Truncated}->{Defined} = "truncated";
$NAMESPACES{"jabber:iq:search"}->{Truncated}->{Hash}    = "child-flag";

$NAMESPACES{"jabber:iq:search"}->{Search}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:search"}->{Search}->{Set} = ["master"];

$NAMESPACES{"jabber:iq:search"}->{Item}->{Get}     = ["__netjabber__:children:query","__netjabber__:iq:search:item"];
$NAMESPACES{"jabber:iq:search"}->{Item}->{Set}     = ["add","Query","__netjabber__:iq:search:item"];
$NAMESPACES{"jabber:iq:search"}->{Item}->{Defined} = ["__netjabber__:children:query","__netjabber__:iq:search:item"];
$NAMESPACES{"jabber:iq:search"}->{Item}->{Hash}    = "child-add";

$NAMESPACES{"jabber:iq:search"}->{Item}->{Add} = ["Query","__netjabber__:iq:search:item","Item","item"];

$NAMESPACES{"jabber:iq:search"}->{Items}->{Get} = ["__netjabber__:children:query","__netjabber__:iq:search:item"];

#-----------------------------------------------------------------------------
# __netjabber__:iq:search:item
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:search:item"}->{Email}->{Get}     = "email";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Email}->{Set}     = ["scalar","email"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{Email}->{Defined} = "email";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Email}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{First}->{Get}     = "first";
$NAMESPACES{"__netjabber__:iq:search:item"}->{First}->{Set}     = ["scalar","first"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{First}->{Defined} = "first";
$NAMESPACES{"__netjabber__:iq:search:item"}->{First}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{Family}->{Get}     = "family";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Family}->{Set}     = ["scalar","family"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{Family}->{Defined} = "family";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Family}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{Given}->{Get}     = "given";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Given}->{Set}     = ["scalar","given"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{Given}->{Defined} = "given";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Given}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{JID}->{Get}     = "jid";
$NAMESPACES{"__netjabber__:iq:search:item"}->{JID}->{Set}     = ["jid","jid"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{JID}->{Defined} = "jid";
$NAMESPACES{"__netjabber__:iq:search:item"}->{JID}->{Hash}    = "att";

$NAMESPACES{"__netjabber__:iq:search:item"}->{Key}->{Get}     = "key";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Key}->{Set}     = ["scalar","key"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{Key}->{Defined} = "key";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Key}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{Last}->{Get}     = "last";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Last}->{Set}     = ["scalar","last"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{Last}->{Defined} = "last";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Last}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{Name}->{Get}     = "name";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{Name}->{Defined} = "name";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Name}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{Nick}->{Get}     = "nick";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Nick}->{Set}     = ["scalar","nick"];
$NAMESPACES{"__netjabber__:iq:search:item"}->{Nick}->{Defined} = "nick";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Nick}->{Hash}    = "child-data";

$NAMESPACES{"__netjabber__:iq:search:item"}->{Item}->{Get} = "__netjabber__:master";
$NAMESPACES{"__netjabber__:iq:search:item"}->{Item}->{Set} = ["master"];

#-----------------------------------------------------------------------------
# jabber:iq:time
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:time"}->{Display}->{Get}     = "display";
$NAMESPACES{"jabber:iq:time"}->{Display}->{Set}     = ["special","display"];
$NAMESPACES{"jabber:iq:time"}->{Display}->{Defined} = "display";
$NAMESPACES{"jabber:iq:time"}->{Display}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:time"}->{TZ}->{Get}     = "tz";
$NAMESPACES{"jabber:iq:time"}->{TZ}->{Set}     = ["special","tz"];
$NAMESPACES{"jabber:iq:time"}->{TZ}->{Defined} = "tz";
$NAMESPACES{"jabber:iq:time"}->{TZ}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:time"}->{UTC}->{Get}     = "utc";
$NAMESPACES{"jabber:iq:time"}->{UTC}->{Set}     = ["special","utc"];
$NAMESPACES{"jabber:iq:time"}->{UTC}->{Defined} = "utc";
$NAMESPACES{"jabber:iq:time"}->{UTC}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:time"}->{Time}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:time"}->{Time}->{Set} = ["master","all"];

#-----------------------------------------------------------------------------
# jabber:iq:version
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:version"}->{Name}->{Get}     = "name";
$NAMESPACES{"jabber:iq:version"}->{Name}->{Set}     = ["scalar","name"];
$NAMESPACES{"jabber:iq:version"}->{Name}->{Defined} = "name";
$NAMESPACES{"jabber:iq:version"}->{Name}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:version"}->{OS}->{Get}     = "os";
$NAMESPACES{"jabber:iq:version"}->{OS}->{Set}     = ["special","os"];
$NAMESPACES{"jabber:iq:version"}->{OS}->{Defined} = "os";
$NAMESPACES{"jabber:iq:version"}->{OS}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:version"}->{Ver}->{Get}     = "version";
$NAMESPACES{"jabber:iq:version"}->{Ver}->{Set}     = ["special","version"];
$NAMESPACES{"jabber:iq:version"}->{Ver}->{Defined} = "version";
$NAMESPACES{"jabber:iq:version"}->{Ver}->{Hash}    = "child-data";

$NAMESPACES{"jabber:iq:version"}->{Version}->{Get} = "__netjabber__:master";
$NAMESPACES{"jabber:iq:version"}->{Version}->{Set} = ["master","all"];


##############################################################################
#
# GetResults - helper function for jabber:iq:search to easily get the items
#              back in a hash format.
#
##############################################################################
sub GetResults {
  my $self = shift;
  my %results;
  foreach my $item ($self->GetItems()) {
    my %result;
    my @xData = $item->GetX("jabber:x:data");
    if ($#xData == -1) {
      %result = $item->GetItem();
    } else {
      foreach my $field ($xData[0]->GetFields()) {
	$result{$field->GetVar()} = $field->GetValue();
      }
    }
    $results{$item->GetJID()} = \%result;
  }
  return %results;
}


1;
