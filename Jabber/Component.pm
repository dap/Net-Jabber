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

    use Net::Jabber;

    $Con = new Net::Jabber::Component();

    $Con->Connect(hostname=>"jabber.org",
                  secret=>"foo");

      or

    $Con->Connect(connectiontype=>"exec");

    if ($Con->Connected()) {
      print "We are connected to the server...\n";
    }

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
use XML::Stream 1.06;
use IO::Select;
use vars qw($VERSION $AUTOLOAD);

$VERSION = "1.0021";

use Net::Jabber::Protocol;
($Net::Jabber::Protocol::VERSION < $VERSION) &&
  die("Net::Jabber::Protocol $VERSION required--this is only version $Net::Jabber::Protocol::VERSION");

use Net::Jabber::Key;
($Net::Jabber::Key::VERSION < $VERSION) &&
  die("Net::Jabber::Key $VERSION required--this is only version $Net::Jabber::Key::VERSION");

sub new {
  srand( time() ^ ($$ + ($$ << 15)));

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
			   header=>"NJ::Component"
			  );
  
  $self->{SERVER} = {hostname => "localhost",
		     port => 5269,
		     componentname => ""};

  $self->{CONNECTED} = 0;

  $self->{STREAM} = new XML::Stream(debugfh=>$self->{DEBUG}->GetHandle(),
				    debuglevel=>$self->{DEBUG}->GetLevel(),
				    debugtime=>$self->{DEBUG}->GetTime());

  $self->{VERSION} = $VERSION;
  
  $self->{LIST}->{currentID} = 0;

  return $self;
}


##############################################################################
#
# AUTOLOAD - This function calls the delegate with the appropriate function
#            name and argument list.
#
##############################################################################
sub AUTOLOAD {
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
sub Connect {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  $self->{DEBUG}->Log1("Connect: type($args{connectiontype})");

  $args{connectiontype} = "accept" unless exists($args{connectiontype});
  $self->{CONNECTIONTYPE} = $args{connectiontype};

  if (($args{connectiontype} eq "exec") ||
      ($args{connectiontype} eq "stdinout")) {
    
    $self->{SESSION} = 
      $self->{STREAM}->
	Connect(connectiontype=>"stdinout",
		namespace=>"jabber:component:exec",
		timeout=>10,
	       ) || (($self->SetErrorCode($self->{STREAM}->GetErrorCode())) &&
		     return);
  }
  
  if (($args{connectiontype} eq "accept") || 
      ($args{connectiontype} eq "tcpip")) {

    $self->{DEBUG}->Log1("Connect: hostname($args{hostname}) secret($args{secret}) componentname($args{componentname})");
    
    if (!exists($args{hostname})) {
      $self->SetErrorCode("No hostname specified.");
      return;
    }
    
    if (!exists($args{secret})) {
      $self->SetErrorCode("No secret specified.");
      return;
    }
    
    if (!exists($args{componentname})) {
      $self->SetErrorCode("No component specified.");
      return;
    }
    
    $self->{SERVER}->{hostname} = delete($args{hostname});
    $self->{SERVER}->{port} = delete($args{port}) if exists($args{port});
    
    $self->{SESSION} = 
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
	       );
    if ($self->{SESSION} eq "") {
      $self->SetErrorCode($self->{STREAM}->GetErrorCode());
      return;
    }
  }

  $self->{DEBUG}->Log1("Connect: connection made");

  if (($args{connectiontype} eq "accept") ||
      ($args{connectiontype} eq "tcpip")) {
    $self->Send("<handshake>".Digest::SHA1::sha1_hex($self->{SESSION}->{id}.$args{secret})."</handshake>");
    my @handshake = $self->Process();
    return if ($handshake[0] eq "");
    return if (&Net::Jabber::GetXMLData("value",$handshake[0],"","") ne "");
  }

  $self->{STREAM}->SetCallBacks(node=>sub{ $self->CallBack(@_) });
  $self->{CONNECTED} = 1;
  return 1;
}


###########################################################################
#
# Disconnect - Sends the string to close the connection cleanly.
#
###########################################################################
sub Disconnect {
  my $self = shift;
  $self->{STREAM}->Disconnect($self->{SESSION}->{id}) if ($self->{CONNECTED} == 1);
  $self->{CONNECTED} = 0;
  $self->{DEBUG}->Log1("Disconnect: bye bye");
}


###########################################################################
#
# Connected - returns 1 if the Component is connected to the server, 0
#             otherwise.
#
###########################################################################
sub Connected {
  my $self = shift;

  $self->{DEBUG}->Log1("Connected: ($self->{CONNECTED})");
  return $self->{CONNECTED};
}


1;
