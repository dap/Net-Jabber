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

package Net::Jabber::X::Form;

=head1 NAME

Net::Jabber::X::Form - Jabber X Form Module

=head1 SYNOPSIS

  Net::Jabber::X::Form is a companion to the Net::Jabber::X module.
  It provides the user a simple interface to set and retrieve all parts 
  of a Jabber X Form.

=head1 DESCRIPTION

  To initialize the X with a Jabber <x/> and then access the form
  query you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the x:

    use Net::Jabber;

    sub foo {
      my $foo = new Net::Jabber::Foo(@_);
      my $form = $foo->GetX();
      .
      .
      .
    }

  You now have access to all of the retrieval functions available.

  To create a new X form to send to the server:

    use Net::Jabber;

    $client = new Net::Jabber::Client();
    ...

    $foo = new Net::Jabber::Foo();
    $form = $foo->NewX("jabber:x:form");
    ...

    $client->Send($foo);

  Using $form you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions

    @fields     = $form->GetFields();
    @fieldTrees = $form->GetFieldTrees();

=head2 Creation functions

    $field   = $form->AddField();
    $field   = $form->AddField(jid=>"bob\@jabber.org",
                               name=>"Bob",
                               groups=>["school","friends"]);

=head1 METHODS

=head2 Retrieval functions

  GetFields() - returns an array of Net::Jabber::X::Form::Field objects.
               These can be modified or accessed with the functions
               available to them.

  GetFieldTrees() - returns an array of XML::Parser objects that contain
                   the data for each field.

=head2 Creation functions

  AddField(hash) - creates and returns a new Net::Jabbber::X::Form::Field
                  object.  The argument hash is passed to the SetField 
                  function.  Check the Net::Jabber::X::Form::Field
                  for valid values.

=head1 AUTHOR

By Ryan Eatmon in February of 2001 for http://jabber.org..

=head1 COPYRIGHT

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

require 5.003;
use strict;
use Carp;
use vars qw($VERSION $AUTOLOAD %FUNCTIONS);

$VERSION = "1.0021";

use Net::Jabber::X::Form::Field;
($Net::Jabber::X::Form::Field::VERSION < $VERSION) &&
  die("Net::Jabber::X::Form::Field $VERSION required--this is only version $Net::Jabber::X::Form::Field::VERSION");

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
  my $self = shift;
  return if ($AUTOLOAD =~ /::DESTROY$/);
  $AUTOLOAD =~ s/^.*:://;
  my ($type,$value) = ($AUTOLOAD =~ /^(Get|Set|Defined)(.*)$/);
  $type = "" unless defined($type);
  my $treeName = "FIELD";
  
  return &Net::Jabber::BuildXML(@{$self->{$treeName}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{$treeName}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{Instructions} = ["value","instructions",""];

$FUNCTIONS{set}->{Instructions} = ["single","instructions","*","",""];

$FUNCTIONS{defined}->{instructions} = ["existence","instructions",""];


##############################################################################
#
# SetForm - takes a hash of all of the things you can set on a jabber:x:form
#           and sets each one.
#
##############################################################################
sub SetForm {
  shift;
  my $self = shift;
  my %form;
  while($#_ >= 0) { $form{ lc pop(@_) } = pop(@_); }

  $self->SetInstructions($form{instructions}) if exists($form{instructions});
}


##############################################################################
#
# GetFields - returns an array of Net::Jabber::X::Form::Field objects.
#
##############################################################################
sub GetFields {
  shift;
  my $self = shift;

  if (!(exists($self->{FIELDS}))) {
    my $fieldTree;
    foreach $fieldTree ($self->GetFieldTrees()) {
      my $field = new Net::Jabber::X::Form::Field(@{$fieldTree});
      push(@{$self->{FIELDS}},$field);
    }
  }

  return (exists($self->{FIELDS}) ? @{$self->{FIELDS}} : ());
}


##############################################################################
#
# GetFieldTrees - returns an array of XML::Parser trees of <field/>s.
#
##############################################################################
sub GetFieldTrees {
  shift;
  my $self = shift;
  return &Net::Jabber::GetXMLData("tree array",$self->{X},"field");
}


##############################################################################
#
# AddField - creates a new Net::Jabber::X::Form::Field object from the tree
#           passed to the function if any.  Then it returns a pointer to that
#           object so you can modify it.
#
##############################################################################
sub AddField {
  shift;
  my $self = shift;
  
  my $field = new Net::Jabber::X::Form::Field("field",[{}]);
  $field->SetField(@_);
  push(@{$self->{FIELDS}},$field);
  return $field;
}


##############################################################################
#
# MergeFields - takes the <field/>s in the Net::Jabber::X::Form::Field
#              objects and pulls the data out and merges it into the <x/>.
#              This is a private helper function.  It should be used any time
#              you need to access the full <x/> so that the <field/>s are
#              included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeFields {
  shift;
  my $self = shift;

  return if !(exists($self->{FIELDS}));

  my $field;
  my @fields;
  foreach $field (@{$self->{FIELDS}}) {
    push(@fields,$field);
  }

  foreach my $i (1..$#{$self->{X}->[1]}) {
    if ((ref($self->{X}->[1]->[$i]) eq "") &&
        ($self->{X}->[1]->[$i] eq "field")) {
      my $field = pop(@fields);
      $field->MergeOptions();
      my @fieldTree = $field->GetTree();
      $self->{X}->[1]->[($i+1)] = $fieldTree[1];
    }
  }

  foreach $field (@fields) {
    $field->MergeOptions();
    my @fieldTree = $field->GetTree();
    $self->{X}->[1]->[($#{$self->{X}->[1]}+1)] = "field";
    $self->{X}->[1]->[($#{$self->{X}->[1]}+1)] = $fieldTree[1];
  }
}


1;
