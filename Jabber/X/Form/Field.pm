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

package Net::Jabber::X::Form::Field;

=head1 NAME

Net::Jabber::X::Form::Field - Jabber X Form Field Module

=head1 SYNOPSIS

  Net::Jabber::X::Form::Field is a companion to the 
  Net::Jabber::X::Form module.  It provides the user a simple 
  interface to set and retrieve all parts of a Jabber Form Field.

=head1 DESCRIPTION

  To initialize the Field with a Jabber <x/> and then access the </x>
  you must pass it the XML::Parser Tree array from the 
  Net::Jabber::Client module.  In the callback function for the object
  type foo:

    use Net::Jabber;

    sub foo {
      my $foo = new Net::Jabber::Foo(@_);

      my @xTags = $foo->GetX("jabber:x:form");

      my $xTag;
      foreach $xTag (@xTags) {
        my @fields = $xTag->GetFields();
	my $field;
	foreach $field (@fields) {
	  $field->GetXXXX();
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

  To create a new X Form Field to send to another user:

    use Net::Jabber;

    $Client = new Net::Jabber::Client();
    ...

    $foo = new Net::Jabber::Foo();
    $form = $foo->NewX("jabber:x:form");
    $foo = $form->AddField();
    ...

    $client->Send($foo);

  Using $field you can call the creation functions below to populate the 
  tag before sending it.

  For more information about the array format being passed to the CallBack
  please read the Net::Jabber::Client documentation.

=head2 Retrieval functions


    $type    = $field->GetType();
    $var     = $field->GetVar();
    $label   = $field->GetLabel();
    $value   = $field->GetValue();
    $order   = $field->GetOrder();

    @options = $field->GetOptions();

    @field   = $field->GetTree();
    $str     = $field->GetXML();

=head2 Creation functions

    $field->SetField(type=>"entry",
		     var=>"icqnum",
		     label=>"ICQ #",
		     order=>1);
    $field->SetType('pulldown');
    $field->SetVar('sex');
    $field->SetLabel('Sex');
    $field->SetOrder('2');
    $field->AddOption(value=>"m",
		      label=>"Male");
    $field->AddOption(value=>"f",
		      label=>"Female");
    $field->AddOption(value=>"u",
		      label=>"Unknown");

=head2 Test functions

    $test = $field->DefinedType();
    $test = $field->DefinedVar();
    $test = $field->DefinedLabel();
    $test = $field->DefinedOrder();

=head1 METHODS

=head2 Retrieval functions

  GetType() - returns a string with type of field this is.

  GetVar() - returns a string with variable name that the field sets.
             This is meant to be used as an index to a hash, but mainly
             so that when returned to the server the thing parsing it
             can quickly see which value goes with what variable.

  GetLabel() - returns a string with label that should be displayed in
               front of the widget for this field.

  GetValue() - returns a string with the value that this is field is set
               to.  If set then this should be the default value for the
               field in the widget, otherwise it is the value that the
               program returned.

  GetOrder() - returns an integer with the order that this field should
               be displayed in on the form.  So a field with order=1
               should be displayed, or prompted, before the field with
               order=2.

  GetXML() - returns the XML string that represents the <field/>.

  GetTree() - returns an array that contains the <field/> tag
              in XML::Parser Tree format.

=head2 Creation functions

  SetField(type=>string,   - set multiple fields in the <field/>
           var=>string,      at one time.  This is a cumulative
           label=>string,    and overwriting action.  If you
           value=>string,    set the "var" twice, the second
           order=>integer)   setting is what is used.  If you set
                             the tpe, and then set the
                             label then both will be in the
                             <field/> tag.  For valid settings
                             read the specific Set functions below.

  SetType(string) - sets the type of field that this <field/> is.

  SetVar(string) - sets the var name for the <field/>.

  SetLabel(string) - sets the label that should be shown next to the
                     widget in the form.

  SetValue(string) - sets the value of the field.

  SetOrder(integer) - sets the order to show the field in.

=head2 Test functions

  DefinedType() - returns 1 if the type attribute is set in the <field/>,
                  0 otherwise.

  DefinedVar() - returns 1 if the var attribute is set in the <field/>,
                 0 otherwise.

  DefinedLabel() - returns 1 if the label attribute is set in the <field/>,
                   0 otherwise.

  DefinedOrder() - returns 1 if the order attribute is set in the <field/>,
                   0 otherwise.

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

use Net::Jabber::X::Form::Field::Option;
($Net::Jabber::X::Form::Field::Option::VERSION < $VERSION) &&
  die("Net::Jabber::X::Form::Field::Option $VERSION required--this is only version $Net::Jabber::X::Form::Field::Option::VERSION");

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self = { };
  
  $self->{VERSION} = $VERSION;

  bless($self, $proto);

  if ("@_" ne ("")) {
    my @temp = @_;
    $self->{FIELD} = \@temp;
  } else {
    $self->{FIELD} = [ "field" , [{}]];
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
  my $treeName = "FIELD";
  
  return &Net::Jabber::BuildXML(@{$self->{$treeName}}) if ($AUTOLOAD eq "GetXML");
  return @{$self->{$treeName}} if ($AUTOLOAD eq "GetTree");
  return &Net::Jabber::Get($self,$self,$value,$treeName,$FUNCTIONS{get}->{$value},@_) if ($type eq "Get");
  return &Net::Jabber::Set($self,$self,$value,$treeName,$FUNCTIONS{set}->{$value},@_) if ($type eq "Set");
  return &Net::Jabber::Defined($self,$self,$value,$treeName,$FUNCTIONS{defined}->{$value},@_) if ($type eq "Defined");
  return &Net::Jabber::debug($self,$treeName) if ($AUTOLOAD eq "debug");
  &Net::Jabber::MissingFunction($self,$AUTOLOAD);
}


$FUNCTIONS{get}->{Value} = ["value","",""];
$FUNCTIONS{get}->{Label} = ["value","","label"];
$FUNCTIONS{get}->{Order} = ["value","","order"];
$FUNCTIONS{get}->{Var}   = ["value","","var"];
$FUNCTIONS{get}->{Type}  = ["value","","type"];

$FUNCTIONS{set}->{Value} = ["single","","*","",""];
$FUNCTIONS{set}->{Label} = ["single","","","label","*"];
$FUNCTIONS{set}->{Order} = ["single","","","order","*"];
$FUNCTIONS{set}->{Var}   = ["single","","","var","*"];
$FUNCTIONS{set}->{Type}  = ["single","","","type","*"];

$FUNCTIONS{defined}->{Label} = ["existence","","label"];
$FUNCTIONS{defined}->{Order} = ["existence","","order"];
$FUNCTIONS{defined}->{Var}   = ["existence","","var"];
$FUNCTIONS{defined}->{Type}  = ["existence","","type"];


##############################################################################
#
# SetField - takes a hash of all of the things you can set on an field <x/>
#           and sets each one.
#
##############################################################################
sub SetField {
  my $self = shift;
  my %field;
  while($#_ >= 0) { $field{ lc pop(@_) } = pop(@_); }
  
  $self->SetValue($field{value}) if exists($field{value});
  $self->SetLabel($field{label}) if exists($field{label});
  $self->SetOrder($field{order}) if exists($field{order});
  $self->SetVar($field{var}) if exists($field{var});
  $self->SetType($field{type}) if exists($field{type});
}


##############################################################################
#
# GetOptions - returns an array of Net::Jabber::X::Form::Field::Option 
#              objects.
#
##############################################################################
sub GetOptions {
  my $self = shift;

  if (!(exists($self->{OPTIONS}))) {
    my $optionTree;
    foreach $optionTree ($self->GetOptionTrees()) {
      my $option = new Net::Jabber::X::Form::Field::Option(@{$optionTree});
      push(@{$self->{OPTIONS}},$option);
    }
  }

  return (exists($self->{OPTIONS}) ? @{$self->{OPTIONS}} : ());
}


##############################################################################
#
# GetOptionTrees - returns an array of XML::Parser trees of <option/>s.
#
##############################################################################
sub GetOptionTrees {
  my $self = shift;
  return &Net::Jabber::GetXMLData("tree array",$self->{FIELD},"option");
}


##############################################################################
#
# AddOption - creates a new Net::Jabber::X::Form::Field::Option object from 
#             the tree passed to the function if any.  Then it returns a 
#             pointer to that object so you can modify it.
#
##############################################################################
sub AddOption {
  my $self = shift;
  
  my $option = new Net::Jabber::X::Form::Field::Option("option",[{}]);
  $option->SetOption(@_);
  push(@{$self->{OPTIONS}},$option);
  return $option;
}


##############################################################################
#
# MergeOptions - takes the <option/>s in the Net::Jabber::X::Form::Field::Option
#                objects and pulls the data out and merges it into the <x/>.
#                This is a private helper function.  It should be used any
#                time you need to access the full <x/> so that the <option/>s
#                are included.  (ie. GetXML, GetTree, debug, etc...)
#
##############################################################################
sub MergeOptions {
  my $self = shift;

  return if !(exists($self->{OPTIONS}));

  my $option;
  my @options;
  foreach $option (@{$self->{OPTIONS}}) {
    push(@options,$option);
  }

  foreach my $i (1..$#{$self->{FIELD}->[1]}) {
    if ((ref($self->{FIELD}->[1]->[$i]) eq "") &&
        ($self->{FIELD}->[1]->[$i] eq "option")) {
      my $option = pop(@options);
      my @optionTree = $option->GetTree();
      $self->{FIELD}->[1]->[($i+1)] = $optionTree[1];
    }
  }

  foreach $option (@options) {
    my @optionTree = $option->GetTree();
    $self->{FIELD}->[1]->[($#{$self->{FIELD}->[1]}+1)] = "option";
    $self->{FIELD}->[1]->[($#{$self->{FIELD}->[1]}+1)] = $optionTree[1];
  }
}


1;
