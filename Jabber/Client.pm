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

package Net::Jabber::Client;

=head1 NAME

Net::Jabber::Client - Jabber Client Library

=head1 SYNOPSIS

  Net::Jabber::Client is a module that provides a developer easy access
  to the Jabber Instant Messaging protocol.

=head1 DESCRIPTION

  Client.pm uses Protocol.pm to provide enough high level APIs and
  automation of the low level APIs that writing a Jabber Client in
  Perl is trivial.  For those that wish to work with the low level
  you can do that too, but those functions are covered in the
  documentation for each module.

  Net::Jabber::Client provides functions to connect to a Jabber server,
  login, send and receive messages, set personal information, create
  a new user account, manage the roster, and disconnect.  You can use
  all or none of the functions, there is no requirement.

  For more information on how the details for how Net::Jabber is written
  please see the help for Net::Jabber itself.

  For a full list of high level functions available please see
  Net::Jabber::Protocol.

=head2 Basic Functions

    use Net::Jabber qw(Client);

    $Con = new Net::Jabber::Client();

    $Con->Connect(hostname=>"jabber.org");

    if ($Con->Connected()) {
      print "We are connected to the server...\n";
    }

    #
    # For the list of available function see Net::Jabber::Protocol.
    #

    $Con->Disconnect();

=head1 METHODS

=head2 Basic Functions

    new(debuglevel=>0|1|2, - creates the Client object.  debugfile
        debugfile=>string,   should be set to the path for the debug
        debugtime=>0|1)      log to be written.  If set to "stdout"
                             then the debug will go there.  debuglevel
                             controls the amount of debug.  For more
                             information about the valid setting for
                             debuglevel, debugfile, and debugtime see
                             Net::Jabber::Debug.

    Connect(hostname=>string,      - opens a connection to the server
   	        port=>integer,           listed in the hostname (default
            connectiontype=>string,  localhost), on the port (default
            ssl=>0|1)                5222) listed, using the
                                     connectiontype listed (default
                                     tcpip).  The two connection types
                                     available are:
                                       tcpip  standard TCP socket
                                       http   TCP socket, but with the
                                              headers needed to talk
                                              through a web proxy
                                     If you specify ssl, then it will
                                     be used to connect.

    Disconnect() - closes the connection to the server.

    Connected() - returns 1 if the Transport is connected to the server,
                  and 0 if not.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org.

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use vars qw($VERSION $AUTOLOAD);

$VERSION = "1.28";

sub new
{
    my $proto = shift;
    my $self = { };

    my %args;
    while($#_ >= 0) { $args{ lc(pop(@_)) } = pop(@_); }

    bless($self, $proto);

    $self->{DELEGATE} = new Net::Jabber::Protocol();

    $self->{DEBUG} =
        new Net::Jabber::Debug(level=>exists($args{debuglevel}) ? $args{debuglevel} : -1,
                               file=>exists($args{debugfile}) ? $args{debugfile} : "stdout",
                               time=>exists($args{debugtime}) ? $args{debugtime} : 0,
                               setdefault=>1,
                               header=>"NJ::Client"
                    );

    $self->{SERVER} = {hostname => "localhost",
                       port => 5222 ,
                       ssl=>(exists($args{ssl}) ? $args{ssl} : 0),
                       connectiontype=>(exists($args{connectiontype}) ? $args{connectiontype} : "tcpip")
                      };

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


##############################################################################
#
# AUTOLOAD - This function calls the delegate with the appropriate function
#            name and argument list.
#
##############################################################################
sub AUTOLOAD
{
    my $self = $_[0];
    return if ($AUTOLOAD =~ /::DESTROY$/);
    $AUTOLOAD =~ s/^.*:://;
    $self->{DELEGATE}->$AUTOLOAD(@_);
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

    while($#_ >= 0) { $self->{SERVER}{ lc pop(@_) } = pop(@_); }

    $self->{DEBUG}->Log1("Connect: hostname($self->{SERVER}->{hostname})");

    delete($self->{SESSION});
    $self->{SESSION} =
        $self->{STREAM}->
            Connect(hostname=>$self->{SERVER}->{hostname},
                    port=>$self->{SERVER}->{port},
                    namespace=>"jabber:client",
                    connectiontype=>$self->{SERVER}->{connectiontype},
                    ssl=>$self->{SERVER}->{ssl},
                    timeout=>10
                   );

    if ($self->{SESSION}) {
        $self->{DEBUG}->Log1("Connect: connection made");

        $self->{STREAM}->SetCallBacks(node=>sub{ $self->CallBack(@_) });
        $self->{CONNECTED} = 1;
        return 1;
    } else {
        $self->SetErrorCode($self->{STREAM}->GetErrorCode());
        return;
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
    $self->{CONNECTED} = 0;
    $self->{DEBUG}->Log1("Disconnect: bye bye");
}


###########################################################################
#
# Connected - returns 1 if the Transport is connected to the server, 0
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

    $args{connectattempts} = -1 unless exists($args{connectattempts});
    $args{connectsleep} = 5 unless exists($args{connectsleep});
    $args{register} = 0 unless exists($args{register});

    my %connect;
    $connect{hostname} = $args{hostname};
    $connect{port} = $args{port} if exists($args{port});
    $connect{connectiontype} = $args{connectiontype}
        if exists($args{connectiontype});
    $connect{ssl} = $args{ssl} if exists($args{ssl});
    
    $self->{DEBUG}->Log1("Execute: begin");

    my $connectAttempt = $args{connectattempts};

    while(($connectAttempt == -1) || ($connectAttempt > 0))
    {

        $self->{DEBUG}->Log1("Execute: Attempt to connect ($connectAttempt)");

        my $status = $self->Connect(%connect);

        if (!(defined($status)))
        {
            $self->{DEBUG}->Log1("Execute: Jabber server is not answering.  (".$self->GetErrorCode().")");
            $self->{CONNECTED} = 0;

            $connectAttempt-- unless ($connectAttempt == -1);
            sleep($args{connectsleep});
            next;
        }

        $self->{DEBUG}->Log1("Execute: Connected...");
        &{$self->{CB}->{onconnect}}() if exists($self->{CB}->{onconnect});

        my @result = $self->AuthSend(username=>$args{username},
                                     password=>$args{password},
                                     resource=>$args{resource}
                                     );
        if ($result[0] ne "ok")
        {
            $self->{DEBUG}->Log1("Execute: Could not auth with server: ($result[0]: $result[1])");
            if ($args{register} == 0)
            {
                $self->{DEBUG}->Log1("Execute: Reigster turned off.  Exiting.");
                $self->Disconnect();
                &{$self->{CB}->{ondisconnect}}()
                    if exists($self->{CB}->{ondisconnect});
                $connectAttempt = 0;
            }
            else
            {
                my %fields = $self->RegisterRequest();

                $fields{username} = $args{username};
                $fields{password} = $args{password};

                $self->RegisterSend(%fields);
                
                @result = $self->AuthSend(username=>$args{username},
                                          password=>$args{password},
                                          resource=>$args{resource}
                                         );

                if ($result[0] ne "ok")
                {
                    $self->{DEBUG}->Log1("Execute: Register failed.  Exiting.");
                    $self->Disconnect();
                    &{$self->{CB}->{ondisconnect}}()
                        if exists($self->{CB}->{ondisconnect});
                    $connectAttempt = 0;
                }
                else
                {
                    &{$self->{CB}->{onauth}}()
                        if exists($self->{CB}->{onauth});
                }
            }
        }
        else
        {
            &{$self->{CB}->{onauth}}()
                if exists($self->{CB}->{onauth});
        }
 
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
