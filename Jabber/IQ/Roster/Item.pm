package Net::Jabber::IQ::Roster::Item;

=head1 NAME

Net::Jabber::IQ::Roster::Item - Jabber IQ Roster Item Module

=head1 SYNOPSIS

  Net::Jabber::IQ::Roster::Item is a companion to the 
  Net::Jabber::IQ::Roster module.  It provides the user a simple 
  interface to set and retrieve all parts of a Jabber Roster Item.

=head1 DESCRIPTION

  To initialize the Item with a Jabber <iq/> and then access the auth
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $roster = $iq->GetQuery();
      my @items = $roster->GetItems();
      foreach $item (@items) {
        ...
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

    $IQ = new Net::Jabber::IQ();
    $Roster = $IQ->NewQuery("roster");
    $Item = $Roster->AddItem();
    ...

    $Client->Send($IQ);

  Using $Item you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $jid          = $Auth->GetJID();
    $name         = $Auth->GetName();
    $subscription = $Auth->GetSubscription();
    $ask          = $Item->GetAsk();
    @groups       = $Item->GetGroup();

    @item         = $Item->GetTree();
    $str          = $Item->GetXML();

=head2 Creation functions

    $Item->SetItem(jid=>'bob@jabber.org',
		   name=>'Bob',
		   subscription=>'both',
		   group=>[ 'friends','school' ]);

    $Auth->SetJID('bob@jabber.org');
    $Auth->SetName('Bob');
    $Auth->SetSubscription('both');
    $Auth->SetAsk('both');
    $Auth->SetGroup(['friends','school']);

=head1 METHODS

=head2 Retrieval functions

  GetJID() - returns a string with the jabber ID of this <item/>.

  GetName() - returns a string with the name of the jabber ID.

  GetSubscription() - returns a string with the current subscription 
                      of this <item/>.

                      none    means no one is getting <presence/> tags
                      to      means we are getting their <presence/>
                              but they are not getting ours
                      from    means we are not getting their <presence/>
                              but they are getting ours
                      both    means we are getting their <presence/>
                              and they are getting ours
                      remove  remove this jid from the roster

  GetAsk() - returns a string with the current ask of this <item/>.
             This is the pending request by you to this JID, usually
             handled by the server.

  GetGroup() - returns an array of strings with the names of the groups
               that this <item/> belongs to.

  GetXML() - returns the XML string that represents the <presence/>.
             This is used by the Send() function in Client.pm to send
             this object as a Jabber Presence.

  GetTree() - returns an array that contains the <presence/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetItem(jid=>string,          - set multiple fields in the <item/>
          name=>string,           at one time.  This is a cumlative
          subscription=>string,   and overwriting action.  If you
          ask=>string,            set the "ask" twice, the second
          group=>array)           setting is what is used.  If you set
                                  the password, and then set the
                                  resource then both will be in the
                                  <item/> tag.  For valid settings
                                  read the specific Set functions below.
                                  Note: group does not behave in this
                                  manner.  For each group setting a
                                  new <group/> tag will be created.

  SetJID(string) - sets the username for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

  SetName(string) - sets the password for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

  SetSubscription(string) - sets the resource for the account you are
                        trying to connect with.  Leave blank for
                        an anonymous account.

  SetAsk(string) - sets the ask for the <item/>.

  SetGroup(array) - sets the group for each group in the array.


=head1 AUTHOR

By Ryan Eatmon in December of 1999 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION);

$VERSION = "0.8.1";

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  if (@_ != ("")) {
    my @temp = @_;
    $self->{ITEM} = \@temp;
  } else {
    $self->{ITEM} = [ "item" , [{}]];
  }

  return $self;
}


##############################################################################
#
#
#
##############################################################################
sub GetJID {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{ITEM},"","jid");
}


##############################################################################
#
#
#
##############################################################################
sub GetName {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{ITEM},"","name");
}


##############################################################################
#
#
#
##############################################################################
sub GetSubscription {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{ITEM},"","subscription");
}


##############################################################################
#
#
#
##############################################################################
sub GetAsk {
  my $self = shift;
  return &Net::Jabber::GetXMLData("value",$self->{ITEM},"","ask");
}


##############################################################################
#
#
#
##############################################################################
sub GetGroup {
  my $self = shift;

  return &Net::Jabber::GetXMLData("value array",$self->{ITEM},"group");
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  return &Net::Jabber::BuildXML(@{$self->{ITEM}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;  
  return @{$self->{ITEM}};
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
  $self->SetSubscription($item{subscription}) if exists($item{subscription});
  $self->SetAsk($item{ask}) if exists($item{ask});
  $self->SetGroup($item{group}) if exists($item{group});
}


##############################################################################
#
# SetJID - 
#
##############################################################################
sub SetJID {
  my $self = shift;
  my ($jid) = @_;
  &Net::Jabber::SetXMLData("single",$self->{ITEM},"","",{jid=>$jid});
}


##############################################################################
#
# SetName - 
#
##############################################################################
sub SetName {
  my $self = shift;
  my ($name) = @_;
  &Net::Jabber::SetXMLData("single",$self->{ITEM},"","",{name=>$name});
}


##############################################################################
#
# SetSubscription - 
#
##############################################################################
sub SetSubscription {
  my $self = shift;
  my ($subscription) = @_;
  &Net::Jabber::SetXMLData("single",$self->{ITEM},"","",{subscription=>$subscription});
}


##############################################################################
#
# SetAsk - 
#
##############################################################################
sub SetAsk {
  my $self = shift;
  my ($ask) = @_;
  &Net::Jabber::SetXMLData("single",$self->{ITEM},"","",{ask=>$ask});
}


##############################################################################
#
# SetGroup -
#
##############################################################################
sub SetGroup {
  my $self = shift;
  my (@groups) = @_;
  my ($group);

  foreach $group (@groups) {
    &Net::Jabber::SetXMLData("multiple",$self->{ITEM},"group",$group,{});
  }
}


##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for dbeugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug ITEM: $self\n";
  &Net::Jabber::printData("debug: \$self->{ITEM}->",$self->{ITEM});
}

1;
