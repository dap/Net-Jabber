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
  set in it.  The current supported namespaces are:

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
    http://jabber.org/protocol/bytestreams
    http://jabber.org/protocol/commands
    http://jabber.org/protocol/disco#info
    http://jabber.org/protocol/disco#items
    http://jabber.org/protocol/feature-neg
    http://jabber.org/protocol/muc#admin
    http://jabber.org/protocol/pubsub
    http://jabber.org/protocol/pubsub#event
    http://jabber.org/protocol/pubsub#owner
    http://jabber.org/protocol/si
    http://jabber.org/protocol/si/profile/file-transfer
    http://jabber.org/protocol/si/profile/tree-transfer
    http://www.jabber.org/protocol/soap # Experimental
    
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
      my ($sid,$IQ) = @_;
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

  Type     Get                 Set                 Defined
  =======  ================    ================    ==================
  objects  GetMethodCall()     AddMethodCall()     DefinedMethodCall()
  objects  GetMethodResponse() AddMethodResponse() DefinedMethodReponse()

=head1 jabber:iq:rpc - methodCall objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetMethodName()   SetMethodName()   DefinedMethodName()
  objects  GetParams()       AddParams()       DefinedParams()
  master   GetMethodCall()   SetMethodCall()
  
=head1 jabber:iq:rpc - methodResponse objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetParams()       AddParams()       DefinedParams()
  objects  GetFault()        AddFault()        DefinedFault()

=head1 jabber:iq:rpc - fault objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetValue()        AddValue()        DefinedValue() 

=head1 jabber:iq:rpc - params objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects                    AddParam()
  objects  GetParams()

=head1 jabber:iq:rpc - param objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetValue()        AddValue()        DefinedValue() 

=head1 jabber:iq:rpc - value objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetBase64()       SetBase64()       DefinedBase64()
  string   GetBoolean()      SetBoolean()      DefinedBoolean()
  string   GetDateTime()     SetDateTime()     DefinedDateTime()
  string   GetDouble()       SetDouble()       DefinedDouble()
  string   GetI4()           SetI4()           DefinedI4()    
  string   GetInt()          SetInt()          DefinedInt()
  string   GetString()       SetString()       DefinedString()
  string   GetValue()        SetValue()        DefinedValue() 
  objects  GetStruct()       AddStruct()       DefinedStruct()
  objects  GetArray()        AddArray()        DefinedArray() 
  master   GetRPCValue()     SetRPCValue()                      

=head1 jabber:iq:rpc - struct objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects                    AddMember()
  objects  GetMembers()

=head1 jabber:iq:rpc - member objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetName()         SetName()         DefinedName()
  objects  GetValue()        AddValue()        DefinedValue()
  master   GetMember()       SetMember()
  
=head1 jabber:iq:rpc - array objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects                    AddData()
  objects  GetDatas()

=head1 jabber:iq:rpc - data objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetValue()        AddValue()        DefinedValue()

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

=head1 http://www.jabber.org/protocol/bytestreams

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetActivate()     SetActivate()     DefinedActivate()
  string   GetStreamHostUsedJID()
                             SetStreamHostUsedJID()
                                               DefinedStreamHostUsedJID()
  string   GetSID()          SetSID()          DefinedSID()
  objects                    AddStreamHost()                    
  objects  GetStreamHosts()                                     
  master   GetByteStreams()  SetByteStreams()

=head1 http://www.jabber.org/protocol/bytestreams streamhost objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetHost()         SetHost()         DefinedHost()
  string   GetJID()          SetJID()          DefinedJID()
  string   GetPort()         SetPort()         DefinedPort()
  string   GetZeroConf()     SetZeroConf()     DefinedZeroConf()
  master   GetStreamHost()   SetStreamHost()

=head1 http://www.jabber.org/protocol/commands

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetAction()       SetAction()       DefinedAction() 
  string   GetNode()         SetNode()         DefinedNode() 
  string   GetSessionID()    SetSessionID()    DefinedSessionID() 
  objects                    AddNote()
  objects  GetNotes()
  master   GetCommand()      SetCommand()

=head1 http://www.jabber.org/protocol/commands note object

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetMessage()      SetMessage()      DefinedMessage() 
  string   GetType()         SetType()         DefinedType() 
  master   GetNote()         SetNote()

=head1 http://www.jabber.org/protocol/disco#info

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode() 
  objects                    AddFeature()
  objects  GetFeatures()
  objects                    AddIdentity()
  objects  GetIdentities()
  master   GetDiscoInfo()    SetDiscoInfo()

=head1 http://www.jabber.org/protocol/disco#info feature objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetVar()          SetVar()          DefinedVar() 
  master   GetFeature()      SetFeature()

=head1 http://www.jabber.org/protocol/disco#info identity objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetCategory()     SetCategory()     DefinedCategory() 
  string   GetName()         SetName()         DefinedName() 
  string   GetType()         SetType()         DefinedType() 
  master   GetIdentity()     SetIdentity()

=head1 http://www.jabber.org/protocol/disco#items

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode() 
  objects                    AddItem()
  objects  GetItems()
  master   GetDiscoItems()   SetDiscoItems()

=head1 http://www.jabber.org/protocol/disco#items item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetAction()       SetAction()       DefinedAction() 
  string   GetJID()          SetJID()          DefinedJID() 
  string   GetName()         SetName()         DefinedName() 
  string   GetNode()         SetNode()         DefinedNode() 
  master   GetItem()         SetItem()

=head1 http://www.jabber.org/protocol/feature-neg

  Type     Get               Set               Defined
  =======  ================  ================  ==================

      This is just a wrapper for x:data to provide it with context.

=head1 http://www.jabber.org/protocol/pubsub

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetAffiliations() AddAffiliations()
  objects  GetConfigure()    AddConfigure()
  objects  GetCreate()       AddCreate()
  objects  GetDelete()       AddDelete()
  objects  GetEntities()     AddEntities()
  objects  GetEntity()       AddEntity()
  objects  GetItems()        AddItems()
  objects  GetItem()         AddItem()
  objects  GetOptions()      AddOptions()
  objects  GetPublish()      AddPublish()
  objects  GetPurge()        AddPurge()
  objects  GetRetract()      AddRetract()
  objects  GetSubscribe()    AddSubscribe()
  objects  GetUnsubscribe()  AddUnsubscribe()

=head1 http://www.jabber.org/protocol/pubsub affiliations objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetEntity()       AddEntity()

=head1 http://www.jabber.org/protocol/pubsub configure objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode()
  master   GetConfigure()    SetConfigure()

=head1 http://www.jabber.org/protocol/pubsub create objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode()
  master   GetCreate()       SetCreate()

=head1 http://www.jabber.org/protocol/pubsub delete objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode()
  master   GetDelete()       SetDelete()

=head1 http://www.jabber.org/protocol/pubsub entity objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetAffiliation()  SetAffiliation()  DefinedAffiliation()
  string   GetJID()          SetJID()          DefinedJID()
  string   GetNode()         SetNode()         DefinedNode()
  string   GetSubscription() SetSubscription() DefinedSubscription()
  objects  GetSubscribeOptions()
                             AddSubscribeOptions()
  master   GetEntity()       SetEntity()

=head1 http://www.jabber.org/protocol/pubsub items objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetItem()         AddItem()
  string   GetMaxItems()     SetMaxItems()     DefinedMaxItems()
  string   GetNode()         SetNode()         DefinedNode()
  master   GetItems()        SetItems()

=head1 http://www.jabber.org/protocol/pubsub item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetID()           SetID()           DefinedID()
  raw      GetPayload()      SetPayload()      DefinedPayload()
  master   GetItem()         SetItem()

=head1 http://www.jabber.org/protocol/pubsub options objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetJID()          SetJID()          DefinedJID()
  string   GetNode()         SetNode()         DefinedNode()
  master   GetOptions()      SetOptions()

=head1 http://www.jabber.org/protocol/pubsub publish objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetItem()         AddItem()
  string   GetNode()         SetNode()         DefinedNode()
  master   GetRetract()      SetRetract()

=head1 http://www.jabber.org/protocol/pubsub purge objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode()
  master   GetPurge()        SetPurge()

=head1 http://www.jabber.org/protocol/pubsub retract objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetItem()         AddItem()
  string   GetNode()         SetNode()         DefinedNode()
  master   GetRetract()      SetRetract()

=head1 http://www.jabber.org/protocol/pubsub subscribe objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetJID()          SetJID()          DefinedJID()
  string   GetNode()         SetNode()         DefinedNode()
  master   GetSubscribe()    SetSubscribe()

=head1 http://www.jabber.org/protocol/pubsub subscribe-options objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  flag     GetRequired()     SetRequired()     DefinedRequired()
  master   GetSubscribeOptions()
                             SetSubscriceOptions()

=head1 http://www.jabber.org/protocol/pubsub unsubscribe objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetJID()          SetJID()          DefinedJID()
  string   GetNode()         SetNode()         DefinedNode()
  master   GetUnsubscribe()  SetUnsubscribe()

=head1 http://www.jabber.org/protocol/pubsub#event

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetDelete()       AddDelete()
  objects  GetItems()        AddItems()

=head1 http://www.jabber.org/protocol/pubsub#event delete objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode()
  master   GetDelete()       SetDelete()

=head1 http://www.jabber.org/protocol/pubsub#event items objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  objects  GetItem()         AddItem()
  string   GetNode()         SetNode()         DefinedNode()
  master   GetItems()        SetItems()

=head1 http://www.jabber.org/protocol/pubsub#event item objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetID()           SetID()           DefinedID()
  raw      GetPayload()      SetPayload()      DefinedPayload()
  master   GetItem()         SetItem()

=head1 http://www.jabber.org/protocol/pubsub#owner

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetAction()       SetAction()       DefinedAction()
  objects  GetConfigure()    AddConfigure()
  master   GetOwner()        SetOwner()
 
=head1 http://www.jabber.org/protocol/pubsub#owner configure objects

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetNode()         SetNode()         DefinedNode()
  master   GetConfigure()    SetConfigure()

=head1 http://www.jabber.org/protocol/si

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetID()           SetID()           DefinedID()
  string   GetMimeType()     SetMimeType()     DefinedMimeType()
  string   GetProfile()      SetProfile()      DefinedProfile()
  master   GetStream()       SetStream()

=head1 http://www.jabber.org/protocol/si/profile/file-transfer

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  string   GetDate()         SetDate()         DefinedDate()
  string   GetDesc()         SetDesc()         DefinedDesc()
  string   GetHash()         SetHash()         DefinedHash()
  string   GetName()         SetName()         DefinedName()
  string   GetRange()        SetRange()        DefinedRange()
  string   GetRangeOffset()  SetRangeOffset()  DefinedRangeOffset()
  string   GetRangeLength()  SetRangeLength()  DefinedRangeLength()
  string   GetSize()         SetSize()         DefinedSize()
  master   GetFile()         SetFile()   

=head1 http://www.jabber.org/protocol/soap - Experimental

  Type     Get               Set               Defined
  =======  ================  ================  ==================
  raw      GetPayload()      SetPayload()      DefinedPayload()
  master   GetSoap()         SetSoap()

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
use vars qw($VERSION %FUNCTIONS %NAMESPACES %TAGS $AUTOLOAD);

$VERSION = "1.30";

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

$FUNCTIONS{XMLNS}->{XPath}->{Path} = '@xmlns';

$FUNCTIONS{Query}->{XPath}->{Type} = 'node';
$FUNCTIONS{Query}->{XPath}->{Path} = '*[@xmlns]';
$FUNCTIONS{Query}->{XPath}->{Child} = 'Query';
$FUNCTIONS{Query}->{XPath}->{Calls} = ['Get','Defined'];

$FUNCTIONS{X}->{XPath}->{Type} = 'node';
$FUNCTIONS{X}->{XPath}->{Path} = '*[@xmlns]';
$FUNCTIONS{X}->{XPath}->{Child} = 'X';
$FUNCTIONS{X}->{XPath}->{Calls} = ['Get','Defined'];

my $ns;

#-----------------------------------------------------------------------------
# jabber:iq:agent
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:agent';

$NAMESPACES{$ns}->{Agents}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Agents}->{XPath}->{Path} = 'agents';

$NAMESPACES{$ns}->{Description}->{XPath}->{Path} = 'description/text()';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = 'name/text()';

$NAMESPACES{$ns}->{GroupChat}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{GroupChat}->{XPath}->{Path} = 'groupchat';

$NAMESPACES{$ns}->{Register}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Register}->{XPath}->{Path} = 'register';

$NAMESPACES{$ns}->{Search}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Search}->{XPath}->{Path} = 'search';

$NAMESPACES{$ns}->{Service}->{XPath}->{Path} = 'service/text()';

$NAMESPACES{$ns}->{Transport}->{XPath}->{Path} = 'transport/text()';

$NAMESPACES{$ns}->{URL}->{XPath}->{Path} = 'url/text()';

$NAMESPACES{$ns}->{Agent}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:agents
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:agents';

$NAMESPACES{$ns}->{Agent}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Agent}->{XPath}->{Path} = 'agent';
$NAMESPACES{$ns}->{Agent}->{XPath}->{Child} = ['Query','jabber:iq:agent',"__netjabber__:skip_xmlns"];
$NAMESPACES{$ns}->{Agent}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Agents}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Agents}->{XPath}->{Path} = 'agent';
$NAMESPACES{$ns}->{Agents}->{XPath}->{Child} = ['Query','jabber:iq:agent'];
$NAMESPACES{$ns}->{Agents}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# jabber:iq:auth
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:auth';

$NAMESPACES{$ns}->{Digest}->{XPath}->{Path} = 'digest/text()';

$NAMESPACES{$ns}->{Hash}->{XPath}->{Path} = 'hash/text()';

$NAMESPACES{$ns}->{Password}->{XPath}->{Path} = 'password/text()';

$NAMESPACES{$ns}->{Resource}->{XPath}->{Path} = 'resource/text()';

$NAMESPACES{$ns}->{Sequence}->{XPath}->{Path} = 'sequence/text()';

$NAMESPACES{$ns}->{Token}->{XPath}->{Path} = 'token/text()';

$NAMESPACES{$ns}->{Username}->{XPath}->{Path} = 'username/text()';

$NAMESPACES{$ns}->{Auth}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:autoupdate
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:autoupdate';

$NAMESPACES{$ns}->{Beta}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Beta}->{XPath}->{Path} = 'beta';
$NAMESPACES{$ns}->{Beta}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{$ns}->{Beta}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Dev}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Dev}->{XPath}->{Path} = 'dev';
$NAMESPACES{$ns}->{Dev}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{$ns}->{Dev}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Release}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Release}->{XPath}->{Path} = 'release';
$NAMESPACES{$ns}->{Release}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{$ns}->{Release}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Releases}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Releases}->{XPath}->{Path} = '*';
$NAMESPACES{$ns}->{Releases}->{XPath}->{Child} = ['Query','__netjabber__:iq:autoupdate:release'];
$NAMESPACES{$ns}->{Releases}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:autoupdate:release
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:autoupdate:release';

$NAMESPACES{$ns}->{Desc}->{XPath}->{Path} = 'desc/text()';

$NAMESPACES{$ns}->{Priority}->{XPath}->{Path} = '@priority';

$NAMESPACES{$ns}->{URL}->{XPath}->{Path} = 'url/text()';

$NAMESPACES{$ns}->{Version}->{XPath}->{Path} = 'version/text()';

$NAMESPACES{$ns}->{Release}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:browse
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:browse';

$NAMESPACES{$ns}->{Category}->{XPath}->{Path} = '@category';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{Type}->{XPath}->{Path} = '@type';

$NAMESPACES{$ns}->{NS}->{XPath}->{Type} = 'array';
$NAMESPACES{$ns}->{NS}->{XPath}->{Path} = 'ns/text()';

$NAMESPACES{$ns}->{Browse}->{XPath}->{Type} = 'master';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = '*[name() != "ns"]';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse','__netjabber__:specifyname','item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = '*[name() != "ns"]';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:browse
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:browse';

$NAMESPACES{$ns}->{Category}->{XPath}->{Path} = '@category';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{Type}->{XPath}->{Path} = '@type';

$NAMESPACES{$ns}->{NS}->{XPath}->{Type} = 'array';
$NAMESPACES{$ns}->{NS}->{XPath}->{Path} = 'ns/text()';

$NAMESPACES{$ns}->{Browse}->{XPath}->{Type} = 'master';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = '*[name() != "ns"]';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse','__netjabber__:specifyname','item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = '*[name() != "ns"]';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:browse'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# jabber:iq:conference
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:conference';

$NAMESPACES{$ns}->{ID}->{XPath}->{Path} = 'id/text()';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = 'name/text()';

$NAMESPACES{$ns}->{Nick}->{XPath}->{Path} = 'nick/text()';

$NAMESPACES{$ns}->{Privacy}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Privacy}->{XPath}->{Path} = 'privacy';

$NAMESPACES{$ns}->{Secret}->{XPath}->{Path} = 'secret/text()';

$NAMESPACES{$ns}->{Conference}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:filter
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:filter';

$NAMESPACES{$ns}->{Rule}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Rule}->{XPath}->{Path} = 'rule';
$NAMESPACES{$ns}->{Rule}->{XPath}->{Child} = ['Query','__netjabber__:iq:filter:rule'];
$NAMESPACES{$ns}->{Rule}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Rules}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Rules}->{XPath}->{Path} = 'rule';
$NAMESPACES{$ns}->{Rules}->{XPath}->{Child} = ['Query','__netjabber__:iq:filter:rule'];
$NAMESPACES{$ns}->{Rules}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:filter:rule
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:filter:rule';

$NAMESPACES{$ns}->{Body}->{XPath}->{Path} = 'body/text()';

$NAMESPACES{$ns}->{Continued}->{XPath}->{Path} = 'continued/text()';

$NAMESPACES{$ns}->{Drop}->{XPath}->{Path} = 'drop/text()';

$NAMESPACES{$ns}->{Edit}->{XPath}->{Path} = 'edit/text()';

$NAMESPACES{$ns}->{Error}->{XPath}->{Path} = 'error/text()';

$NAMESPACES{$ns}->{From}->{XPath}->{Path} = 'from/text()';

$NAMESPACES{$ns}->{Offline}->{XPath}->{Path} = 'offline/text()';

$NAMESPACES{$ns}->{Reply}->{XPath}->{Path} = 'reply/text()';

$NAMESPACES{$ns}->{Resource}->{XPath}->{Path} = 'resource/text()';

$NAMESPACES{$ns}->{Show}->{XPath}->{Path} = 'show/text()';

$NAMESPACES{$ns}->{Size}->{XPath}->{Path} = 'size/text()';

$NAMESPACES{$ns}->{Subject}->{XPath}->{Path} = 'subject/text()';

$NAMESPACES{$ns}->{Time}->{XPath}->{Path} = 'time/text()';

$NAMESPACES{$ns}->{Type}->{XPath}->{Path} = 'type/text()';

$NAMESPACES{$ns}->{Unavailable}->{XPath}->{Path} = 'unavailable/text()';

$NAMESPACES{$ns}->{Rule}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:gateway
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:gateway';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = 'jid/text()';

$NAMESPACES{$ns}->{Desc}->{XPath}->{Path} = 'desc/text()';

$NAMESPACES{$ns}->{Prompt}->{XPath}->{Path} = 'prompt/text()';

$NAMESPACES{$ns}->{Gateway}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:last
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:last';

$NAMESPACES{$ns}->{Message}->{XPath}->{Path} = 'text()';

$NAMESPACES{$ns}->{Seconds}->{XPath}->{Path} = '@seconds';

$NAMESPACES{$ns}->{Last}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:oob
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:oob';

$NAMESPACES{$ns}->{Desc}->{XPath}->{Path} = 'desc/text()';

$NAMESPACES{$ns}->{URL}->{XPath}->{Path} = 'url/text()';

$NAMESPACES{$ns}->{Oob}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:pass
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:pass';

$NAMESPACES{$ns}->{Client}->{XPath}->{Path} = 'client/text()';

$NAMESPACES{$ns}->{ClientPort}->{XPath}->{Path} = 'client/@port';

$NAMESPACES{$ns}->{Close}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Close}->{XPath}->{Path} = 'close';

$NAMESPACES{$ns}->{Expire}->{XPath}->{Path} = 'expire/text()';

$NAMESPACES{$ns}->{OneShot}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{OneShot}->{XPath}->{Path} = 'oneshot';

$NAMESPACES{$ns}->{Proxy}->{XPath}->{Path} = 'proxy/text()';

$NAMESPACES{$ns}->{ProxyPort}->{XPath}->{Path} = 'proxy/@port';

$NAMESPACES{$ns}->{Server}->{XPath}->{Path} = 'server/text()';

$NAMESPACES{$ns}->{ServerPort}->{XPath}->{Path} = 'server/@port';

$NAMESPACES{$ns}->{Pass}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:register
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:register';

$NAMESPACES{$ns}->{Address}->{XPath}->{Path} = 'address/text()';

$NAMESPACES{$ns}->{City}->{XPath}->{Path} = 'city/text()';

$NAMESPACES{$ns}->{Date}->{XPath}->{Path} = 'date/text()';

$NAMESPACES{$ns}->{Email}->{XPath}->{Path} = 'email/text()';

$NAMESPACES{$ns}->{First}->{XPath}->{Path} = 'first/text()';

$NAMESPACES{$ns}->{Instructions}->{XPath}->{Path} = 'instructions/text()';

$NAMESPACES{$ns}->{Key}->{XPath}->{Path} = 'key/text()';

$NAMESPACES{$ns}->{Last}->{XPath}->{Path} = 'last/text()';

$NAMESPACES{$ns}->{Misc}->{XPath}->{Path} = 'misc/text()';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = 'name/text()';

$NAMESPACES{$ns}->{Nick}->{XPath}->{Path} = 'nick/text()';

$NAMESPACES{$ns}->{Password}->{XPath}->{Path} = 'password/text()';

$NAMESPACES{$ns}->{Phone}->{XPath}->{Path} = 'phone/text()';

$NAMESPACES{$ns}->{Registered}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Registered}->{XPath}->{Path} = 'registered';

$NAMESPACES{$ns}->{Remove}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Remove}->{XPath}->{Path} = 'remove';

$NAMESPACES{$ns}->{State}->{XPath}->{Path} = 'state/text()';

$NAMESPACES{$ns}->{Text}->{XPath}->{Path} = 'text/text()';

$NAMESPACES{$ns}->{URL}->{XPath}->{Path} = 'url/text()';

$NAMESPACES{$ns}->{Username}->{XPath}->{Path} = 'username/text()';

$NAMESPACES{$ns}->{Zip}->{XPath}->{Path} = 'zip/text()';

$NAMESPACES{$ns}->{Register}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:roster
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:roster';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:roster:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:roster:item'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:roster:item
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:roster:item';

$NAMESPACES{$ns}->{Ask}->{XPath}->{Path} = '@ask';

$NAMESPACES{$ns}->{Group}->{XPath}->{Type} = 'array';
$NAMESPACES{$ns}->{Group}->{XPath}->{Path} = 'group/text()';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{Subscription}->{XPath}->{Path} = '@subscription';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:rpc
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:rpc';

$NAMESPACES{$ns}->{MethodCall}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{MethodCall}->{XPath}->{Path} = 'methodCall';
$NAMESPACES{$ns}->{MethodCall}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:methodCall'];
$NAMESPACES{$ns}->{MethodCall}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{$ns}->{MethodResponse}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{MethodResponse}->{XPath}->{Path} = 'methodResponse';
$NAMESPACES{$ns}->{MethodResponse}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:methodResponse'];
$NAMESPACES{$ns}->{MethodResponse}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:methodCall
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:methodCall';

$NAMESPACES{$ns}->{MethodName}->{XPath}->{Path} = 'methodName/text()';

$NAMESPACES{$ns}->{Params}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Params}->{XPath}->{Path} = 'params';
$NAMESPACES{$ns}->{Params}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:params'];
$NAMESPACES{$ns}->{Params}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{$ns}->{MethodCall}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:methodResponse
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:methodResponse';

$NAMESPACES{$ns}->{Params}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Params}->{XPath}->{Path} = 'params';
$NAMESPACES{$ns}->{Params}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:params'];
$NAMESPACES{$ns}->{Params}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{$ns}->{Fault}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Fault}->{XPath}->{Path} = 'fault';
$NAMESPACES{$ns}->{Fault}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:fault'];
$NAMESPACES{$ns}->{Fault}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:fault
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:fault';

$NAMESPACES{$ns}->{Value}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Value}->{XPath}->{Path} = 'value';
$NAMESPACES{$ns}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{$ns}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:params
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:params';

$NAMESPACES{$ns}->{Param}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Param}->{XPath}->{Path} = 'param';
$NAMESPACES{$ns}->{Param}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:param'];
$NAMESPACES{$ns}->{Param}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Params}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Params}->{XPath}->{Path} = 'param';
$NAMESPACES{$ns}->{Params}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:param'];
$NAMESPACES{$ns}->{Params}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:param
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:param';

$NAMESPACES{$ns}->{Value}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Value}->{XPath}->{Path} = 'value';
$NAMESPACES{$ns}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{$ns}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:value
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:value';

$NAMESPACES{$ns}->{Base64}->{XPath}->{Path} = 'base64/text()';

$NAMESPACES{$ns}->{Boolean}->{XPath}->{Path} = 'boolean/text()';

$NAMESPACES{$ns}->{DateTime}->{XPath}->{Path} = 'dateTime.iso8601/text()';

$NAMESPACES{$ns}->{Double}->{XPath}->{Path} = 'double/text()';

$NAMESPACES{$ns}->{I4}->{XPath}->{Path} = 'i4/text()';
$NAMESPACES{$ns}->{Int}->{XPath}->{Path} = 'int/text()';

$NAMESPACES{$ns}->{String}->{XPath}->{Path} = 'string/text()';

$NAMESPACES{$ns}->{Value}->{XPath}->{Path} = 'value/text()';

$NAMESPACES{$ns}->{RPCValue}->{XPath}->{Type} = 'master';

$NAMESPACES{$ns}->{Struct}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Struct}->{XPath}->{Path} = 'struct';
$NAMESPACES{$ns}->{Struct}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:struct'];
$NAMESPACES{$ns}->{Struct}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{$ns}->{Array}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Array}->{XPath}->{Path} = 'array';
$NAMESPACES{$ns}->{Array}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:array'];
$NAMESPACES{$ns}->{Array}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:struct
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:struct';

$NAMESPACES{$ns}->{Member}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Member}->{XPath}->{Path} = 'member';
$NAMESPACES{$ns}->{Member}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:struct:member'];
$NAMESPACES{$ns}->{Member}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Members}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Members}->{XPath}->{Path} = 'member';
$NAMESPACES{$ns}->{Members}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:struct:member'];
$NAMESPACES{$ns}->{Members}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:struct:member
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:struct:member';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = 'name/text()';

$NAMESPACES{$ns}->{Value}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Value}->{XPath}->{Path} = 'value';
$NAMESPACES{$ns}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{$ns}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

$NAMESPACES{$ns}->{Member}->{XPath}->{Type} = 'master';


#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:array
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:array';

$NAMESPACES{$ns}->{Data}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Data}->{XPath}->{Path} = 'data';
$NAMESPACES{$ns}->{Data}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:array:data'];
$NAMESPACES{$ns}->{Data}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Datas}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Datas}->{XPath}->{Path} = 'data';
$NAMESPACES{$ns}->{Datas}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:array:data'];
$NAMESPACES{$ns}->{Datas}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:rpc:array:data
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:rpc:array:data';

$NAMESPACES{$ns}->{Value}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Value}->{XPath}->{Path} = 'value';
$NAMESPACES{$ns}->{Value}->{XPath}->{Child} = ['Query','__netjabber__:iq:rpc:value'];
$NAMESPACES{$ns}->{Value}->{XPath}->{Calls} = ['Get','Defined','Add'];

#-----------------------------------------------------------------------------
# jabber:iq:search
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:search';

$NAMESPACES{$ns}->{Email}->{XPath}->{Path} = 'email/text()';

$NAMESPACES{$ns}->{Family}->{XPath}->{Path} = 'family/text()';

$NAMESPACES{$ns}->{First}->{XPath}->{Path} = 'first/text()';

$NAMESPACES{$ns}->{Given}->{XPath}->{Path} = 'given/text()';

$NAMESPACES{$ns}->{Instructions}->{XPath}->{Path} = 'instructions/text()';

$NAMESPACES{$ns}->{Key}->{XPath}->{Path} = 'key/text()';

$NAMESPACES{$ns}->{Last}->{XPath}->{Path} = 'last/text()';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = 'name/text()';

$NAMESPACES{$ns}->{Nick}->{XPath}->{Path} = 'nick/text()';

$NAMESPACES{$ns}->{Truncated}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Truncated}->{XPath}->{Path} = 'truncated';

$NAMESPACES{$ns}->{Search}->{XPath}->{Type} = 'master';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:search:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:search:item'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];


#-----------------------------------------------------------------------------
# __netjabber__:iq:search:item
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:search:item';

$NAMESPACES{$ns}->{Email}->{XPath}->{Path} = 'email/text()';

$NAMESPACES{$ns}->{First}->{XPath}->{Path} = 'first/text()';

$NAMESPACES{$ns}->{Family}->{XPath}->{Path} = 'family/text()';

$NAMESPACES{$ns}->{Given}->{XPath}->{Path} = 'given/text()';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Key}->{XPath}->{Path} = 'key/text()';

$NAMESPACES{$ns}->{Last}->{XPath}->{Path} = 'last/text()';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = 'name/text()';

$NAMESPACES{$ns}->{Nick}->{XPath}->{Path} = 'nick/text()';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# jabber:iq:time
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:time';

$NAMESPACES{$ns}->{Display}->{XPath}->{Type} = ['special','time-display'];
$NAMESPACES{$ns}->{Display}->{XPath}->{Path} = 'display/text()';
$NAMESPACES{$ns}->{Display}->{XPath}->{Calls} = ['Get','Set','Defined'];

$NAMESPACES{$ns}->{TZ}->{XPath}->{Type} = ['special','time-tz'];
$NAMESPACES{$ns}->{TZ}->{XPath}->{Path} = 'tz/text()';

$NAMESPACES{$ns}->{UTC}->{XPath}->{Type} = ['special','time-utc'];
$NAMESPACES{$ns}->{UTC}->{XPath}->{Path} = 'utc/text()';

$NAMESPACES{$ns}->{Time}->{XPath}->{Type} = ['master','all'];
$NAMESPACES{$ns}->{Time}->{XPath}->{Calls} = ['Get','Set'];

#-----------------------------------------------------------------------------
# jabber:iq:version
#-----------------------------------------------------------------------------
$ns = 'jabber:iq:version';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = 'name/text()';

$NAMESPACES{$ns}->{OS}->{XPath}->{Type} = ['special','version-os'];
$NAMESPACES{$ns}->{OS}->{XPath}->{Path} = 'os/text()';

$NAMESPACES{$ns}->{Ver}->{XPath}->{Type} = ['special','version-version'];
$NAMESPACES{$ns}->{Ver}->{XPath}->{Path} = 'version/text()';

$NAMESPACES{$ns}->{Version}->{XPath}->{Type} = ['master','all'];

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/bytestreams
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/bytestreams';

$NAMESPACES{$ns}->{Activate}->{XPath}->{Path} = 'activate/text()';

$NAMESPACES{$ns}->{StreamHostUsedJID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{StreamHostUsedJID}->{XPath}->{Path} = 'streamhost-used/@jid';

$NAMESPACES{$ns}->{SID}->{XPath}->{Path} = '@sid';

$NAMESPACES{$ns}->{StreamHost}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{StreamHost}->{XPath}->{Path} = 'streamhost';
$NAMESPACES{$ns}->{StreamHost}->{XPath}->{Child} = ['Query','__netjabber__:iq:bytestreams:streamhost'];
$NAMESPACES{$ns}->{StreamHost}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{StreamHosts}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{StreamHosts}->{XPath}->{Path} = 'streamhost';
$NAMESPACES{$ns}->{StreamHosts}->{XPath}->{Child} = ['Query','__netjabber__:iq:bytestreams:streamhost'];
$NAMESPACES{$ns}->{StreamHosts}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{$ns}->{ByteStreams}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:bytestreams:streamhost
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:bytestreams:streamhost';

$NAMESPACES{$ns}->{Host}->{XPath}->{Path} = '@host';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Port}->{XPath}->{Path} = '@port';

$NAMESPACES{$ns}->{ZeroConf}->{XPath}->{Path} = '@zeroconf';

$NAMESPACES{$ns}->{StreamHost}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/commands
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/commands';

$TAGS{$ns} = "command";

$NAMESPACES{$ns}->{Action}->{XPath}->{Path} = '@action';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{SessionID}->{XPath}->{Path} = '@sessionid';

$NAMESPACES{$ns}->{Status}->{XPath}->{Path} = '@status';

$NAMESPACES{$ns}->{Note}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Note}->{XPath}->{Path} = 'note';
$NAMESPACES{$ns}->{Note}->{XPath}->{Child} = ['Query','__netjabber__:iq:commands:note'];
$NAMESPACES{$ns}->{Note}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Notes}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Notes}->{XPath}->{Path} = 'note';
$NAMESPACES{$ns}->{Notes}->{XPath}->{Child} = ['Query','__netjabber__:iq:commands:note'];
$NAMESPACES{$ns}->{Notes}->{XPath}->{Calls} = ['Get'];

# xxx xml:lang

$NAMESPACES{$ns}->{Command}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:commands:note
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:commands:note';

$NAMESPACES{$ns}->{Type}->{XPath}->{Path} = '@type';

$NAMESPACES{$ns}->{Message}->{XPath}->{Path} = 'text()';

$NAMESPACES{$ns}->{Note}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/disco#info
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/disco#info';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Feature}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Feature}->{XPath}->{Path} = 'feature';
$NAMESPACES{$ns}->{Feature}->{XPath}->{Child} = ['Query','__netjabber__:iq:disco:info:feature'];
$NAMESPACES{$ns}->{Feature}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Features}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Features}->{XPath}->{Path} = 'feature';
$NAMESPACES{$ns}->{Features}->{XPath}->{Child} = ['Query','__netjabber__:iq:disco:info:feature'];
$NAMESPACES{$ns}->{Features}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{$ns}->{Identity}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Identity}->{XPath}->{Path} = 'identity';
$NAMESPACES{$ns}->{Identity}->{XPath}->{Child} = ['Query','__netjabber__:iq:disco:info:identity'];
$NAMESPACES{$ns}->{Identity}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Identities}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Identities}->{XPath}->{Path} = 'identity';
$NAMESPACES{$ns}->{Identities}->{XPath}->{Child} = ['Query','__netjabber__:iq:disco:info:identity'];
$NAMESPACES{$ns}->{Identities}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{$ns}->{DiscoInfo}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:disco:info:feature
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:disco:info:feature';

$NAMESPACES{$ns}->{Var}->{XPath}->{Path} = '@var';

$NAMESPACES{$ns}->{Feature}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:disco:info:identity
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:disco:info:identity';

$NAMESPACES{$ns}->{Category}->{XPath}->{Path} = '@category';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{Type}->{XPath}->{Path} = '@type';

$NAMESPACES{$ns}->{Identity}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/disco#items
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/disco#items';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:disco:items:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:disco:items:item'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];

$NAMESPACES{$ns}->{DiscoItems}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:disco:items:item
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:disco:items:item';

$NAMESPACES{$ns}->{Action}->{XPath}->{Path} = '@action';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/feature-neg
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/feature-neg';

$TAGS{$ns} = "feature";

$NAMESPACES{$ns}->{FeatureNeg}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/muc#admin
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/muc#admin';

$NAMESPACES{$ns}->{Admin}->{XPath}->{Type} = 'master';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'node';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:muc:admin:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:muc:admin:item'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Get'];

#-----------------------------------------------------------------------------
# __netjabber__:iq:muc:admin:item
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:muc:admin:item';

$NAMESPACES{$ns}->{ActorJID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{ActorJID}->{XPath}->{Path} = 'actor/@jid';

$NAMESPACES{$ns}->{Affiliation}->{XPath}->{Path} = '@affiliation';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Nick}->{XPath}->{Path} = '@nick';

$NAMESPACES{$ns}->{Reason}->{XPath}->{Path} = 'reason/text()';

$NAMESPACES{$ns}->{Role}->{XPath}->{Path} = '@role';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = "master";

#-----------------------------------------------------------------------------
# http://www.jabber.org/protocol/pubsub
#-----------------------------------------------------------------------------
$ns = 'http://www.jabber.org/protocol/pubsub';

$TAGS{$ns} = "pubsub";

$NAMESPACES{$ns}->{Affiliations}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Affiliations}->{XPath}->{Path} = 'affiliations';
$NAMESPACES{$ns}->{Affiliations}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:affiliations'];
$NAMESPACES{$ns}->{Affiliations}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Configure}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Configure}->{XPath}->{Path} = 'configure';
$NAMESPACES{$ns}->{Configure}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:configure'];
$NAMESPACES{$ns}->{Configure}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Create}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Create}->{XPath}->{Path} = 'create';
$NAMESPACES{$ns}->{Create}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:create'];
$NAMESPACES{$ns}->{Create}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Delete}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Delete}->{XPath}->{Path} = 'delete';
$NAMESPACES{$ns}->{Delete}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:delete'];
$NAMESPACES{$ns}->{Delete}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Entities}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Entities}->{XPath}->{Path} = 'entities';
$NAMESPACES{$ns}->{Entities}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:entities'];
$NAMESPACES{$ns}->{Entities}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Entity}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Entity}->{XPath}->{Path} = 'entity';
$NAMESPACES{$ns}->{Entity}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:entity'];
$NAMESPACES{$ns}->{Entity}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = 'items';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:items'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Options}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Options}->{XPath}->{Path} = 'options';
$NAMESPACES{$ns}->{Options}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:options'];
$NAMESPACES{$ns}->{Options}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Publish}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Publish}->{XPath}->{Path} = 'publish';
$NAMESPACES{$ns}->{Publish}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:publish'];
$NAMESPACES{$ns}->{Publish}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Purge}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Purge}->{XPath}->{Path} = 'purge';
$NAMESPACES{$ns}->{Purge}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:purge'];
$NAMESPACES{$ns}->{Purge}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Retract}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Retract}->{XPath}->{Path} = 'retract';
$NAMESPACES{$ns}->{Retract}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:retract'];
$NAMESPACES{$ns}->{Retract}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Subscribe}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Subscribe}->{XPath}->{Path} = 'subscribe';
$NAMESPACES{$ns}->{Subscribe}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:subscribe'];
$NAMESPACES{$ns}->{Subscribe}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Unsubscribe}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Unsubscribe}->{XPath}->{Path} = 'unsubscribe';
$NAMESPACES{$ns}->{Unsubscribe}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:unsubscribe'];
$NAMESPACES{$ns}->{Unsubscribe}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{PubSub}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:affiliations
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:affiliations';

$NAMESPACES{$ns}->{Entity}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Entity}->{XPath}->{Path} = 'entity';
$NAMESPACES{$ns}->{Entity}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:entity'];
$NAMESPACES{$ns}->{Entity}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Affiliations}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:configure
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:configure';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Configure}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:create
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:create';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Create}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:delete
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:delete';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Delete}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:entities
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:entities';

$NAMESPACES{$ns}->{Entity}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Entity}->{XPath}->{Path} = 'entity';
$NAMESPACES{$ns}->{Entity}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:entity'];
$NAMESPACES{$ns}->{Entity}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Entities}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:entity
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:entity';

$NAMESPACES{$ns}->{Affiliation}->{XPath}->{Path} = '@affiliation';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Subscription}->{XPath}->{Path} = '@subscription';

$NAMESPACES{$ns}->{SubscribeOptions}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{SubscribeOptions}->{XPath}->{Path} = 'subscribe-options';
$NAMESPACES{$ns}->{SubscribeOptions}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:subscribe-options'];
$NAMESPACES{$ns}->{SubscribeOptions}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Entity}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:items
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:items';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{MaxItems}->{XPath}->{Path} = '@max_items';

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:item
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:item';

$NAMESPACES{$ns}->{ID}->{XPath}->{Path} = '@id';

$NAMESPACES{$ns}->{Payload}->{XPath}->{Type} = 'raw';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:options
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:options';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Options}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:publish
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:publish';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Publish}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:purge
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:purge';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Purge}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:retract
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:retract';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Retract}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:subscribe
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:subscribe';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Subscribe}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:subscribe-options
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:subscribe-options';

$NAMESPACES{$ns}->{Required}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Required}->{XPath}->{Path} = 'required';

$NAMESPACES{$ns}->{SubscribeOptions}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:unsubscribe
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:unsubscribe';

$NAMESPACES{$ns}->{JID}->{XPath}->{Type} = 'jid';
$NAMESPACES{$ns}->{JID}->{XPath}->{Path} = '@jid';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Unsubscribe}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://www.jabber.org/protocol/pubsub#event
#-----------------------------------------------------------------------------
$ns = 'http://www.jabber.org/protocol/pubsub#event';

$TAGS{$ns} = "event";

$NAMESPACES{$ns}->{Delete}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Delete}->{XPath}->{Path} = 'delete';
$NAMESPACES{$ns}->{Delete}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:event:delete'];
$NAMESPACES{$ns}->{Delete}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Items}->{XPath}->{Path} = 'items';
$NAMESPACES{$ns}->{Items}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:event:items'];
$NAMESPACES{$ns}->{Items}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Event}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:event:delete
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:event:delete';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Delete}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:event:items
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:event:items';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Item}->{XPath}->{Path} = 'item';
$NAMESPACES{$ns}->{Item}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:event:item'];
$NAMESPACES{$ns}->{Item}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Items}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:event:item
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:event:item';

$NAMESPACES{$ns}->{ID}->{XPath}->{Path} = '@id';

$NAMESPACES{$ns}->{Payload}->{XPath}->{Type} = 'raw';

$NAMESPACES{$ns}->{Item}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://www.jabber.org/protocol/pubsub#owner
#-----------------------------------------------------------------------------
$ns = 'http://www.jabber.org/protocol/pubsub#owner';

$TAGS{$ns} = "pubsub";

$NAMESPACES{$ns}->{Action}->{XPath}->{Path} = '@action';

$NAMESPACES{$ns}->{Configure}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Configure}->{XPath}->{Path} = 'configure';
$NAMESPACES{$ns}->{Configure}->{XPath}->{Child} = ['Query','__netjabber__:iq:pubsub:owner:configure'];
$NAMESPACES{$ns}->{Configure}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Owner}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:pubsub:owner:configure
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:pubsub:owner:configure';

$NAMESPACES{$ns}->{Node}->{XPath}->{Path} = '@node';

$NAMESPACES{$ns}->{Configure}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/si
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/si';

$TAGS{$ns} = "si";

$NAMESPACES{$ns}->{ID}->{XPath}->{Path} = '@id';

$NAMESPACES{$ns}->{MimeType}->{XPath}->{Path} = '@mime-type';

$NAMESPACES{$ns}->{Profile}->{XPath}->{Path} = '@profile';

$NAMESPACES{$ns}->{Stream}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/si/profile/file-transfer
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/si/profile/file-transfer';

$TAGS{$ns} = "file";

$NAMESPACES{$ns}->{Date}->{XPath}->{Path} = '@date';

$NAMESPACES{$ns}->{Desc}->{XPath}->{Path} = 'desc/text()';

$NAMESPACES{$ns}->{Hash}->{XPath}->{Path} = '@hash';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{Range}->{XPath}->{Type} = 'flag';
$NAMESPACES{$ns}->{Range}->{XPath}->{Path} = 'range';

$NAMESPACES{$ns}->{RangeOffset}->{XPath}->{Path} = 'range/@offset';

$NAMESPACES{$ns}->{RangeLength}->{XPath}->{Path} = 'range/@length';

$NAMESPACES{$ns}->{Size}->{XPath}->{Path} = '@size';

$NAMESPACES{$ns}->{File}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://jabber.org/protocol/si/profile/tree-transfer
#-----------------------------------------------------------------------------
$ns = 'http://jabber.org/protocol/si/profile/tree-transfer';

$TAGS{$ns} = "tree";

$NAMESPACES{$ns}->{Directory}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Directory}->{XPath}->{Path} = 'directory';
$NAMESPACES{$ns}->{Directory}->{XPath}->{Child} = ['Query','__netjabber__:iq:si:profile:tree:directory'];
$NAMESPACES{$ns}->{Directory}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Numfiles}->{XPath}->{Path} = '@numfiles';

$NAMESPACES{$ns}->{Size}->{XPath}->{Path} = '@size';

$NAMESPACES{$ns}->{Tree}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:si:profile:tree:directory
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:si:profile:tree:directory';

$NAMESPACES{$ns}->{Directory}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{Directory}->{XPath}->{Path} = 'directory';
$NAMESPACES{$ns}->{Directory}->{XPath}->{Child} = ['Query','__netjabber__:iq:si:profile:tree:directory'];
$NAMESPACES{$ns}->{Directory}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{File}->{XPath}->{Type} = 'children';
$NAMESPACES{$ns}->{File}->{XPath}->{Path} = 'file';
$NAMESPACES{$ns}->{File}->{XPath}->{Child} = ['Query','__netjabber__:iq:si:profile:tree:file'];
$NAMESPACES{$ns}->{File}->{XPath}->{Calls} = ['Add','Get'];

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{Dir}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# __netjabber__:iq:si:profile:tree:file
#-----------------------------------------------------------------------------
$ns = '__netjabber__:iq:si:profile:tree:file';

$NAMESPACES{$ns}->{Name}->{XPath}->{Path} = '@name';

$NAMESPACES{$ns}->{SID}->{XPath}->{Path} = '@sid';

$NAMESPACES{$ns}->{File}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# http://www.jabber.org/protocol/soap
#-----------------------------------------------------------------------------
$ns = 'http://www.jabber.org/protocol/soap';

$TAGS{$ns} = "soap";

$NAMESPACES{$ns}->{Payload}->{XPath}->{Type} = 'raw';

$NAMESPACES{$ns}->{Soap}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# XMPP-Bind
#-----------------------------------------------------------------------------
$ns = &XML::Stream::ConstXMLNS("xmpp-bind");

$TAGS{$ns} = "bind";

$NAMESPACES{$ns}->{Resource}->{XPath}->{Path} = 'resource/text()';

$NAMESPACES{$ns}->{Bind}->{XPath}->{Type} = 'master';

#-----------------------------------------------------------------------------
# XMPP-Session
#-----------------------------------------------------------------------------
$ns = &XML::Stream::ConstXMLNS("xmpp-session");

$TAGS{$ns} = "session";

$NAMESPACES{$ns}->{Session}->{XPath}->{Type} = 'master';







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
