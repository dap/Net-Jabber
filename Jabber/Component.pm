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

package Net::Jabber::Component;

=head1 NAME

Net::Jabber::Component - Jabber Component Library

=head1 SYNOPSIS

  Net::Jabber::Component is a module that provides a developer easy access
  to developing server components in the Jabber Instant Messaging protocol.

=head1 DESCRIPTION

  Component.pm seeks to provide enough high level APIs and automation of
  the low level APIs that writing a Jabber Component in Perl is trivial.
  For those that wish to work with the low level you can do that too,
  but those functions are covered in the documentation for each module.

  Net::Jabber::Component provides functions to connect to a Jabber server,
  login, send and receive messages, set personal information, create
  a new user account, manage the roster, and disconnect.  You can use
  all or none of the functions, there is no requirement.

  For more information on how the details for how Net::Jabber is written
  please see the help for Net::Jabber itself.

  For a full list of high level functions available please see
  Net::Jabber::Protocol.

=head2 Basic Functions

    use Net::Jabber qw(Component);

    $Con = new Net::Jabber::Component();

    $Con->Connect(hostname=>"jabber.org",
                  secret=>"foo");

      or

    $Con->Connect(connectiontype=>"exec");

    if ($Con->Connected()) {
      print "We are connected to the server...\n";
    }

    $status = $Con->Process();
    $status = $Con->Process(5);

    #
    # For the list of available function see Net::Jabber::Protocol.
    #

    $Con->Disconnect();

=head1 METHODS

=head2 Basic Functions

    new(debuglevel=>0|1|2, - creates the Component object.  debugfile
        debugfile=>string,   should be set to the path for the debug
        debugtime=>0|1)      log to be written.  If set to "stdout"
                             then the debug will go there.  debuglevel
                             controls the amount of debug.  For more
                             information about the valid setting for
                             debuglevel, debugfile, and debugtime see
                             Net::Jabber::Debug.

    Connect(hostname=>string,       - opens a connection to the server
	    port=>integer,            based on the value of connectiontype.
	    secret=>string,           The two valid setings are:
	    componentname=>string,      accept - TCP/IP remote connection
	    connectiontype=>string)              (default)
                                        exec   - STDIN/OUT local connection
                                      If accept then it connects to the
                                      server listed in the hostname value,
                                      on the port listed.  The defaults
                                      for the two are localhost and 5222.
                                      The secret is the password needed
                                      to attach the hostname, and the
                                      componentname is the name that
                                      server and clients will know the
                                      component by (both used for security
                                      purposes).
                                      If exec then the module reads from
                                      STDIN and writes to STDOUT.  The
                                      server will start the script at run
                                      time and will restart the script if
                                      it exits or dies.  No secret is
                                      needed since this configuration is
                                      specified by the server admin and so
                                      it is assumed that they trust your
                                      script.

    Process(integer) - takes the timeout period as an argument.  If no
                       timeout is listed then the function blocks until
                       a packet is received.  Otherwise it waits that
                       number of seconds and then exits so your program
                       can continue doing useful things.  NOTE: This is
                       important for GUIs.  You need to leave time to
                       process GUI commands even if you are waiting for
                       packets.  The following are the possible return
                       values, and what they mean:

                           1   - Status ok, data received.
                           0   - Status ok, no data received.
                         undef - Status not ok, stop processing.
                       
                       IMPORTANT: You need to check the output of every
                       Process.  If you get an undef then the connection
                       died and you should behave accordingly.

    Execute(hostname=>string,       - Generic inner loop to handle
	    port=>int,                connecting to the server, calling
	    secret=>string,           Process, and reconnecting if the
	    componentname=>string,    connection is lost.  There are four
	    connectiontype=>string,   callbacks available that are called
            connectattempts=>int,     at various places in the loop.
            connectsleep=>int)          onconnect - when the component
                                                    connects to the server.
                                        onprocess - this is the most inner
                                                    loop and so gets called
                                                    the most.  Be very very
                                                    careful what you put
                                                    here since it can
                                                    *DRASTICALLY* affect
                                                    performance.
                                        ondisconnect - when the connection
                                                       is lost.
                                        onexit - when the function gives
                                                 up trying to connect and
                                                 exits.
                                      The arguments are passed straight on
                                      to the Connect function, except for
                                      connectattempts and connectsleep.
                                      connectattempts is the number of
                                      time that the Component should try to
                                      connect before giving up.  -1 means
                                      try forever.  The default is -1.
                                      connectsleep is the number of seconds
                                      to sleep between each connection
                                      attempt.

    Disconnect() - closes the connection to the server.

    Connected() - returns 1 if the Component is connected to the server,
                  and 0 if not.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org.

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use Carp;
use base qw( Net::Jabber::Protocol );
use vars qw( $VERSION );

$VERSION = "1.30";

use Net::Jabber::Data;
($Net::Jabber::Data::VERSION < $VERSION) &&
  die("Net::Jabber::Data $VERSION required--this is only version $Net::Jabber::Data::VERSION");

use Net::Jabber::XDB;
($Net::Jabber::XDB::VERSION < $VERSION) &&
  die("Net::Jabber::XDB $VERSION required--this is only version $Net::Jabber::XDB::VERSION");

#use Net::Jabber::Log;
#($Net::Jabber::Log::VERSION < $VERSION) &&
#  die("Net::Jabber::Log $VERSION required--this is only version $Net::Jabber::Log::VERSION");

use Net::Jabber::Key;
($Net::Jabber::Key::VERSION < $VERSION) &&
  die("Net::Jabber::Key $VERSION required--this is only version $Net::Jabber::Key::VERSION");

sub new
{
    srand( time() ^ ($$ + ($$ << 15)));

    my $proto = shift;
    my $self = { };

    my %args;
    while($#_ >= 0) { $args{ lc(pop(@_)) } = pop(@_); }

    bless($self, $proto);

    $self->{DEBUG} =
        new Net::Jabber::Debug(level=>exists($args{debuglevel}) ? $args{debuglevel} : -1,
                               file=>exists($args{debugfile}) ? $args{debugfile} : "stdout",
                               time=>exists($args{debugtime}) ? $args{debugtime} : 0,
                               setdefault=>1,
                               header=>"NJ::Component"
                              );

    $self->{SERVER} = {hostname => "localhost",
                       port => 5269,
                       componentname => ""};

    $self->{CONNECTED} = 0;

    $self->{STREAM} = new XML::Stream(style=>"node",
                                      debugfh=>$self->{DEBUG}->GetHandle(),
                                      debuglevel=>$self->{DEBUG}->GetLevel(),
                                      debugtime=>$self->{DEBUG}->GetTime());

    $self->{VERSION} = $VERSION;

    $self->{LIST}->{currentID} = 0;

    $self->callbackInit();

    return $self;
}


###########################################################################
#
# Connect - Takes a has and opens the connection to the specified server.
#           Registers CallBack as the main callback for all packets from
#           the server.
#
#           NOTE:  Need to add some error handling if the connection is
#           not made because the server hostname is wrong or whatnot.
#
###########################################################################
sub Connect
{
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{connectiontype} = "accept" unless exists($args{connectiontype});
    $self->{CONNECTIONTYPE} = $args{connectiontype};
    
    $self->{DEBUG}->Log1("Connect: type($self->{CONNECTIONTYPE})");

    if (($args{connectiontype} eq "exec") ||
            ($args{connectiontype} eq "stdinout"))
    {

        if (!($self->{SESSION} =
            $self->{STREAM}->
                Connect(connectiontype=>"stdinout",
                        namespace=>"jabber:component:exec",
                        timeout=>10,
                        )))
        {
            $self->SetErrorCode($self->{STREAM}->GetErrorCode());
            return;
        }
    }

    if (($args{connectiontype} eq "accept") ||
        ($args{connectiontype} eq "tcpip"))
    {

        $self->{DEBUG}->Log1("Connect: hostname($args{hostname}) secret($args{secret}) componentname($args{componentname})");

        if (!exists($args{hostname})) {
            $self->SetErrorCode("No hostname specified.");
            return;
        }

        if (!exists($args{secret}))
        {
            $self->SetErrorCode("No secret specified.");
            return;
        }

        if (!exists($args{componentname}))
        {
            $self->SetErrorCode("No component specified.");
            return;
        }

        $self->{SERVER}->{hostname} = delete($args{hostname});
        $self->{SERVER}->{port} = delete($args{port}) if exists($args{port});

        if (!($self->{SESSION} =
                    $self->{STREAM}->
                        Connect(hostname=>$self->{SERVER}->{hostname},
                                port=>$self->{SERVER}->{port},
                                to=>$args{componentname},
                                namespace=>"jabber:component:accept",
                                (defined($args{myhostname}) ?
                                 (myhostname=>$args{myhostname}) :
                                 ()
                                ),
                                timeout=>10
                                )))
        {
            $self->SetErrorCode($self->{STREAM}->GetErrorCode());
            return;
        }
    }

    $self->{DEBUG}->Log1("Connect: connection made");

    my $handshake;
    if (($args{connectiontype} eq "accept") ||
        ($args{connectiontype} eq "tcpip"))
    {
        $self->Send("<handshake>".Digest::SHA1::sha1_hex($self->{SESSION}->{id}.$args{secret})."</handshake>");
        $handshake = $self->Process();

        if (!defined($handshake) ||
            ($#{$handshake} == -1) ||
            (ref($handshake->[0]) ne "XML::Stream::Node") ||
            ($handshake->[0]->get_tag() ne "handshake"))
        {
            $self->SetErrorCode("Bad handshake.");
            return;
        }
        shift(@{$handshake});
    }

    foreach my $node (@{$handshake})
    {
        $self->CallBack($self->{SESSION}->{id},$node);
    }

    $self->{STREAM}->SetCallBacks(node=>sub{ $self->CallBack(@_) });

    $self->{CONNECTED} = 1;
    return 1;
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
    my $self = shift;
    my ($timeout) = @_;
    my %status;

    if (exists($self->{PROCESSERROR}) && ($self->{PROCESSERROR} == 1))
    {
        croak("There was an error in the last call to Process that you did not check for and\nhandle.  You should always check the output of the Process call.  If it was\nundef then there was a fatal error that you need to check.  There is an error\nin your program");
    }

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
        if ($status{$self->{SESSION}->{id}} == -1)
        {
            $self->{PROCESSERROR} = 1;
            return;
        }
        else
        {
            return $status{$self->{SESSION}->{id}};
        }
    }
    else
    {
        %status = $self->{STREAM}->Process($timeout);
        if ($status{$self->{SESSION}->{id}} == -1)
        {
            $self->{PROCESSERROR} = 1;
            return;
        }
        else
        {
            return $status{$self->{SESSION}->{id}};
        }
    }
}


###########################################################################
#
# Disconnect - Sends the string to close the connection cleanly.
#
###########################################################################
sub Disconnect
{
    my $self = shift;
    $self->{STREAM}->Disconnect($self->{SESSION}->{id})
        if ($self->{CONNECTED} == 1);
    $self->{STREAM}->SetCallBacks(node=>undef);
    $self->{CONNECTED} = 0;
    $self->{DEBUG}->Log1("Disconnect: bye bye");
}


###########################################################################
#
# Connected - returns 1 if the Component is connected to the server, 0
#             otherwise.
#
###########################################################################
sub Connected
{
    my $self = shift;

    $self->{DEBUG}->Log1("Connected: ($self->{CONNECTED})");
    return $self->{CONNECTED};
}


###########################################################################
#
# Execute - generic inner loop to listen for incoming messages, stay
#           connected to the server, and do all the right things.  It
#           calls a couple of callbacks for the user to put hooks into
#           place if they choose to.
#
###########################################################################
sub Execute
{
    my $self = shift;
    my %args;
    while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

    $args{connectiontype} = "accept" unless exists($args{connectiontype});
    $args{connectattempts} = -1 unless exists($args{connectattempts});
    $args{connectsleep} = 5 unless exists($args{connectsleep});

    $self->{DEBUG}->Log1("Execute: begin");

    my $connectAttempt = $args{connectattempts};

    while(($connectAttempt == -1) || ($connectAttempt > 0))
    {

        $self->{DEBUG}->Log1("Execute: Attempt to connect ($connectAttempt)");

        my $status;
        if ($args{connectiontype} eq "accept")
        {
            $status = $self->Connect(hostname=>$args{hostname},
                                     port=>$args{port},
                                     secret=>$args{secret},
                                     connectiontype=>$args{connectiontype},
                                     componentname=>$args{componentname});
        }
        if ($args{connectiontype} eq "exec")
        {
            $status = $self->Connect(connectiontype=>"exec");
        }

        if (!(defined($status)))
        {
            $self->{DEBUG}->Log1("Execute: Jabber server is not answering.  (".$self->GetErrorCode().")");
            $self->{CONNECTED} = 0;

            $connectAttempt-- unless ($connectAttempt == -1);
            sleep($args{connectsleep});
            next;
        }

        $self->{DEBUG}->Log1("Execute: Connected...");
        &{$self->{CB}->{onconnect}}()
            if exists($self->{CB}->{onconnect});

        while($self->Connected())
        {
            while(defined($status = $self->Process($args{processtimeout})))
            {
                &{$self->{CB}->{onprocess}}()
                    if exists($self->{CB}->{onprocess});
            }

            if (!defined($status))
            {
                $self->Disconnect();
                $self->{DEBUG}->Log1("Execute: Connection to server lost...");
                &{$self->{CB}->{ondisconnect}}()
                    if exists($self->{CB}->{ondisconnect});

                $connectAttempt = $args{connectattempts};
                next;
            }
        }
    }

    $self->{DEBUG}->Log1("Execute: end");
    &{$self->{CB}->{onexit}}() if exists($self->{CB}->{onexit});
}


1;
