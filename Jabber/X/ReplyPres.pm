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

package Net::Jabber::X::ReplyPres;

=head1 NAME

Net::Jabber::X::ReplyPres - Jabber X Reply Presence Notification

=head1 SYNOPSIS

  Net::Jabber::X::ReplyPres is a companion to the Net::Jabber::X module.
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber X Reply Presence.
 
  The main purpose for this module is to handle the presence that is sent
  when a user is typing a reply to you.

=head1 DESCRIPTION

  To initialize the ReplyPres with a Jabber <x/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <x/>.  
  In the callback function:

    use Net::Jabber;

    sub presence {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:replypres");

      my $xTag;
      foreach $xTag (@xTags) {
	$xTag->....
	
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new ReplyPres to send to the server:

    use Net::Jabber;

    $foo = new Net::Jabber::Foo();
    $xTag = $foo->NewX("jabber:x:replypres");

  Now you can call the creation functions below.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    n/a

=head2 Creation functions

    n/a

=head1 METHODS

=head2 Retrieval functions

    n/a

=head2 Creation functions

    n/a

=head1 AUTHOR

By Ryan Eatmon in November of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION);

$VERSION = "1.0020";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  return $self;
}


1;
