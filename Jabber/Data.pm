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

package Net::Jabber::Data;

=head1 NAME

Net::Jabber::Data - Jabber Data Library

=head1 SYNOPSIS

  Net::Jabber::Data is a companion to the Net::Jabber::XDB module. It
  provides the user a simple interface to set and retrieve all 
  parts of a Jabber XDB Data.

=head1 DESCRIPTION

  Net::Jabber::Data differs from the other Net::Jabber::* modules in that
  the XMLNS of the data is split out into more submodules under
  Data.  For specifics on each module please view the documentation
  for each Net::Jabber::Data::* module.  The available modules are:

    Net::Jabber::Data::Agent      - Agent Namespace
    Net::Jabber::Data::Agents     - Supported Agents list from server
    Net::Jabber::Data::Auth       - Simple Client Authentication
    Net::Jabber::Data::AutoUpdate - Auto-Update for clients
    Net::Jabber::Data::Filter     - Messaging Filter
    Net::Jabber::Data::Fneg       - Feature Negotiation
    Net::Jabber::Data::Oob        - Out of Bandwidth File Transfers
    Net::Jabber::Data::Register   - Registration requests
    Net::Jabber::Data::Roster     - Buddy List management
    Net::Jabber::Data::Search     - Searching User Directories
    Net::Jabber::Data::Time       - Client Time
    Net::Jabber::Data::Version    - Client Version

  Each of these modules provide Net::Jabber::Data with the functions
  to access the data.  By using delegates and the AUTOLOAD function
  the functions for each namespace is used when that namespace is
  active.

  To access a Data object you must create an XDB object and use the
  access functions there to get to the Data.  To initialize the XDB with 
  a Jabber <xdb/> you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the xdb
  you can access the data tag by doing the following:

    use Net::Jabber;

    sub xdbCB {
      my $xdb = new Net::Jabber::XDB(@_);
      my $data = $mesage->GetData();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new xdb to send to the server:

    use Net::Jabber;

    my $xdb = new Net::Jabber::XDB();
    $data = $xdb->NewData("jabber:xdb:register");

  Now you can call the creation functions for the Data as defined in the
  proper namespaces.  See below for the general <data/> functions, and
  in each data module for those functions.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $xmlns     = $XDB->GetXMLNS();

    $str       = $XDB->GetXML();
    @xdb        = $XDB->GetTree();

=head2 Creation functions

    $Data->SetXMLNS("jabber:xdb:roster");

=head1 METHODS

=head2 Retrieval functions

  GetXMLNS() - returns a string with the namespace of the data that
               the <xdb/> contains.

  GetXML() - returns the XML string that represents the <xdb/>. This 
             is used by the Send() function in Client.pm to send
             this object as a Jabber XDB.

  GetTree() - returns an array that contains the <xdb/> tag in XML::Parser 
              Tree format.

=head2 Creation functions

  SetXMLNS(string) - sets the xmlns of the <data/> to the string.

=head1 CUSTOM Data MODULES

  Part of the flexability of this module is that you can write your own
  module to handle a new namespace if you so choose.  The SetDelegates
  function is your way to register the xmlns and which module will
  provide the missing access functions.

  To register your namespace and module, you can either create an XDB
  object and register it once, or you can use the SetDelegates
  function in Client.pm to do it for you:

    my $Client = new Net::Jabber::Client();
    $Client->AddDelegate(namespace=>"blah:blah",
			 parent=>"Net::Jabber::Data",
			 delegate=>"Blah::Blah");
    
  or

    my $Transport = new Net::Jabber::Transport();
    $Transport->AddDelegate(namespace=>"blah:blah",
			    parent=>"Net::Jabber::Data",
			    delegate=>"Blah::Blah");

  Once you have the delegate registered you need to define the access
  functions.  Here is a an example module:

    package Blah::Blah;

    sub new {
      my $proto = shift;
      my $class = ref($proto) || $proto;
      my $self = { };
      $self->{VERSION} = $VERSION;
      bless($self, $proto);
      return $self;
    }

    sub SetBlah {
      shift;
      my $self = shift;
      my ($blah) = @_;
      return &Net::Jabber::SetXMLData("single",$self->{DATA},"blah","$blah",{});
    }

    sub GetBlah {
      shift;
      my $self = shift;
      return &Net::Jabber::GetXMLData("value",$self->{DATA},"blah","");
    }

    1;

  Now when you create a new Data object and call GetBlah on that object
  it will AUTOLOAD the above function and handle the request.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD);

$VERSION = "1.0021";

use Net::Jabber::Data::Auth;
($Net::Jabber::Data::Auth::VERSION < $VERSION) &&
  die("Net::Jabber::Data::Auth $VERSION required--this is only version $Net::Jabber::Data::Auth::VERSION");

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{DATA} = \@temp;
    $self->GetDelegate();
  } else {
    $self->{DATA} = [ "data" , [{}]];
  }

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
# GetDelegate - sets the delegate for the AUTOLOAD function based on the
#               namespace.
#
##############################################################################
sub GetDelegate {
  my $self = shift;
  my $xmlns = $self->GetXMLNS();
  return if $xmlns eq "";
  if (exists($Net::Jabber::DELEGATES{data}->{$xmlns})) {
    eval("\$self->{DELEGATE} = new ".$Net::Jabber::DELEGATES{data}->{$xmlns}->{delegate}."()");
  }
}


##############################################################################
#
# GetXMLS - returns the namespace of the data in the <xdb/>
#
##############################################################################
sub GetXMLNS {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{DATA},"","xmlns");
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  $self->MergeItems() if (exists($self->{ITEMS}));
  $self->MergeAgents() if (exists($self->{AGENTS}));
  $self->MergeReleases() if (exists($self->{RELEASES}));
  $self->MergeRules() if (exists($self->{RULES}));
  return &Net::Jabber::BuildXML(@{$self->{DATA}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;
  $self->MergeItems() if (exists($self->{ITEMS}));
  $self->MergeAgents() if (exists($self->{AGENTS}));
  $self->MergeReleases() if (exists($self->{RELEASES}));
  $self->MergeRules() if (exists($self->{RULES}));
  return @{$self->{DATA}};
}


##############################################################################
#
# SetXMLS - sets the namespace of the <data/>
#
##############################################################################
sub SetXMLNS {
  my $self = shift;
  my ($xmlns) = @_;
  &Net::Jabber::SetXMLData("single",$self->{DATA},"","",{"xmlns"=>$xmlns});
  $self->GetDelegate();
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for debugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug Data: $self\n";
  $self->MergeItems() if (exists($self->{ITEMS}));
  $self->MergeAgents() if (exists($self->{AGENTS}));
  $self->MergeReleases() if (exists($self->{RELEASES}));
  $self->MergeRules() if (exists($self->{RULES}));
  &Net::Jabber::printData("debug: \$self->{DATA}->",$self->{DATA});
}

1;
