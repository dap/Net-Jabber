package Net::Jabber::Transport;

=head1 NAME

Net::Jabber::Transport - Jabber Transport Library

=head1 SYNOPSIS

  Net::Jabber::Transport is a module that provides a developer easy access
  to tranports in the Jabber Instant Messaging protocol.

=head1 DESCRIPTION

  Transport.pm seeks to provide enough high level APIs and automation of 
  the low level APIs that writing a Jabber Transport in Perl is trivial.
  For those that wish to work with the low level you can do that too, 
  but those functions are covered in the documentation for each module.

  Net::Jabber::Transport provides functions to connect to a Jabber server,
  login, send and receive messages, set personal information, create
  a new user account, manage the roster, and disconnect.  You can use
  all or none of the functions, there is no requirement.

  For more information on how the details for how Net::Jabber is written
  please see the help for Net::Jabber itself.

  For a full list of high level functions available please see 
  Net::Jabber::Protocol.

=head2 Basic Functions

    use Net::Jabber;

    $Con = new Net::Jabber::Transport();

    $Con->Connect(hostname=>"jabber.org");

    #
    # For the list of available function see Net::Jabber::Protocol.
    #

    $Con->Disconnect();

=head1 METHODS

=head2 Basic Functions

    new(debug=>string)       - creates the Transport object.  debug
        debugfh=>FileHandle)   should be set to the path for the debug
                               log to be written.  If set to "stdout" 
                               then the debug will go there.  Also, you
                               can specify a filehandle that already
                               exists and use that.

    Connect(hostname=>string,      - opens a connection to the server
	    port=>integer,           listedt in the hostname value,
	    secret=>string,          on the port listed.  The defaults
	    transportname=>string)   for the two are localhost and 5222.
				     The secret is the password needed
                                     to attach the hostname, and the
                                     transportname is the name that
                                     server and clients will know the
                                     transport by.

    Disconnect() - closes the connection to the server.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org.

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use XML::Stream;
use IO::Select;
use FileHandle;
use vars qw($VERSION $AUTOLOAD);

$VERSION = "1.0";

use Net::Jabber::Protocol;
($Net::Jabber::Protocol::VERSION < $VERSION) &&
  die("Net::Jabber::Protocol $VERSION required--this is only version $Net::Jabber::Protocol::VERSION");

sub new {
  srand( time() ^ ($$ + ($$ << 15)));

  my $proto = shift;
  my $self = { };

  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  $self->{DEBUG} = 0;
  if (exists($args{debugfh}) && ($args{debugfh} ne "")) {
    $self->{DEBUGFILE} = $args{debugfh};
    $self->{DEBUG} = 1;
  }
  if (((!exists($args{debugfh})) || 
       (exists($args{debugfh}) && ($args{debugfh} eq ""))) && 
      (exists($args{debug}) && ($args{debug} ne ""))) {
    $self->{DEBUG} = 1;
    if (lc($args{debug}) eq "stdout") {
      $self->{DEBUGFILE} = new FileHandle(">&STDOUT");
      $self->{DEBUGFILE}->autoflush(1);
    } else {
      if (-e $args{debug}) {
	if (-w $args{debug}) {
	  $self->{DEBUGFILE} = new FileHandle(">$args{debug}");
	  $self->{DEBUGFILE}->autoflush(1);
	} else {
	  print "WARNING: debug file ($args{debug}) is not writable by you\n";
	  print "         No debug information being saved.\n";
	  $self->{DEBUG} = 0;
	}
      } else {
	$self->{DEBUGFILE} = new FileHandle(">$args{debug}");
	if (defined($self->{DEBUGFILE})) {
	  $self->{DEBUGFILE}->autoflush(1);
	} else {
	  print "WARNING: debug file ($args{debug}) does not exist \n";
	  print "         and is not writable by you.\n";
	  print "         No debug information being saved.\n";
	  $self->{DEBUG} = 0;
	}
      }
    }
  }

  $self->{SERVER} = {hostname => "127.0.0.1", 
		     port => 5269,
		     transportname => ""};

  $self->{STREAM} = new XML::Stream(debugfh=>$self->{DEBUGFILE})
    if ($self->{DEBUG});
  $self->{STREAM} = new XML::Stream()
    if !($self->{DEBUG});

  $self->{VERSION} = $VERSION;
  
  $self->{LIST}->{currentID} = 0;

  if (eval "require Digest::SHA1") {
    $self->{DIGEST} = 1;
    Digest::SHA1->import(qw(sha1 sha1_hex sha1_base64));
  } else {
    print "ERROR:  You cannot use Transport.pm unless you have Digest::SHA1 installed.\n";
    exit(0);
  }

  $self->{DELEGATE} = new Net::Jabber::Protocol();

  bless($self, $proto);
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
# debug - prints the arguments to the debug log if debug is turned on.
#
###########################################################################
sub debug {
  my $self = shift;
  return if ($self->{DEBUG} == 0);
  my $fh = $self->{DEBUGFILE};
  print $fh "Transport: @_\n";
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

  if (!exists($args{hostname})) {
    print "ERROR: no hostname specified.\n";
    exit(0);
  }

  if (!exists($args{secret})) {
    print "ERROR: no secret specified.\n";
    exit(0);
  }

  if (!exists($args{transportname})) {
    print "ERROR: no transport name specified.\n";
    exit(0);
  }

  $self->{SERVER}->{hostname} = delete($args{hostname});
  $self->{SERVER}->{port} = delete($args{port}) if exists($args{port});
  $self->{SERVER}->{transportname} = delete($args{transportname});

  $self->{SERVER}->{id} = rand(1000000);
  $self->{SERVER}->{id} =~ s/\.//;
  ($self->{SERVER}->{id}) = 
    ($self->{SERVER}->{id} =~ /(\d\d\d\d\d\d\d\d\d\d)/);
  $self->{SERVER}->{digest} =
    Digest::SHA1::sha1_hex($self->{SERVER}->{id}.$args{secret});

  $self->{NAMESPACE} = new XML::Stream::Namespace("etherx");
  $self->{NAMESPACE}->SetXMLNS("http://etherx.jabber.org/");
  $self->{NAMESPACE}->SetAttributes(secret=>$self->{SERVER}->{digest});

  $self->{SESSION} = 
    $self->{STREAM}->
      Connect(hostname=>$self->{SERVER}->{hostname},
	      port=>$self->{SERVER}->{port},
	      myhostname=>$self->{SERVER}->{transportname},
	      id=>$self->{SERVER}->{id},
	      namespace=>"jabber:server",
	      namespaces=> [ $self->{NAMESPACE} ]
	     ) || return undef;
  
  $self->{STREAM}->OnNode(sub{ $self->CallBack(@_) });
  return 1;
}


###########################################################################
#
# Disconnect - Sends the string to close the connection cleanly.
#
###########################################################################
sub Disconnect {
  my $self = shift;

  $self->{STREAM}->Disconnect();
}


1;
