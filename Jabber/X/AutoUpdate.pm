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

package Net::Jabber::X::AutoUpdate;

=head1 NAME

Net::Jabber::X::AutoUpdate - Jabber X AutoUpdate Delegate

=head1 SYNOPSIS

  Net::Jabber::X::AutoUpdate is a companion to the Net::Jabber::X module.
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber X AutoUpdate.

=head1 DESCRIPTION

  To initialize the AutoUpdate with a Jabber <x/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <x/>.  
  In the callback function:

    use Net::Jabber;

    sub iq {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:autoupdate");

      my $xTag;
      foreach $xTag (@xTags) {
	$xTag->....
	
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new AutoUpdate to send to the server:

    use Net::Jabber;

    $foo = new Net::Jabber::Foo();
    $x = $foo->NewX("jabber:x:autoupdate");

  Now you can call the creation functions below.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $jid = $xTag->GetJID();

=head2 Creation functions

    $xTag->SetX(jid=>"update.jabber.org");

    $xTag->SetJID("update.jabber.com");

=head1 METHODS

=head2 Retrieval functions

  GetJID() - returns a string with the Jabber Identifier of the 
             agent that is going to handle the update.

=head2 Creation functions

  SetX(jid=>string) - set multiple fields in the <x/> at one
                      time.  This is a cumulative and over
                      writing action.  If you set the "jid"
                      attribute twice, the second setting is
                      what is used.  For valid settings read the
                      specific Set functions below.

  SetJID(string) - sets the JID of the agent that is going to handle the
                   update.

=head1 AUTHOR

By Ryan Eatmon in May of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.0020";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

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
  my $parent = shift;
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "X";

  return &Net::Jabber::Get($parent,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($parent,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($parent,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  &Net::Jabber::MissingFunction($parent,$AUTOLOAD);
}

$FUNCTIONS{get}->{JID} = ["value","",""];

$FUNCTIONS{set}->{JID} = ["single","","*","",""];


##############################################################################
#
# SetX - takes a hash of all of the things you can set on a 
#        jabber:x:autoupdate and sets each one.
#
##############################################################################
sub SetX {
  shift;
  my $self = shift;
  my %x;
  while($#_ >= 0) { $x{ lc pop(@_) } = pop(@_); }

  $self->SetJID($x{jid}) if exists($x{jid});
}


1;
