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

package Net::Jabber::X::Roster::Item;

=head1 NAME

Net::Jabber::X::Roster::Item - Jabber IQ Roster Item Module

=head1 SYNOPSIS

  Net::Jabber::X::Roster::Item is a companion to the 
  Net::Jabber::X::Roster module.  It provides the user a simple 
  interface to set and retrieve all parts of a Jabber Roster Item.

=head1 DESCRIPTION

  To initialize the Item with a Jabber <x/> and then access the </x>
  you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the object
  type foo:

    use Net::Jabber;

    sub foo {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:roster");

      my $xTag;
      foreach $xTag (@xTags) {
        my @items = $xTag->GetItems();
	my $item;
	foreach $item (@items) {
	  $item->GetXXXX();
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

  To create a new IQ Roster Item to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $foo = new Net::Jabber::Foo();
    $roster = $foo->NewX("jabber:x:roster");
    $foo = $roster->AddItem();
    ...

    $client->Send($foo);

  Using $item you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $jid          = $item->GetJID();
    $jidJID       = $item->GetJID("jid");
    $name         = $item->GetName();
    @groups       = $item->GetGroups();

    @item         = $item->GetTree();
    $str          = $item->GetXML();

=head2 Creation functions

    $item->SetItem(jid=>'bob@jabber.org',
		   name=>'Bob',
		   subscription=>'both',
		   groups=>[ 'friends','school' ]);

    $item->SetJID('bob@jabber.org');
    $item->SetName('Bob');
    $item->SetGroups(['friends','school']);

=head1 METHODS

=head2 Retrieval functions

  GetJID()      - returns either a string with the Jabber Identifier,
  GetJID("jid")   or a Net::Jabber::JID object for the person who is 
                  listed in this <item/>.  To get the JID object set the 
                  string to "jid", otherwise leave blank for the text
                  string.

  GetName() - returns a string with the name of the jabber ID.

  GetGroups() - returns an array of strings with the names of the groups
               that this <item/> belongs to.

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetItem(jid=>string|JID, - set multiple fields in the <item/>
          name=>string,      at one time.  This is a cumulative
          groups=>array)     and overwriting action.  If you
                             set the "name" twice, the second
                             setting is what is used.  If you set
                             the name, and then set the
                             jid then both will be in the
                             <item/> tag.  For valid settings
                             read the specific Set functions below.
                             Note: groups does not behave in this
                             manner.  For each group setting a
                             new <group/> tag will be created.

  SetJID(string) - sets the Jabber Identifier.  You can either pass a
  SetJID(JID)      string or a JID object.  They must be valid Jabber 
                   Identifiers or the server will return an error message.
                   (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

  SetName(string) - sets the password for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

  SetGroups(array) - sets the group for each group in the array.


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

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{ITEM} = \@temp;
  } else {
    $self->{ITEM} = [ "item" , [{}]];
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
  my $treeName = "ITEM";
  
  return &Net::Jabber::BuildXML(@{$self->{$treeName}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{$treeName}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{JID}          = ["value","","jid"];
$FUNCTIONS{get}->{Name}         = ["value","","name"];
$FUNCTIONS{get}->{Groups}       = ["value array","group",""];

$FUNCTIONS{set}->{Name}         = ["single","","","name","*"];

$FUNCTIONS{defined}->{JID}          = ["existence","","jid"];
$FUNCTIONS{defined}->{Name}         = ["existence","","name"];
$FUNCTIONS{defined}->{Group}        = ["existence","group",""];


##############################################################################
#
# SetItem - takes a hash of all of the things you can set on an item <x/>
#           and sets each one.
#
##############################################################################
sub SetItem {
  my $self = shift;
  my %item;
  while($#_ >= 0) { $item{ lc pop(@_) } = pop(@_); }
  
  $self->SetJID($item{jid}) if exists($item{jid});
  $self->SetName($item{name}) if exists($item{name});
  $self->SetGroups($item{groups}) if exists($item{groups});
}


##############################################################################
#
# SetJID - sets the JID of the <item/>
#
##############################################################################
sub SetJID {
  my $self = shift;
  my ($jid) = @_;
  if (ref($jid) eq "Net::Jabber::JID") {
    $jid = $jid->GetJID();
  }
  &Net::Jabber::SetXMLData("single",$self->{ITEM},"","",{jid=>$jid});
}


##############################################################################
#
# SetGroups - sets the groups of the <item/>
#
##############################################################################
sub SetGroups {
  my $self = shift;
  my (@groups) = @_;
  my ($group);

  foreach $group (@groups) {
    &Net::Jabber::SetXMLData("multiple",$self->{ITEM},"group",$group,{});
  }
}


1;
