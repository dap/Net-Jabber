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

package Net::Jabber::X::SXPM::Map;

=head1 NAME

Net::Jabber::X::SXPM::Map - Jabber X SXPM Map Module

=head1 SYNOPSIS

  Net::Jabber::X::SXPM::Map is a companion to the 
  Net::Jabber::X::SXPM module.  It provides the user a simple 
  interface to set and retrieve all parts of a Jabber SXPM Map.

=head1 DESCRIPTION

  To initialize the Map with a Jabber <x/> and then access the </x>
  you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the object
  type foo:

    use Net::Jabber;

    sub foo {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:sxpm");

      my $xTag;
      foreach $xTag (@xTags) {
        my @maps = $xTag->GetMaps();
	my $map;
	foreach $map (@maps) {
	  $map->GetXXXX();
	  .
	  .
	  .
	}
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available below.

  To create a new IQ SXPM Map to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $foo = new Net::Jabber::Foo();
    $sxpm = $foo->NewX("jabber:x:sxpm");
    $foo = $sxpm->AddMap();
    ...

    $client->Send($foo);

  Using $map you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $char  = $map->GetChar();
    $color = $map->GetColor();

    @map   = $map->GetTree();
    $str   = $map->GetXML();

=head2 Creation functions

    $map->SetMap(char=>"@");     # for erasing a pixel
    $map->SetMap(char=>"a",
		 color=>"#FFFFFF");
  
    $map->SetChar('b');
    $map->SetColor('#FF0000');

=head1 METHODS

=head2 Retrieval functions

  GetChar() - returns a string with the character of the <map/>.

  GetColor() - returns a string with the RGB color of the <map/>.

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetMap(char=>string,  - set multiple fields in the <map/>
         color=>string)   at one time.  This is a cumulative
                          and overwriting action.  If you
                          set the "char" twice, the second
                          setting is what is used.  If you set
                          the char, and then set the color
                          then both will be in the <map/>
                          tag.  For valid settings read the 
                          specific Set functions below.

  SetChar(string) - sets the character that is associated with this
                    color map entry.

  SetColor(string) - sets the color that is associated with this
                     color map entry.  Must be in RGB #xxxxxx format.


=head1 AUTHOR

By Ryan Eatmon in January of 2001 for http://jabber.org..

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

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{MAP} = \@temp;
  } else {
    $self->{MAP} = [ "map" , [{}]];
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
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "MAP";
  
  return &Net::Jabber::BuildXML(@{$self->{$treeName}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{$treeName}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{Char}      = ["value","","char"];
$FUNCTIONS{get}->{Color}     = ["value","","color"];

$FUNCTIONS{set}->{Char}      = ["single","","","char","*"];
$FUNCTIONS{set}->{Color}     = ["single","","","color","*"];

$FUNCTIONS{defined}->{Char}  = ["existence","","char"];
$FUNCTIONS{defined}->{Color} = ["existence","","color"];


##############################################################################
#
# SetMap - takes a hash of all of the things you can set on an map <x/>
#           and sets each one.
#
##############################################################################
sub SetMap {
  my $self = shift;
  my %map; 
  while($#_ >= 0) { $map{ lc pop(@_) } = pop(@_); }
  
  $self->SetChar($map{char}) if exists($map{char});
  $self->SetColor($map{color}) if exists($map{color});
}


1;
