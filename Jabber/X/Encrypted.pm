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

package Net::Jabber::X::Encrypted;

=head1 NAME

Net::Jabber::X::Encrypted - Jabber X Encrypted Module

=head1 SYNOPSIS

  Net::Jabber::X::Encrypted is a companion to the Net::Jabber::X module.
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber X Encrypted.

=head1 DESCRIPTION

  To initialize the Encrypted with a Jabber <x/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <x/>.  
  In the callback function:

    use Net::Jabber;

    sub iq {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:encrypted");

      my $xTag;
      foreach $xTag (@xTags) {
	$xTag->....
	
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new Encrypted to send to the server:

    use Net::Jabber;

    $foo = new Net::Jabber::Foo();
    $x = $foo->NewX("jabber:x:encrypted");

  Now you can call the creation functions below.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $message = $xTag->GetMessage();

=head2 Creation functions

    $xTag->SetEncrypted(message=>data);

    $xTag->SetMessage(data);

=head1 METHODS

=head2 Retrieval functions

  GetMessage() - returns a string with the message data.

=head2 Creation functions

  SetEncrypted(message=>string) - set multiple fields in the <x/> at one
                                  time.  This is a cumulative and over
                                  writing action.  If you set the 
                                  "message" data twice, the second 
                                  setting is what is used.  If you set the
                                  message, and then set another field 
                                  then both will be in the <x/> tag.  For 
                                  valid settings read the specific Set 
                                  functions below.

  SetMessage(string) - sets the data for the message.

=head1 AUTHOR

By Ryan Eatmon in December of 2000 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.0021";

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

$FUNCTIONS{get}->{Message} = ["value","",""];

$FUNCTIONS{set}->{Message} = ["single","","*","",""];


##############################################################################
#
# SetEncrypted - takes a hash of all of the things you can set on a
#             jabber:x:encrypted and sets each one.
#
##############################################################################
sub SetEncrypted {
  shift;
  my $self = shift;
  my %encrypted;
  while($#_ >= 0) { $encrypted{ lc pop(@_) } = pop(@_); }

  $self->SetMessage($encrypted{message}) if exists($encrypted{message});
}


1;
