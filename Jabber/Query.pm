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
  string   GetURL()          SetURL()          DefinedURL()
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

$VERSION = "1.28";

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = { };

    $self->{VERSION} = $VERSION;

    bless($self, $proto);

    $self->{DEBUGHEADER} = "Query";

    $self->{DATA} = {};
    $self->{CHILDREN} = {};

    $self->{TAG} = "query";

    if ("@_" ne (""))
    {
        if (ref($_[0]) eq "Net::Jabber::Query")
        {
            return $_[0];
        }
        elsif (ref($_[0]) eq "")
        {
            $self->{TAG} = shift;
            $self->{TREE} = new XML::Stream::Node($self->{TAG});
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

$FUNCTIONS{XMLNS}->{XPath}->{Path}  = '@xmlns';

$FUNCTIONS{Query}->{XPath}->{Type}  = 'node';
$FUNCTIONS{Query}->{XPath}->{Path}  = '*[@xmlns]';
$FUNCTIONS{Query}->{XPath}->{Child} = 'Query';
$FUNCTIONS{Query}->{XPath}->{Calls} = ['Get','Defined'];

$FUNCTIONS{X}->{XPath}->{Type}  = 'node';
$FUNCTIONS{X}->{XPath}->{Path}  = '*[@xmlns]';
$FUNCTIONS{X}->{XPath}->{Child} = 'X';
$FUNCTIONS{X}->{XPath}->{Calls} = ['Get','Defined'];

#-----------------------------------------------------------------------------
# jabber:iq:agent
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:agent"}->{Agents}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:agent"}->{Agents}->{XPath}->{Path}  = 'agents';

$NAMESPACES{"jabber:iq:agent"}->{Description}->{XPath}->{Path}  = 'description/text()';

$NAMESPACES{"jabber:iq:agent"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"jabber:iq:agent"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"jabber:iq:agent"}->{Name}->{XPath}->{Path}  = 'name/text()';

$NAMESPACES{"jabber:iq:agent"}->{GroupChat}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:agent"}->{GroupChat}->{XPath}->{Path}  = 'groupchat';

$NAMESPACES{"jabber:iq:agent"}->{Register}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:agent"}->{Register}->{XPath}->{Path}  = 'register';

$NAMESPACES{"jabber:iq:agent"}->{Search}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:agent"}->{Search}->{XPath}->{Path}  = 'search';

$NAMESPACES{"jabber:iq:agent"}->{Service}->{XPath}->{Path}  = 'service/text()';

$NAMESPACES{"jabber:iq:agent"}->{Transport}->{XPath}->{Path}  = 'transport/text()';

$NAMESPACES{"jabber:iq:agent"}->{URL}->{XPath}->{Path}  = 'url/text()';

$NAMESPACES{"jabber:iq:agent"}->{Agent}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:agents
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{XPath}->{Path}  = 'agent';
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{XPath}->{Child} = ['Query','jabber:iq:agent',"__netjabber__:skip_xmlns"];
$NAMESPACES{"jabber:iq:agents"}->{Agent}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:agents"}->{Agents}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:agents"}->{Agents}->{XPath}->{Path}  = 'agent';
$NAMESPACES{"jabber:iq:agents"}->{Agents}->{XPath}->{Child} = ['Query','jabber:iq:agent'];
$NAMESPACES{"jabber:iq:agents"}->{Agents}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# jabber:iq:auth
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:auth"}->{Digest}->{XPath}->{Path}  = 'digest/text()';

$NAMESPACES{"jabber:iq:auth"}->{Hash}->{XPath}->{Path}  = 'hash/text()';

$NAMESPACES{"jabber:iq:auth"}->{Password}->{XPath}->{Path}  = 'password/text()';

$NAMESPACES{"jabber:iq:auth"}->{Resource}->{XPath}->{Path}  = 'resource/text()';

$NAMESPACES{"jabber:iq:auth"}->{Sequence}->{XPath}->{Path}  = 'sequence/text()';

$NAMESPACES{"jabber:iq:auth"}->{Token}->{XPath}->{Path}  = 'token/text()';

$NAMESPACES{"jabber:iq:auth"}->{Username}->{XPath}->{Path}  = 'username/text()';

$NAMESPACES{"jabber:iq:auth"}->{Auth}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:autoupdate
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{XPath}->{Path}  = 'beta';
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{"jabber:iq:autoupdate"}->{Beta}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{XPath}->{Path}  = 'dev';
$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{"jabber:iq:autoupdate"}->{Dev}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{XPath}->{Path}  = 'release';
$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{"jabber:iq:autoupdate"}->{Release}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:autoupdate"}->{Releases}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:autoupdate"}->{Releases}->{XPath}->{Path}  = '*';
$NAMESPACES{"jabber:iq:autoupdate"}->{Releases}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{"jabber:iq:autoupdate"}->{Releases}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:autoupdate:release
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Desc}->{XPath}->{Path}  = 'desc/text()';

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Priority}->{XPath}->{Path}  = '@priority';

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{URL}->{XPath}->{Path}  = 'url/text()';

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Version}->{XPath}->{Path}  = 'version/text()';

$NAMESPACES{"__netjabber__:iq:autoupdate:release"}->{Release}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:browse
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:browse"}->{Category}->{XPath}->{Path}  = '@category';

$NAMESPACES{"jabber:iq:browse"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"jabber:iq:browse"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"jabber:iq:browse"}->{Name}->{XPath}->{Path}  = '@name';

$NAMESPACES{"jabber:iq:browse"}->{Type}->{XPath}->{Path}  = '@type';

$NAMESPACES{"jabber:iq:browse"}->{NS}->{XPath}->{Type}  = 'array';
$NAMESPACES{"jabber:iq:browse"}->{NS}->{XPath}->{Path}  = 'ns/text()';

$NAMESPACES{"jabber:iq:browse"}->{Browse}->{XPath}->{Type}  = 'master';

$NAMESPACES{"jabber:iq:browse"}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:browse"}->{Item}->{XPath}->{Path}  = '*[name() != "ns"]';
$NAMESPACES{"jabber:iq:browse"}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse','__netjabber__:specifyname','item'];
$NAMESPACES{"jabber:iq:browse"}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:browse"}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:browse"}->{Items}->{XPath}->{Path}  = '*[name() != "ns"]';
$NAMESPACES{"jabber:iq:browse"}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse'];
$NAMESPACES{"jabber:iq:browse"}->{Items}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:browse
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:browse"}->{Category}->{XPath}->{Path}  = '@category';

$NAMESPACES{"__netjabber__:iq:browse"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"__netjabber__:iq:browse"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"__netjabber__:iq:browse"}->{Name}->{XPath}->{Path}  = '@name';

$NAMESPACES{"__netjabber__:iq:browse"}->{Type}->{XPath}->{Path}  = '@type';

$NAMESPACES{"__netjabber__:iq:browse"}->{NS}->{XPath}->{Type}  = 'array';
$NAMESPACES{"__netjabber__:iq:browse"}->{NS}->{XPath}->{Path}  = 'ns/text()';

$NAMESPACES{"__netjabber__:iq:browse"}->{Browse}->{XPath}->{Type}  = 'master';

$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{XPath}->{Path}  = '*[name() != "ns"]';
$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse','__netjabber__:specifyname','item'];
$NAMESPACES{"__netjabber__:iq:browse"}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"__netjabber__:iq:browse"}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:browse"}->{Items}->{XPath}->{Path}  = '*[name() != "ns"]';
$NAMESPACES{"__netjabber__:iq:browse"}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse'];
$NAMESPACES{"__netjabber__:iq:browse"}->{Items}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# jabber:iq:conference
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:conference"}->{ID}->{XPath}->{Path}  = 'id/text()';

$NAMESPACES{"jabber:iq:conference"}->{Name}->{XPath}->{Path}  = 'name/text()';

$NAMESPACES{"jabber:iq:conference"}->{Nick}->{XPath}->{Path}  = 'nick/text()';

$NAMESPACES{"jabber:iq:conference"}->{Privacy}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:conference"}->{Privacy}->{XPath}->{Path}  = 'privacy';

$NAMESPACES{"jabber:iq:conference"}->{Secret}->{XPath}->{Path}  = 'secret/text()';

$NAMESPACES{"jabber:iq:conference"}->{Conference}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:filter
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{XPath}->{Path}  = 'rule';
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{XPath}->{Child} = ['Query','__netjabber__:iq:filter:rule'];
$NAMESPACES{"jabber:iq:filter"}->{Rule}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:filter"}->{Rules}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:filter"}->{Rules}->{XPath}->{Path}  = 'rule';
$NAMESPACES{"jabber:iq:filter"}->{Rules}->{XPath}->{Child} = ['Query','__netjabber__:iq:filter:rule'];
$NAMESPACES{"jabber:iq:filter"}->{Rules}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:filter:rule
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Body}->{XPath}->{Path}  = 'body/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Continued}->{XPath}->{Path}  = 'continued/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Drop}->{XPath}->{Path}  = 'drop/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Edit}->{XPath}->{Path}  = 'edit/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Error}->{XPath}->{Path}  = 'error/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{From}->{XPath}->{Path}  = 'from/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Offline}->{XPath}->{Path}  = 'offline/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Reply}->{XPath}->{Path}  = 'reply/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Resource}->{XPath}->{Path}  = 'resource/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Show}->{XPath}->{Path}  = 'show/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Size}->{XPath}->{Path}  = 'size/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Subject}->{XPath}->{Path}  = 'subject/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Time}->{XPath}->{Path}  = 'time/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Type}->{XPath}->{Path}  = 'type/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Unavailable}->{XPath}->{Path}  = 'unavailable/text()';

$NAMESPACES{"__netjabber__:iq:filter:rule"}->{Rule}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:gateway
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:gateway"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"jabber:iq:gateway"}->{JID}->{XPath}->{Path}  = 'jid/text()';

$NAMESPACES{"jabber:iq:gateway"}->{Desc}->{XPath}->{Path}  = 'desc/text()';

$NAMESPACES{"jabber:iq:gateway"}->{Prompt}->{XPath}->{Path}  = 'prompt/text()';

$NAMESPACES{"jabber:iq:gateway"}->{Gateway}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:last
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:last"}->{Message}->{XPath}->{Path}  = 'text()';

$NAMESPACES{"jabber:iq:last"}->{Seconds}->{XPath}->{Path}  = '@seconds';

$NAMESPACES{"jabber:iq:last"}->{Last}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:oob
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:oob"}->{Desc}->{XPath}->{Path}  = 'desc/text()';

$NAMESPACES{"jabber:iq:oob"}->{URL}->{XPath}->{Path}  = 'url/text()';

$NAMESPACES{"jabber:iq:oob"}->{Oob}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:pass
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:pass"}->{Client}->{XPath}->{Path}  = 'client/text()';

$NAMESPACES{"jabber:iq:pass"}->{ClientPort}->{XPath}->{Path}  = 'client/@port';

$NAMESPACES{"jabber:iq:pass"}->{Close}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:pass"}->{Close}->{XPath}->{Path}  = 'close';

$NAMESPACES{"jabber:iq:pass"}->{Expire}->{XPath}->{Path}  = 'expire/text()';

$NAMESPACES{"jabber:iq:pass"}->{OneShot}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:pass"}->{OneShot}->{XPath}->{Path}  = 'oneshot';

$NAMESPACES{"jabber:iq:pass"}->{Proxy}->{XPath}->{Path}  = 'proxy/text()';

$NAMESPACES{"jabber:iq:pass"}->{ProxyPort}->{XPath}->{Path}  = 'proxy/@port';

$NAMESPACES{"jabber:iq:pass"}->{Server}->{XPath}->{Path}  = 'server/text()';

$NAMESPACES{"jabber:iq:pass"}->{ServerPort}->{XPath}->{Path}  = 'server/@port';

$NAMESPACES{"jabber:iq:pass"}->{Pass}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:register
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:register"}->{Address}->{XPath}->{Path}  = 'address/text()';

$NAMESPACES{"jabber:iq:register"}->{City}->{XPath}->{Path}  = 'city/text()';

$NAMESPACES{"jabber:iq:register"}->{Date}->{XPath}->{Path}  = 'date/text()';

$NAMESPACES{"jabber:iq:register"}->{Email}->{XPath}->{Path}  = 'email/text()';

$NAMESPACES{"jabber:iq:register"}->{First}->{XPath}->{Path}  = 'first/text()';

$NAMESPACES{"jabber:iq:register"}->{Instructions}->{XPath}->{Path}  = 'instructions/text()';

$NAMESPACES{"jabber:iq:register"}->{Key}->{XPath}->{Path}  = 'key/text()';

$NAMESPACES{"jabber:iq:register"}->{Last}->{XPath}->{Path}  = 'last/text()';

$NAMESPACES{"jabber:iq:register"}->{Misc}->{XPath}->{Path}  = 'misc/text()';

$NAMESPACES{"jabber:iq:register"}->{Name}->{XPath}->{Path}  = 'name/text()';

$NAMESPACES{"jabber:iq:register"}->{Nick}->{XPath}->{Path}  = 'nick/text()';

$NAMESPACES{"jabber:iq:register"}->{Password}->{XPath}->{Path}  = 'password/text()';

$NAMESPACES{"jabber:iq:register"}->{Phone}->{XPath}->{Path}  = 'phone/text()';

$NAMESPACES{"jabber:iq:register"}->{Registered}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:register"}->{Registered}->{XPath}->{Path}  = 'registered';

$NAMESPACES{"jabber:iq:register"}->{Remove}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:register"}->{Remove}->{XPath}->{Path}  = 'remove';

$NAMESPACES{"jabber:iq:register"}->{State}->{XPath}->{Path}  = 'state/text()';

$NAMESPACES{"jabber:iq:register"}->{Text}->{XPath}->{Path}  = 'text/text()';

$NAMESPACES{"jabber:iq:register"}->{URL}->{XPath}->{Path}  = 'url/text()';

$NAMESPACES{"jabber:iq:register"}->{Username}->{XPath}->{Path}  = 'username/text()';

$NAMESPACES{"jabber:iq:register"}->{Zip}->{XPath}->{Path}  = 'zip/text()';

$NAMESPACES{"jabber:iq:register"}->{Register}->{XPath}->{Type}  = 'master';
$NAMESPACES{"jabber:iq:register"}->{Register}->{XPath}->{Path}  = '*/name()';

#-----------------------------------------------------------------------------
# jabber:iq:roster
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:roster"}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:roster"}->{Item}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:iq:roster"}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:roster:item'];
$NAMESPACES{"jabber:iq:roster"}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:roster"}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:roster"}->{Items}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:iq:roster"}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:roster:item'];
$NAMESPACES{"jabber:iq:roster"}->{Items}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:roster:item
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Ask}->{XPath}->{Path}  = '@ask';

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Group}->{XPath}->{Type}  = 'array';
$NAMESPACES{"__netjabber__:iq:roster:item"}->{Group}->{XPath}->{Path}  = 'group/text()';

$NAMESPACES{"__netjabber__:iq:roster:item"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"__netjabber__:iq:roster:item"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Name}->{XPath}->{Path}  = '@name';

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Subscription}->{XPath}->{Path}  = '@subscription';

$NAMESPACES{"__netjabber__:iq:roster:item"}->{Item}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:rpc
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{XPath}->{Path}  = 'methodCall';
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:methodCall'];
$NAMESPACES{"jabber:iq:rpc"}->{MethodCall}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{XPath}->{Path}  = 'methodResponse';
$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:methodResponse'];
$NAMESPACES{"jabber:iq:rpc"}->{MethodResponse}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:methodCall
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodName}->{XPath}->{Path}  = 'methodName/text()';

$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{XPath}->{Path}  = 'params';
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:params'];
$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{Params}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{"__netjabber__:iq:rpc:methodCall"}->{MethodCall}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:methodResponse
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{XPath}->{Path}  = 'params';
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:params'];
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Params}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{XPath}->{Path}  = 'fault';
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:fault'];
$NAMESPACES{"__netjabber__:iq:rpc:methodResponse"}->{Fault}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:fault
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{XPath}->{Path}  = 'value';
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{"__netjabber__:iq:rpc:fault"}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:params
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{XPath}->{Type}  = 'node';
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{XPath}->{Path}  = 'param';
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:param'];
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Param}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Params}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Params}->{XPath}->{Path}  = 'param';
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Params}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:param'];
$NAMESPACES{"__netjabber__:iq:rpc:params"}->{Params}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:param
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{XPath}->{Path}  = 'value';
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{"__netjabber__:iq:rpc:param"}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:value
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Base64}->{XPath}->{Path}  = 'base64/text()';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Boolean}->{XPath}->{Path}  = 'boolean/text()';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{DateTime}->{XPath}->{Path}  = 'dateTime.iso8601/text()';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Double}->{XPath}->{Path}  = 'double/text()';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{I4}->{XPath}->{Path}  = 'i4/text()';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{String}->{XPath}->{Path}  = 'string/text()';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Value}->{XPath}->{Path}  = 'value/text()';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{RPCValue}->{XPath}->{Type}  = 'master';

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{XPath}->{Path}  = 'struct';
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:struct'];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Struct}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{XPath}->{Path}  = 'array';
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:array'];
$NAMESPACES{"__netjabber__:iq:rpc:value"}->{Array}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:struct
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{XPath}->{Type}  = 'node';
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{XPath}->{Path}  = 'member';
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:struct:member'];
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Member}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Members}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Members}->{XPath}->{Path}  = 'member';
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Members}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:struct:member'];
$NAMESPACES{"__netjabber__:iq:rpc:struct"}->{Members}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:struct:member
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Name}->{XPath}->{Path}  = 'name/text()';

$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{XPath}->{Path}  = 'value';
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{"__netjabber__:iq:rpc:struct:member"}->{Member}->{XPath}->{Type}  = 'master';


#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:array
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{XPath}->{Type}  = 'node';
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{XPath}->{Path}  = 'data';
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:array:data'];
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Data}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Datas}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Datas}->{XPath}->{Path}  = 'data';
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Datas}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:array:data'];
$NAMESPACES{"__netjabber__:iq:rpc:array"}->{Datas}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:array:data
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{XPath}->{Type}  = 'children';
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{XPath}->{Path}  = 'value';
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{"__netjabber__:iq:rpc:array:data"}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# jabber:iq:search
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:search"}->{Email}->{XPath}->{Path}  = 'email/text()';

$NAMESPACES{"jabber:iq:search"}->{Family}->{XPath}->{Path}  = 'family/text()';

$NAMESPACES{"jabber:iq:search"}->{First}->{XPath}->{Path}  = 'first/text()';

$NAMESPACES{"jabber:iq:search"}->{Given}->{XPath}->{Path}  = 'given/text()';

$NAMESPACES{"jabber:iq:search"}->{Instructions}->{XPath}->{Path}  = 'instructions/text()';

$NAMESPACES{"jabber:iq:search"}->{Key}->{XPath}->{Path}  = 'key/text()';

$NAMESPACES{"jabber:iq:search"}->{Last}->{XPath}->{Path}  = 'last/text()';

$NAMESPACES{"jabber:iq:search"}->{Name}->{XPath}->{Path}  = 'name/text()';

$NAMESPACES{"jabber:iq:search"}->{Nick}->{XPath}->{Path}  = 'nick/text()';

$NAMESPACES{"jabber:iq:search"}->{Truncated}->{XPath}->{Type}  = 'flag';
$NAMESPACES{"jabber:iq:search"}->{Truncated}->{XPath}->{Path}  = 'truncated';

$NAMESPACES{"jabber:iq:search"}->{Search}->{XPath}->{Type}  = 'master';

$NAMESPACES{"jabber:iq:search"}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{"jabber:iq:search"}->{Item}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:iq:search"}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:search:item'];
$NAMESPACES{"jabber:iq:search"}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{"jabber:iq:search"}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{"jabber:iq:search"}->{Items}->{XPath}->{Path}  = 'item';
$NAMESPACES{"jabber:iq:search"}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:search:item'];
$NAMESPACES{"jabber:iq:search"}->{Items}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:search:item
#-----------------------------------------------------------------------------
$NAMESPACES{"__netjabber__:iq:search:item"}->{Email}->{XPath}->{Path}  = 'email/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{First}->{XPath}->{Path}  = 'first/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{Family}->{XPath}->{Path}  = 'family/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{Given}->{XPath}->{Path}  = 'given/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{JID}->{XPath}->{Type}  = 'jid';
$NAMESPACES{"__netjabber__:iq:search:item"}->{JID}->{XPath}->{Path}  = '@jid';

$NAMESPACES{"__netjabber__:iq:search:item"}->{Key}->{XPath}->{Path}  = 'key/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{Last}->{XPath}->{Path}  = 'last/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{Name}->{XPath}->{Path}  = 'name/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{Nick}->{XPath}->{Path}  = 'nick/text()';

$NAMESPACES{"__netjabber__:iq:search:item"}->{Item}->{XPath}->{Type}  = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:time
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:time"}->{Display}->{XPath}->{Type}  = ['special','time-display'];
$NAMESPACES{"jabber:iq:time"}->{Display}->{XPath}->{Path}  = 'display/text()';
$NAMESPACES{"jabber:iq:time"}->{Display}->{XPath}->{Calls} = ['Get','Set','Defined'];

$NAMESPACES{"jabber:iq:time"}->{TZ}->{XPath}->{Type}  = ['special','time-tz'];
$NAMESPACES{"jabber:iq:time"}->{TZ}->{XPath}->{Path}  = 'tz/text()';

$NAMESPACES{"jabber:iq:time"}->{UTC}->{XPath}->{Type}  = ['special','time-utc'];
$NAMESPACES{"jabber:iq:time"}->{UTC}->{XPath}->{Path}  = 'utc/text()';

$NAMESPACES{"jabber:iq:time"}->{Time}->{XPath}->{Type}  = ['master','all'];
$NAMESPACES{"jabber:iq:time"}->{Time}->{XPath}->{Calls} = ['Get','Set'];

#-----------------------------------------------------------------------------
# jabber:iq:version
#-----------------------------------------------------------------------------
$NAMESPACES{"jabber:iq:version"}->{Name}->{XPath}->{Path}  = 'name/text()';

$NAMESPACES{"jabber:iq:version"}->{OS}->{XPath}->{Type}  = ['special','version-os'];
$NAMESPACES{"jabber:iq:version"}->{OS}->{XPath}->{Path}  = 'os/text()';

$NAMESPACES{"jabber:iq:version"}->{Ver}->{XPath}->{Type}  = ['special','version-version'];
$NAMESPACES{"jabber:iq:version"}->{Ver}->{XPath}->{Path}  = 'version/text()';

$NAMESPACES{"jabber:iq:version"}->{Version}->{XPath}->{Type}  = ['master','all'];

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/muc#admin
#-----------------------------------------------------------------------------
$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Admin}->{XPath}->{Type}  = 'master';

$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Item}->{XPath}->{Type}  = 'node';
$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Item}->{XPath}->{Path}  = 'item';
$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:muc:admin:item'];
$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Items}->{XPath}->{Type}  = 'children';
$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Items}->{XPath}->{Path}  = 'item';
$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:muc:admin:item'];
$NAMESPACES{'http://jabber.org/protocol/muc#admin'}->{Items}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:muc:admin:item
#-----------------------------------------------------------------------------
$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{ActorJID}->{XPath}->{Type} = 'jid';
$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{ActorJID}->{XPath}->{Path} = 'actor/@jid';

$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{Affiliation}->{XPath}->{Path} = '@affiliation';

$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{Nick}->{XPath}->{Path} = '@nick';

$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{Reason}->{XPath}->{Path} = 'reason/text()';

$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{Role}->{XPath}->{Path} = '@role';

$NAMESPACES{'__netjabber__:iq:muc:admin:item'}->{Item}->{XPath}->{Type} = "master";


##############################################################################
#
# GetResults - helper function for jabber:iq:search to easily get the items
#              back in a hash format.
#
##############################################################################
sub GetResults
{
    my $self = shift;
    my %results;
    foreach my $item ($self->GetItems())
    {
        my %result;
        my @xData = $item->GetX("jabber:x:data");
        if ($#xData == -1) 
        {
            %result = $item->GetItem();
        }
        else
        {
            foreach my $field ($xData[0]->GetFields())
            {
                $result{$field->GetVar()} = $field->GetValue();
            }
        }
        $results{$item->GetJID()} = \%result;
    }
    return %results;
}


1;
