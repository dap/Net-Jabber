package Net::Jabber::IQ::Roster;

=head1 NAME

Net::Jabber::IQ::Roster - Jabber IQ Roster Module

=head1 SYNOPSIS

  Net::Jabber::IQ::Roster is a companion to the Net::Jabber::IQ module.
  It provides the user a simple interface to set and retrieve all parts 
  of a Jabber IQ Roster query.

=head1 DESCRIPTION

  To initialize the IQ with a Jabber <iq/> and then access the roster
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $roster = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new IQ roster to send to the server:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $IQ = new Net::Jabber::IQ();
    $Roster = $IQ->NewQuery("roster");
    ...

    $Client->Send($IQ);

  Using $Roster you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    @items  = $Roster->GetItems();

    @roster = $Roster->GetTree();
    $str    = $Roster->GetXML();

=head2 Creation functions

    $item   = $Roster->AddItem();

=head1 METHODS

=head2 Retrieval functions

  GetItems() - returns an array of Net::Jabber::IQ::Roster::Item objects.
               These can be modified or accessed with the functions
               available to them.

  GetXML() - returns the XML string that represents the <query/>.
             This is used by the GetXML() function in IQ.pm to build
             the XML string for the <iq/> that contains this <query/>.

  GetTree() - returns an array that contains the <query/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  AddItem(XML::Parser tree) - creates a new Net::Jabbber::IQ::Roster::Item
                              object and populates it with the tree if one
                              was passed in.  This returns the pointer to
                              the <item/> so you can modify it with the
                              creation functions from that module.

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

use Net::Jabber::IQ::Roster::Item;
($Net::Jabber::IQ::Roster::Item::VERSION < $VERSION) &&
  die("Net::Jabber::IQ::Roster::Item $VERSION required--this is only version $Net::Jabber::IQ::Roster::Item::VERSION");

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  if (@_ != ("")) {
    my @temp = @_;
    $self->{ROSTER} = \@temp;

    my ($itemTree);
    foreach $itemTree ($self->GetItemTrees()) {
      $self->AddItem(@{$itemTree});
    }
  } else {
    $self->{ROSTER} = [ "query" , [{xmlns=>"jabber:iq:roster"}]];
    $self->{ITEMS} = {};
  }
  return $self;
}


##############################################################################
#
# GetItems - returns an array of Net::Jabber::IQ::Roster::Item objects.
#
##############################################################################
sub GetItems {
  my $self = shift;

  return @{$self->{ITEMS}};
}


##############################################################################
#
# GetXML - returns the XML string that represents the data in the XML::Parser
#          Tree.
#
##############################################################################
sub GetXML {
  my $self = shift;
  $self->MergeItems();
  return &Net::Jabber::BuildXML(@{$self->{ROSTER}});
}


##############################################################################
#
# GetTree - returns the XML::Parser Tree that is stored in the guts of
#           the object.
#
##############################################################################
sub GetTree {
  my $self = shift;  
  $self->MergeItems();
  return @{$self->{ROSTER}};
}


##############################################################################
#
# AddItem - creates a new Net::Jabber::IQ::Roster::Item object from the tree
#           passed to the function if any.  Then it returns a pointer to that
#           object so you can modify it.
#
##############################################################################
sub AddItem {
  my $self = shift;
  my (@tree) = @_;
  
  my $itemObj = new Net::Jabber::IQ::Roster::Item(@tree);
  push(@{$self->{ITEMS}},$itemObj);
  return $itemObj;
}


##############################################################################
#
# GetItemTrees - returns an array of XML::Parser trees of <item/>s.
#
##############################################################################
sub GetItemTrees {
  my $self = shift;
  return &Net::Jabber::GetXMLData("tree array",$self->{ROSTER},"item");
}


##############################################################################
#
# MergeItems - takes the <item/>s in the Net::Jabber::IQ::Roster::Item
#              objects and pulls the data out and merges it into the <query/>.
#              This is a private helper function.  It should be used any time
#              you need to access the full <query/> so that the <item/>s are
#              included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeItems {
  my $self = shift;
  my (@tree);
  my $count = 1;
  my ($item);
  foreach $item (@{$self->{ITEMS}}) {
    @tree = $item->GetTree();
    $self->{ROSTER}->[1]->[$count++] = "item";
    $self->{ROSTER}->[1]->[$count++] = ($item->GetTree())[1];
  }
}

##############################################################################
#
# debug - prints out the XML::Parser Tree in a readable format for debugging
#
##############################################################################
sub debug {
  my $self = shift;

  print "debug ROSTER: $self\n";
  $self->MergeItems();
  &Net::Jabber::printData("debug: \$self->{ROSTER}->",$self->{ROSTER});
}

1;
