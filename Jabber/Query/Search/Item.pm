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

package Net::Jabber::Query::Search::Item;

=head1 NAME

Net::Jabber::Query::Search::Item - Jabber IQ Search Item Module

=head1 SYNOPSIS

  Net::Jabber::Query::Search::Item is a companion to the 
  Net::Jabber::Query::Search module.  It provides the user a simple 
  interface to set and retrieve all parts of a Jabber Search Item.

=head1 DESCRIPTION

  To initialize the Item with a Jabber <iq/> and then access the search
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $search = $iq->GetQuery();
      my @items = $search->GetItems();
      foreach $item (@items) {
        ...
      }
      .
      .
      .
    }

  You now have access to all of the retrieval functions available below.

  To create a new IQ Search Item to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $iq = new Net::Jabber::IQ();
    $search = $iq->NewQuery("jabber:iq:search");
    $item = $search->AddItem();
    ...

    $client->Send($iq);

  Using $Item you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $jid    = $item->GetJID();
    $jidJID = $item->GetJID("jid");
    $name   = $item->GetName();
    $first  = $item->GetFirst();
    $given  = $item->GetGiven();
    $last   = $item->GetLast();
    $family = $item->GetFamily();
    $nick   = $item->GetNick();
    $email  = $item->GetEmail();

    %result = $item->GetResult();

    @item   = $item->GetTree();
    $str    = $item->GetXML();

=head2 Creation functions

    $item->SetItem(jid=>'bob@jabber.org',
		   name=>'Bob',
		   first=>'Bob',
		   last=>'Smith',
		   nick=>'bob',
		   email=>'bob@hotmail.com');

    $item->SetJID('bob@jabber.org');
    $item->SetName('Bob Smith');
    $item->SetFirst('Bob');
    $item->SetGiven('Bob');
    $item->SetLast('Smith');
    $item->SetFamily('Smith');
    $item->SetNick('bob');
    $item->SetEmail('bob@bobworld.com');

=head2 Test functions

    $test = $item->DefinedName();
    $test = $item->DefinedFirst();
    $test = $item->DefinedGiven();
    $test = $item->DefinedLast();
    $test = $item->DefinedFamily();
    $test = $item->DefinedNick();
    $test = $item->DefinedEmail();

=head1 METHODS

=head2 Retrieval functions

  GetJID()      - returns either a string with the Jabber Identifier,
  GetJID("jid")   or a Net::Jabber::JID object for the account that is 
                  listed in this <item/>.  To get the JID object set the 
                  string to "jid", otherwise leave blank for the text
                  string.

  GetName() - returns a string with the full name of the account being 
              returned.

  GetFirst() - returns a string with the first name of the account being 
               returned.

  GetGiven() - returns a string with the given name of the account being 
               returned.

  GetLast() - returns a string with the last name of the jabber account 
              being returned.

  GetFamily() - returns a string with the family name of the jabber 
                account being returned.

  GetNick() - returns a string with the nick of the jabber account being 
              returned.

  GetEmail() - returns a string with the email of the jabber account being 
               returned.

  GetResult() - returns a hash with all of the valid fields set.  Here is
                the way the hash might look.

                  $result{last} = "Smith";
                  $result{first} = "Bob";

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetItem(jid=>string|JID, - set multiple fields in the <item/>
          name=>string,      at one time.  This is a cumulative
          first=>string,     and overwriting action.  If you
          given=>string,     set the "name" twice, the second
          last=>string,      setting is what is used.  If you set
          family=>string)    the first, and then set the
          nick=>string,      last then both will be in the
          email=>string)     <item/> tag.  For valid settings
                             read the specific Set functions below.

  SetJID(string) - sets the Jabber Identifier.  You can either pass a
  SetJID(JID)      string or a JID object.  They must be valid Jabber 
                   Identifiers or the server will return an error message.
                   (ie.  jabber:bob@jabber.org/Silent Bob, etc...)

  SetName(string) - sets the name this search item should show in the
                    search.

  SetFirst(string) - sets the first name this search item should show 
                     in the search.

  SetGiven(string) - sets the given name this search item should show 
                     in the search.

  SetLast(string) - sets the last name this search item should show in
                    the search.

  SetFamily(string) - sets the family name this search item should show 
                      in the search.

  SetNick(string) - sets the nick this search item should show in the
                    search.

  SetEmail(string) - sets the email this search item should show in the
                     search.

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

$FUNCTIONS{get}->{JID}    = ["value","","jid"];
$FUNCTIONS{get}->{Name}   = ["value","name",""];
$FUNCTIONS{get}->{First}  = ["value","first",""];
$FUNCTIONS{get}->{Given}  = ["value","given",""];
$FUNCTIONS{get}->{Last}   = ["value","last",""];
$FUNCTIONS{get}->{Family} = ["value","family",""];
$FUNCTIONS{get}->{Nick}   = ["value","nick",""];
$FUNCTIONS{get}->{Email}  = ["value","email",""];

$FUNCTIONS{set}->{JID}    = ["single","","","jid","*"];
$FUNCTIONS{set}->{Name}   = ["single","name","*","",""];
$FUNCTIONS{set}->{First}  = ["single","first","*","",""];
$FUNCTIONS{set}->{Given}  = ["single","given","*","",""];
$FUNCTIONS{set}->{Last}   = ["single","last","*","",""];
$FUNCTIONS{set}->{Family} = ["single","family","*","",""];
$FUNCTIONS{set}->{Nick}   = ["single","nick","*","",""];
$FUNCTIONS{set}->{Email}  = ["single","email","*","",""];

$FUNCTIONS{defined}->{JID}    = ["existence","","jid"];
$FUNCTIONS{defined}->{Name}   = ["existence","name",""];
$FUNCTIONS{defined}->{First}  = ["existence","first",""];
$FUNCTIONS{defined}->{Given}  = ["existence","given",""];
$FUNCTIONS{defined}->{Last}   = ["existence","last",""];
$FUNCTIONS{defined}->{Family} = ["existence","family",""];
$FUNCTIONS{defined}->{Nick}   = ["existence","nick",""];
$FUNCTIONS{defined}->{Email}  = ["existence","email",""];


##############################################################################
#
# GetResult - returns a hash that contains the set fields.
#
##############################################################################
sub GetResult {
  my $self = shift;

  my %result;
  $result{name} = $self->GetName() if ($self->DefinedName());
  $result{first} = $self->GetFirst() if ($self->DefinedFirst());
  $result{given} = $self->GetGiven() if ($self->DefinedGiven());
  $result{last} = $self->GetLast() if ($self->DefinedLast());
  $result{family} = $self->GetFamily() if ($self->DefinedFamily());
  $result{nick} = $self->GetNick() if ($self->DefinedNick());
  $result{email} = $self->GetEmail() if ($self->DefinedEmail());

  return %result;
}


##############################################################################
#
# SetItem - takes a hash of all of the things you can set on an item <query/>
#           and sets each one.
#
##############################################################################
sub SetItem {
  my $self = shift;
  my %item;
  while($#_ >= 0) { $item{ lc pop(@_) } = pop(@_); }
  
  $self->SetJID($item{jid}) if exists($item{jid});
  $self->SetName($item{name}) if exists($item{name});
  $self->SetFirst($item{first}) if exists($item{first});
  $self->SetGiven($item{given}) if exists($item{given});
  $self->SetLast($item{last}) if exists($item{last});
  $self->SetFamily($item{family}) if exists($item{family});
  $self->SetNick($item{nick}) if exists($item{nick});
  $self->SetEmail($item{email}) if exists($item{email});
}


1;
