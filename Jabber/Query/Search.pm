package Net::Jabber::Query::Search;

=head1 NAME

Net::Jabber::Query::Search - Jabber IQ Search Module

=head1 SYNOPSIS

  Net::Jabber::Query::Search is a companion to the Net::Jabber::Query module.
  It provides the user a simple interface to set and retrieve all parts 
  of a Jabber IQ Search query.

=head1 DESCRIPTION

  To initialize the IQ with a Jabber <iq/> and then access the search
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the iq:

    use Net::Jabber;

    sub iq {
      my $iq = new Net::Jabber::IQ(@_);
      my $search = $iq->GetQuery();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new IQ search to send to the server:

    use Net::Jabber;

    $client = new Net::Jabber::Client();
    ...

    $iq = new Net::Jabber::IQ();
    $search = $iq->NewQuery("jabber:iq:search");
    ...

    $client->Send($iq);

  Using $search you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    $name         = $search->GetName();
    $first        = $search->GetFirst();
    $given        = $search->GetGiven();
    $last         = $search->GetLast();
    $family       = $search->GetFamily();
    $nick         = $search->GetNick();
    $email        = $search->GetEmail();
    $key          = $search->GetKey();
    $instructions = $search->GetInstructions();

    %fields       = $search->GetFields();

    @items        = $search->GetItems();
    @itemTrees    = $search->GetItemTrees();
    %results      = $search->GetResults();

    $truncated    = $search->GetTruncated();

=head2 Creation functions

    $search->SetSearch(key=>"somekey",
                       name=>"",
                       first=>"",
                       last=>"",
                       nick=>"bob",
                       email=>"");
    $search->SetSearch(instructions=>"Fill in a field to search".
                                     " for any matching Jabber users.",
                       key=>"somekey",
                       name=>"",
                       first=>"",
                       last=>"",      
                       nick=>"",
                       email=>"");

    $search->SetInstructions("Fill out the form...");
    $search->SetKey("somekey");
    $search->SetName("");
    $search->SetFirst("Bob");
    $search->SetGiven("Bob");
    $search->SetLast("Smith");
    $search->SetFamily("Smith");
    $search->SetNick("");
    $search->SetEmail("");

    $search->SetTruncated();

    $item   = $search->AddItem();
    $item   = $search->AddItem(jid=>"bob\@jabber.org",
                               name=>"Bob Smith",
			       first=>"Bob",
			       last=>"Smith",
			       nick=>"bob");

=head2 Test fucntions

    $test = $search->DefinedName();
    $test = $search->DefinedFirst();
    $test = $search->DefinedGiven();
    $test = $search->DefinedLast();
    $test = $search->DefinedFamily();
    $test = $search->DefinedNick();
    $test = $search->DefinedEmail();
    $test = $search->DefinedKey();
    $test = $search->DefinedInstructions();

    $test = $search->DefinedTruncated();

=head1 METHODS

=head2 Retrieval functions

  GetInstructions() - returns a string that contains the instructions
                      for using this search query.

  GetKey() - returns a string that contains the value of key from the
             search agent.

  GetName() - returns a string that contains the value of name in the
              search query.

  GetFirst() - returns a string that contains the value of first in the
               search query.

  GetGiven() - returns a string that contains the value of given name
               in the search query.

  GetLast() - returns a string that contains the value of last in the
              search query.

  GetFamily() - returns a string that contains the value of the family 
                name in the search query.

  GetNick() - returns a string that contains the value of nick in the
              search query.

  GetEmail() - returns a string that contains the value of email in the
               search query.

  GetFields() - returns a hash that contains the fields required by the
                sender in $hash{tag} = value format.

  GetItems() - returns an array of Net::Jabber::Query::Search::Item 
               objects. These can be modified or accessed with the 
               functions available to them.

  GetItemTrees() - returns an array of XML::Parser objects that contain
                   the data for each item.

  GetResults() - returns an hash that represents the data in the Item
                 trees.  The hash looks like this:

                   $results{jid1}->{field1} = "value1";
                                   {field2} = "value2";
                                   {field3} = "value3";
                   $results{jid2}->{field1} = "value1";
                                   {field2} = "value2";
                                   {field3} = "value3";

  GetTruncated() - returns 1 if <truncated/> exists in the search query,
                   0 otherwise.

=head2 Creation functions

  SetSearch(instructions=>string, - set multiple fields in the <query/>
            key=>string,            at one time.  This is a cumulative
            name=>string,           and overwriting action.  If you
            first=>string,          set the "name" twice, the second
            given=>string,          setting is what is used.  If you set
            last=>string,           the first, and then set the
            family=>string)         last then both will be in the
            nick=>string,           search.  For valid settings read
            email=>string)          the specific Set functions below.

  SetInstructions(string) - sets the value of the instructions in the 
                            <query/>.

  SetKey(string) - sets the value of key in the <query/>.

  SetName(string) - sets the value of name in the <query/>.  If "" then
                    it creates an empty tag.

  SetFirst(string) - sets the value of first in the <query/>.  If "" then
                     it creates an empty tag.

  SetGiven(string) - sets the value of given in the <query/>.  If "" then
                     it creates an empty tag.

  SetLast(string) - sets the value of last in the <query/>.  If "" then
                    it creates an empty tag.

  SetFamily(string) - sets the value of family in the <query/>.  If "" then
                      it creates an empty tag.

  SetNick(string) - sets the value of nick in the <query/>.  If "" then
                    it creates an empty tag.

  SetEmail(string) - sets the value of email in the <query/>.  If "" then
                     it creates an empty tag.

  SetTruncated() - adds a <truncated/> tag to the <query/> to indicate that
                   the search results were truncated.

  AddItem(hash) - creates and returns a new Net::Jabbber::Query::Search::Item
                  object.  The argument hash is passed to the SetItem 
                  function.  Check the Net::Jabber::Query::Search::Item
                  for valid values.

=head2 Test functions

  DefinedInstructions() - returns 1 if there is a <instructions/> in 
                          the query, 0 if not.

  DefinedKey() - returns 1 if there is a <key/> in the query, 0 if not.

  DefinedName() - returns 1 if there is a <name/> in the query, 0 if not.

  DefinedFirst() - returns 1 if there is a <first/> in the query, 0 if not.

  DefinedGiven() - returns 1 if there is a <given/> in the query, 0 if not.

  DefinedLast() - returns 1 if there is a <last/> in the query, 0 if not.

  DefinedFamily() - returns 1 if there is a <family/> in the query, 0 if not.

  DefinedNick() - returns 1 if there is a <nick/> in the query, 0 if not.

  DefinedEmail() - returns 1 if there is a <email/> in the query, 0 if not.

  DefinedTruncated() - returns 1 if there is a <truncated/> in the query, 
                       0 if not.

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

$VERSION = "1.0017";

use Net::Jabber::Query::Search::Item;
($Net::Jabber::Query::Search::Item::VERSION < $VERSION) &&
  die("Net::Jabber::Query::Search::Item $VERSION required--this is only version $Net::Jabber::Query::Search::Item::VERSION");

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
  my $treeName = "QUERY";

  return &Net::Jabber::Get($parent,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($parent,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($parent,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  &Net::Jabber::MissingFunction($parent,$AUTOLOAD);
}

$FUNCTIONS{get}->{Instructions} = ["value","instructions",""];
$FUNCTIONS{get}->{Key}          = ["value","key",""];
$FUNCTIONS{get}->{Name}         = ["value","name",""];
$FUNCTIONS{get}->{First}        = ["value","first",""];
$FUNCTIONS{get}->{Given}        = ["value","given",""];
$FUNCTIONS{get}->{Last}         = ["value","last",""];
$FUNCTIONS{get}->{Family}       = ["value","family",""];
$FUNCTIONS{get}->{Nick}         = ["value","nick",""];
$FUNCTIONS{get}->{Email}        = ["value","email",""];
$FUNCTIONS{get}->{Truncated}    = ["existence","truncated",""];

$FUNCTIONS{set}->{Instructions} = ["single","instructions","*","",""];
$FUNCTIONS{set}->{Key}          = ["single","key","*","",""];
$FUNCTIONS{set}->{Name}         = ["single","name","*","",""];
$FUNCTIONS{set}->{First}        = ["single","first","*","",""];
$FUNCTIONS{set}->{Given}        = ["single","given","*","",""];
$FUNCTIONS{set}->{Last}         = ["single","last","*","",""];
$FUNCTIONS{set}->{Family}       = ["single","family","*","",""];
$FUNCTIONS{set}->{Nick}         = ["single","nick","*","",""];
$FUNCTIONS{set}->{Email}        = ["single","email","*","",""];
$FUNCTIONS{set}->{Truncated}    = ["single","truncated","*","",""];

$FUNCTIONS{defined}->{Instructions} = ["existence","instructions",""];
$FUNCTIONS{defined}->{Key}          = ["existence","key",""];
$FUNCTIONS{defined}->{Name}         = ["existence","name",""];
$FUNCTIONS{defined}->{First}        = ["existence","first",""];
$FUNCTIONS{defined}->{Given}        = ["existence","given",""];
$FUNCTIONS{defined}->{Last}         = ["existence","last",""];
$FUNCTIONS{defined}->{Family}       = ["existence","family",""];
$FUNCTIONS{defined}->{Nick}         = ["existence","nick",""];
$FUNCTIONS{defined}->{Email}        = ["existence","email",""];
$FUNCTIONS{defined}->{Truncated}    = ["existence","truncated",""];


##############################################################################
#
# GetFields - returns a hash that contains the fields and values that in the
#             <query/>.
#
##############################################################################
sub GetFields {
  shift;
  my $self = shift;
  my %fields;

  $fields{instructions} = $self->GetInstructions() if ($self->DefinedInstructions() == 1);
  $fields{key} = $self->GetKey() if ($self->DefinedKey() == 1);
  $fields{name} = $self->GetName() if ($self->DefinedName() == 1);
  $fields{first} = $self->GetFirst() if ($self->DefinedFirst() == 1);
  $fields{given} = $self->GetGiven() if ($self->DefinedGiven() == 1);
  $fields{last} = $self->GetLast() if ($self->DefinedLast() == 1);
  $fields{family} = $self->GetFamily() if ($self->DefinedFamily() == 1);
  $fields{nick} = $self->GetNick() if ($self->DefinedNick() == 1);
  $fields{email} = $self->GetEmail() if ($self->DefinedEmail() == 1);

  return \%fields;
}


##############################################################################
#
# GetItems - returns an array of Net::Jabber::Query::Search::Item objects.
#
##############################################################################
sub GetItems {
  shift;
  my $self = shift;

  if (!(exists($self->{ITEMS}))) {
    my $itemTree;
    foreach $itemTree ($self->GetItemTrees()) {
      my $item = new Net::Jabber::Query::Search::Item(@{$itemTree});
      push(@{$self->{ITEMS}},$item);
    }
  }

  return (exists($self->{ITEMS}) ? @{$self->{ITEMS}} : ());
}


##############################################################################
#
# GetItemTrees - returns an array of XML::Parser trees of <item/>s.
#
##############################################################################
sub GetItemTrees {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("tree array",$self->{QUERY},"item");
}


##############################################################################
#
# GetResults - returns a hash of the data in the <item/>s.
#
##############################################################################
sub GetResults {
  shift;
  my $self = shift;

  my %results;
  my $item;
  foreach $item ($self->GetItems()) {
    my %result = $item->GetResult();
    $results{$item->GetJID()} = \%result;
  }

  return %results;
}


##############################################################################
#
# SetSearch - takes a hash of all of the things you can set on a search query
#             and sets each one.
#
##############################################################################
sub SetSearch {
  shift;
  my $self = shift;
  my %search;
  while($#_ >= 0) { $search{ lc pop(@_) } = pop(@_); }
  
  $self->SetInstructions($search{instructions}) if exists($search{instructions});
  $self->SetKey($search{key}) if exists($search{key});
  $self->SetName($search{name}) if exists($search{name});
  $self->SetFirst($search{first}) if exists($search{first});
  $self->SetGiven($search{given}) if exists($search{given});
  $self->SetLast($search{last}) if exists($search{last});
  $self->SetFamily($search{family}) if exists($search{family});
  $self->SetNick($search{nick}) if exists($search{nick});
  $self->SetEmail($search{email}) if exists($search{email});
  $self->SetTruncated($search{truncated}) if exists($search{truncated});
}


##############################################################################
#
# AddItem - creates a new Net::Jabber::Query::Search::Item object from the tree
#           passed to the function if any.  Then it returns a pointer to that
#           object so you can modify it.
#
##############################################################################
sub AddItem {
  shift;
  my $self = shift;
  
  my $item = new Net::Jabber::Query::Search::Item("item",[{}]);
  $item->SetItem(@_);
  push(@{$self->{ITEMS}},$item);
  return $item;
}


##############################################################################
#
# MergeItems - takes the <item/>s in the Net::Jabber::Query::Search::Item
#              objects and pulls the data out and merges it into the <query/>.
#              This is a private helper function.  It should be used any time
#              you need to access the full <query/> so that the <item/>s are
#              included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeItems {
  shift;
  my $self = shift;
  my $count = 1;
  my $item;
  foreach $item (@{$self->{ITEMS}}) {
    while ((ref($self->{QUERY}->[1]->[$count]) ne "") ||
	   ((ref($self->{QUERY}->[1]->[$count]) eq "") &&
	    ($self->{QUERY}->[1]->[$count] ne "item") &&
	    ($self->{QUERY}->[1]->[$count] ne ""))) {
      $count += 1;
    }
    $self->{QUERY}->[1]->[$count++] = "item";
    $self->{QUERY}->[1]->[$count++] = ($item->GetTree())[1];
  }
}


1;
