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

package Net::Jabber::Server;

=head1 NAME

Net::Jabber::Server - Jabber Server Library

=head1 SYNOPSIS

  Net::Jabber::Server is a module that provides a developer easy access
  to developing applications that need an embedded Jabber server.

=head1 DESCRIPTION

  Server.pm seeks to provide enough high level APIs and automation of 
  the low level APIs that writing and spawning a Jabber Server in Perl 
  is trivial.  For those that wish to work with the low level you can 
  do that too, but those functions are covered in the documentation for 
  each module.

  Net::Jabber::Server provides functions to run a full Jabber server that
  accepts incoming connections and delivers packets to external Jabber
  servers.  You can use all or none of the functions, there is no requirement.

  For more information on how the details for how Net::Jabber is written
  please see the help for Net::Jabber itself.

  For a full list of high level functions available please see 
  Net::Jabber::Protocol.

=head2 Basic Functions

    use Net::Jabber;

    $Server = new Net::Jabber::Server();

    $Server->Start();
    $Server->Start(jabberxml=>"custom_jabber.xml",
	           hostname=>"foobar.net");

    $Server->Stop();

=head1 METHODS

=head2 Basic Functions

    new(debuglevel=>0|1|2, - creates the Server object.  debugfile
        debugfile=>string,   should be set to the path for the debug
        debugtime=>0|1)      log to be written.  If set to "stdout" 
                             then the debug will go there.  debuglevel 
                             controls the amount of debug.  For more
                             information about the valid setting for
                             debuglevel, debugfile, and debugtime see 
                             Net::Jabber::Debug.

    Start(hostname=>string, - starts the server listening on the proper
	  jaberxml=>string)   ports.  hostname is a quick way of telling
                              the server the hostname to listen on.
                              jabberxml defines the path to a different
                              jabberd configuration file (default is
                              "./jabber.xml").

    Stop() - stops the server from running and shuts down all sub programs.

=head1 AUTHOR

By Ryan Eatmon in January of 2001 for http://jabber.org.

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use strict;
use XML::Stream 1.07;
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

  $self->{KEY} = new Net::Jabber::Key();

  $self->{DELEGATE} = new Net::Jabber::Protocol();

  $self->{DEBUG} = 
    new Net::Jabber::Debug(level=>exists($args{debuglevel}) ? $args{debuglevel} : -1,
			   file=>exists($args{debugfile}) ? $args{debugfile} : "stdout",
			   time=>exists($args{debugtime}) ? $args{debugtime} : 0,
			   setdefault=>1,
			   header=>"NJ::Server"
			  );

  $self->{SERVER} = {hostname => "localhost",
		     port => 5269,
		     servername => ""};

  $self->{STREAM} = new XML::Stream(debugfh=>$self->{DEBUG}->GetHandle(),
				    debuglevel=>$self->{DEBUG}->GetLevel(),
				    debugtime=>$self->{DEBUG}->GetTime());

  $self->{STREAM}->SetCallBacks(node=>sub{ $self->CallBack(@_) },
				sid=>sub{ return $self->{KEY}->Generate()});

  $self->{VERSION} = $VERSION;

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


##############################################################################
#
# Start - starts the server running
#
##############################################################################
sub Start {
  my $self = shift;
  my %args;
  while($#_ >= 0) { $args{ lc pop(@_) } = pop(@_); }

  $self->{STOP} = 0;

  $self->SetCallBacks('message'=>sub{ $self->messageHandler(@_); },
		      'presence'=>sub{ $self->presenceHandler(@_); },
		      'iq'=>sub{ $self->iqHandler(@_); },
		      'db:result'=>sub{ $self->dbresultHandler(@_); },
		      'db:verify'=>sub{ $self->dbverifyHandler(@_); },
		     );

  my $hostname = $self->{SERVER}->{hostname};
  $hostname = $args{hostname} if exists($args{hostname});

  my $status = "";
  while(($status eq "") && ($self->{STOP} == 0)) {
    $status = $self->{STREAM}->Listen(hostname=>$hostname,
				      port=>$self->{SERVER}->{port},
				      namespace=>"jabber:server");

    while(($self->{STOP} == 0) && defined($self->{STREAM}->Process(0))) {}
    $status = "";
  }
}


##############################################################################
#
# Stop - shuts down the server
#
##############################################################################
sub Stop {
  my $self = shift;
  $self->{STOP} = 1;
}


sub messageHandler {
  my $self = shift;
  my $sid = shift;
  my ($message) = @_;

  $self->{DEBUG}->Log2("messageHandler: message(",$message->GetXML(),")");
}


sub presenceHandler {
  my $self = shift;
  my $sid = shift;
  my ($presence) = @_;

  $self->{DEBUG}->Log2("presenceHandler: presence(",$presence->GetXML(),")");
}


sub iqHandler {
  my $self = shift;
  my $sid = shift;
  my ($iq) = @_;

  $self->{DEBUG}->Log2("iqHandler: iq(",$iq->GetXML(),")");
}


sub dbresultHandler {
  my $self = shift;
  my $sid = shift;
  my ($dbresult) = @_;

  $self->{DEBUG}->Log2("dbresultHandler: dbresult(",$dbresult->GetXML(),")");

  my $dbverify = new Net::Jabber::Dialback::Verify();
  $dbverify->SetVerify(to=>$dbresult->GetFrom(),
		       from=>$dbresult->GetTo(),
		       id=>$self->{STREAM}->GetRoot($sid)->{id},
		       data=>$dbresult->GetData());
  $self->Send($dbverify);
}


sub dbverifyHandler {
  my $self = shift;
  my $sid = shift;
  my ($dbverify) = @_;

  $self->{DEBUG}->Log2("dbverifyHandler: dbverify(",$dbverify->GetXML(),")");
}


1;