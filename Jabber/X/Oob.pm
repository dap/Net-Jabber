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

package Net::Jabber::X::Oob;

=head1 NAME

Net::Jabber::X::Oob - Jabber X Out Of Bandwidth File Transfer Module

=head1 SYNOPSIS

  Net::Jabber::X::Oob is a companion to the Net::Jabber::X module.
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber X Oob.

=head1 DESCRIPTION

  To initialize the Oob with a Jabber <x/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <x/>.  
  In the callback function:

    use Net::Jabber;

    sub iq {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:oob");

      my $xTag;
      foreach $xTag (@xTags) {
	$xTag->....
	
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new Oob to send to the server:

    use Net::Jabber;

    $foo = new Net::Jabber::Foo();
    $x = $foo->NewX("jabber:x:oob");

  Now you can call the creation functions below.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $url  = $xTag->GetURL();
    $desc = $xTag->GetDesc();

=head2 Creation functions

    $xTag->SetOob(UrL=>"http://my.web.server.com/~me/pics/bob.jpg",
	          desc=>"Picture of Bob, the one and only");

    $xTag->SetURL("http://my.web.server.com/~me/pics/bobandme.jpg");
    $xTag->SetDesc("Bob and Me at the Open Source conference");

=head1 METHODS

=head2 Retrieval functions

  GetURL() - returns a string with the URL of the file being sent Oob.

  GetDesc() - returns a string with the description of the file being
               sent Oob.

=head2 Creation functions

  SetOob(url=>string,  - set multiple fields in the <x/> at one
         desc=>string)   time.  This is a cumulative and over
                         writing action.  If you set the "url"
                         attribute twice, the second setting is
                         what is used.  If you set the url, and
                         then set the desc then both will be in
                         the <x/> tag.  For valid settings read the
                         specific Set functions below.

  SetURL(string) - sets the URL for the file being sent Oob.

  SetDesc(string) - sets the description for the file being sent Oob.

=head2 Test functions

  DefinedURL() - returns 1 if <url/> exists in the x, 0 otherwise.

  DefinedDesc() - returns 1 if <desc/> exists in the x, 0 otherwise.

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

$FUNCTIONS{get}->{URL}  = ["value","url",""];
$FUNCTIONS{get}->{Desc} = ["value","desc",""];

$FUNCTIONS{set}->{URL}  = ["single","url","*","",""];
$FUNCTIONS{set}->{Desc} = ["single","desc","*","",""];

$FUNCTIONS{defined}->{URL}  = ["existence","url",""];
$FUNCTIONS{defined}->{Desc} = ["existence","desc",""];


##############################################################################
#
# SetOob - takes a hash of all of the things you can set on a jabber:x:oob and
#          sets each one.
#
##############################################################################
sub SetOob {
  shift;
  my $self = shift;
  my %oob;
  while($#_ >= 0) { $oob{ lc pop(@_) } = pop(@_); }

  $self->SetURL($oob{url}) if exists($oob{url});
  $self->SetDesc($oob{desc}) if exists($oob{desc});
}


1;
