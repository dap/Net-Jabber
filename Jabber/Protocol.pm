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

package Net::Jabber::Protocol;

=head1 NAME

Net::Jabber::Protocol - Jabber Protocol Library

=head1 SYNOPSIS

  Net::Jabber::Protocol is a module that provides a developer easy
  access to the Jabber Instant Messaging protocol.  It provides high
  level functions to the Net::Jabber Client, Component, and Server
  objects.  These functions are automatically indluded in those modules
  through AUTOLOAD and delegates.

=head1 DESCRIPTION

  Protocol.pm seeks to provide enough high level APIs and automation of
  the low level APIs that writing a Jabber Client/Transport in Perl is
  trivial.  For those that wish to work with the low level you can do
  that too, but those functions are covered in the documentation for
  each module.

  Net::Jabber::Protocol provides functions to login, send and receive
  messages, set personal information, create a new user account, manage
  the roster, and disconnect.  You can use all or none of the functions,
  there is no requirement.

  For more information on how the details for how Net::Jabber is written
  please see the help for Net::Jabber itself.

  For more information on writing a Client see Net::Jabber::Client.

  For more information on writing a Transport see Net::Jabber::Transport.

=head2 Basic Functions

    use Net::Jabber qw( Client );
    $Con = new Net::Jabber::Client();            # From
    $status = $Con->Connect(name=>"jabber.org"); # Net::Jabber::Client

      or

    use Net::Jabber qw( Component );
    $Con = new Net::Jabber::Component();         #
    $status = $Con->Connect(name=>"jabber.org",  # From
			    secret=>"bob");      # Net::Jabber::Component


    $Con->SetCallBacks(send=>\&sendCallBack,
		       receive=>\&receiveCallBack,
		       message=>\&messageCallBack,
		       iq=>\&handleTheIQTag);

    $Con->SetMessageCallBacks(normal=>\&messageNormalCB,
                              chat=>\&messageChatCB);

    $Con->SetPresenceCallBacks(available=>\&presenceAvailableCB,
                               unavailable=>\&presenceUnavailableCB);

    $Con->SetIQCallBacks("jabber:iq:roster"=>
			 {
			  get=>\&iqRosterGetCB,
			  set=>\&iqRosterSetCB,
			  result=>\&iqRosterResultCB,
			 },
			 etc...
			);

    $Con->Info(name=>"Jarl",
	       version=>"v0.6000");

    $error = $Con->GetErrorCode();
    $Con->SetErrorCode("Timeout limit reached");

    $Con->Process();
    $Con->Process(5);

    $Con->Send($object);
    $Con->Send("<tag>XML</tag>");

    $Con->Send($object,1);
    $Con->Send("<tag>XML</tag>",1);

    $Con->Disconnect();

=head2 ID Functions

    $id         = $Con->SendWithID($sendObj);
    $id         = $Con->SendWithID("<tag>XML</tag>");
    $receiveObj = $Con->SendAndReceiveWithID($sendObj);
    $receiveObj = $Con->SendAndReceiveWithID($sendObj,
                                             10);
    $receiveObj = $Con->SendAndReceiveWithID("<tag>XML</tag>");
    $receiveObj = $Con->SendAndReceiveWithID("<tag>XML</tag>",
                                             5);
    $yesno      = $Con->ReceivedID($id);
    $receiveObj = $Con->GetID($id);
    $receiveObj = $Con->WaitForID($id);
    $receiveObj = $Con->WaitForID($id,
                                  20);

=head2 Namespace Functions

    $Con->DefineNamespace(xmlns=>"foo:bar",
			  type=>"Query",
			  functions=>[{name=>"Foo",
				       get=>"foo",
				       set=>["scalar","foo"],
				       defined=>"foo",
				       hash=>"child-data"},
				      {name=>"Bar",
				       get=>"bar",
				       set=>["scalar","bar"],
				       defined=>"bar",
				       hash=>"child-data"},
				      {name=>"FooBar",
				       get=>"__netjabber__:master",
				       set=>["master"]}]);

=head2 Message Functions

    $Con->MessageSend(to=>"bob@jabber.org",
                      subject=>"Lunch",
                      body=>"Let's go grab some...\n";
                      thread=>"ABC123",
                      priority=>10);

=head2 Presence Functions

    $Con->PresenceSend();
    $Con->PresenceSend(type=>"unavailable");
    $Con->PresenceSend(show=>"away");
    $Con->PresenceSend(signature=>...signature...);

=head2 Subscription Functions

    $Con->Subscription(type=>"subscribe",
                       to=>"bob@jabber.org");

    $Con->Subscription(type=>"unsubscribe",
                       to=>"bob@jabber.org");

    $Con->Subscription(type=>"subscribed",
                       to=>"bob@jabber.org");

    $Con->Subscription(type=>"unsubscribed",
                       to=>"bob@jabber.org");

=head2 Presence DB Functions

    $Con->PresenceDBParse(Net::Jabber::Presence);

    $Con->PresenceDBDelete("bob\@jabber.org");
    $Con->PresenceDBDelete(Net::Jabber::JID);

    $presence  = $Con->PresenceDBQuery("bob\@jabber.org");
    $presence  = $Con->PresenceDBQuery(Net::Jabber::JID);

    @resources = $Con->PresenceDBResources("bob\@jabber.org");
    @resources = $Con->PresenceDBResources(Net::Jabber::JID);

=head2 IQ  Functions

=head2 IQ::Agents Functions

    %agents = $Con->AgentsGet();
    %agents = $Con->AgentsGet(to=>"transport.jabber.org");

=head2 IQ::Auth Functions

    @result = $Con->AuthSend();
    @result = $Con->AuthSend(username=>"bob",
                             password=>"bobrulez",
                             resource=>"Bob");

=head2 IQ::Browse Functions

    %hash = $Con->BrowseRequest(jid=>"jabber.org");
    %hash = $Con->BrowseRequest(jid=>"jabber.org",
                                timeout=>10);

=head2 IQ::Browse DB Functions

    $Con->BrowseDBDelete("jabber.org");
    $Con->BrowseDBDelete(Net::Jabber::JID);

    $presence  = $Con->BrowseDBQuery(jid=>"bob\@jabber.org");
    $presence  = $Con->BrowseDBQuery(jid=>Net::Jabber::JID);
    $presence  = $Con->BrowseDBQuery(jid=>"users.jabber.org",
                                     timeout=>10);
    $presence  = $Con->BrowseDBQuery(jid=>"conference.jabber.org",
                                     refresh=>1);

=head2 IQ::Last Functions

    $Con->LastQuery();
    $Con->LastQuery(to=>"bob@jabber.org");

    %result = $Con->LastQuery(waitforid=>1);
    %result = $Con->LastQuery(to=>"bob@jabber.org",
                              waitforid=>1);

    %result = $Con->LastQuery(to=>"bob@jabber.org",
                              waitforid=>1,
                              timeout=>10);
    %result = $Con->LastQuery(waitforid=>1,
                              timeout=>10);

    $Con->LastSend(to=>"bob@jabber.org");

    $seconds = $Con->LastActivity();

=head2 IQ::Register Functions

    %hash   = $Con->RegisterRequest();
    %hash   = $Con->RegisterRequest(to=>"transport.jabber.org");
    %hash   = $Con->RegisterRequest(to=>"transport.jabber.org",
                                    timeout=>10);

    @result = $Con->RegisterSend(to=>"somewhere",
                                 usersname=>"newuser",
                                 resource=>"New User",
                                 password=>"imanewbie",
                                 email=>"newguy@new.com",
                                 key=>"some key");

    @result = $Con->RegisterSendData("users.jabber.org",
                                     first=>"Bob",
                                     last=>"Smith",
                                     nick=>"bob",
                                     email=>"foo@bar.net");


=head2 IQ::Roster Functions

    %roster = $Con->RosterParse($iq);
    %roster = $Con->RosterGet();
    $Con->RosterAdd(jid=>"bob\@jabber.org",
                    name=>"Bob");
    $Con->RosterRemove(jid=>"bob@jabber.org");


=head2 IQ::RPC Functions

    $query = $Con->RPCEncode(type=>"methodCall",
                             methodName=>"methodName",
                             params=>[param,param,...]);
    $query = $Con->RPCEncode(type=>"methodResponse",
                             params=>[param,param,...]);
    $query = $Con->RPCEncode(type=>"methodResponse",
                             faultCode=>4,
                             faultString=>"Too many params");

    @response = $Con->RPCParse($iq);

    @response = $Con->RPCCall(to=>"dataHouse.jabber.org",
                              methodname=>"numUsers",
                              params=>[ param,param,... ]
                             );

    $Con->RPCResponse(to=>"you\@jabber.org",
                      params=>[ param,param,... ]);

    $Con->RPCResponse(to=>"you\@jabber.org",
                      faultCode=>"4",
                      faultString=>"Too many parameters"
                     );

    $Con->RPCSetCallBacks(myMethodA=>\&methoda,
                          myMethodB=>\&do_somthing,
                          etc...
                         );

=head2 IQ::Search Functions

    %fields = $Con->SearchRequest();
    %fields = $Con->SearchRequest(to=>"users.jabber.org");
    %fields = $Con->SearchRequest(to=>"users.jabber.org",
                                  timeout=>10);

    $Con->SearchSend(to=>"somewhere",
                     name=>"",
                     first=>"Bob",
                     last=>"",
                     nick=>"bob",
                     email=>"",
                     key=>"some key");

    $Con->SearchSendData("users.jabber.org",
                         first=>"Bob",
                         last=>"",
                         nick=>"bob",
                         email=>"");

=head2 IQ::Time Functions

    $Con->TimeQuery();
    $Con->TimeQuery(to=>"bob@jabber.org");

    %result = $Con->TimeQuery(waitforid=>1);
    %result = $Con->TimeQuery(to=>"bob@jabber.org",
                              waitforid=>1);

    $Con->TimeSend(to=>"bob@jabber.org");

=head2 IQ::Version Functions

    $Con->VersionQuery();
    $Con->VersionQuery(to=>"bob@jabber.org");

    %result = $Con->VersionQuery(waitforid=>1);
    %result = $Con->VersionQuery(to=>"bob@jabber.org",
                                 waitforid=>1);

    $Con->VersionSend(to=>"bob@jabber.org",
                      name=>"Net::Jabber",
                      ver=>"1.0a",
                      os=>"Perl");

=head2 X Functions

    $Con->SXPMSend(to=>'bob@jabber.org',
                   type=>'chat',
                   boardheight=>400,
                   boardwidth=>400,
                   map=>{ '#'=>'',
                          ' '=>'None',
                          'a'=>'#FFFFFF',
                          'b'=>'#FF0000',
                          ...
                        }
                   data=>"4 .3 . 2 .2  .3 .4 ",
                   datawidth=>5
                  );

=head1 METHODS

=head2 Basic Functions

    GetErrorCode() - returns a string that will hopefully contain some
                     useful information about why a function returned
                     an undef to you.

    SetErrorCode(string) - set a useful error message before you return
                           an undef to the caller.

    SetCallBacks(message=>function,  - sets the callback functions for
                 presence=>function,   the top level tags listed.  The
                 iq=>function)         available tags to look for are
    SetCallBacks(xdb=>function,        <message/>, <presence/>, and
                 db:verify=>function,  <iq/>.  If a packet is received
                 db:result=>function)  with an ID which is found in the
    SetCallBacks(send=>function,       registerd ID list (see RegisterID
                 receive=>function,    below) then it is not sent to
                 update=>function)     these functions, instead it
                                       is inserted into a LIST and can
                                       be retrieved by some functions
                                       we will mention later.

                                       send and receive are used to
                                       log what XML is sent and received.
                                       update is used as way to update
                                       your program while waiting for
                                       a packet with an ID to be
                                       returned (useful for GUI apps).

                                       A major change that came with
                                       the last release is that the
                                       session id is passed to the
                                       callback as the first argument.
                                       This was done to facilitate
                                       the Server module.

                                       The next argument depends on
                                       which callback you are talking
                                       about.  message, presence, iq,
                                       xdb, db:verify, and db:result
                                       all get passed in Net::Jabber
                                       objects that match those types.
                                       send and receive get passed in
                                       strings.  update gets passed
                                       nothing, not even the session id.

                                       If you set the function to undef,
                                       then the callback is removed from
                                       the list.

    SetMessageCallBacks(type=>function - sets the callback functions for
                        etc...)          the specified presence type. The
                                         function takes types as the main
                                         key, and lets you specify a
                                         function for each type of packet
                                         you can get.
                                           "available"
                                           "unavailable"
                                           "subscribe"
                                           "unsubscribe"
                                           "subscribed"
                                           "unsubscribed"
                                           "probe"
                                           "error"
                                         When it gets a <presence/> packet
                                         it checks the type='' for a defined
                                         callback.  If there is one then it
                                         calls the function with two
                                         arguments:
                                           the session ID, and the
                                           Net::Jabber::Presence object.

                                         If you set the function to undef,
                                         then the callback is removed from
                                         the list.

                       NOTE: If you use this, which is a cleaner method,
                             then you must *NOT* specify a callback for
                             presence in the SetCallBacks function.

                                         Net::Jabber defines a few default
                                         callbacks for various types:

                                         "subscribe" -
                                           replies with subscribed
                                          
                                         "unsubscribe" -
                                           replies with unsubscribed
                                         
                                         "subscribed" -
                                           replies with subscribed
                                         
                                         "unsubscribed" -
                                           replies with unsubscribed
                                         

    SetMessageCallBacks(type=>function, - sets the callback functions for
                        etc...)           the specified message type. The 
                                          function takes types as the main
                                          key, and lets you specify a
                                          function for each type of packet
                                          you can get.
                                           "normal"
                                           "chat"
                                           "groupchat"
                                           "headline"
                                           "error"
                                         When it gets a <message/> packet
                                         it checks the type='' for a
                                         defined callback. If there is one
                                         then it calls the function with
                                         two arguments:
                                           the session ID, and the
                                           Net::Jabber::Message object.

                                         If you set the function to undef,
                                         then the callback is removed from
                                         the list.

                       NOTE: If you use this, which is a cleaner method,
                             then you must *NOT* specify a callback for
                             message in the SetCallBacks function.


    SetIQCallBacks(namespace=>{      - sets the callback functions for
                     get=>function,    the specified namespace. The
                     set=>function,    function takes namespaces as the
                     result=>function  main key, and lets you specify a
                   },                  function for each type of packet
                   etc...)             you can get.
                                         "get"
                                         "set"
                                         "result"
                                       When it gets an <iq/> packet it
                                       checks the type='' and the
                                       xmlns='' for a defined callback.
                                       If there is one then it calls
                                       the function with two arguments:
                                       the session ID, and the
                                       Net::Jabber::xxxx object.

                                       If you set the function to undef,
                                       then the callback is removed from
                                       the list.

                       NOTE: If you use this, which is a cleaner method,
                             then you must *NOT* specify a callback for
                             iq in the SetCallBacks function.

                                       Net::Jabber defines a few default
                                       callbacks for various types and
                                       namespaces:

                                       jabber:iq:last(get) -
                                         replies with the current last
                                         activity
                                       jabber:iq:last(result) -
                                         reformats the <iq/> into a
                                         <message/> and submits it as
                                         if the packet was received.

                                       jabber:iq:rpc(set) -
                                         calls the rpc method and
                                         returns the response

                                       jabber:iq:time(get) -
                                         replys with the current time
                                       jabber:iq:time(result) -
                                         reformats the <iq/> into a
                                         <message/> and submits it as
                                         if the packet was received.

                                       jabber:iq:version(get) -
                                         replys with the info for the
                                         Client/Component (as defined
                                         in the Info function)
                                       jabber:iq:version(result) -
                                         reformats the <iq/> into a
                                         <message/> and submits it as
                                         if the packet was received.

    Info(name=>string,    - Set some information so that Net::Jabber
         version=>string)   can auto-reply to some packets for you to
                            reduce the work you have to do.

                            NOTE: This requires that you use the
                            SetIQCallBacks methodology and not the
                            SetCallBacks for <iq/> packets.

    Process(integer) - takes the timeout period as an argument.  If no
                       timeout is listed then the function blocks until
                       a packet is received.  Otherwise it waits that
                       number of seconds and then exits so your program
                       can continue doing useful things.  NOTE: This is
                       important for GUIs.  You need to leave time to
                       process GUI commands even if you are waiting for
                       packets.

                       IMPORTANT: You need to check the output of every
                       Process.  If you get an undef or "" then the
                       connection died and you should behave accordingly.

    Send(object,         - takes either a Net::Jabber::xxxxx object or
	 ignoreActivity)   an XML string as an argument and sends it to
    Send(string,           the server.  If you set ignoreActivty to 1,
         ignoreActivity)   then the XML::Stream module will not record
                           this packet as couting towards user activity.
=head2 ID Functions

    SendWithID(object) - takes either a Net::Jabber::xxxxx object or an
    SendWithID(string)   XML string as an argument, adds the next
                         available ID number and sends that packet to
                         the server.  Returns the ID number assigned.

    SendAndReceiveWithID(object,  - uses SendWithID and WaitForID to
                         timeout)   provide a complete way to send and
    SendAndReceiveWithID(string,    receive packets with IDs.  Can take
                         timeout)   either a Net::Jabber::xxxxx object
                                    or an XML string.  Returns the
                                    proper Net::Jabber::xxxxx object
                                    based on the type of packet
                                    received.  The timeout is passed
                                    on to WaitForID, see that function
                                    for how the timeout works.

    ReceivedID(integer) - returns 1 if a packet has been received with
                          specified ID, 0 otherwise.

    GetID(integer) - returns the proper Net::Jabber::xxxxx object based
                     on the type of packet received with the specified
                     ID.  If the ID has been received the GetID returns
                     0.

    WaitForID(integer, - blocks until a packet with the ID is received.
              timeout)   Returns the proper Net::Jabber::xxxxx object
                         based on the type of packet received.  If the
                         timeout limit is reached then if the packet
                         does come in, it will be discarded.


    NOTE:  Only <iq/> officially support ids, so sending a <message/>, or
           <presence/> with an id is a risk.  The server will ignore the
           id tag and pass it through, so both clients must support the
           id tag for these functions to be useful.

=head2 Namespace Functions

    DefineNamespace(xmlns=>string,    - This function is very complex.
                    type=>string,       It is a little too complex to
                    functions=>array)   discuss within the confines of
                                        this small paragraph.  Please
                                        refer to the man page for
                                        Net::Jabber::Namespaces for the
                                        full documentation on this
                                        subject.

=head2 Message Functions

    MessageSend(hash) - takes the hash and passes it to SetMessage in
                        Net::Jabber::Message (refer there for valid
                        settings).  Then it sends the message to the
                        server.

=head2 Presence Functions

    PresenceSend()                  - no arguments will send an empty
    PresenceSend(hash,                Presence to the server to tell it
		 signature=>string)   that you are available.  If you
                                      provide a hash, then it will pass
                                      that hash to the SetPresence()
                                      function as defined in the
                                      Net::Jabber::Presence module.
                                      Optionally, you can specify a
                                      signature and a jabber:x:signed
                                      will be placed in the <presence/>.

=head2 Subscription Functions

    Subscription(hash) - taks the hash and passes it to SetPresence in
                         Net::Jabber::Presence (refer there for valid
                         settings).  Then it sends the subscription to
                         server.

                         The valid types of subscription are:

                           subscribe    - subscribe to JID's presence
                           unsubscribe  - unsubscribe from JID's presence
                           subscribed   - response to a subscribe
                           unsubscribed - response to an unsubscribe

=head2 Presence DB Functions

    PresenceDBParse(Net::Jabber::Presence) - for every presence that you
                                             receive pass the Presence
                                             object to the DB so that
                                             it can track the resources
                                             and priorities for you.
                                             Returns either the presence
                                             passed in, if it not able
                                             to parsed for the DB, or the
                                             current presence as found by
                                             the PresenceDBQuery
                                             function.

    PresenceDBDelete(string|Net::Jabber::JID) - delete thes JID entry
                                                from the DB.

    PresenceDBQuery(string|Net::Jabber::JID) - returns the NJ::Presence
                                               that was last received for
                                               the highest priority of
                                               this JID.  You can pass
                                               it a string or a NJ::JID
                                               object.

    PresenceDBResources(string|Net::Jabber::JID) - returns an array of
                                                   resources in order
                                                   from highest priority
                                                   to lowest.

=head2 IQ Functions

=head2 IQ::Agents Functions

    AgentsGet(to=>string, - takes all of the information and
    AgentsGet()             builds a Net::Jabber::IQ::Agents packet.
                            It then sends that packet either to the
                            server, or to the specified transport,
                            with an ID and waits for that ID to return.
                            Then it looks in the resulting packet and
                            builds a hash that contains the values
                            of the agent list.  The hash is layed out
                            like this:  (NOTE: the jid is the key to
                            distinguish the various agents)

                              $hash{<JID>}->{order} = 4
                                          ->{name} = "ICQ Transport"
                                          ->{transport} = "ICQ #"
                                          ->{description} = "ICQ..blah.."
                                          ->{service} = "icq"
                                          ->{register} = 1
                                          ->{search} = 1
                                        etc...

                            The order field determines the order that
                            it came from the server in... in case you
                            care.  For more info on the valid fields
                            see the Net::Jabber::Query jabber:iq:agent
                            namespace.

=head2 IQ::Auth Functions

    AuthSend(username=>string, - takes all of the information and
             password=>string,   builds a Net::Jabber::IQ::Auth packet.
             resource=>string)   It then sends that packet to the
                                 server with an ID and waits for that
                                 ID to return.  Then it looks in
	                         resulting packet and determines if
	                         authentication was successful for not.
                                 The array returned from AuthSend looks
                                 like this:
                                   [ type , message ]
                                 If type is "ok" then authentication
                                 was successful, otherwise message
                                 contains a little more detail about the
                                 error.

=head2 IQ::Browse Functions

    BrowseRequest(jid=>string, - sends a jabber:iq:browse request to
                  timeout=>int)  the jid passed as an argument, and
                                 returns a hash with the resulting
                                 tree.  The format of the hash is:

                $browse{'category'} = "conference"
                $browse{'children'}->[0]
                $browse{'children'}->[1]
                $browse{'children'}->[11]
                $browse{'jid'} = "conference.jabber.org"
                $browse{'name'} = "Jabber.org Conferencing Center"
                $browse{'ns'}->[0]
                $browse{'ns'}->[1]
                $browse{'type'} = "public"

                                 The ns array is an array of the
                                 namespaces that this jid supports.
                                 The children array points to hashs
                                 of this form, and represent the fact
                                 that they can be browsed to.

                                 The timeout arguement is to tell the
                                 system how long to wait before giving
                                 up getting a reply back.

=head2 IQ::Browse DB Functions

    BrowseDBDelete(string|Net::Jabber::JID) - delete thes JID browse
                                              data from the DB.

    BrowseDBQuery(jid=>string | NJ::JID, - returns the browse data
                  timeout=>integer,        for the requested JID.  If
                  refresh=>0|1)            the DB does not contain
                                           the data for the JID, then
                                           it attempts to fetch the
                                           data via BrowseRequest().
                                           The timeout is passed to
                                           the BrowseRequest() call,
                                           and refresh tells the DB
                                           to request the data, even
                                           if it already has some.

=head2 IQ::Last Functions

    LastQuery(to=>string,     - asks the jid specified for its last
              waitforid=>0|1,   activity.  If the to is blank, then it
              timeout=>int)     queries the server.  Returns a hash with
    LastQuery()                 the various items set if waitforid is set
                                to 1:

                                  $last{seconds} - Seconds since activity
                                  $last{message} - Message for activity

                                If you specify waitforid, then you can
                                optionally specify a timeout in seconds.

    LastSend(to=>string, - sends the specified last to the specified jid.
             hash)         the hash is the seconds and message as shown
	                   in the Net::Jabber::Query man page.

    LastActivity() - returns the number of seconds since the last activity
                     by the user.

=head2 IQ::Register Functions

    RegisterRequest(to=>string,  - send an <iq/> request to the specified
                    timeout=>int)  server/transport, if not specified it
    RegisterRequest()              sends to the current active server.
                                   The function returns a hash that
                                   contains the required fields.   Here
                                   is an example of the hash:

                                   $hash{fields}    - The raw fields from
                                                      the iq:register.
                                                      To be used if there
                                                      is no x:data in the
	                                              packet.
                                   $hash{instructions} - How to fill out
                                                         the form.
                                   $hash{form}   - The new dynamic forms.

                                   In $hash{form}, the fields that are
                                   present are the required fields the
                                   server needs.

    RegisterSend(hash) - takes the contents of the hash and passes it
	                 to the SetRegister function in the module
                         Net::Jabber::Query jabber:iq:register namespace.
                         This function returns an array that looks like
                         this:

                            [ type , message ]

                         If type is "ok" then registration was
                         successful, otherwise message contains a
                         little more detail about the error.

    RegisterSendData(string|JID, - takes the contents of the hash and
	             hash)         builds a jabebr:x:data return packet
                     	           which it sends in a Net::Jabber::Query
                                   jabber:iq:register namespace packet.
                                   The first argument is the JID to send

                                   the packet to.
                                   This function returns an array that
                                   looks like this:

                                     [ type , message ]

                                   If type is "ok" then registration was
                                   successful, otherwise message contains
                                   a little more detail about the error.


=head2 IQ::Roster Functions

    RosterParse(IQ object) - returns a hash that contains the roster
                             parsed into the following data structure:

                  $roster{'bob@jabber.org'}->{name}
                                      - Name you stored in the roster

                  $roster{'bob@jabber.org'}->{subscription}
                                      - Subscription status
                                        (to, from, both, none)

		  $roster{'bob@jabber.org'}->{ask}
                                      - The ask status from this user
                                        (subscribe, unsubscribe)

		  $roster{'bob@jabber.org'}->{groups}
                                      - Array of groups that
                                        bob@jabber.org is in

    RosterGet() - sends an empty Net::Jabber::IQ::Roster tag to the
                  server so the server will send the Roster to the
                  client.  Returns the above hash from RosterParse.

    RosterAdd(hash) - sends a packet asking that the jid be
                      added to the roster.  The hash format
	              is defined in the SetItem function
                      in the Net::Jabber::Query jabber:iq:roster
                      namespace.

    RosterRemove(hash) - sends a packet asking that the jid be
                         removed from the roster.  The hash
	                 format is defined in the SetItem function
                         in the Net::Jabber::Query jabber:iq:roster
                         namespace.

=head2 IQ::RPC Functions

    RPCParse(IQ object) - returns an array.  The first argument tells
                          the status "ok" or "fault".  The second
                          argument is an array if "ok", or a hash if
                          "fault".

    RPCCall(to=>jid|string,     - takes the methodName and params,
            methodName=>string,   builds the RPC calls and sends it
            params=>array)        to the specified address.  Returns
                                  the above data from RPCParse.

    RPCResponse(to=>jid|string,      - generates a response back to
                params=>array,         the caller.  If any part of
                faultCode=>int,        fault is specified, then it
                faultString=>string)   wins.


    Note: To ensure that you get the correct type for a param sent
          back, you can specify the type by prepending the type to
          the value:

            "i4:5"
            "boolean:0"
            "string:56"
            "double:5.0"
            "datetime:20020415T11:11:11"
            "base64:...."

    RPCSetCallBacks(method=>function, - sets the callback functions
		    method=>function,   for the specified methods.
                    etc...)             The method comes from the
                                        <methodName/> and is case
                                        sensitive.  The single
                                        arguemnt is a ref to an
                                        array that contains the
                                        <params/>.  The function you
                                        write should return one of two
                               	        things:

                                          ["ok", [...] ]

                                        The [...] is a list of the
                                        <params/> you want to return.

                                          ["fault", {faultCode=>1,
                                                     faultString=>...} ]

                                        If you set the function to undef,
                                        then the method is removed from
                                        the list.

=head2 IQ::Search Functions

    SearchRequest(to=>string,  - send an <iq/> request to the specified
                  timeout=>int)  server/transport, if not specified it
    SearchRequest()              sends to the current active server.
                                 The function returns a hash that
                                 contains the required fields.   Here
                                 is an example of the hash:

                                 $hash{fields}    - The raw fields from
                                                    the iq:register.  To
                                                    be used if there is
                                                    no x:data in the
                                                    packet.
                                 $hash{instructions} - How to fill out
                                                       the form.
                                 $hash{form}   - The new dynamic forms.

                                 In $hash{form}, the fields that are
                                 present are the required fields the
                                 server needs.

    SearchSend(to=>string|JID, - takes the contents of the hash and
	       hash)             passes it to the SetSearch function
                     	         in the Net::Jabber::Query
                                 jabber:iq:search namespace.  And then
                                 sends the packet.

    SearchSendData(string|JID, - takes the contents of the hash and
	           hash)         builds a jabebr:x:data return packet
                     	         which it sends in a Net::Jabber::Query
                                 jabber:iq:search namespace packet.
                                 The first argument is the JID to send
                                 the packet to.

=head2 IQ::Time Functions

    TimeQuery(to=>string,     - asks the jid specified for its localtime.
              waitforid=>0|1)   If the to is blank, then it queries the
    TimeQuery()                 server.  Returns a hash with the various
                                items set if waitforid is set to 1:

                                  $time{utc}     - Time in UTC
                                  $time{tz}      - Timezone
                                  $time{display} - Display string

    TimeSend(to=>string) - sends the current UTC time to the specified
                           jid.

=head2 IQ::Version Functions

    VersionQuery(to=>string,     - asks the jid specified for its
                 waitforid=>0|1)   client version information.  If the
    VersionQuery()                 to is blank, then it queries the
                                   server.  Returns ahash with the
                                   various items set if waitforid is
                                   set to 1:

                                     $version{name} - Name
                                     $version{ver}  - Version
                                     $version{os}   - Operating System/
                                                        Platform

    VersionSend(to=>string,   - sends the specified version information
                name=>string,   to the jid specified in the to.
                ver=>string,
                os=>string)

=head2 X Functions

    SXPMSend(to=>string,   - sends the specified sxpm information to the
             type=>string,   jid in the to with the message type being
             hash)           set in the type.  See the Net::Jabber::SXPM
                             module for valid values for the hash.
                             This function returns the
                             Net::Jabber::Message object sent to the jid.

=head1 AUTHOR

By Ryan Eatmon in February of 2002 for http://jabber.org

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use Carp;
use vars qw($VERSION);

$VERSION = "1.27";

sub new
{
    my $proto = shift;
    my $self = { };

    $self->{VERSION} = $VERSION;

    bless($self, $proto);
    return $self;
}


###############################################################################
#+-----------------------------------------------------------------------------
#|
#| Base API
#|
#+-----------------------------------------------------------------------------
###############################################################################

###############################################################################
#
# GetErrorCode - if you are returned an undef, you can call this function
#                and hopefully learn more information about the problem.
#
###############################################################################
sub GetErrorCode
{
    shift;
    my $self = shift;
    return ((exists($self->{ERRORCODE}) && ($self->{ERRORCODE} ne "")) ?
            $self->{ERRORCODE} :
            $!
           );
}


##############3################################################################
#
# SetErrorCode - sets the error code so that the caller can find out more
#                information about the problem
#
###############################################################################
sub SetErrorCode
{
    shift;
    my $self = shift;
    my ($errorcode) = @_;
    $self->{ERRORCODE} = $errorcode;
}


###############################################################################
#
# CallBack - Central callback function.  If a packet comes back with an ID
#            and the tag and ID have been registered then the packet is not
#            returned as normal, instead it is inserted in the LIST and
#            stored until the user wants to fetch it.  If the tag and ID
#            are not registered the function checks if a callback exists
#            for this tag, if it does then that callback is called,
#            otherwise the function drops the packet since it does not know
#            how to handle it.
#
###############################################################################
sub CallBack
{
    shift;
    my $self = shift;
    my $sid = shift;
    my ($object) = @_;

    my $tag;
    my $id;
    my $tree;
    
    if (ref($object) !~ /^Net::Jabber/)
    {
        if ($self->{DEBUG}->GetLevel() >= 1 || exists($self->{CB}->{receive}))
        {
            my $xml = $object->GetXML();
            $self->{DEBUG}->Log1("CallBack: sid($sid) received($xml)");
            &{$self->{CB}->{receive}}($sid,$xml) if exists($self->{CB}->{receive});
        }

        $tag = $object->get_tag();
        $id = "";
        $id = $object->get_attrib("id")
            if defined($object->get_attrib("id"));
        $tree = $object;
    }
    else
    {
        $tag = $object->GetTag();
        $id = $object->GetID();
        $tree = $object->GetTree();
    }

    $self->{DEBUG}->Log1("CallBack: tag($tag)");
    $self->{DEBUG}->Log1("CallBack: id($id)") if ($id ne "");

    my $pass = 1;
    $pass = 0
        if (!exists($self->{CB}->{$tag}) &&
            !exists($self->{CB}->{XPath}) &&
            !$self->CheckID($tag,$id)
           );

    if ($pass)
    {
        $self->{DEBUG}->Log1("CallBack: we either want it or were waiting for it.");

        my $NJObject;
        if (ref($object) !~ /^Net::Jabber/)
        {
            $NJObject = $self->BuildObject($tag,$object);
        }
        else
        {
            $NJObject = $object;
        }

        if ($NJObject == -1)
        {
            $self->{DEBUG}->Log1("CallBack: DANGER!! DANGER!! We didn't build a packet!  We're all gonna die!!");
        }
        else
        {
            if ($self->CheckID($tag,$id))
            {
                $self->{DEBUG}->Log1("CallBack: found registry entry: tag($tag) id($id)");
                $self->DeregisterID($tag,$id);
                if ($self->TimedOutID($id))
                {
                    $self->{DEBUG}->Log1("CallBack: dropping packet due to timeout");
                    $self->CleanID($id);
                }
                else
                {
                    $self->{DEBUG}->Log1("CallBack: they still want it... we still got it...");
                    $self->GotID($id,$NJObject);
                }
            }
            else
            {
                $self->{DEBUG}->Log1("CallBack: no registry entry");

                foreach my $xpath (keys(%{$self->{CB}->{XPath}}))
                {
                    if ($NJObject->GetTree()->XPathCheck($xpath))
                    {
                        foreach my $func (keys(%{$self->{CB}->{XPath}->{$xpath}}))
                        {
                            $self->{DEBUG}->Log1("CallBack: goto xpath($xpath) function($func)");
                            &{$self->{CB}->{XPath}->{$xpath}->{$func}}($sid,$NJObject);
                        }
                    }
                }
                
                if (exists($self->{CB}->{$tag}))
                {
                    $self->{DEBUG}->Log1("CallBack: goto user function($self->{CB}->{$tag})");
                    &{$self->{CB}->{$tag}}($sid,$NJObject);
                }
                else
                {
                    $self->{DEBUG}->Log1("CallBack: no defined function.  Dropping packet.");
                }
            }
        }
    }
    else
    {
        $self->{DEBUG}->Log1("CallBack: a packet that no one wants... how sad. =(");
    }
}


###############################################################################
#
# BuildObject - turn the packet into an object.
#
###############################################################################
sub BuildObject
{
    shift;
    my $self = shift;
    my ($tag,$object) = @_;

    my $NJObject = -1;
    if ($tag eq "iq")
    {
        $NJObject = new Net::Jabber::IQ($object);
    }
    elsif ($tag eq "presence")
    {
        $NJObject = new Net::Jabber::Presence($object);
    }
    elsif ($tag eq "message")
    {
        $NJObject = new Net::Jabber::Message($object);
    }
    elsif ($tag eq "xdb")
    {
        $NJObject = new Net::Jabber::XDB($object);
    }
    elsif ($tag eq "db:result")
    {
        $NJObject = new Net::Jabber::Dialback::Result($object);
    }
    elsif ($tag eq "db:verify")
    {
        $NJObject = new Net::Jabber::Dialback::Verify($object);
    }

    return $NJObject;
}


###############################################################################
#
# SetCallBacks - Takes a hash with top level tags to look for as the keys
#                and pointers to functions as the values.  The functions
#                are called and passed the XML::Parser::Tree objects
#                generated by XML::Stream.
#
###############################################################################
sub SetCallBacks
{
    shift;
    my $self = shift;
    while($#_ >= 0)
    {
        my $func = pop(@_);
        my $tag = pop(@_);
        $self->{DEBUG}->Log1("SetCallBacks: tag($tag) func($func)");
        if (defined($func))
        {
            $self->{CB}->{$tag} = $func;
        }
        else
        {
            delete($self->{CB}->{$tag});
        }
        $self->{STREAM}->SetCallBacks(update=>$func) if ($tag eq "update");
    }
}


###############################################################################
#
# SetIQCallBacks - define callbacks for the namespaces inside an iq.
#
###############################################################################
sub SetIQCallBacks
{
    shift;
    my $self = shift;

    while($#_ >= 0)
    {
        my $hash = pop(@_);
        my $namespace = pop(@_);

        foreach my $type (keys(%{$hash}))
        {
            if (defined($hash->{$type}))
            {
                $self->{CB}->{IQns}->{$namespace}->{$type} = $hash->{$type};
            }
            else
            {
                delete($self->{CB}->{IQns}->{$namespace}->{$type});
            }
        }
    }
}


###############################################################################
#
# SetPresenceCallBacks - define callbacks for the different presence packets.
#
###############################################################################
sub SetPresenceCallBacks
{
    shift;
    my $self = shift;
    my (%types) = @_;

    foreach my $type (keys(%types))
    {
        if (defined($types{$type}))
        {
            $self->{CB}->{Pres}->{$type} = $types{$type};
        }
        else
        {
            delete($self->{CB}->{Pres}->{$type});
        }
    }
}


###############################################################################
#
# SetMessageCallBacks - define callbacks for the different message packets.
#
###############################################################################
sub SetMessageCallBacks
{
    shift;
    my $self = shift;
    my (%types) = @_;

    foreach my $type (keys(%types))
    {
        if (defined($types{$type}))
        {
            $self->{CB}->{Mess}->{$type} = $types{$type};
        }
        else
        {
            delete($self->{CB}->{Mess}->{$type});
        }
    }
}


###############################################################################
#
# SetXPathCallBacks - define callbacks for packets based on XPath.
#
###############################################################################
sub SetXPathCallBacks
{ 
    shift;
    my $self = shift;
    my (%xpaths) = @_;

    foreach my $xpath (keys(%xpaths))
    {
        $self->{DEBUG}->Log1("SetXPathCallBacks: xpath($xpath) func($xpaths{$xpath})");
        $self->{CB}->{XPath}->{$xpath}->{$xpaths{$xpath}} = $xpaths{$xpath};
    }
}


###############################################################################
#
# RemoveXPathCallBacks - remove callbacks for packets based on XPath.
#
###############################################################################
sub RemoveXPathCallBacks
{
    shift;
    my $self = shift;
    my (%xpaths) = @_;

    foreach my $xpath (keys(%xpaths))
    {
        $self->{DEBUG}->Log1("RemoveXPathCallBacks: xpath($xpath) func($xpaths{$xpath})");
        delete($self->{CB}->{XPath}->{$xpath}->{$xpaths{$xpath}});
    }
}


###############################################################################
#
# Info - set the base information about this Jabber Client/Component for
#        use in a default response.
#
###############################################################################
sub Info
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    foreach my $arg (keys(%args))
    {
        $self->{INFO}->{$arg} = $args{$arg};
    }
}


###############################################################################
#
#  Process - If a timeout value is specified then the function will wait
#            that long before returning.  This is useful for apps that
#            need to handle other processing while still waiting for
#            packets.  If no timeout is listed then the function waits
#            until a packet is returned.  Either way the function exits
#            as soon as a packet is returned.
#
###############################################################################
sub Process
{
    shift;
    my $self = shift;
    my ($timeout) = @_;
    my %status;

    $self->{DEBUG}->Log1("Process: timeout($timeout)") if defined($timeout);

    if (!defined($timeout) || ($timeout eq ""))
    {
        while(1)
        {
            %status = $self->{STREAM}->Process();
            $self->{DEBUG}->Log1("Process: status($status{$self->{SESSION}->{id}})");
            last if ($status{$self->{SESSION}->{id}} != 0);
            select(undef,undef,undef,.25);
        }
        $self->{DEBUG}->Log1("Process: return($status{$self->{SESSION}->{id}})");
        return (($status{$self->{SESSION}->{id}} == -1) ?
                undef :
                $status{$self->{SESSION}->{id}}
               );
    }
    else
    {
        %status = $self->{STREAM}->Process($timeout);
        return (($status{$self->{SESSION}->{id}} == -1) ?
                 undef :
                 $status{$self->{SESSION}->{id}}
               );
    }
}


###############################################################################
#
# Send - Takes either XML or a Net::Jabber::xxxx object and sends that
#        packet to the server.
#
###############################################################################
sub Send
{
    shift;
    my $self = shift;
    my $object = shift;
    my $ignoreActivity = shift;
    $ignoreActivity = 0 unless defined($ignoreActivity);

    if (ref($object) eq "")
    {
        $self->SendXML($object,$ignoreActivity);
    }
    else
    {
        $self->SendXML($object->GetXML(),$ignoreActivity);
    }
}


###############################################################################
#
# SendXML - Sends the XML packet to the server
#
###############################################################################
sub SendXML
{
    shift;
    my $self = shift;
    my $xml = shift;
    my $ignoreActivity = shift;
    $ignoreActivity = 0 unless defined($ignoreActivity);

    $self->{DEBUG}->Log1("SendXML: sent($xml)");
    &{$self->{CB}->{send}}($self->{SESSION}->{id},$xml) if exists($self->{CB}->{send});
    $self->{STREAM}->IgnoreActivity($self->{SESSION}->{id},$ignoreActivity);
    $self->{STREAM}->Send($self->{SESSION}->{id},$xml);
    $self->{STREAM}->IgnoreActivity($self->{SESSION}->{id},0);
}


###############################################################################
#
# SendWithID - Take either XML or a Net::Jabber::xxxx object and send it
#              with the next available ID number.  Then return that ID so
#              the client can track it.
#
###############################################################################
sub SendWithID
{
    shift;
    my $self = shift;
    my ($object) = @_;

    #----------------------------------------------------------------------------
    # Take the current XML stream and insert an id attrib at the top level.
    #----------------------------------------------------------------------------
    my $currentID = $self->{LIST}->{currentID};

    $self->{DEBUG}->Log1("SendWithID: currentID($currentID)");

    my $xml;
    if (ref($object) eq "")
    {
        $self->{DEBUG}->Log1("SendWithID: in($object)");
        $xml = $object;
        $xml =~ s/^(\<[^\>]+)(\>)/$1 id\=\'$currentID\'$2/;
        my ($tag) = ($xml =~ /^\<(\S+)\s/);
        $self->RegisterID($tag,$currentID);
    }
    else
    {
        $self->{DEBUG}->Log1("SendWithID: in(",$object->GetXML(),")");
        $object->SetID($currentID);
        $xml = $object->GetXML();
        $self->RegisterID($object->GetTag(),$currentID);
    }
    $self->{DEBUG}->Log1("SendWithID: out($xml)");

    #----------------------------------------------------------------------------
    # Send the new XML string.
    #----------------------------------------------------------------------------
    $self->SendXML($xml);

    #----------------------------------------------------------------------------
    # Increment the currentID and return the ID number we just assigned.
    #----------------------------------------------------------------------------
    $self->{LIST}->{currentID}++;
    return $currentID;
}


###############################################################################
#
# SendAndReceiveWithID - Take either XML or a Net::Jabber::xxxxx object and
#                        send it with the next ID.  Then wait for that ID
#                        to come back and return the response in a
#                        Net::Jabber::xxxx object.
#
###############################################################################
sub SendAndReceiveWithID
{
    shift;
    my $self = shift;
    my ($object,$timeout) = @_;
    &{$self->{CB}->{startwait}}() if exists($self->{CB}->{startwait});
    $self->{DEBUG}->Log1("SendAndReceiveWithID: object($object)");
    my $id = $self->SendWithID($object);
    $self->{DEBUG}->Log1("SendAndReceiveWithID: sent with id($id)");
    my $packet = $self->WaitForID($id,$timeout);
    &{$self->{CB}->{endwait}}() if exists($self->{CB}->{endwait});
    return $packet;
}


###############################################################################
#
# ReceivedID - returns 1 if a packet with the ID has been received, or 0
#              if it has not.
#
###############################################################################
sub ReceivedID
{
    shift;
    my $self = shift;
    my ($id) = @_;

    $self->{DEBUG}->Log1("ReceivedID: id($id)");
    return 1 if exists($self->{LIST}->{$id});
    $self->{DEBUG}->Log1("ReceivedID: nope...");
    return 0;
}


###############################################################################
#
# GetID - Return the Net::Jabber::xxxxx object that is stored in the LIST
#         that matches the ID if that ID exists.  Otherwise return 0.
#
###############################################################################
sub GetID
{
    shift;
    my $self = shift;
    my ($id) = @_;

    $self->{DEBUG}->Log1("GetID: id($id)");
    return $self->{LIST}->{$id} if $self->ReceivedID($id);
    $self->{DEBUG}->Log1("GetID: haven't gotten that id yet...");
    return 0;
}


###############################################################################
#
# CleanID - Delete the list entry for this id since we don't want a leak.
#
###############################################################################
sub CleanID
{
    shift;
    my $self = shift;
    my ($id) = @_;

    $self->{DEBUG}->Log1("CleanID: id($id)");
    delete($self->{LIST}->{$id});
}


###############################################################################
#
# WaitForID - Keep looping and calling Process(1) to poll every second
#             until the response from the server occurs.
#
###############################################################################
sub WaitForID
{
    shift;
    my $self = shift;
    my ($id,$timeout) = @_;
    $timeout = "300" unless defined($timeout);

    $self->{DEBUG}->Log1("WaitForID: id($id)");
    my $endTime = time + $timeout;
    while(!$self->ReceivedID($id) && ($endTime >= time))
    {
        $self->{DEBUG}->Log1("WaitForID: haven't gotten it yet... let's wait for more packets");
        return unless (defined($self->Process(1)));
        &{$self->{CB}->{update}}() if exists($self->{CB}->{update});
    }
    if (!$self->ReceivedID($id))
    {
        $self->TimeoutID($id);
        $self->{DEBUG}->Log1("WaitForID: timed out...");
        return;
    }
    else
    {
        $self->{DEBUG}->Log1("WaitForID: we got it!");
        my $packet = $self->GetID($id);
        $self->CleanID($id);
        return $packet;
    }
}


###############################################################################
#
# GotID - Callback to store the Net::Jabber::xxxxx object in the LIST at
#         the ID index.  This is a private helper function.
#
###############################################################################
sub GotID
{
    shift;
    my $self = shift;
    my ($id,$object) = @_;

    $self->{DEBUG}->Log1("GotID: id($id) xml(",$object->GetXML(),")");
    $self->{LIST}->{$id} = $object;
}


###############################################################################
#
# CheckID - Checks the ID registry if this tag and ID have been registered.
#           0 = no, 1 = yes
#
###############################################################################
sub CheckID
{
    shift;
    my $self = shift;
    my ($tag,$id) = @_;
    $id = "" unless defined($id);

    $self->{DEBUG}->Log1("CheckID: tag($tag) id($id)");
    return 0 if ($id eq "");
    $self->{DEBUG}->Log1("CheckID: we have that here somewhere...");
    return exists($self->{IDRegistry}->{$tag}->{$id});
}


###############################################################################
#
# TimeoutID - Timeout the tag and ID in the registry so that the CallBack
#             can know what to put in the ID list and what to pass on.
#
###############################################################################
sub TimeoutID
{
    shift;
    my $self = shift;
    my ($id) = @_;

    $self->{DEBUG}->Log1("TimeoutID: id($id)");
    $self->{LIST}->{$id} = 0;
}


###############################################################################
#
# TimedOutID - Timeout the tag and ID in the registry so that the CallBack
#             can know what to put in the ID list and what to pass on.
#
###############################################################################
sub TimedOutID
{
    shift;
    my $self = shift;
    my ($id) = @_;

    return (exists($self->{LIST}->{$id}) && ($self->{LIST}->{$id} == 0));
}


###############################################################################
#
# RegisterID - Register the tag and ID in the registry so that the CallBack
#              can know what to put in the ID list and what to pass on.
#
###############################################################################
sub RegisterID
{
    shift;
    my $self = shift;
    my ($tag,$id) = @_;

    $self->{DEBUG}->Log1("RegisterID: tag($tag) id($id)");
    $self->{IDRegistry}->{$tag}->{$id} = 1;
}


###############################################################################
#
# DeregisterID - Delete the tag and ID in the registry so that the CallBack
#                can knows that it has been received.
#
###############################################################################
sub DeregisterID
{
    shift;
    my $self = shift;
    my ($tag,$id) = @_;

    $self->{DEBUG}->Log1("DeregisterID: tag($tag) id($id)");
    delete($self->{IDRegistry}->{$tag}->{$id});
}


###############################################################################
#
# DefineNamespace - adds the namespace and corresponding functions onto the
#                   of available functions based on namespace.
#
###############################################################################
sub DefineNamespace
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    croak("You must specify xmlns=>'' for the function call to DefineNamespace")
        if !exists($args{xmlns});
    croak("You must specify type=>'' for the function call to DefineNamespace")
        if !exists($args{type});
    croak("You must specify functions=>'' for the function call to DefineNamespace")
        if !exists($args{functions});
    
    eval("delete(\$Net::Jabber::$args{type}::NAMESPACES{\$args{xmlns}}) if exists(\$Net::Jabber::$args{type}::NAMESPACES{\$args{xmlns}})");
    
    foreach my $function (@{$args{functions}})
    {
        my %tempHash = %{$function};
        my %funcHash;
        foreach my $func (keys(%tempHash))
        {
            $funcHash{ucfirst(lc($func))} = $tempHash{$func};
        }

        croak("You must specify name=>'' for each function in call to DefineNamespace")
            if !exists($funcHash{Name});

        my $name = delete($funcHash{Name});

        if (!exists($funcHash{Set}) && exists($funcHash{Get}))
        {
            croak("The DefineNamespace arugments have changed, and I cannot determine the\nnew values automatically for name($name).  Please read the man page\nfor Net::Jabber::Namespaces.  I apologize for this incompatability.\n");
        }

        if (exists($funcHash{Type}) || exists($funcHash{Path}) ||
            exists($funcHash{Child}) || exists($funcHash{Calls}))
        {
            foreach my $type (keys(%funcHash))
            {
                eval("\$Net::Jabber::$args{type}::NAMESPACES{'$args{xmlns}'}->{'$name'}->{XPath}->{'$type'} = \$funcHash{'$type'};");
            }
            next;
        }
        
        my $type = $funcHash{Set}->[0];
        my $xpath = $funcHash{Set}->[1];
        if (exists($funcHash{Hash}))
        {
            $xpath = "text()" if ($funcHash{Hash} eq "data");
            $xpath .= "/text()" if ($funcHash{Hash} eq "child-data");
            $xpath = "\@$xpath" if ($funcHash{Hash} eq "att");
            $xpath = "$1/\@$2" if ($funcHash{Hash} =~ /^att-(\S+)-(.+)$/);
        }

        if ($type eq "master")
        {
            eval("\$Net::Jabber::$args{type}::NAMESPACES{\$args{xmlns}}->{\$name}->{XPath}->{Type} = 'master';");
            next;
        }
        
        if ($type eq "scalar")
        {
            eval("\$Net::Jabber::$args{type}::NAMESPACES{\$args{xmlns}}->{\$name}->{XPath}->{Path} = '$xpath';");
            next;
        }
        
        if ($type eq "flag")
        {
            eval("\$Net::Jabber::$args{type}::NAMESPACES{\$args{xmlns}}->{\$name}->{XPath}->{Type} = 'flag';");
            eval("\$Net::Jabber::$args{type}::NAMESPACES{\$args{xmlns}}->{\$name}->{XPath}->{Path} = '$xpath';");
            next;
        }

        if (($funcHash{Hash} eq "child-add") && exists($funcHash{Add}))
        {
            eval("\$Net::Jabber::$args{type}::NAMESPACES{'$args{xmlns}'}->{'$name'}->{XPath}->{Type}  = 'node';");
            eval("\$Net::Jabber::$args{type}::NAMESPACES{'$args{xmlns}'}->{'$name'}->{XPath}->{Path}  = '\$funcHash{Add}->[3]';");
            eval("\$Net::Jabber::$args{type}::NAMESPACES{'$args{xmlns}'}->{'$name'}->{XPath}->{Child} = ['\$funcHash{Add}->[0]','\$funcHash{Add}->[1]'];");
            eval("\$Net::Jabber::$args{type}::NAMESPACES{'$args{xmlns}'}->{'$name'}->{XPath}->{Calls} = ['Add'];");
            next;
        }
    }
}


###############################################################################
#
# MessageSend - Takes the same hash that Net::Jabber::Message->SetMessage
#               takes and sends the message to the server.
#
###############################################################################
sub MessageSend
{
    shift;
    my $self = shift;

    my $mess = new Net::Jabber::Message();
    $mess->SetMessage(@_);
    $self->Send($mess);
}


###############################################################################
#
# PresenceDBParse - adds the presence information to the Presence DB so
#                   you can keep track of the current state of the JID and
#                   all of it's resources.
#
###############################################################################
sub PresenceDBParse
{
    shift;
    my $self = shift;
    my ($presence) = @_;

    my $type = $presence->GetType();
    $type = "" unless defined($type);
    return $presence unless (($type eq "") ||
                 ($type eq "available") ||
                 ($type eq "unavailable"));

    my $fromJID = $presence->GetFrom("jid");
    my $fromID = $fromJID->GetJID();
    $fromID = "" unless defined($fromID);
    my $resource = $fromJID->GetResource();
    $resource = " " unless ($resource ne "");
    my $priority = $presence->GetPriority();
    $priority = 0 unless defined($priority);

    $self->{DEBUG}->Log1("PresenceDBParse: fromJID(",$fromJID->GetJID("full"),") resource($resource) priority($priority) type($type)");
    $self->{DEBUG}->Log2("PresenceDBParse: xml(",$presence->GetXML(),")");

    if (exists($self->{PRESENCEDB}->{$fromID}))
    {
        my $oldPriority = $self->{PRESENCEDB}->{$fromID}->{resources}->{$resource};
        $oldPriority = "" unless defined($oldPriority);

        my $loc = 0;
        foreach my $index (0..$#{$self->{PRESENCEDB}->{$fromID}->{priorities}->{$oldPriority}})
        {
            $loc = $index
               if ($self->{PRESENCEDB}->{$fromID}->{priorities}->{$oldPriority}->[$index]->{resource} eq $resource);
        }
        splice(@{$self->{PRESENCEDB}->{$fromID}->{priorities}->{$oldPriority}},$loc,1);
        delete($self->{PRESENCEDB}->{$fromID}->{resources}->{$resource});
        delete($self->{PRESENCEDB}->{$fromID}->{priorities}->{$oldPriority})
            if (exists($self->{PRESENCEDB}->{$fromID}->{priorities}->{$oldPriority}) &&
        ($#{$self->{PRESENCEDB}->{$fromID}->{priorities}->{$oldPriority}} == -1));
        delete($self->{PRESENCEDB}->{$fromID})
            if (scalar(keys(%{$self->{PRESENCEDB}->{$fromID}})) == 0);

        $self->{DEBUG}->Log1("PresenceDBParse: remove ",$fromJID->GetJID("full")," from the DB");
    }

    if (($type eq "") || ($type eq "available"))
    {
        my $loc = -1;
        foreach my $index (0..$#{$self->{PRESENCEDB}->{$fromID}->{priorities}->{$priority}}) {
            $loc = $index
                if ($self->{PRESENCEDB}->{$fromID}->{priorities}->{$priority}->[$index]->{resource} eq $resource);
        }
        $loc = $#{$self->{PRESENCEDB}->{$fromID}->{priorities}->{$priority}}+1
            if ($loc == -1);
        $self->{PRESENCEDB}->{$fromID}->{resources}->{$resource} = $priority;
        $self->{PRESENCEDB}->{$fromID}->{priorities}->{$priority}->[$loc]->{presence} =
            $presence;
        $self->{PRESENCEDB}->{$fromID}->{priorities}->{$priority}->[$loc]->{resource} =
            $resource;

        $self->{DEBUG}->Log1("PresenceDBParse: add ",$fromJID->GetJID("full")," to the DB");
    }

    my $currentPresence = $self->PresenceDBQuery($fromJID);
    return (defined($currentPresence) ? $currentPresence : $presence);
}


###############################################################################
#
# PresenceDBDelete - delete the JID from the DB completely.
#
###############################################################################
sub PresenceDBDelete
{
    shift;
    my $self = shift;
    my ($jid) = @_;

    my $indexJID = $jid;
    $indexJID = $jid->GetJID() if (ref($jid) eq "Net::Jabber::JID");

    return if !exists($self->{PRESENCEDB}->{$indexJID});
    delete($self->{PRESENCEDB}->{$indexJID});
    $self->{DEBUG}->Log1("PresenceDBDelete: delete ",$indexJID," from the DB");
}


###############################################################################
#
# PresenceDBQuery - retrieve the last Net::Jabber::Presence received with
#                  the highest priority.
#
###############################################################################
sub PresenceDBQuery
{
    shift;
    my $self = shift;
    my ($jid) = @_;

    my $indexJID = $jid;
    $indexJID = $jid->GetJID() if (ref($jid) eq "Net::Jabber::JID");

    return if !exists($self->{PRESENCEDB}->{$indexJID});
    return if (scalar(keys(%{$self->{PRESENCEDB}->{$indexJID}->{priorities}})) == 0);

    my $highPriority =
        (sort {$b cmp $a} keys(%{$self->{PRESENCEDB}->{$indexJID}->{priorities}}))[0];

    return $self->{PRESENCEDB}->{$indexJID}->{priorities}->{$highPriority}->[0]->{presence};
}


###############################################################################
#
# PresenceDBResources - returns a list of the resources from highest
#                       priority to lowest.
#
###############################################################################
sub PresenceDBResources
{
    shift;
    my $self = shift;
    my ($jid) = @_;

    my $indexJID = $jid;
    $indexJID = $jid->GetJID() if (ref($jid) eq "Net::Jabber::JID");

    my @resources;

    return if !exists($self->{PRESENCEDB}->{$indexJID});

    foreach my $priority (sort {$b cmp $a} keys(%{$self->{PRESENCEDB}->{$indexJID}->{priorities}}))
    {
        foreach my $index (0..$#{$self->{PRESENCEDB}->{$indexJID}->{priorities}->{$priority}})
        {
            next if ($self->{PRESENCEDB}->{$indexJID}->{priorities}->{$priority}->[$index]->{resource} eq " ");
            push(@resources,$self->{PRESENCEDB}->{$indexJID}->{priorities}->{$priority}->[$index]->{resource});
        }
    }
    return @resources;
}


###############################################################################
#
# PresenceSend - Sends a presence tag to announce your availability
#
###############################################################################
sub PresenceSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{ignoreactivity} = 0 unless exists($args{ignoreactivity});
    my $ignoreActivity = delete($args{ignoreactivity});

    my $presence = new Net::Jabber::Presence();

    if (exists($args{signature}))
    {
        my $xSigned = $presence->NewX("jabber:x:signed");
        $xSigned->SetSigned(signature=>delete($args{signature}));
    }

    $presence->SetPresence(%args);
    $self->Send($presence,$ignoreActivity);
    return $presence;
}


###############################################################################
#
# PresenceProbe - Sends a presence probe to the server
#
###############################################################################
sub PresenceProbe
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }
    delete($args{type});

    my $presence = new Net::Jabber::Presence();
    $presence->SetPresence(type=>"probe",
                           %args);
    $self->Send($presence);
}


###############################################################################
#
# Subscription - Sends a presence tag to perform the subscription on the
#                specified JID.
#
###############################################################################
sub Subscription
{
    shift;
    my $self = shift;

    my $presence = new Net::Jabber::Presence();
    $presence->SetPresence(@_);
    $self->Send($presence);
}


###############################################################################
#
# AgentsGet - Sends an empty IQ to the server/transport to request that the
#             list of supported Agents be sent to them.  Returns a hash
#             containing the values for the agents.
#
###############################################################################
sub AgentsGet
{
    shift;
    my $self = shift;

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(@_);
    $iq->SetIQ(type=>"get");
    my $query = $iq->NewQuery("jabber:iq:agents");

    $iq = $self->SendAndReceiveWithID($iq);

    return unless defined($iq);

    $query = $iq->GetQuery();
    my @agents = $query->GetAgents();

    my %agents;
    my $count = 0;
    foreach my $agent (@agents)
    {
        my $jid = $agent->GetJID();
        $agents{$jid}->{name} = $agent->GetName();
        $agents{$jid}->{description} = $agent->GetDescription();
        $agents{$jid}->{transport} = $agent->GetTransport();
        $agents{$jid}->{service} = $agent->GetService();
        $agents{$jid}->{register} = $agent->DefinedRegister();
        $agents{$jid}->{search} = $agent->DefinedSearch();
        $agents{$jid}->{groupchat} = $agent->DefinedGroupChat();
        $agents{$jid}->{agents} = $agent->DefinedAgents();
        $agents{$jid}->{order} = $count++;
    }

    return %agents;
}


###############################################################################
#
# AuthSend - This is a self contained function to send a login iq tag with
#            an id.  Then wait for a reply what the same id to come back
#            and tell the caller what the result was.
#
###############################################################################
sub AuthSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    carp("AuthSend requires a username arguement")
        unless exists($args{username});
    carp("AuthSend requires a password arguement")
        unless exists($args{password});
    carp("AuthSend requires a resource arguement")
        unless exists($args{resource});

    my $authType = "digest";
    my $token;
    my $sequence;

    #--------------------------------------------------------------------------
    # First let's ask the sever what all is available in terms of auth types.
    # If we get an error, then all we can do is digest or plain.
    #--------------------------------------------------------------------------
    my $iqAuthProbe = new Net::Jabber::IQ();
    $iqAuthProbe->SetIQ(type=>"get");
    my $iqAuthProbeQuery = $iqAuthProbe->NewQuery("jabber:iq:auth");
    $iqAuthProbeQuery->SetUsername($args{username});
    $iqAuthProbe = $self->SendAndReceiveWithID($iqAuthProbe);

    return unless defined($iqAuthProbe);
    return ( $iqAuthProbe->GetErrorCode() , $iqAuthProbe->GetError() )
        if ($iqAuthProbe->GetType() eq "error");

    if ($iqAuthProbe->GetType() eq "error")
    {
        $authType = "digest";
    }
    else
    {
        $iqAuthProbeQuery = $iqAuthProbe->GetQuery();
        $authType = "plain" if $iqAuthProbeQuery->DefinedPassword();
        $authType = "digest" if $iqAuthProbeQuery->DefinedDigest();
        $authType = "zerok" if ($iqAuthProbeQuery->DefinedSequence() &&
                    $iqAuthProbeQuery->DefinedToken());
        $token = $iqAuthProbeQuery->GetToken() if ($authType eq "zerok");
        $sequence = $iqAuthProbeQuery->GetSequence() if ($authType eq "zerok");
    }

    delete($args{digest});
    delete($args{type});

    #----------------------------------------------------------------------------
    # 0k authenticaion (http://core.jabber.org/0k.html)
    #
    # Tell the server that we want to connect this way, the server sends back
    # a token and a sequence number.  We take that token + the password and
    # SHA1 it.  Then we SHA1 it sequence number more times and send that hash.
    # The server SHA1s that hash one more time and compares it to the hash it
    # stored last time.  IF they match, we are in and it stores the hash we sent
    # for the next time and decreases the sequence number, else, no go.
    #----------------------------------------------------------------------------
    if ($authType eq "zerok")
    {
        my $hashA = Digest::SHA1::sha1_hex(delete($args{password}));
        $args{hash} = Digest::SHA1::sha1_hex($hashA.$token);

        for (1..$sequence)
        {
            $args{hash} = Digest::SHA1::sha1_hex($args{hash});
        }
    }

    #----------------------------------------------------------------------------
    # If we have access to the SHA-1 digest algorithm then let's use it.
    # Remove the password from the hash, create the digest, and put the
    # digest in the hash instead.
    #
    # Note: Concat the Session ID and the password and then digest that
    # string to get the server to accept the digest.
    #----------------------------------------------------------------------------
    if ($authType eq "digest")
    {
        my $password = delete($args{password});
        $args{digest} = Digest::SHA1::sha1_hex($self->{SESSION}->{id}.$password);
    }

    #----------------------------------------------------------------------------
    # Create a Net::Jabber::IQ object to send to the server
    #----------------------------------------------------------------------------
    my $IQLogin = new Net::Jabber::IQ();
    $IQLogin->SetIQ(type=>"set");
    my $IQAuth = $IQLogin->NewQuery("jabber:iq:auth");
    $IQAuth->SetAuth(%args);

    #----------------------------------------------------------------------------
    # Send the IQ with the next available ID and wait for a reply with that
    # id to be received.  Then grab the IQ reply.
    #----------------------------------------------------------------------------
    $IQLogin = $self->SendAndReceiveWithID($IQLogin);

    #----------------------------------------------------------------------------
    # From the reply IQ determine if we were successful or not.  If yes then
    # return "".  If no then return error string from the reply.
    #----------------------------------------------------------------------------
    return unless defined($IQLogin);
    return ( $IQLogin->GetErrorCode() , $IQLogin->GetError() )
        if ($IQLogin->GetType() eq "error");
    return ("ok","");
}


###############################################################################
#
# BrowseRequest - requests the browse information from the specified JID.
#
###############################################################################
sub BrowseRequest
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $timeout = exists($args{timeout}) ? delete($args{timeout}) : undef;

    my $IQ = new Net::Jabber::IQ();
    $IQ->SetIQ(to=>$args{jid},
               type=>"get");
    my $IQBrowse = $IQ->NewQuery("jabber:iq:browse");

    #--------------------------------------------------------------------------
    # Send the IQ with the next available ID and wait for a reply with that
    # id to be received.  Then grab the IQ reply.
    #--------------------------------------------------------------------------
    $IQ = $self->SendAndReceiveWithID($IQ,$timeout);

    #--------------------------------------------------------------------------
    # Check if there was an error.
    #--------------------------------------------------------------------------
    return unless defined($IQ);
    if ($IQ->GetType() eq "error")
    {
        $self->SetErrorCode($IQ->GetErrorCode().": ".$IQ->GetError());
        return;
    }

    $IQBrowse = $IQ->GetQuery();

    if (defined($IQBrowse))
    {
        my %browse = %{$self->BrowseParse($IQBrowse)};
        return %browse;
    }
    else
    {
        return;
    }
}


###############################################################################
#
# BrowseParse - helper function for BrowseRequest to convert the object
#               tree into a hash for better consumption.
#
###############################################################################
sub BrowseParse
{
    shift;
    my $self = shift;
    my $item = shift;
    my %browse;

    if ($item->DefinedCategory())
    {
        $browse{category} = $item->GetCategory();
    }
    else
    {
        $browse{category} = $item->GetTag();
    }
    $browse{type} = $item->GetType();
    $browse{name} = $item->GetName();
    $browse{jid} = $item->GetJID();
    $browse{ns} = [ $item->GetNS() ];

    foreach my $subitem ($item->GetItems())
    {
        my ($subbrowse) = $self->BrowseParse($subitem);
        push(@{$browse{children}},$subbrowse);
    }

    return \%browse;
}


###############################################################################
#
# BrowseDBDelete - delete the JID from the DB completely.
#
###############################################################################
sub BrowseDBDelete
{
    shift;
    my $self = shift;
    my ($jid) = @_;

    my $indexJID = $jid;
    $indexJID = $jid->GetJID() if (ref($jid) eq "Net::Jabber::JID");

    return if !exists($self->{BROWSEDB}->{$indexJID});
    delete($self->{BROWSEDB}->{$indexJID});
    $self->{DEBUG}->Log1("BrowseDBDelete: delete ",$indexJID," from the DB");
}


###############################################################################
#
# BrowseDBQuery - retrieve the last Net::Jabber::Browse received with
#                  the highest priority.
#
###############################################################################
sub BrowseDBQuery
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{timeout} = 10 unless exists($args{timeout});

    my $indexJID = $args{jid};
    $indexJID = $args{jid}->GetJID() if (ref($args{jid}) eq "Net::Jabber::JID");

    if ((exists($args{refresh}) && ($args{refresh} eq "1")) ||
        (!exists($self->{BROWSEDB}->{$indexJID})))
    {
        my %browse = $self->BrowseRequest(jid=>$args{jid},
                                          timeout=>$args{timeout});

        $self->{BROWSEDB}->{$indexJID} = \%browse;
    }
    return %{$self->{BROWSEDB}->{$indexJID}};
}


###############################################################################
#
# LastQuery - Sends an iq:last query to either the server or the specified
#             JID.
#
###############################################################################
sub LastQuery
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{waitforid} = 0 unless exists($args{waitforid});
    my $waitforid = delete($args{waitforid});

    my $timeout = exists($args{timeout}) ? delete($args{timeout}) : undef;

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(to=>delete($args{to})) if exists($args{to});
    $iq->SetIQ(type=>'get');
    my $last = $iq->NewQuery("jabber:iq:last");

    if ($waitforid == 0)
    {
        $self->Send($iq);
    }
    else
    {
        $iq = $self->SendAndReceiveWithID($iq,$timeout);

        return unless defined($iq);

        $last = $iq->GetQuery();

        return unless defined($last);

        return $last->GetLast();
    }
}


###############################################################################
#
# LastSend - sends an iq:last packet to the specified user.
#
###############################################################################
sub LastSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{ignoreactivity} = 0 unless exists($args{ignoreactivity});
    my $ignoreActivity = delete($args{ignoreactivity});

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(to=>delete($args{to}),
             type=>'result');
    my $last = $iq->NewQuery("jabber:iq:last");
    $last->SetLast(%args);

    $self->Send($iq,$ignoreActivity);
}


###############################################################################
#
# LastActivity - returns number of seconds since the last activity.
#
###############################################################################
sub LastActivity
{
    shift;
    my $self = shift;

    return (time - $self->{STREAM}->LastActivity($self->{SESSION}->{id}));
}


###############################################################################
#
# RegisterRequest - This is a self contained function to send an iq tag
#                   an id that requests the target address to send back
#                   the required fields.  It waits for a reply what the
#                   same id to come back and tell the caller what the
#                   fields are.
#
###############################################################################
sub RegisterRequest
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $timeout = exists($args{timeout}) ? delete($args{timeout}) : undef;

    #----------------------------------------------------------------------------
    # Create a Net::Jabber::IQ object to send to the server
    #----------------------------------------------------------------------------
    my $IQ = new Net::Jabber::IQ();
    $IQ->SetIQ(to=>delete($args{to})) if exists($args{to});
    $IQ->SetIQ(type=>"get");
    my $IQRegister = $IQ->NewQuery("jabber:iq:register");

    #----------------------------------------------------------------------------
    # Send the IQ with the next available ID and wait for a reply with that
    # id to be received.  Then grab the IQ reply.
    #----------------------------------------------------------------------------
    $IQ = $self->SendAndReceiveWithID($IQ,$timeout);

    #----------------------------------------------------------------------------
    # Check if there was an error.
    #----------------------------------------------------------------------------
    return unless defined($IQ);
    if ($IQ->GetType() eq "error")
    {
        $self->SetErrorCode($IQ->GetErrorCode().": ".$IQ->GetError());
        return;
    }

    my %register;
    #----------------------------------------------------------------------------
    # From the reply IQ determine what fields are required and send a hash
    # back with the fields and any values that are already defined (like key)
    #----------------------------------------------------------------------------
    $IQRegister = $IQ->GetQuery();
    $register{fields} = { $IQRegister->GetRegister() };

    #----------------------------------------------------------------------------
    # Get any forms so that we have the option of showing a nive dynamic form
    # to the user and not just a bunch of fields.
    #----------------------------------------------------------------------------
    &ExtractForms(\%register,$IQRegister->GetX("jabber:x:data"));

    #----------------------------------------------------------------------------
    # Get any oobs so that we have the option of sending the user to the http
    # form and not a dynamic one.
    #----------------------------------------------------------------------------
    &ExtractOobs(\%register,$IQRegister->GetX("jabber:x:oob"));

    return %register;
}


###############################################################################
#
# RegisterSend - This is a self contained function to send a registration
#                iq tag with an id.  Then wait for a reply what the same
#                id to come back and tell the caller what the result was.
#
###############################################################################
sub RegisterSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    #----------------------------------------------------------------------------
    # Create a Net::Jabber::IQ object to send to the server
    #----------------------------------------------------------------------------
    my $IQ = new Net::Jabber::IQ();
    $IQ->SetIQ(to=>delete($args{to})) if exists($args{to});
    $IQ->SetIQ(type=>"set");
    my $IQRegister = $IQ->NewQuery("jabber:iq:register");
    $IQRegister->SetRegister(%args);

    #----------------------------------------------------------------------------
    # Send the IQ with the next available ID and wait for a reply with that
    # id to be received.  Then grab the IQ reply.
    #----------------------------------------------------------------------------
    $IQ = $self->SendAndReceiveWithID($IQ);

    #----------------------------------------------------------------------------
    # From the reply IQ determine if we were successful or not.  If yes then
    # return "".  If no then return error string from the reply.
    #----------------------------------------------------------------------------
    return unless defined($IQ);
    return ( $IQ->GetErrorCode() , $IQ->GetError() )
        if ($IQ->GetType() eq "error");
    return ("ok","");
}


###############################################################################
#
# RegisterSendData - This is a self contained function to send a register iq
#                    tag with an id.  It uses the jabber:x:data method to
#                    return the data.
#
###############################################################################
sub RegisterSendData
{
    shift;
    my $self = shift;
    my $to = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    #----------------------------------------------------------------------------
    # Create a Net::Jabber::IQ object to send to the server
    #----------------------------------------------------------------------------
    my $IQ = new Net::Jabber::IQ();
    $IQ->SetIQ(to=>$to) if (defined($to) && ($to ne ""));
    $IQ->SetIQ(type=>"set");
    my $IQRegister = $IQ->NewQuery("jabber:iq:register");
    my $xForm = $IQRegister->NewX("jabber:x:data");
    foreach my $var (keys(%args))
    {
        next if ($args{$var} eq "");
        $xForm->AddField(var=>$var,
                         value=>$args{$var}
                        );
    }

    #----------------------------------------------------------------------------
    # Send the IQ with the next available ID and wait for a reply with that
    # id to be received.  Then grab the IQ reply.
    #----------------------------------------------------------------------------
    $IQ = $self->SendAndReceiveWithID($IQ);

    #----------------------------------------------------------------------------
    # From the reply IQ determine if we were successful or not.  If yes then
    # return "".  If no then return error string from the reply.
    #----------------------------------------------------------------------------
    return unless defined($IQ);
    return ( $IQ->GetErrorCode() , $IQ->GetError() )
        if ($IQ->GetType() eq "error");
    return ("ok","");
}


###############################################################################
#
# RosterAdd - Takes the Jabber ID of the user to add to their Roster and
#             sends the IQ packet to the server.
#
###############################################################################
sub RosterAdd
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(type=>"set");
    my $roster = $iq->NewQuery("jabber:iq:roster");
    my $item = $roster->AddItem();
    $item->SetItem(%args);

    $self->{DEBUG}->Log1("RosterAdd: xml(",$iq->GetXML(),")");
    $self->Send($iq);
}


###############################################################################
#
# RosterAdd - Takes the Jabber ID of the user to remove from their Roster
#             and sends the IQ packet to the server.
#
###############################################################################
sub RosterRemove
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }
    delete($args{subscription});

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(type=>"set");
    my $roster = $iq->NewQuery("jabber:iq:roster");
    my $item = $roster->AddItem();
    $item->SetItem(%args,
         subscription=>"remove");
    $self->Send($iq);
}


###############################################################################
#
# RosterParse - Returns a hash of roster items.
#
###############################################################################
sub RosterParse
{
    shift;
    my $self = shift;
    my($iq) = @_;

    my $query = $iq->GetQuery();
    my @items = $query->GetItems();

    my %roster;
    foreach my $item (@items)
    {
        my $jid = $item->GetJID();
        $roster{$jid}->{name} = $item->GetName();
        $roster{$jid}->{subscription} = $item->GetSubscription();
        $roster{$jid}->{ask} = $item->GetAsk();
        $roster{$jid}->{groups} = [ $item->GetGroup() ];
    }

    return %roster;
}


###############################################################################
#
# RosterGet - Sends an empty IQ to the server to request that the user's
#             Roster be sent to them.  Returns a hash of roster items.
#
###############################################################################
sub RosterGet
{
    shift;
    my $self = shift;

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(type=>"get");
    my $query = $iq->NewQuery("jabber:iq:roster");

    $iq = $self->SendAndReceiveWithID($iq);
    return unless defined($iq);

    return $self->RosterParse($iq);
}


###############################################################################
#
# RosterDBParse - takes an iq packet that containsa roster, parses it, and puts
#                 the roster into the Roster DB.
#
###############################################################################
sub RosterDBParse
{
    shift;
    my $self = shift;
    my ($iq) = @_;

    my $type = $iq->GetType();
    return unless (($type eq "set") || ($type eq "result"));

    my %newroster = $self->RosterParse($iq);

    $self->RosterDBProcessParsed(%newroster);
}


###############################################################################
#
# RosterDBProcessParsed - takes a parsed roster and puts it into the Roster DB.
#
###############################################################################
sub RosterDBProcessParsed
{
    shift;
    my $self = shift;
    my (%roster) = @_;

    foreach my $jid (keys(%roster))
    {
        if ($roster{$jid}->{subscription} eq "remove")
        {
            $self->RosterDBRemove($jid);
        }
        else
        {
            $self->RosterDBAdd($jid, %{$roster{$jid}} );
        }
    }
}


###############################################################################
#
# RosterDBAdd - adds the entry to the Roster DB.
#
###############################################################################
sub RosterDBAdd
{
    shift;
    my $self = shift;
    my ($jid,%item) = @_;

    $self->{ROSTERDB}->{$jid} = \%item;
}


###############################################################################
#
# RosterDBRemove - removes the JID from the Roster DB.
#
###############################################################################
sub RosterDBRemove
{
    shift;
    my $self = shift;
    my ($jid) = @_;

    delete($self->{ROSTERDB}->{$jid}) if exists($self->{ROSTERDB}->{$jid});
}


###############################################################################
#
# RosterDBQuery - allows you to get one of the pieces of info from the
#                 Roster DB.
#
###############################################################################
sub RosterDBQuery
{
    shift;
    my $self = shift;
    my ($jid,$key) = @_;

    return unless exists($self->{ROSTERDB});
    return unless exists($self->{ROSTERDB}->{$jid});
    return unless exists($self->{ROSTERDB}->{$jid}->{$key});
    return $self->{ROSTERDB}->{$jid}->{$key};
}                        


###############################################################################
#
# RPCSetCallBacks - place to register a callback for RPC calls.  This is
#                   used in conjunction with the default IQ callback.
#
###############################################################################
sub RPCSetCallBacks
{
    shift;
    my $self = shift;
    while($#_ >= 0) {
        my $func = pop(@_);
        my $method = pop(@_);
        $self->{DEBUG}->Log2("RPCSetCallBacks: method($method) func($func)");
        if (defined($func))
        {
            $self->{RPCCB}{$method} = $func;
        }
        else
        {
            delete($self->{RPCCB}{$method});
        }
    }
}


###############################################################################
#
# RPCCall - Make an RPC call to the specified JID.
#
###############################################################################
sub RPCCall
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(type=>"set",
               to=>delete($args{to}));
    $iq->AddQuery($self->RPCEncode(type=>"methodCall",
                                   %args));

    $iq = $self->SendAndReceiveWithID($iq);
    return unless defined($iq);

    return $self->RPCParse($iq);
}


###############################################################################
#
# RPCResponse - Send back an RPC response, or fault, to the specified JID.
#
###############################################################################
sub RPCResponse
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(type=>"result",
               to=>delete($args{to}));
    $iq->AddQuery($self->RPCEncode(type=>"methodResponse",
                                   %args));

    $iq = $self->SendAndReceiveWithID($iq);
    return unless defined($iq);

    return $self->RPCParse($iq);
}


###############################################################################
#
# RPCEncode - Returns a Net::Jabber::Query with the arguments encoded for the
#             RPC packet.
#
###############################################################################
sub RPCEncode
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $query = new Net::Jabber::Query();
    $query->SetXMLNS("jabber:iq:rpc");

    my $source;

    if ($args{type} eq "methodCall")
    {
        $source = $query->AddMethodCall();
        $source->SetMethodName($args{methodname});
    }

    if ($args{type} eq "methodResponse")
    {
        $source = $query->AddMethodResponse();
    }

    if (exists($args{faultcode}) || exists($args{faultstring}))
    {
        my $struct = $source->AddFault()->AddValue()->AddStruct();
        $struct->AddMember(name=>"faultCode")->AddValue(i4=>$args{faultcode});
        $struct->AddMember(name=>"faultString")->AddValue(string=>$args{faultstring});
    }
    elsif (exists($args{params}))
    {
        my $params = $source->AddParams();
        foreach my $param (@{$args{params}})
        {
            $self->RPCEncode_Value($params->AddParam(),$param);
        }
    }

    return $query;
}


###############################################################################
#
# RPCEncode_Value - Run through the value, and encode it into XML.
#
###############################################################################
sub RPCEncode_Value
{
    shift;
    my $self = shift;
    my $obj = shift;
    my $value = shift;

    if (ref($value) eq "ARRAY")
    {
        my $array = $obj->AddValue()->AddArray();
        foreach my $data (@{$value})
        {
            $self->RPCEncode_Value($array->AddData(),$data);
        }
    }
    elsif (ref($value) eq "HASH")
    {
        my $struct = $obj->AddValue()->AddStruct();
        foreach my $key (keys(%{$value}))
        {
            $self->RPCEncode_Value($struct->AddMember(name=>$key),$value->{$key});
        }
    }
    else
    {
        if ($value =~ /^(i4|boolean|string|double|datetime|base64):/i)
        {
            my $type = $1;
            my($val) = ($value =~ /^$type:(.*)$/);
            $obj->AddValue($type=>$val);
        }
        elsif ($value =~ /^[+-]?\d+$/)
        {
            $obj->AddValue(i4=>$value);
        }
        elsif ($value =~ /^(-?(?:\d+(?:\.\d*)?|\.\d+)|([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?)$/)
        {
            $obj->AddValue(double=>$value);
        }
        else
        {
            $obj->AddValue(string=>$value);
        }
    }
}


###############################################################################
#
# RPCParse - Returns an array of the params sent in the RPC packet.
#
###############################################################################
sub RPCParse
{
    shift;
    my $self = shift;
    my($iq) = @_;

    my $query = $iq->GetQuery();

    my $source;
    $source = $query->GetMethodCall() if $query->DefinedMethodCall();
    $source = $query->GetMethodResponse() if $query->DefinedMethodResponse();

    if (defined($source))
    {
        if (($source->GetTag() eq "methodResponse") && ($source->DefinedFault()))
        {
            my %response =
                $self->RPCParse_Struct($source->GetFault()->GetValue()->GetStruct());
            return ("fault",\%response);
        }

        if ($source->DefinedParams())
        {
            #------------------------------------------------------------------
            # The <param/>s part
            #------------------------------------------------------------------
            my @response;
            foreach my $param ($source->GetParams()->GetParams())
            {
                push(@response,$self->RPCParse_Value($param->GetValue()));
            }
            return ("ok",\@response);
        }
    }
    else
    {
        print "AAAAHHHH!!!!\n";
    }
}


###############################################################################
#
# RPCParse_Value - Takes a <value/> and returns the data it represents
#
###############################################################################
sub RPCParse_Value
{
    shift;
    my $self = shift;
    my($value) = @_;

    if ($value->DefinedStruct())
    {
        my %struct = $self->RPCParse_Struct($value->GetStruct());
        return \%struct;
    }

    if ($value->DefinedArray())
    {
        my @array = $self->RPCParse_Array($value->GetArray());
        return \@array;
    }

    return $value->GetI4() if $value->DefinedI4();
    return $value->GetBoolean() if $value->DefinedBoolean();
    return $value->GetString() if $value->DefinedString();
    return $value->GetDouble() if $value->DefinedDouble();
    return $value->GetDateTime() if $value->DefinedDateTime();
    return $value->GetBase64() if $value->DefinedBase64();

    return $value->GetValue();
}


###############################################################################
#
# RPCParse_Struct - Takes a <struct/> and returns the hash of values.
#
###############################################################################
sub RPCParse_Struct
{
    shift;
    my $self = shift;
    my($struct) = @_;

    my %struct;
    foreach my $member ($struct->GetMembers())
    {
        $struct{$member->GetName()} = $self->RPCParse_Value($member->GetValue());
    }

    return %struct;
}


###############################################################################
#
# RPCParse_Array - Takes a <array/> and returns the hash of values.
#
###############################################################################
sub RPCParse_Array
{
    shift;
    my $self = shift;
    my($array) = @_;

    my @array;
    foreach my $data ($array->GetDatas())
    {
        push(@array,$self->RPCParse_Value($data->GetValue()));
    }

    return @array;
}


###############################################################################
#
# SearchRequest - This is a self contained function to send an iq tag
#                 an id that requests the target address to send back
#                 the required fields.  It waits for a reply what the
#                 same id to come back and tell the caller what the
#                 fields are.
#
###############################################################################
sub SearchRequest
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $timeout = exists($args{timeout}) ? delete($args{timeout}) : undef;

    #----------------------------------------------------------------------------
    # Create a Net::Jabber::IQ object to send to the server
    #----------------------------------------------------------------------------
    my $IQ = new Net::Jabber::IQ();
    $IQ->SetIQ(to=>delete($args{to})) if exists($args{to});
    $IQ->SetIQ(type=>"get");
    my $IQSearch = $IQ->NewQuery("jabber:iq:search");

    $self->{DEBUG}->Log1("SearchRequest: sent(",$IQ->GetXML(),")");

    #----------------------------------------------------------------------------
    # Send the IQ with the next available ID and wait for a reply with that
    # id to be received.  Then grab the IQ reply.
    #----------------------------------------------------------------------------
    $IQ = $self->SendAndReceiveWithID($IQ,$timeout);

    $self->{DEBUG}->Log1("SearchRequest: received(",$IQ->GetXML(),")")
        if defined($IQ);

    #----------------------------------------------------------------------------
    # Check if there was an error.
    #----------------------------------------------------------------------------
    return unless defined($IQ);
    if ($IQ->GetType() eq "error")
    {
        $self->SetErrorCode($IQ->GetErrorCode().": ".$IQ->GetError());
        $self->{DEBUG}->Log1("SearchRequest: error(",$self->GetErrorCode(),")");
        return;
    }

    my %search;
    #----------------------------------------------------------------------------
    # From the reply IQ determine what fields are required and send a hash
    # back with the fields and any values that are already defined (like key)
    #----------------------------------------------------------------------------
    $IQSearch = $IQ->GetQuery();
    $search{fields} = { $IQSearch->GetSearch() };

    #----------------------------------------------------------------------------
    # Get any forms so that we have the option of showing a nive dynamic form
    # to the user and not just a bunch of fields.
    #----------------------------------------------------------------------------
    &ExtractForms(\%search,$IQSearch->GetX("jabber:x:data"));

    #----------------------------------------------------------------------------
    # Get any oobs so that we have the option of sending the user to the http
    # form and not a dynamic one.
    #----------------------------------------------------------------------------
    &ExtractOobs(\%search,$IQSearch->GetX("jabber:x:oob"));

    return %search;
}


###############################################################################
#
# SearchSend - This is a self contained function to send a search
#              iq tag with an id.  Then wait for a reply what the same
#              id to come back and tell the caller what the result was.
#
###############################################################################
sub SearchSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    #----------------------------------------------------------------------------
    # Create a Net::Jabber::IQ object to send to the server
    #----------------------------------------------------------------------------
    my $IQ = new Net::Jabber::IQ();
    $IQ->SetIQ(to=>delete($args{to})) if exists($args{to});
    $IQ->SetIQ(type=>"set");
    my $IQSearch = $IQ->NewQuery("jabber:iq:search");
    $IQSearch->SetSearch(%args);

    #----------------------------------------------------------------------------
    # Send the IQ.
    #----------------------------------------------------------------------------
    $self->Send($IQ);
}


###############################################################################
#
# SearchSendData - This is a self contained function to send a search iq tag
#                  with an id.  It uses the jabber:x:data method to return the
#                  data.
#
###############################################################################
sub SearchSendData
{
    shift;
    my $self = shift;
    my $to = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    #----------------------------------------------------------------------------
    # Create a Net::Jabber::IQ object to send to the server
    #----------------------------------------------------------------------------
    my $IQ = new Net::Jabber::IQ();
    $IQ->SetIQ(to=>$to) if (defined($to) && ($to ne ""));
    $IQ->SetIQ(type=>"set");
    my $IQSearch = $IQ->NewQuery("jabber:iq:search");
    my $xForm = $IQSearch->NewX("jabber:x:data");
    foreach my $var (keys(%args))
    {
        next if ($args{$var} eq "");
        $xForm->AddField(var=>$var,
                         value=>$args{$var}
                        );
    }

    #----------------------------------------------------------------------------
    # Send the IQ.
    #----------------------------------------------------------------------------
    $self->Send($IQ);
}


###############################################################################
#
# TimeQuery - Sends an iq:time query to either the server or the specified
#             JID.
#
###############################################################################
sub TimeQuery
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{waitforid} = 0 unless exists($args{waitforid});
    my $waitforid = delete($args{waitforid});

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(to=>delete($args{to})) if exists($args{to});
    $iq->SetIQ(type=>'get',%args);
    my $time = $iq->NewQuery("jabber:iq:time");

    if ($waitforid == 0)
    {
        $self->Send($iq);
    }
    else
    {
        $iq = $self->SendAndReceiveWithID($iq);

        return unless defined($iq);

        my $query = $iq->GetQuery();

        return unless defined($query);

        my %result;
        $result{utc} = $query->GetUTC();
        $result{display} = $query->GetDisplay();
        $result{tz} = $query->GetTZ();
        return %result;
    }
}


###############################################################################
#
# TimeSend - sends an iq:time packet to the specified user.
#
###############################################################################
sub TimeSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(to=>delete($args{to}),
               type=>'result');
    my $time = $iq->NewQuery("jabber:iq:time");
    $time->SetTime(%args);

    $self->Send($iq);
}



###############################################################################
#
# VersionQuery - Sends an iq:version query to either the server or the
#                specified JID.
#
###############################################################################
sub VersionQuery
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{waitforid} = 0 unless exists($args{waitforid});
    my $waitforid = delete($args{waitforid});

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(to=>delete($args{to})) if exists($args{to});
    $iq->SetIQ(type=>'get',%args);
    my $version = $iq->NewQuery("jabber:iq:version");

    if ($waitforid == 0)
    {
        $self->Send($iq);
    }
    else
    {
        $iq = $self->SendAndReceiveWithID($iq);

        return unless defined($iq);

        my $query = $iq->GetQuery();

        return unless defined($query);

        my %result;
        $result{name} = $query->GetName();
        $result{ver} = $query->GetVer();
        $result{os} = $query->GetOS();
        return %result;
    }
}


###############################################################################
#
# VersionSend - sends an iq:version packet to the specified user.
#
###############################################################################
sub VersionSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $iq = new Net::Jabber::IQ();
    $iq->SetIQ(to=>delete($args{to}),
               type=>'result');
    my $version = $iq->NewQuery("jabber:iq:version");
    $version->SetVersion(%args);

    $self->Send($iq);
}


###############################################################################
#
# SXPMSend - sends an x:sxpm packet to the specified jid.
#
###############################################################################
sub SXPMSend
{
    shift;
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    my $message = new Net::Jabber::Message();
    $message->SetMessage(to=>delete($args{to}),
                     type=>delete($args{type}));
    my $xTag = $message->NewX("jabber:x:sxpm");
    if (exists($args{map}))
    {
        my %map = %{delete($args{map})};
        foreach my $char (keys(%map))
        {
            $xTag->AddMap(char=>$char,
                          color=>$map{$char});
        }
    }
    $xTag->SetSXPM(%args);

    $self->Send($message);
    return $message;
}


###############################################################################
#+-----------------------------------------------------------------------------
#|
#| Helper Functions
#|
#+-----------------------------------------------------------------------------
###############################################################################


###############################################################################
#
# ExtractForms - Helper function to make extracting jabber:x:data for forms
#                more centrally definable.
#
###############################################################################
sub ExtractForms
{
    my ($target,@xForms) = @_;

    my $tempVar = "1";
    foreach my $xForm (@xForms) {
        $target->{instructions} = $xForm->GetInstructions();
        my $order = 0;
        foreach my $field ($xForm->GetFields())
        {
            $target->{form}->[$order]->{type} = $field->GetType()
                if $field->DefinedType();
            $target->{form}->[$order]->{label} = $field->GetLabel()
                if $field->DefinedLabel();
            $target->{form}->[$order]->{desc} = $field->GetDesc()
                if $field->DefinedDesc();
            $target->{form}->[$order]->{var} = $field->GetVar()
                if $field->DefinedVar();
            $target->{form}->[$order]->{var} = "__netjabber__:tempvar:".$tempVar++
                if !$field->DefinedVar();
            if ($field->DefinedValue())
            {
                if ($field->GetType() eq "list-multi")
                {
                    $target->{form}->[$order]->{value} = [ $field->GetValue() ];
                }
                else
                {
                    $target->{form}->[$order]->{value} = ($field->GetValue())[0];
                }
            }  
            my $count = 0;
            foreach my $option ($field->GetOptions())
            {
                $target->{form}->[$order]->{options}->[$count]->{value} =
                    $option->GetValue();
                $target->{form}->[$order]->{options}->[$count]->{label} =
                    $option->GetLabel();
                $count++;
            }
            $order++;
        }
        foreach my $reported ($xForm->GetReported())
        {
            my $order = 0;
            foreach my $field ($reported->GetFields())
            {
                $target->{reported}->[$order]->{label} = $field->GetLabel();
                $target->{reported}->[$order]->{var} = $field->GetVar();
                $order++;
            }
        }
    }
}


###############################################################################
#
# ExtractOobs - Helper function to make extracting jabber:x:oob for forms
#               more centrally definable.
#
###############################################################################
sub ExtractOobs
{
    my ($target,@xOobs) = @_;

    foreach my $xOob (@xOobs)
    {
        $target->{oob}->{url} = $xOob->GetURL();
        $target->{oob}->{desc} = $xOob->GetDesc();
    }
}


###############################################################################
#+-----------------------------------------------------------------------------
#|
#| Default CallBacks
#|
#+-----------------------------------------------------------------------------
###############################################################################


###############################################################################
#
# callbackInit - initialize the default callbacks
#
###############################################################################
sub callbackInit
{
    shift;
    my $self = shift;

    $self->SetCallBacks(iq=>sub{ $self->callbackIQ(@_) },
                        presence=>sub{ $self->callbackPresence(@_) },
                        message=>sub{ $self->callbackMessage(@_) },
                        );

    $self->SetPresenceCallBacks(available=>sub{ $self->callbackPresenceAvailable(@_) },
                                subscribe=>sub{ $self->callbackPresenceSubscribe(@_) },
                                unsubscribe=>sub{ $self->callbackPresenceUnsubscribe(@_) },
                                subscribed=>sub{ $self->callbackPresenceSubscribed(@_) },
                                unsubscribed=>sub{ $self->callbackPresenceUnsubscribed(@_) },
                               );
                        
    $self->SetIQCallBacks("jabber:iq:last"=>
                          {
                            get=>sub{ $self->callbackGetIQLast(@_) },
                            result=>sub{ $self->callbackResultIQLast(@_) }
                          },
                          "jabber:iq:rpc"=>
                          {
                            set=>sub{ $self->callbackSetIQRPC(@_) },
                          },
                          "jabber:iq:time"=>
                          {
                            get=>sub{ $self->callbackGetIQTime(@_) },
                            result=>sub{ $self->callbackResultIQTime(@_) }
                          },
                          "jabber:iq:version"=>
                          {
                            get=>sub{ $self->callbackGetIQVersion(@_) },
                            result=>sub{ $self->callbackResultIQVersion(@_) }
                          },
                         );
}


###############################################################################
#
# callbackMessage - default callback for <message/> packets.
#
###############################################################################
sub callbackMessage
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $message = shift;

    my $type = "normal";
    $type = $message->GetType() if $message->DefinedType();

    if (exists($self->{CB}->{Mess}->{$type}) &&
        (ref($self->{CB}->{Mess}->{$type}) eq "CODE"))
    {
        &{$self->{CB}->{Mess}->{$type}}($sid,$message);
    }
}


###############################################################################
#
# callbackPresence - default callback for <presence/> packets.
#
###############################################################################
sub callbackPresence
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $presence = shift;

    my $type = "available";
    $type = $presence->GetType() if $presence->DefinedType();

    if (exists($self->{CB}->{Pres}->{$type}) &&
        (ref($self->{CB}->{Pres}->{$type}) eq "CODE"))
    {
        &{$self->{CB}->{Pres}->{$type}}($sid,$presence);
    }
}


###############################################################################
#
# callbackIQ - default callback for <iq/> packets.
#
###############################################################################
sub callbackIQ
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    return unless $iq->DefinedQuery();

    my $type = $iq->GetType();
    my $ns = $iq->GetQuery()->GetXMLNS();

    if (exists($self->{CB}->{IQns}->{$ns}) &&
        (ref($self->{CB}->{IQns}->{$ns}) eq "CODE"))
    {
        &{$self->{CB}->{IQns}->{$ns}}($sid,$iq);

    } elsif (exists($self->{CB}->{IQns}->{$ns}->{$type}) &&
             (ref($self->{CB}->{IQns}->{$ns}->{$type}) eq "CODE"))
    {
        &{$self->{CB}->{IQns}->{$ns}->{$type}}($sid,$iq);
    }
}


###############################################################################
#
# callbackPresenceAvailable - default callback for available packets.
#
###############################################################################
sub callbackPresenceAvailable
{ 
    shift;
    my $self = shift;
    my $sid = shift;
    my $presence = shift;

    my $reply = $presence->Reply();
    $self->Send($reply,1);
}


###############################################################################
#
# callbackPresenceSubscribe - default callback for subscribe packets.
#
###############################################################################
sub callbackPresenceSubscribe
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $presence = shift;

    my $reply = $presence->Reply(type=>"subscribed");
    $self->Send($reply,1);
    $reply->SetType("subscribe");
    $self->Send($reply,1);
}


###############################################################################
#
# callbackPresenceUnsubscribe - default callback for unsubscribe packets.
#
###############################################################################
sub callbackPresenceUnsubscribe
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $presence = shift;

    my $reply = $presence->Reply(type=>"unsubscribed");
    $self->Send($reply,1);
}

   
###############################################################################
#
# callbackPresenceSubscribed - default callback for subscribed packets.
#
###############################################################################
sub callbackPresenceSubscribed
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $presence = shift;

    my $reply = $presence->Reply(type=>"subscribed");
    $self->Send($reply,1);
}


###############################################################################
#
# callbackPresenceUnsubscribed - default callback for unsubscribed packets.
#
###############################################################################
sub callbackPresenceUnsubscribed
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $presence = shift;

    my $reply = $presence->Reply(type=>"unsubscribed");
    $self->Send($reply,1);
}


###############################################################################
#
# callbackSetIQRPC - callback to handle auto-replying to an iq:rpc by calling
#                    the user registered functions.
#
###############################################################################
sub callbackSetIQRPC
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    my $query = $iq->GetQuery();

    my $reply = $iq->Reply(type=>"result");
    my $replyQuery = $reply->GetQuery();

    if (!$query->DefinedMethodCall())
    {
        my $methodResponse = $replyQuery->AddMethodResponse();
        my $struct = $methodResponse->AddFault()->AddValue()->AddStruct();
        $struct->AddMember(name=>"faultCode")->AddValue(int=>400);
        $struct->AddMember(name=>"faultString")->AddValue(string=>"Missing methodCall.");
        $self->Send($reply,1);
        return;
    }

    if (!$query->GetMethodCall()->DefinedMethodName())
    {
        my $methodResponse = $replyQuery->AddMethodResponse();
        my $struct = $methodResponse->AddFault()->AddValue()->AddStruct();
        $struct->AddMember(name=>"faultCode")->AddValue(int=>400);
        $struct->AddMember(name=>"faultString")->AddValue(string=>"Missing methodName.");
        $self->Send($reply,1);
        return;
    }

    my $methodName = $query->GetMethodCall()->GetMethodName();

    if (!exists($self->{RPCCB}->{$methodName}))
    {
        my $methodResponse = $replyQuery->AddMethodResponse();
        my $struct = $methodResponse->AddFault()->AddValue()->AddStruct();
        $struct->AddMember(name=>"faultCode")->AddValue(int=>404);
        $struct->AddMember(name=>"faultString")->AddValue(string=>"methodName $methodName not defined.");
        $self->Send($reply,1);
        return;
    }

    my @params = $self->RPCParse($iq);

    my @return = &{$self->{RPCCB}->{$methodName}}($iq,$params[1]);

    if ($return[0] ne "ok") {
        my $methodResponse = $replyQuery->AddMethodResponse();
        my $struct = $methodResponse->AddFault()->AddValue()->AddStruct();
        $struct->AddMember(name=>"faultCode")->AddValue(int=>$return[1]->{faultCode});
        $struct->AddMember(name=>"faultString")->AddValue(string=>$return[1]->{faultString});
        $self->Send($reply,1);
        return;
    }
    $reply->RemoveQuery();
    $reply->AddQuery($self->RPCEncode(type=>"methodResponse",
                                      params=>$return[1]));

    $self->Send($reply,1);
}


###############################################################################
#
# callbackGetIQTime - callback to handle auto-replying to an iq:time get.
#
###############################################################################
sub callbackGetIQTime
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    my $query = $iq->GetQuery();

    my $reply = $iq->Reply(type=>"result");
    my $replyQuery = $reply->GetQuery();
    $replyQuery->SetTime();

    $self->Send($reply,1);
}


###############################################################################
#
# callbackResultIQTime - callback to handle formatting iq:time result into
#                        a message.
#
###############################################################################
sub callbackResultIQTime
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    my $fromJID = $iq->GetFrom("jid");
    my $query = $iq->GetQuery();

    my $body = "UTC: ".$query->GetUTC()."\n";
    $body .=   "Time: ".$query->GetDisplay()."\n";
    $body .=   "Timezone: ".$query->GetTZ()."\n";
    
    my $message = new Net::Jabber::Message();
    $message->SetMessage(to=>$iq->GetTo(),
                         from=>$iq->GetFrom(),
                         subject=>"CTCP: Time",
                         body=>$body);


    $self->CallBack($sid,$message);
}


###############################################################################
#
# callbackGetIQVersion - callback to handle auto-replying to an iq:time
#                        get.
#
###############################################################################
sub callbackGetIQVersion
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    my $query = $iq->GetQuery();

    my $reply = $iq->Reply(type=>"result");
    my $replyQuery = $reply->GetQuery();
    $replyQuery->SetVersion(name=>$self->{INFO}->{name},
                            ver=>$self->{INFO}->{version},
                            os=>"");

    $self->Send($reply,1);
}


###############################################################################
#
# callbackResultIQVersion - callback to handle formatting iq:time result
#                           into a message.
#
###############################################################################
sub callbackResultIQVersion
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    my $query = $iq->GetQuery();

    my $body = "Program: ".$query->GetName()."\n";
    $body .=   "Version: ".$query->GetVer()."\n";
    $body .=   "OS: ".$query->GetOS()."\n";

    my $message = new Net::Jabber::Message();
    $message->SetMessage(to=>$iq->GetTo(),
                         from=>$iq->GetFrom(),
                         subject=>"CTCP: Version",
                         body=>$body);

    $self->CallBack($sid,$message);
}


###############################################################################
#
# callbackGetIQLast - callback to handle auto-replying to an iq:last get.
#
###############################################################################
sub callbackGetIQLast
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    my $query = $iq->GetQuery();
    my $reply = $iq->Reply(type=>"result");
    my $replyQuery = $reply->GetQuery();
    $replyQuery->SetLast(seconds=>$self->LastActivity());

    $self->Send($reply,1);
}


###############################################################################
#
# callbackResultIQLast - callback to handle formatting iq:last result into
#                        a message.
#
###############################################################################
sub callbackResultIQLast
{
    shift;
    my $self = shift;
    my $sid = shift;
    my $iq = shift;

    my $fromJID = $iq->GetFrom("jid");
    my $query = $iq->GetQuery();
    my $seconds = $query->GetSeconds();

    my $lastTime = &Net::Jabber::GetTimeStamp("local",(time - $seconds),"long");

    my $elapsedTime = &Net::Jabber::GetHumanTime($seconds);

    my $body;
    if ($fromJID->GetUserID() eq "")
    {
        $body  = "Start Time: $lastTime\n";
        $body .= "Up time: $elapsedTime\n";
        $body .= "Message: ".$query->GetMessage()."\n"
            if ($query->DefinedMessage());
    }
    elsif ($fromJID->GetResource() eq "")
    {
        $body  = "Logout Time: $lastTime\n";
        $body .= "Elapsed time: $elapsedTime\n";
        $body .= "Message: ".$query->GetMessage()."\n"
            if ($query->DefinedMessage());
    }
    else
    {
        $body  = "Last activity: $lastTime\n";
        $body .= "Elapsed time: $elapsedTime\n";
        $body .= "Message: ".$query->GetMessage()."\n"
            if ($query->DefinedMessage());
    }
    
    my $message = new Net::Jabber::Message();
    $message->SetMessage(from=>$iq->GetFrom(),
                         subject=>"Last Activity",
                         body=>$body);

    $self->CallBack($sid,$message);
}


1;
