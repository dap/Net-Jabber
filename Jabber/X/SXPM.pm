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

package Net::Jabber::X::SXPM;

=head1 NAME

Net::Jabber::X::SXPM - Jabber X SXPM Delegate

=head1 SYNOPSIS

  Net::Jabber::X::SXPM is a companion to the Net::Jabber::X module.
  It provides the user a simple interface to set and retrieve all 
  parts of a Jabber X SXPM.

=head1 DESCRIPTION

  To initialize the SXPM with a Jabber <x/> you must pass it the 
  XML::Parser Tree array from the module trying to access the <x/>.  
  In the callback function:

    use Net::Jabber;

    sub iq {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:sxpm");

      my $xTag;
      foreach $xTag (@xTags) {
	$xTag->....
	
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new SXPM to send to the server:

    use Net::Jabber;

    $foo = new Net::Jabber::Foo();
    $xTag = $foo->NewX("jabber:x:sxpm");

  Now you can call the creation functions below.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $data        = $xTag->GetData();
    $datawidth   = $xTag->GetDataWidth();
    $datax       = $xTag->GetDataX();
    $datay       = $xTag->GetDataY();
    $boardheight = $xTag->GetBoardHeight();
    $boardwidth  = $xTag->GetBoardWidth();

    @maps      = $xTag->GetMaps();

=head2 Creation functions

    $xTag->SetSXPM(boardwidth=>400,
                   boardheight=>600);
    $xTag->SetSXPM(data=>"3 a2 a  a2 a3 ",
                   datawidth=>4,
		   datax=>100,
		   datay=>300);

    $xTag->SetData(" a aa a");
    $xTag->SetDataWidth(2);
    $xTag->SetDataX(15);
    $xTag->SetDataY(40);
    $xTag->SetBoardHeight(200);
    $xTag->SetBoardWidth(200);

    $map = $xTag->AddMap();

=head1 METHODS

=head2 Retrieval functions

  GetData() - returns a string with the compressed sxpm data in it.
              To uncompress it, run through the string and anytime
              you encounter a number, replace the number and following
              character with that number of that character:

                10a5b10a = aaaaaaaaaabbbbbaaaaaaaaaa

              The use the GetDataWidth() function to get the width
              of a line and break the line to some number of width
              wide strings and that becomes the update block for the 
              sxpm.

  GetDataWidth() - how long a row of the block is so that you can
                   chop up the sxpm block you were sent.
 
  GetDataX() - the x coordinate to overlay the sxpm data at.
 
  GetDataY() - the x coordinate to overlay the sxpm data at.
 
  GetBoardHeight() - returns an integer with the height of the new board
                     to create, or to resize the current board to.

  GetBoardWidth() - returns an integer with the width of the new board
                    to create, or to resize the current board to.

  GetMaps() - returns an array of Net::Jabber::X::SXPM::Map objects.
              These can be modified or accessed with the functions
              available to them.

=head2 Creation functions

  SetSXPM(data=>string,         - set multiple fields in the <x/> at one
          datawidth=>integer,     time.  This is a cumulative and over
          datax=>integer,         writing action.  If you set the "data"
          datay=>integer)         value twice, the second setting is
          boardheight=>integer,   what is used.  If you set the boardheight,
          boardwidth=>integer)    and then set the boardwidth then both 
                                  will be in the <x/> tag.  For valid 
                                  settings read the specific Set functions
                                  below.

  SetData(string) - sets the <data/> cdata to the string.  The string
                    must be valid sxpm data.

  SetDataWidth(integer) - sets the width so that the other side can
                          decode the sxpm data correctly.

  SetDataX(integer) - sets the x coordinate to anchor the sxpm data at.

  SetDataY(integer) - sets the y coordinate to anchor the sxpm data at.

  SetBoardHeight(string) - sets the board height when creating a new board,
                           or resizing the current board.

  SetBoardWidth(string) - sets the board width when creating a new board,
                          or resizing the current board.

  AddMap(XML::Parser tree) - creates a new Net::Jabbber::X::SXPM::Map
                             object and populates it with the tree if one
                             was passed in.  This returns the pointer to
                             the <map/> so you can modify it with the
                             creation functions from that module.

=head2 Test functions

  DefinedData() - returns 1 if the <data/> tag exists in the x, 
                  0 otherwise.

  DefinedDataWidth() - returns 1 if the width attribute exists in the 
                       <data/> tag, 0 otherwise.

  DefinedDataX() - returns 1 if the x attribute exists in the </data>
                   tag, 0 otherwise.

  DefinedDataY() - returns 1 if the y attribute exists in the </data>
                   tag, 0 otherwise.

  DefinedBoard() - returns 1 if there is a <board/> tag in the <x/>.

  DefinedBoardHeight() - returns 1 if the height attribute exists in the 
                        <board/> tag, 0 otherwise.

  DefinedBoardWidth() - returns 1 if the width attribute exists in the 
                       <board/> tag, 0 otherwise.


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

use Net::Jabber::X::SXPM::Map;
($Net::Jabber::X::SXPM::Map::VERSION < $VERSION) &&
  die("Net::Jabber::X::SXPM::Map $VERSION required--this is only version $Net::Jabber::X::SXPM::Map::VERSION");

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

$FUNCTIONS{get}->{Data}        = ["value","data",""];
$FUNCTIONS{get}->{DataWidth}   = ["value","data","width"];
$FUNCTIONS{get}->{DataX}       = ["value","data","x"];
$FUNCTIONS{get}->{DataY}       = ["value","data","y"];
$FUNCTIONS{get}->{BoardHeight} = ["value","board","height"];
$FUNCTIONS{get}->{BoardWidth}  = ["value","board","width"];

$FUNCTIONS{set}->{Data}        = ["single","data","*","",""];
$FUNCTIONS{set}->{DataWidth}   = ["single","data","","width","*"];
$FUNCTIONS{set}->{DataX}       = ["single","data","","x","*"];
$FUNCTIONS{set}->{DataY}       = ["single","data","","y","*"];
$FUNCTIONS{set}->{BoardHeight} = ["single","board","","height","*"];
$FUNCTIONS{set}->{BoardWidth}  = ["single","board","","width","*"];

$FUNCTIONS{defined}->{Data}        = ["existence","data",""];
$FUNCTIONS{defined}->{DataWidth}   = ["existence","data","width"];
$FUNCTIONS{defined}->{DataX}       = ["existence","data","x"];
$FUNCTIONS{defined}->{DataY}       = ["existence","data","y"];
$FUNCTIONS{defined}->{Board}       = ["existence","board",""];
$FUNCTIONS{defined}->{BoardHeight} = ["existence","board","height"];
$FUNCTIONS{defined}->{BoardWidth}  = ["existence","board","width"];


##############################################################################
#
# SetSXPM - takes a hash of all of the things you can set on a jabber:x:sxpm #            and sets each one.
#
##############################################################################
sub SetSXPM {
  shift;
  my $self = shift;
  my %sxpm;
  while($#_ >= 0) { $sxpm{ lc pop(@_) } = pop(@_); }

  $self->SetData($sxpm{data}) if exists($sxpm{data});
  $self->SetDataWidth($sxpm{datawidth}) if exists($sxpm{datawidth});
  $self->SetDataX($sxpm{datax}) if exists($sxpm{datax});
  $self->SetDataY($sxpm{datay}) if exists($sxpm{datay});
  $self->SetBoardHeight($sxpm{boardheight}) if exists($sxpm{boardheight});
  $self->SetBoardWidth($sxpm{boardwidth}) if exists($sxpm{boardwidth});
}


##############################################################################
#
# GetMaps - returns an array of Net::Jabber::X::SXPM::Map objects.
#
##############################################################################
sub GetMaps {
  shift;
  my $self = shift;

  if (!(exists($self->{MAPS}))) {
    my $mapTree;
    foreach $mapTree ($self->GetMapTrees()) {
      my $map = new Net::Jabber::X::SXPM::Map(@{$mapTree});
      push(@{$self->{MAPS}},$map);
    }
  }

  return (exists($self->{MAPS}) ? @{$self->{MAPS}} : ());
}


##############################################################################
#
# AddMap - creates a new Net::Jabber::X::SXPM::Map object from the tree
#           passed to the function if any.  Then it returns a pointer to that
#           object so you can modify it.
#
##############################################################################
sub AddMap {
  shift;
  my $self = shift;

  my $mapObj = new Net::Jabber::X::SXPM::Map("map",[{}]);
  $mapObj->SetMap(@_);
  push(@{$self->{MAPS}},$mapObj);

  return $mapObj;
}


##############################################################################
#
# GetMapTrees - returns an array of XML::Parser trees of <map/>s.
#
##############################################################################
sub GetMapTrees {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("tree array",$self->{X},"map");
}


##############################################################################
#
# MergeMaps - takes the <map/>s in the Net::Jabber::X::SXPM::Map
#              objects and pulls the data out and merges it into the <x/>.
#              This is a private helper function.  It should be used any time
#              you need to access the full <x/> so that the <map/>s are
#              included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeMaps {
  shift;
  my $self = shift;

#  $self->{DEBUG}->Log2("MergeMaps: start");

  return if !(exists($self->{MAPS}));

#  $self->{DEBUG}->Log2("MergeMaps: maps(",$self->{MAPS},")");

  my $map;
  my @maps;
  foreach $map (@{$self->{MAPS}}) {
    push(@maps,$map);
  }

#  $self->{DEBUG}->Log2("MergeMaps: maps(",\@maps,")");
#  $self->{DEBUG}->Log2("MergeMaps: Check the old tags");
#  $self->{DEBUG}->Log2("MergeMaps: length(",$#{$self->{X}->[1]},")");
  
  foreach my $i (1..$#{$self->{X}->[1]}) {
#    $self->{DEBUG}->Log2("MergeMaps: i($i)");
#    $self->{DEBUG}->Log2("MergeMaps: data(",$self->{X}->[1]->[$i],")");

    if ((ref($self->{X}->[1]->[($i+1)]) eq "ARRAY") &&
        ($self->{X}->[1]->[($i+1)]->[0] eq "map")) {
#      $self->{DEBUG}->Log2("MergeMaps: merge index($i)");
      my $map = pop(@maps);
#      $self->{DEBUG}->Log2("MergeMaps: merge map($map)");
      my @mapTree = $map->GetTree();
#      $self->{DEBUG}->Log2("MergeMaps: merge mapTree(",\@mapTree,")");
      $self->{X}->[1]->[($i+1)] = $mapTree[1];
    }
  }

#  $self->{DEBUG}->Log2("MergeMaps: Insert new tags");
  foreach $map (@maps) {
#    $self->{DEBUG}->Log2("MergeMaps: new tag");
    my @mapTree = $map->GetTree();
    $self->{X}->[1]->[($#{$self->{X}->[1]}+1)] = "map";
    $self->{X}->[1]->[($#{$self->{X}->[1]}+1)] = $mapTree[1];
  }

#  $self->{DEBUG}->Log2("MergeMaps: end");
}


1;
